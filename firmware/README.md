# Air Quality Sensor Network

Distributed air quality monitoring system for factory environments. 5 ESP32 + Sensirion SPS30 sensor nodes report to a central server with database logging and a unified web dashboard.

> **📋 See [SCOPE.md](SCOPE.md) for full requirements, architecture, and progress tracking.**

## System Overview

- **5 sensor nodes** — ESP32 + SPS30 distributed across factory floor
- **Central server** — Receives data from all sensors, stores in database
- **Web dashboard** — Live table of all sensors + filterable time-series graph

## Hardware (per node)

- **Microcontroller:** ESP32-D (ESP32-WROOM-32)
- **Sensor:** Sensirion SPS30 (PM1.0, PM2.5, PM10 laser-based particle sensor)
- **Communication:** I2C (SDA: GPIO32, SCL: GPIO33)

## Features

- **Multi-sensor monitoring** — 5 devices with unique IDs reporting to central DB
- **Real-time dashboard** — Table view of all sensors + interactive graph
- **Graph filtering** — Filter by particle size (PM1, PM2.5, PM10) and sensor
- **WiFi connectivity** — Captive portal configuration via WiFiManager
- **OTA updates** — Firmware updates over WiFi via ArduinoOTA
- **Fan cleaning** — Trigger SPS30's built-in high-speed fan cleaning cycle

## Wiring

| SPS30 Pin | ESP32 Pin |
|-----------|-----------|
| VCC       | 5V        |
| GND       | GND       |
| SDA       | GPIO 32   |
| SCL       | GPIO 33   |

## First-Time Setup

1. Power on the ESP32
2. Connect to the `AirQuality-AP` WiFi network from your phone/computer
3. A captive portal will open — select your WiFi network and enter credentials
4. Optionally set the sensor polling interval (default: 5 seconds, minimum: 5)
5. Once connected, the serial monitor displays the device's IP address

## Web Interface

**Central Dashboard:** `http://<server-ip>:8000/` (planned)

**Individual Sensor Fallback:** `http://<sensor-ip>/`
- `/` — Local dashboard with single-sensor readings
- `/data` — JSON API returning `{pm1, pm25, pm10, interval}`
- `/clean` — Triggers SPS30 fan cleaning cycle

## Building & Flashing

This is a PlatformIO project.

**1. Upload filesystem (HTML/CSS/JS):**
```bash
pio run -t uploadfs
```

**2. Upload firmware:**
```bash
pio run -t upload
```

**3. Monitor serial output:**
```bash
pio device monitor
```

> **Note:** You must upload the filesystem (`uploadfs`) at least once before the web interface will work. After that, you can update firmware independently.

## Dependencies

**Sensor firmware** (PlatformIO):
- `WiFiManager` — Captive portal WiFi configuration
- `ESPAsyncWebServer` — Async HTTP server
- `AsyncTCP` — TCP library for async web server
- `ArduinoOTA` — Over-the-air firmware updates
- `sps30` — Sensirion SPS30 driver (paulvha)
- `LittleFS` — Flash filesystem for web assets (built-in)

**Central server** (planned):
- Python 3.x + FastAPI
- SQLite (MVP) / PostgreSQL (production)

## Project Structure

```
air_quality_sensor_network/
├── firmware/                 # ESP32 sensor code (current: src/)
│   ├── src/main.cpp
│   ├── data/index.html
│   └── platformio.ini
├── server/                   # Central server (planned)
│   ├── app.py
│   ├── database.py
│   └── requirements.txt
├── dashboard/                # Web frontend (planned)
│   ├── index.html
│   ├── styles.css
│   └── app.js
├── SCOPE.md                  # Requirements & progress tracking
└── README.md
```

## License

MIT
