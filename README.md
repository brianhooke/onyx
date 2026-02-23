# Onyx

Django application for ABB IRB 6700 Robot Control and Air Quality Monitoring.

## Setup

1. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

2. Run migrations:
   ```bash
   python3 manage.py migrate
   ```

## Running the Server

### With Air Quality Sensors (Recommended)

To enable mDNS discovery for air quality sensors, use the custom command:

```bash
python3 manage.py runserver_mdns 0.0.0.0:8000
```

This advertises the server as `onyx-server.local` on your local network, allowing ESP32 sensors to automatically discover and connect.

### Standard Mode (No Sensor Support)

```bash
python3 manage.py runserver 0.0.0.0:8000
```

## Features

- **Robot Control** (`/`) - ABB IRB 6700 control dashboard
- **Air Quality** (`/air-quality/`) - Real-time PM1.0, PM2.5, PM10 monitoring from ESP32 sensors

## Notes

- Only run one instance of `runserver_mdns` on the network at a time
- Sensors use mDNS to find `onyx-server.local` - no hardcoded IPs needed
- Database is local SQLite (`db.sqlite3`) - historical data doesn't sync between machines
