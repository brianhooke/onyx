from sqlalchemy import create_engine, Column, Integer, Float, String, DateTime, Boolean, func
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from datetime import datetime

DATABASE_URL = "sqlite:///./air_quality.db"

engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()


class Sensor(Base):
    __tablename__ = "sensors"
    
    id = Column(String, primary_key=True)
    display_name = Column(String, nullable=False)
    ip_address = Column(String, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    last_seen = Column(DateTime, default=datetime.utcnow)


class Reading(Base):
    __tablename__ = "readings"
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    sensor_id = Column(String, nullable=False, index=True)
    pm1 = Column(Float, nullable=False)
    pm25 = Column(Float, nullable=False)
    pm10 = Column(Float, nullable=False)
    timestamp = Column(DateTime, default=datetime.utcnow, index=True)
    is_aggregated = Column(Boolean, default=False)


def init_db():
    Base.metadata.create_all(bind=engine)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
