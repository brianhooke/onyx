# Force Sensing Integration Plan

## Overview

The ForceMonitor.mod provides real-time 6-axis force/torque sensing via `FCGetForce()`. This plan outlines how to integrate force monitoring **inside** the generated toolpath procedures.

## Current Architecture

### ForceMonitor.mod (standalone)
```rapid
VAR fcforcevector forces;

PROC force_monitor()
    WHILE TRUE DO
        forces := FCGetForce();
        SetAO AO_Force_X, forces.xforce;
        SetAO AO_Force_Y, forces.yforce;
        SetAO AO_Force_Z, forces.zforce;
        SetAO AO_Force_TX, forces.xtorque;
        SetAO AO_Force_TY, forces.ytorque;
        SetAO AO_Force_TZ, forces.ztorque;
        WaitTime 0.01;  ! 10ms polling
    ENDWHILE
ENDPROC
```

**Problem:** This runs as a separate background task, NOT integrated with toolpath motion.

## Integration Strategy

### Option A: Inline Force Monitoring (Recommended)

Embed force sensing directly into generated toolpath procedures:

```rapid
PROC Py2Heli()
    VAR fcforcevector forces;
    VAR num maxForceZ := 0;
    
    ! Before each motion segment
    forces := FCGetForce();
    IF Abs(forces.zforce) > ForceLimit THEN
        ! Force exceeded - take action
        StopMove;
        TPWrite "Force limit exceeded: " \Num:=forces.zforce;
        RAISE ERR_FORCE_LIMIT;
    ENDIF
    
    ! Execute motion with force monitoring
    FCPressL pCurrent, vTravel, TargetForce, fine, tHeli \WObj:=Bed1Wyong;
    
    ! Log peak force after segment
    forces := FCGetForce();
    IF Abs(forces.zforce) > maxForceZ THEN
        maxForceZ := Abs(forces.zforce);
    ENDIF
ENDPROC
```

### Option B: Parallel Task Force Monitor

Run force monitoring as a parallel RAPID task that shares data with toolpath task:

```rapid
! In ForceMonitor task (T_ROB2 or background)
PERS num gForceX := 0;
PERS num gForceY := 0;
PERS num gForceZ := 0;
PERS bool gForceAlarm := FALSE;

PROC ForceMonitorTask()
    VAR fcforcevector forces;
    WHILE TRUE DO
        forces := FCGetForce();
        gForceX := forces.xforce;
        gForceY := forces.yforce;
        gForceZ := forces.zforce;
        
        IF Abs(forces.zforce) > gForceLimit THEN
            gForceAlarm := TRUE;
        ENDIF
        WaitTime 0.01;
    ENDWHILE
ENDPROC

! In toolpath task (T_ROB1)
PROC Py2Heli()
    ! Check shared force alarm
    IF gForceAlarm THEN
        StopMove;
        RAISE ERR_FORCE_LIMIT;
    ENDIF
    
    ! Use shared force values
    TPWrite "Current Z Force: " \Num:=gForceZ;
ENDPROC
```

## Implementation Steps

### Phase 1: Add Force Variables to Tool Class

Modify `tool_class.py` to add force-related variable declarations:

```python
def _generate_var_declarations(self, params: Dict, workzone: Dict, track_min: float, track_max: float) -> List[str]:
    lines = super()._generate_var_declarations(params, workzone, track_min, track_max)
    
    # Add force monitoring variables
    if self._uses_force_control(params):
        lines.extend([
            "        VAR fcforcevector CurrentForces;",
            "        VAR num PeakForceZ := 0;",
            f"        VAR num ForceLimit := {params.get('force_limit', 500)};",
        ])
    
    return lines
```

### Phase 2: Add Force Checks in Pattern Execution

Modify `_generate_pattern_execution()` to include force monitoring:

```python
def _generate_pattern_execution(self, points: List[Point], params: Dict, workzone: Dict) -> List[str]:
    lines = []
    
    for i, point in enumerate(points):
        # Add force check before each move
        if self._uses_force_control(params):
            lines.extend([
                "        ! Check force before move",
                "        CurrentForces := FCGetForce();",
                "        IF Abs(CurrentForces.zforce) > ForceLimit THEN",
                "            StopMove;",
                "            TPWrite \"Force limit at point \" \\Num:={};".format(i),
                "            RAISE ERR_FORCE_LIMIT;",
                "        ENDIF",
            ])
        
        # Generate move command
        lines.append(f"        {move_cmd}")
        
        # Track peak force after move
        if self._uses_force_control(params):
            lines.extend([
                "        CurrentForces := FCGetForce();",
                "        IF Abs(CurrentForces.zforce) > PeakForceZ THEN",
                "            PeakForceZ := Abs(CurrentForces.zforce);",
                "        ENDIF",
            ])
    
    return lines
```

### Phase 3: Add Force Parameters to Frontend

Add new parameters to `toolpath_generator_compact.html`:

- `force_limit` - Maximum allowed force (N)
- `force_monitoring_enabled` - Enable/disable inline force checks
- `force_log_interval` - How often to log force values (every N points)

### Phase 4: Real-time Force Display

The Force Monitor UI (already added) polls `/api/irc5/force-data/` to display:
- 6-axis force/torque bar charts
- Force Z history sparkline
- Peak force tracking

## Required IRC5 Configuration

### Analog Outputs
Create these AO signals in the IRC5 I/O configuration:
- `AO_Force_X` (range: -500 to 500)
- `AO_Force_Y` (range: -500 to 500)
- `AO_Force_Z` (range: -500 to 500)
- `AO_Force_TX` (range: -50 to 50)
- `AO_Force_TY` (range: -50 to 50)
- `AO_Force_TZ` (range: -50 to 50)

### Force Control Prerequisites
- Force Control option must be installed
- Load identification must be performed (`FCLoadID`, `FCCalib`)
- Tool data must include correct mass/CoG

## Error Handling

Add new error codes:
```rapid
CONST errnum ERR_FORCE_LIMIT := 100;
CONST errnum ERR_FORCE_SENSOR := 101;
```

Error handler in toolpath:
```rapid
ERROR
    IF ERRNO = ERR_FORCE_LIMIT THEN
        TPWrite "Force limit exceeded - stopping";
        ! Lift tool to safe height
        MoveL Offs(CurrentPos, 0, 0, 200), v100, z5, tHeli;
    ENDIF
    RAISE;
```

## Timeline

1. **Phase 1** (Now): Force Monitor UI + API endpoint ✓
2. **Phase 2** (Next): Add force variables to tool_class.py
3. **Phase 3**: Implement inline force checks in pattern execution
4. **Phase 4**: Frontend parameters for force limits
5. **Phase 5**: Testing with actual force control hardware

## Files to Modify

- `robot_control/generator/tool_class.py` - Add force monitoring to generated RAPID
- `robot_control/generator/generator.py` - Include force parameters
- `robot_control/templates/robot_control/toolpath_generator_compact.html` - Force settings UI
- `robot_control/generator/ForceMonitor.mod` - Reference implementation (moved)
