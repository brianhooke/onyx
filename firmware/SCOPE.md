# Air Quality Sensor Network — Project Scope

## Overview

Distributed air quality monitoring system for factory environment using 5 ESP32 + Sensirion SPS30 sensor nodes, a central database, and a web dashboard.

---

## System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        FACTORY FLOOR                            │
│                                                                 │
│   [Sensor 1]    [Sensor 2]    [Sensor 3]    [Sensor 4]    [Sensor 5]
│       │             │             │             │             │
│       └─────────────┴──────┬──────┴─────────────┴─────────────┘
│                            │ WiFi                              
└────────────────────────────┼────────────────────────────────────┘
                             │
                    ┌────────▼────────┐
                    │   Central PC    │
                    │  ┌───────────┐  │
                    │  │  Database │  │
                    │  └───────────┘  │
                    │  ┌───────────┐  │
                    │  │  Web App  │  │
                    │  └───────────┘  │
                    └─────────────────┘
```

---

## Hardware (per node)

| Component | Details |
|-----------|---------|
| MCU | ESP32-D (ESP32-WROOM-32) |
| Sensor | Sensirion SPS30 (PM1.0, PM2.5, PM10) |
| Interface | I2C (SDA: GPIO32, SCL: GPIO33) |
| Power | 5V USB or DC adapter |

**Total: 5 sensor nodes**

---

## Requirements

### 1. Sensor Nodes (ESP32 firmware)

| ID | Requirement | Status |
|----|-------------|--------|
| SN-1 | Each device has a unique identifier (e.g., `SENSOR_01` ... `SENSOR_05`) | ✅ Done |
| SN-2 | Device sends PM1.0, PM2.5, PM10 readings to central server | ✅ Done |
| SN-3 | Configurable reporting interval (default 5s, min 5s) | ✅ Done |
| SN-4 | WiFi configuration via captive portal (WiFiManager) | ✅ Done |
| SN-5 | OTA firmware updates | ✅ Done (ArduinoOTA) |
| SN-6 | Manual fan cleaning trigger | ✅ Done |
| SN-7 | Local web UI for single-sensor view (optional fallback) | ✅ Done |

### 2. Central Database

| ID | Requirement | Status |
|----|-------------|--------|
| DB-1 | Runs on dedicated PC on local network | ✅ Done |
| DB-2 | Stores readings: timestamp, sensor_id, pm1, pm25, pm10 | ✅ Done |
| DB-3 | Supports historical queries (time range, sensor filter) | ✅ Done |
| DB-4 | Database choice: SQLite (simple) or PostgreSQL (scalable) | ✅ Done (SQLite) |
| DB-5 | Store sensor display names (user-editable, default `SENSOR_01`...) | ✅ Done |
| DB-6 | Data compression: aggregate raw 5s readings to 1-minute averages at EOD | ✅ Done (2am daily) |
| DB-7 | Retain all historical data (compressed) indefinitely | ✅ Done |

### 3. Web Dashboard

| ID | Requirement | Status |
|----|-------------|--------|
| WD-1 | Displays live readings from all 5 sensors in a table | ✅ Done |
| WD-2 | Table columns: Sensor Name, PM1.0, PM2.5, PM10, Last Updated | ✅ Done |
| WD-8 | Editable sensor names (stored in DB, default `SENSOR_01`...) | ✅ Done |
| WD-3 | Time-series graph showing readings over time | ✅ Done |
| WD-4 | Graph filter: by particle size (PM1, PM2.5, PM10) | ✅ Done |
| WD-5 | Graph filter: by sensor (any combination of 5) | ✅ Done |
| WD-6 | Responsive design for PC browser | ✅ Done |
| WD-7 | Auto-refresh / real-time updates | ✅ Done |

### 4. Communication Protocol

| ID | Requirement | Status |
|----|-------------|--------|
| CP-1 | Sensors POST data to central server via HTTP/REST | ✅ Done |
| CP-2 | JSON payload: `{sensor_id, pm1, pm25, pm10, timestamp}` | ✅ Done |
| CP-3 | Central server acknowledges receipt | ✅ Done |

---

## Tech Stack (Proposed)

| Layer | Technology |
|-------|------------|
| Sensor firmware | C++ / Arduino / PlatformIO |
| Central server | Python (FastAPI or Flask) |
| Database | SQLite (MVP) → PostgreSQL (production) |
| Web frontend | HTML/CSS/JS + Chart.js |
| Hosting | Local PC on factory LAN |

---

## Milestones

| # | Milestone | Target |
|---|-----------|--------|
| M1 | Single sensor working with local web UI | ✅ Complete |
| M2 | Sensor firmware with unique ID + HTTP POST to server | ✅ Complete |
| M3 | Central server + database receiving/storing data | ✅ Complete |
| M4 | Web dashboard with live table | ✅ Complete |
| M5 | Web dashboard with filterable graph | ✅ Complete |
| M6 | Deploy 5 sensors across factory | ⬜ |

---

## Design Decisions

| Decision | Resolution |
|----------|------------|
| Sensor naming | Default to `SENSOR_01`...`SENSOR_05`, user can rename via dashboard (names stored in DB) |
| Data retention | Keep forever, but compress: raw 5s data aggregated to 1-min averages at end of day |
| Alerting | Not required |
| Network | Assume all devices on same local network (sensors can reach server IP) |

---

## File Structure (Planned)

```
air_quality_sensor_network/
├── firmware/                 # ESP32 sensor code
│   ├── src/main.cpp
│   ├── platformio.ini
│   └── data/index.html       # Local fallback UI
├── server/                   # Central server + DB
│   ├── app.py                # FastAPI/Flask server
│   ├── database.py           # DB models/queries
│   └── requirements.txt
├── dashboard/                # Web frontend
│   ├── index.html
│   ├── styles.css
│   └── app.js
├── SCOPE.md                  # This file
└── README.md                 # Setup instructions
```

---

*Last updated: Feb 2026*
