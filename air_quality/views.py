from django.shortcuts import render
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from django.utils import timezone
from django.conf import settings
from datetime import timedelta
import json
import httpx
import subprocess
import os

from .models import Sensor, Reading


def dashboard(request):
    """Render the air quality dashboard."""
    return render(request, 'air_quality/dashboard.html')


def api_sensors(request):
    """Get all sensors with latest readings."""
    sensors = Sensor.objects.all()
    data = []
    for sensor in sensors:
        data.append({
            'id': sensor.sensor_id,
            'display_name': sensor.display_name,
            'ip_address': sensor.ip_address,
            'last_seen': sensor.last_seen.isoformat() if sensor.last_seen else None,
            'pm1': sensor.pm1,
            'pm25': sensor.pm25,
            'pm10': sensor.pm10,
        })
    return JsonResponse(data, safe=False)


@csrf_exempt
@require_http_methods(["POST"])
def api_readings(request):
    """Receive sensor readings from ESP32 devices."""
    try:
        data = json.loads(request.body)
        sensor_id = data.get('sensor_id')
        
        if not sensor_id:
            return JsonResponse({'error': 'sensor_id required'}, status=400)
        
        # Get client IP
        x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
        if x_forwarded_for:
            ip_address = x_forwarded_for.split(',')[0].strip()
        else:
            ip_address = request.META.get('REMOTE_ADDR')
        
        # Get or create sensor
        sensor, created = Sensor.objects.get_or_create(
            sensor_id=sensor_id,
            defaults={'display_name': sensor_id}
        )
        
        # Update sensor with latest values
        sensor.ip_address = ip_address
        sensor.pm1 = data.get('pm1')
        sensor.pm25 = data.get('pm25')
        sensor.pm10 = data.get('pm10')
        sensor.last_seen = timezone.now()
        sensor.save()
        
        # Create reading record
        Reading.objects.create(
            sensor=sensor,
            pm1=data.get('pm1', 0),
            pm25=data.get('pm25', 0),
            pm10=data.get('pm10', 0),
        )
        
        return JsonResponse({'status': 'ok', 'sensor_id': sensor_id})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)


def api_readings_history(request):
    """Get historical readings for charting."""
    hours = int(request.GET.get('hours', 24))
    sensor_id = request.GET.get('sensor_id')
    
    since = timezone.now() - timedelta(hours=hours)
    
    queryset = Reading.objects.filter(timestamp__gte=since)
    if sensor_id:
        queryset = queryset.filter(sensor__sensor_id=sensor_id)
    
    queryset = queryset.order_by('timestamp')
    
    data = []
    for reading in queryset:
        data.append({
            'sensor_id': reading.sensor.sensor_id,
            'pm1': reading.pm1,
            'pm25': reading.pm25,
            'pm10': reading.pm10,
            'timestamp': reading.timestamp.isoformat(),
        })
    
    return JsonResponse(data, safe=False)


@csrf_exempt
@require_http_methods(["PUT"])
def api_sensor_update(request, sensor_id):
    """Update sensor display name."""
    try:
        sensor = Sensor.objects.get(sensor_id=sensor_id)
        data = json.loads(request.body)
        
        if 'display_name' in data:
            sensor.display_name = data['display_name']
            sensor.save()
        
        return JsonResponse({'status': 'ok'})
    except Sensor.DoesNotExist:
        return JsonResponse({'error': 'Sensor not found'}, status=404)


@csrf_exempt
@require_http_methods(["POST"])
def api_reset_wifi(request, sensor_id):
    """Trigger WiFi reset on a sensor."""
    try:
        sensor = Sensor.objects.get(sensor_id=sensor_id)
        
        if not sensor.ip_address:
            return JsonResponse({'error': 'Sensor IP address unknown'}, status=400)
        
        # Send reset command to sensor
        try:
            with httpx.Client(timeout=5.0) as client:
                response = client.post(f"http://{sensor.ip_address}/reset-wifi")
                if response.status_code == 200:
                    return JsonResponse({'status': 'ok', 'message': 'WiFi reset triggered'})
                else:
                    return JsonResponse({'error': f'Sensor returned {response.status_code}'}, status=502)
        except httpx.RequestError as e:
            return JsonResponse({'error': f'Could not reach sensor: {str(e)}'}, status=502)
    
    except Sensor.DoesNotExist:
        return JsonResponse({'error': 'Sensor not found'}, status=404)


@csrf_exempt
@require_http_methods(["POST"])
def api_flash_firmware(request):
    """Flash firmware to connected ESP32 device."""
    # Use firmware directory relative to Django project
    firmware_path = os.path.join(settings.BASE_DIR, 'firmware')
    
    if not os.path.exists(firmware_path):
        return JsonResponse({'error': 'Firmware project not found'}, status=404)
    
    # Find pio command
    import shutil
    pio_cmd = shutil.which('pio') or shutil.which('platformio')
    if not pio_cmd:
        # Fallback to common locations
        for path in ['/usr/local/bin/pio', os.path.expanduser('~/.platformio/penv/bin/pio'),
                     os.path.expanduser('~/Library/Python/3.9/bin/pio')]:
            if os.path.exists(path):
                pio_cmd = path
                break
    
    if not pio_cmd:
        return JsonResponse({'error': 'PlatformIO not found. Install with: pip install platformio'}, status=404)
    
    try:
        result = subprocess.run(
            [pio_cmd, "run", "-t", "upload"],
            cwd=firmware_path,
            capture_output=True,
            text=True,
            timeout=120
        )
        
        if result.returncode == 0:
            return JsonResponse({
                'status': 'ok',
                'message': 'Firmware flashed successfully',
                'output': result.stdout[-2000:] if len(result.stdout) > 2000 else result.stdout
            })
        else:
            return JsonResponse({
                'error': 'Flash failed',
                'output': result.stderr[-2000:] if len(result.stderr) > 2000 else result.stderr
            }, status=500)
            
    except subprocess.TimeoutExpired:
        return JsonResponse({'error': 'Flash timed out'}, status=504)
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)
