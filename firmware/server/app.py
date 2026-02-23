from fastapi import FastAPI, Depends, HTTPException, Query, Request
import httpx
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from pathlib import Path
import subprocess
import asyncio
import socket
from sqlalchemy.orm import Session
from sqlalchemy import func, and_
from pydantic import BaseModel
from datetime import datetime, timedelta
from typing import Optional, List
from apscheduler.schedulers.background import BackgroundScheduler
from zeroconf import ServiceInfo, Zeroconf
import atexit

from database import init_db, get_db, Sensor, Reading, SessionLocal

app = FastAPI(title="Air Quality Sensor Network API")

zeroconf = None
service_info = None

def get_local_ip():
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
        s.close()
        return ip
    except:
        return "127.0.0.1"

def start_mdns():
    global zeroconf, service_info
    import threading
    
    def run_mdns():
        global zeroconf, service_info
        try:
            local_ip = get_local_ip()
            print(f"Starting mDNS advertisement as airquality-server.local ({local_ip})")
            
            service_info = ServiceInfo(
                "_http._tcp.local.",
                "Air Quality Server._http._tcp.local.",
                addresses=[socket.inet_aton(local_ip)],
                port=8000,
                properties={"path": "/api/"},
                server="airquality-server.local.",
            )
            zeroconf = Zeroconf()
            zeroconf.register_service(service_info)
        except Exception as e:
            print(f"mDNS failed: {e}")
    
    threading.Thread(target=run_mdns, daemon=True).start()

def stop_mdns():
    global zeroconf, service_info
    if zeroconf and service_info:
        zeroconf.unregister_service(service_info)
        zeroconf.close()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class ReadingCreate(BaseModel):
    sensor_id: str
    pm1: float
    pm25: float
    pm10: float


class SensorUpdate(BaseModel):
    display_name: str


class ReadingResponse(BaseModel):
    sensor_id: str
    pm1: float
    pm25: float
    pm10: float
    timestamp: datetime

    class Config:
        from_attributes = True


class SensorResponse(BaseModel):
    id: str
    display_name: str
    last_seen: datetime
    ip_address: Optional[str] = None
    pm1: Optional[float] = None
    pm25: Optional[float] = None
    pm10: Optional[float] = None


DASHBOARD_DIR = Path(__file__).parent.parent / "dashboard"

@app.on_event("startup")
def startup():
    init_db()
    start_scheduler()
    start_mdns()

@app.on_event("shutdown")
def shutdown():
    stop_mdns()


@app.get("/")
def serve_dashboard():
    return FileResponse(DASHBOARD_DIR / "index.html")


app.mount("/static", StaticFiles(directory=DASHBOARD_DIR), name="static")


@app.post("/api/readings")
def create_reading(reading: ReadingCreate, request: Request, db: Session = Depends(get_db)):
    client_ip = request.client.host if request.client else None
    
    sensor = db.query(Sensor).filter(Sensor.id == reading.sensor_id).first()
    if not sensor:
        sensor = Sensor(
            id=reading.sensor_id,
            display_name=reading.sensor_id,
            ip_address=client_ip
        )
        db.add(sensor)
    else:
        sensor.ip_address = client_ip
    
    sensor.last_seen = datetime.utcnow()
    
    db_reading = Reading(
        sensor_id=reading.sensor_id,
        pm1=reading.pm1,
        pm25=reading.pm25,
        pm10=reading.pm10
    )
    db.add(db_reading)
    db.commit()
    
    return {"status": "ok", "id": db_reading.id}


@app.get("/api/sensors", response_model=List[SensorResponse])
def get_sensors(db: Session = Depends(get_db)):
    sensors = db.query(Sensor).all()
    result = []
    
    for sensor in sensors:
        latest = db.query(Reading).filter(
            Reading.sensor_id == sensor.id
        ).order_by(Reading.timestamp.desc()).first()
        
        result.append(SensorResponse(
            id=sensor.id,
            display_name=sensor.display_name,
            last_seen=sensor.last_seen,
            ip_address=sensor.ip_address,
            pm1=latest.pm1 if latest else None,
            pm25=latest.pm25 if latest else None,
            pm10=latest.pm10 if latest else None
        ))
    
    return result


@app.put("/api/sensors/{sensor_id}")
def update_sensor(sensor_id: str, update: SensorUpdate, db: Session = Depends(get_db)):
    sensor = db.query(Sensor).filter(Sensor.id == sensor_id).first()
    if not sensor:
        raise HTTPException(status_code=404, detail="Sensor not found")
    
    sensor.display_name = update.display_name
    db.commit()
    return {"status": "ok"}


@app.post("/api/sensors/{sensor_id}/reset-wifi")
async def reset_sensor_wifi(sensor_id: str, db: Session = Depends(get_db)):
    sensor = db.query(Sensor).filter(Sensor.id == sensor_id).first()
    if not sensor:
        raise HTTPException(status_code=404, detail="Sensor not found")
    
    if not sensor.ip_address:
        raise HTTPException(status_code=400, detail="Sensor IP address unknown")
    
    try:
        async with httpx.AsyncClient(timeout=5.0) as client:
            response = await client.get(f"http://{sensor.ip_address}/reset-wifi")
            if response.status_code == 200:
                return {"status": "ok", "message": "WiFi reset triggered"}
            else:
                raise HTTPException(status_code=502, detail="Sensor returned error")
    except httpx.TimeoutException:
        raise HTTPException(status_code=504, detail="Sensor not responding")
    except Exception as e:
        raise HTTPException(status_code=502, detail=str(e))


@app.get("/api/readings", response_model=List[ReadingResponse])
def get_readings(
    sensor_id: Optional[str] = Query(None),
    hours: int = Query(1, ge=1, le=168),
    db: Session = Depends(get_db)
):
    since = datetime.utcnow() - timedelta(hours=hours)
    query = db.query(Reading).filter(Reading.timestamp >= since)
    
    if sensor_id:
        query = query.filter(Reading.sensor_id == sensor_id)
    
    readings = query.order_by(Reading.timestamp.asc()).limit(10000).all()
    return readings


FIRMWARE_DIR = Path(__file__).parent.parent
PIO_PATH = "/Users/briansone/Library/Python/3.9/bin/pio"

firmware_upload_status = {"running": False, "output": "", "success": None}


@app.post("/api/firmware/upload")
async def upload_firmware():
    global firmware_upload_status
    
    if firmware_upload_status["running"]:
        raise HTTPException(status_code=409, detail="Upload already in progress")
    
    firmware_upload_status = {"running": True, "output": "", "success": None}
    
    async def run_upload():
        global firmware_upload_status
        try:
            # Upload filesystem first
            proc_fs = await asyncio.create_subprocess_exec(
                PIO_PATH, "run", "-t", "uploadfs",
                cwd=str(FIRMWARE_DIR),
                stdout=asyncio.subprocess.PIPE,
                stderr=asyncio.subprocess.STDOUT
            )
            stdout_fs, _ = await proc_fs.communicate()
            firmware_upload_status["output"] += stdout_fs.decode()
            
            if proc_fs.returncode != 0:
                firmware_upload_status["success"] = False
                firmware_upload_status["running"] = False
                return
            
            # Upload firmware
            proc = await asyncio.create_subprocess_exec(
                PIO_PATH, "run", "-t", "upload",
                cwd=str(FIRMWARE_DIR),
                stdout=asyncio.subprocess.PIPE,
                stderr=asyncio.subprocess.STDOUT
            )
            stdout, _ = await proc.communicate()
            firmware_upload_status["output"] += stdout.decode()
            firmware_upload_status["success"] = proc.returncode == 0
        except Exception as e:
            firmware_upload_status["output"] += f"\nError: {str(e)}"
            firmware_upload_status["success"] = False
        finally:
            firmware_upload_status["running"] = False
    
    asyncio.create_task(run_upload())
    return {"status": "started", "message": "Firmware upload started"}


@app.get("/api/firmware/status")
def get_firmware_status():
    return firmware_upload_status


def aggregate_old_readings():
    db = SessionLocal()
    try:
        yesterday = datetime.utcnow().replace(hour=0, minute=0, second=0, microsecond=0) - timedelta(days=1)
        day_before = yesterday - timedelta(days=1)
        
        sensors = db.query(Sensor).all()
        
        for sensor in sensors:
            readings = db.query(Reading).filter(
                and_(
                    Reading.sensor_id == sensor.id,
                    Reading.timestamp >= day_before,
                    Reading.timestamp < yesterday,
                    Reading.is_aggregated == False
                )
            ).all()
            
            if len(readings) < 2:
                continue
            
            minute_buckets = {}
            for r in readings:
                key = r.timestamp.replace(second=0, microsecond=0)
                if key not in minute_buckets:
                    minute_buckets[key] = []
                minute_buckets[key].append(r)
            
            for minute_ts, bucket in minute_buckets.items():
                if len(bucket) > 1:
                    avg_pm1 = sum(r.pm1 for r in bucket) / len(bucket)
                    avg_pm25 = sum(r.pm25 for r in bucket) / len(bucket)
                    avg_pm10 = sum(r.pm10 for r in bucket) / len(bucket)
                    
                    aggregated = Reading(
                        sensor_id=sensor.id,
                        pm1=round(avg_pm1, 2),
                        pm25=round(avg_pm25, 2),
                        pm10=round(avg_pm10, 2),
                        timestamp=minute_ts,
                        is_aggregated=True
                    )
                    db.add(aggregated)
                    
                    for r in bucket:
                        db.delete(r)
            
            db.commit()
        
        print(f"[{datetime.utcnow()}] Aggregation complete")
    except Exception as e:
        print(f"Aggregation error: {e}")
        db.rollback()
    finally:
        db.close()


scheduler = BackgroundScheduler()

def start_scheduler():
    scheduler.add_job(aggregate_old_readings, 'cron', hour=2, minute=0)
    scheduler.start()
    atexit.register(lambda: scheduler.shutdown())


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
