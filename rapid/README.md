# RAPID Force Monitor Module

## Overview
This module reads ATI Force/Torque sensor data via ABB Force Control and exposes the values as persistent variables that can be read via Robot Web Services (RWS).

## Installation

1. **Copy the module to the controller:**
   - Transfer `ForceMonitor.mod` to the controller via USB or FTP
   - Or manually create the module in the Program Editor

2. **Load the module:**
   - On the FlexPendant: Program Editor → Modules → Load Module
   - Select `ForceMonitor.mod`

3. **Option A - Run from main program:**
   Add this call in your main program loop:
   ```rapid
   ForceReadOnce;
   ```

4. **Option B - Run as background task (recommended for continuous monitoring):**
   - Create a new SEMI-STATIC task in the controller configuration
   - Set the entry point to `ForceMonitorStart`
   - This will continuously update force values at 20Hz

## Variables Exposed

| Variable | Type | Description |
|----------|------|-------------|
| `fm_fx` | num | Force X (Newtons) |
| `fm_fy` | num | Force Y (Newtons) |
| `fm_fz` | num | Force Z (Newtons) |
| `fm_tx` | num | Torque X (Newton-meters) |
| `fm_ty` | num | Torque Y (Newton-meters) |
| `fm_tz` | num | Torque Z (Newton-meters) |
| `fm_status` | num | 0=stopped, 1=running, -1=error |
| `fm_timestamp` | num | Last update time |

## Reading via RWS

Once running, read values from the Onyx app or via curl:

```bash
# Read force X
curl --digest -u "Default User:robotics" \
  "http://192.168.125.1/rw/rapid/symbol/data/RAPID/T_ROB1/ForceMonitor/fm_fx"

# Read all forces (requires multiple calls)
```

## Troubleshooting

- **FCGetForce not found:** Ensure Force Control option is installed
- **Values always 0:** Check sensor connection and calibration
- **fm_status = -1:** Error reading sensor, check Force Control configuration

## Customization

Edit `UPDATE_INTERVAL` in the module to change the update rate:
- `0.05` = 20Hz (default)
- `0.1` = 10Hz
- `0.25` = 4Hz
