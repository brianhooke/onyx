"""
Helicopter tool procedure generator.

Generates PROC Py2Heli() based on Andrew's HeliFC pattern with force control.
Key characteristics:
- Uses force control (FCPress commands) when heli_force > 0
- Falls back to fixed height mode when heli_force = 0
- X coordinates are negated (Bed1Wyong coordinate system)
- extax formula: Bed1Wyong.uframe.trans.x + trans.x + offset
- Track position clamped to limits - arm extends to reach beyond
"""

from .utils import get_track_limits


def generate_py2heli(params: dict) -> str:
    """
    Generate PROC Py2Heli() RAPID code with force control.
    
    Force control modes:
    - heli_force = 0: Fixed height mode (MoveL commands)
    - heli_force > 0: Force control mode (FCPressL commands)
    
    Uses frontend parameters:
    - panel_datum_x, panel_datum_y: Start corner (near track)
    - panel_x, panel_y: Panel dimensions  
    - panel_z: Panel height
    - heli_travel_speed: Travel speed
    - heli_blade_speed: Blade RPM
    - heli_blade_angle: Blade angle (degrees)
    - heli_z_offset: Additional Z offset
    - helicopter_step: Step size between passes
    - heli_force: Target force (N, 0=fixed height, 100-500=force control)
    
    Returns:
        Complete PROC Py2Heli() as a string
    """
    # Extract parameters (no defaults - values always provided by frontend/DB)
    workzone = params['heli_workzone']
    step_size = params['helicopter_step']
    global_z_offset = params['z_offset']
    heli_z_offset = params['heli_z_offset']
    total_z_offset = global_z_offset + heli_z_offset
    travel_speed = params['heli_travel_speed']
    blade_speed = params['heli_blade_speed']
    blade_angle = params['heli_blade_angle']
    
    # Calculate workzone boundaries based on selected workzone
    if workzone == 'panel':
        start_x = params['panel_datum_x']
        start_y = params['panel_datum_y']
        panel_x = params['panel_x']
        panel_y = params['panel_y']
        work_z = params['panel_z'] + total_z_offset
    else:  # bed
        start_x = params['bed_datum_x']
        start_y = params['bed_datum_y']
        panel_x = params['bed_length_x']
        panel_y = params['bed_width_y']
        work_z = total_z_offset  # Bed is at Z=0
    
    # Force control parameters
    heli_force = params['heli_force']
    force_change = 100  # Standard force change rate
    pos_supv_dist = 125  # Standard position supervision distance
    
    # Determine if force control is enabled
    use_force_control = heli_force > 0
    
    # Calculate end coordinates (far corner)
    end_x = start_x + panel_x
    end_y = start_y + panel_y
    
    # HeliBladeWidth constant (from baseline)
    blade_width = 600
    
    # Track limits (shared utility)
    track_min, track_max = get_track_limits(params)
    
    # Build conditional code blocks based on force control mode
    if use_force_control:
        mode_desc = f"FORCE CONTROL MODE: {heli_force}N"
        mode_note = f"Force={heli_force}N, ForceChange={force_change}, PosSupvDist={pos_supv_dist}"
        mode_tpwrite = 'TPWrite "MODE: FORCE CONTROL, Force=" \\Num:=HeliForce;'
        fc_calib = '''! Force control calibration
        TPWrite "Py2Heli: Calibrating force control...";
        FCCalib HeliLoad70rpm;
        WaitTime 0.5;'''
        fc_confirm = '''! Operator confirmation before force control engagement
        TPErase;
        TPWrite "Robot should be 100mm off concrete and above concrete.";
        TPWrite "Only press play if this is the case!!!";
        TPWrite "Otherwise PP to main.";
        Stop;'''
        fc_start = f'''! Start force control
        TPWrite "P1: Starting force control...";
        FCPress1LStart Offs(pStart,-25,0,-5),v10,\\Fz:=HeliForce,15,\\ForceChange:={force_change}\\PosSupvDist:={pos_supv_dist},z5,tHeli\\WObj:=Bed1Wyong;
        bFCActive:=TRUE;'''
        move_cmd = 'FCPressL'
        move_suffix = ',HeliForce,fine,tHeli\\WObj:=Bed1Wyong;'
        fc_end = '''! End force control BEFORE lifting (critical - prevents blade dig-in)
        TPWrite "FINISH: Ending force control...";
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tHeli\\WObj:=Bed1Wyong);
        FCPressEnd Offs(CurrentPos,0,0,50),v50,\\DeactOnly,tHeli\\WObj:=Bed1Wyong;
        bFCActive:=FALSE;
        TPWrite "FINISH: Force control ended, tool lifted off surface";'''
        error_fc = '''IF bFCActive THEN
            FCPressEnd Offs(CurrentPos,0,0,100),v50,\\DeactOnly,tHeli\\WObj:=Bed1Wyong;
        ENDIF'''
    else:
        mode_desc = "FIXED HEIGHT MODE"
        mode_note = f"Z = FormHeight(150) + z_offset({total_z_offset}) = {150 + total_z_offset}mm"
        mode_tpwrite = 'TPWrite "MODE: FIXED HEIGHT (no force control)";'
        fc_calib = ''
        fc_confirm = ''
        fc_start = '''! Lower to work height (fixed height mode)
        MoveL pStart,v50,fine,tHeli\\WObj:=Bed1Wyong;'''
        move_cmd = 'MoveL'
        move_suffix = ',fine,tHeli\\WObj:=Bed1Wyong;'
        fc_end = '''! Lift off surface BEFORE stopping blades (critical - prevents blade dig-in)
        TPWrite "FINISH: Lifting off surface...";
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tHeli\\WObj:=Bed1Wyong);
        MoveJ Offs(CurrentPos,0,0,50),v100,fine,tHeli\\WObj:=Bed1Wyong;
        TPWrite "FINISH: Tool lifted off surface";'''
        error_fc = ''
    
    # Build the procedure
    proc = f'''
    PROC Py2Heli()
        ! Py2Heli - Cross-hatch pattern with force control
        ! Generated by Onyx Toolpath Generator v2
        ! Panel: ({start_x},{start_y}) to ({end_x},{end_y})
        ! {mode_note}
        ! Step: {step_size}mm
        ! Pattern: X passes first, then Y passes
        ! Mode: {mode_desc}
        
        VAR robtarget pStart;
        VAR robtarget pEnd;
        VAR robtarget pCurrent;
        VAR jointtarget CurrentJoints;
        VAR robtarget CurrentPos;
        VAR num WorkZ:=0;
        VAR num SafeZ:=0;
        VAR num CurrentY:=0;
        VAR num CurrentX:=0;
        VAR num MinY:=0;
        VAR num MaxY:=0;
        VAR num MinX:=0;
        VAR num MaxX:=0;
        VAR num StepSize:={step_size};
        VAR num SweepDir:=1;
        VAR num StepDir:=1;
        VAR num PassCount:=0;
        VAR num NextX:=0;
        VAR num StartY:=0;
        VAR num EndY:=0;
        VAR bool bDone:=FALSE;
        VAR bool bFCActive:=FALSE;
        VAR speeddata vTravel:=[{travel_speed},15,2000,15];
        VAR num TrackMin:={track_min};
        VAR num TrackMax:={track_max};
        VAR num CalcTrack:=0;
        VAR num HeliForce:={heli_force};
        VAR fcforcevector myForceVector;
        
        ! Initialize runtime values
        WorkZ:=FormHeight+{total_z_offset};
        SafeZ:=WorkZ+200;
        MinY:={start_y}+{blade_width}/2;
        MaxY:={end_y}-{blade_width}/2;
        MinX:={start_x}+{blade_width}/2;
        MaxX:={end_x}-{blade_width}/2;
        
        TPWrite "========================================";
        TPWrite "Py2Heli: Cross-hatch Starting";
        TPWrite "========================================";
        TPWrite "Panel X: " \\Num:={start_x};
        TPWrite " to X: " \\Num:={end_x};
        TPWrite "Panel Y: " \\Num:={start_y};
        TPWrite " to Y: " \\Num:={end_y};
        TPWrite "WorkZ=" \\Num:=WorkZ;
        TPWrite "SafeZ=" \\Num:=SafeZ;
        TPWrite "MinX=" \\Num:=MinX;
        TPWrite "MaxX=" \\Num:=MaxX;
        TPWrite "MinY=" \\Num:=MinY;
        TPWrite "MaxY=" \\Num:=MaxY;
        TPWrite "StepSize=" \\Num:=StepSize;
        {mode_tpwrite}
        
        ! Get helicopter if needed
        IF ToolNum<>2 THEN
            TPWrite "Py2Heli: Getting helicopter...";
            Home;
            Heli_Pickup;
        ENDIF
        
        ! ============================================
        ! PHASE 1: X PASSES (sweep X, step in Y)
        ! Start at far Y, work back toward track
        ! ============================================
        TPWrite "========================================";
        TPWrite "=== PHASE 1: X Passes ===";
        TPWrite "========================================";
        CurrentY:=MaxY;
        SweepDir:=1;
        PassCount:=0;
        TPWrite "P1: Starting at CurrentY=" \\Num:=CurrentY;
        TPWrite "P1: Will step toward MinY=" \\Num:=MinY;
        
        ! Initialize start position (X negated per Andrew's pattern)
        pStart.trans:=[-1*(MinX-100),CurrentY,WorkZ];
        pStart.rot:=OrientZYX(0,0,180);
        pStart.robconf:=[0,0,0,0];
        
        IF CurrentY<1800 THEN
            CalcTrack:=Bed1Wyong.uframe.trans.x+pStart.trans.x+1000+{blade_width}/2;
        ELSE
            CalcTrack:=Bed1Wyong.uframe.trans.x+pStart.trans.x+{blade_width}/2;
        ENDIF
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pStart.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        
        pEnd:=pStart;
        pEnd.trans.x:=-1*(MaxX+100);
        IF CurrentY<1800 THEN
            CalcTrack:=Bed1Wyong.uframe.trans.x+pEnd.trans.x+1000-{blade_width}/2;
        ELSE
            CalcTrack:=Bed1Wyong.uframe.trans.x+pEnd.trans.x-{blade_width}/2;
        ENDIF
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pEnd.extax.eax_a:=CalcTrack;
        
        ! Move to start position (safe height)
        pStart.trans.z:=SafeZ;
        MoveJ pStart,v500,z5,tHeli\\WObj:=Bed1Wyong;
        
        ! Home stepper and set blade angle
        TPWrite "Py2Heli: Homing stepper...";
        Heli_Stepper_Home;
        TPWrite "Py2Heli: Setting blade angle to " \\Num:={blade_angle};
        HeliBlade_Angle {blade_angle};
        TPWrite "Py2Heli: Blade angle set to " \\Num:={blade_angle};
        WaitTime 1;
        
        {fc_calib}
        
        ! Disable configuration tracking for cross-hatch movements
        ConfL\\Off;
        ConfJ\\Off;
        
        ! Start blade rotation
        TPWrite "Py2Heli: Starting blade at " \\Num:={blade_speed};
        TPWrite " RPM...";
        HeliBladeSpeed {blade_speed},"FWD";
        WaitTime 2;
        
        ! Lower to approach height
        pStart.trans.z:=WorkZ;
        MoveJ Offs(pStart,0,0,100),v100,z5,tHeli\\WObj:=Bed1Wyong;
        
        {fc_confirm}
        
        MoveJ Offs(pStart,0,0,50),v50,z5,tHeli\\WObj:=Bed1Wyong;
        
        {fc_start}
        
        TPWrite "P1: Entering X-pass loop...";
        bDone:=FALSE;
        
        ! X-pass loop (using flag instead of EXIT)
        WHILE CurrentY>=MinY AND bDone=FALSE DO
            Incr PassCount;
            TPWrite "----------------------------------------";
            TPWrite "P1: X Pass " \\Num:=PassCount;
            TPWrite "P1: CurrentY=" \\Num:=CurrentY;
            TPWrite "P1: SweepDir=" \\Num:=SweepDir;
            
            pStart.trans.y:=CurrentY;
            pEnd.trans.y:=CurrentY;
            
            IF CurrentY<1800 THEN
                CalcTrack:=Bed1Wyong.uframe.trans.x+pStart.trans.x+1000+{blade_width}/2;
            ELSE
                CalcTrack:=Bed1Wyong.uframe.trans.x+pStart.trans.x+{blade_width}/2;
            ENDIF
            IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
            IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
            pStart.extax.eax_a:=CalcTrack;
            
            IF CurrentY<1800 THEN
                CalcTrack:=Bed1Wyong.uframe.trans.x+pEnd.trans.x+1000-{blade_width}/2;
            ELSE
                CalcTrack:=Bed1Wyong.uframe.trans.x+pEnd.trans.x-{blade_width}/2;
            ENDIF
            IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
            IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
            pEnd.extax.eax_a:=CalcTrack;
            
            IF SweepDir=1 THEN
                TPWrite "P1: Sweep to pEnd (far X)";
                {move_cmd} pEnd,vTravel{move_suffix}
            ELSE
                TPWrite "P1: Sweep to pStart (near X)";
                {move_cmd} pStart,vTravel{move_suffix}
            ENDIF
            
            ! Log force and Z position after sweep
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tHeli\WObj:=Bed1Wyong);
            myForceVector:=FCGetForce(\Tool:=tHeli);
            TPWrite "P1: Z=" \\Num:=CurrentPos.trans.z;
            TPWrite "P1: Force=" \\Num:=myForceVector.zforce;
            TPWrite "P1: Sweep complete";
            
            IF (CurrentY-StepSize)<MinY THEN
                TPWrite "P1: Last pass - (CurrentY-StepSize) < MinY";
                TPWrite "P1: Setting bDone=TRUE to exit loop";
                bDone:=TRUE;
            ELSE
                ! Only step to next row if not done
                CurrentY:=CurrentY-StepSize;
                TPWrite "P1: Step to next Y row=" \\Num:=CurrentY;
                
                IF SweepDir=1 THEN
                    pEnd.trans.y:=CurrentY;
                    IF CurrentY<1800 THEN
                        CalcTrack:=Bed1Wyong.uframe.trans.x+pEnd.trans.x+1000-{blade_width}/2;
                    ELSE
                        CalcTrack:=Bed1Wyong.uframe.trans.x+pEnd.trans.x-{blade_width}/2;
                    ENDIF
                    IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
                    IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
                    pEnd.extax.eax_a:=CalcTrack;
                    {move_cmd} pEnd,vTravel{move_suffix}
                    
                    ! Log force and Z after step move
                    CurrentJoints:=CJointT();
                    CurrentPos:=CalcRobT(CurrentJoints,tHeli\WObj:=Bed1Wyong);
                    myForceVector:=FCGetForce(\Tool:=tHeli);
                    TPWrite "P1: Z=" \\Num:=CurrentPos.trans.z;
                    TPWrite "P1: Force=" \\Num:=myForceVector.zforce;
                ELSE
                    pStart.trans.y:=CurrentY;
                    IF CurrentY<1800 THEN
                        CalcTrack:=Bed1Wyong.uframe.trans.x+pStart.trans.x+1000+{blade_width}/2;
                    ELSE
                        CalcTrack:=Bed1Wyong.uframe.trans.x+pStart.trans.x+{blade_width}/2;
                    ENDIF
                    IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
                    IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
                    pStart.extax.eax_a:=CalcTrack;
                    {move_cmd} pStart,vTravel{move_suffix}
                    
                    ! Log force and Z after step move
                    CurrentJoints:=CJointT();
                    CurrentPos:=CalcRobT(CurrentJoints,tHeli\WObj:=Bed1Wyong);
                    myForceVector:=FCGetForce(\Tool:=tHeli);
                    TPWrite "P1: Z=" \\Num:=CurrentPos.trans.z;
                    TPWrite "P1: Force=" \\Num:=myForceVector.zforce;
                ENDIF
                
                SweepDir:=-1*SweepDir;
            ENDIF
        ENDWHILE
        
        TPWrite "P1: X passes complete, total=" \\Num:=PassCount;
        TPWrite "P1: Final position Y=" \\Num:=CurrentY;
        TPWrite "P1: pEnd.trans.x=" \\Num:=pEnd.trans.x;
        
        ! ============================================
        ! PHASE 2: Y PASSES (sweep Y, step in X)
        ! Continue from where Pass 1 ended
        ! ============================================
        TPWrite "========================================";
        TPWrite "=== PHASE 2: Y Passes ===";
        TPWrite "========================================";
        
        ! Continue from where X passes ended - NO diagonal repositioning
        IF SweepDir=1 THEN
            CurrentX:=MaxX;
        ELSE
            CurrentX:=MinX;
        ENDIF
        TPWrite "P2: Starting from CurrentX=" \\Num:=CurrentX;
        TPWrite "P2: Starting from CurrentY=" \\Num:=CurrentY;
        
        ! Step direction: continue stepping in X from where we are
        IF CurrentX>=MaxX THEN
            StepDir:=-1;
            TPWrite "P2: StepDir=-1 (toward MinX)";
        ELSE
            StepDir:=1;
            TPWrite "P2: StepDir=+1 (toward MaxX)";
        ENDIF
        
        ! First Y sweep: go to opposite Y bound from current position
        IF CurrentY>((MinY+MaxY)/2) THEN
            EndY:=MinY;
            TPWrite "P2: First sweep toward MinY";
        ELSE
            EndY:=MaxY;
            TPWrite "P2: First sweep toward MaxY";
        ENDIF
        
        PassCount:=0;
        
        ! First Y sweep from current position
        TPWrite "P2: First Y sweep to EndY=" \\Num:=EndY;
        pEnd.trans.x:=-1*CurrentX;
        pEnd.trans.y:=EndY;
        CalcTrack:=Bed1Wyong.uframe.trans.x+pEnd.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pEnd.extax.eax_a:=CalcTrack;
        TPWrite "P2: Moving...";
        {move_cmd} pEnd,vTravel{move_suffix}
        CurrentY:=EndY;
        
        ! Log force and Z after first Y sweep
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tHeli\WObj:=Bed1Wyong);
        myForceVector:=FCGetForce(\Tool:=tHeli);
        TPWrite "P2: Z=" \\Num:=CurrentPos.trans.z;
        TPWrite "P2: Force=" \\Num:=myForceVector.zforce;
        TPWrite "P2: First Y sweep complete";
        
        TPWrite "P2: Entering Y-pass loop...";
        bDone:=FALSE;
        
        ! Y-pass loop - step in X, sweep in Y
        WHILE bDone=FALSE DO
            Incr PassCount;
            TPWrite "----------------------------------------";
            TPWrite "P2: Y Pass " \\Num:=PassCount;
            
            ! Calculate next column
            NextX:=CurrentX+(StepDir*StepSize);
            TPWrite "P2: CurrentX=" \\Num:=CurrentX;
            TPWrite "P2: NextX=" \\Num:=NextX;
            
            ! Check if complete
            IF (StepDir=1 AND NextX>MaxX) OR (StepDir=-1 AND NextX<MinX) THEN
                TPWrite "P2: NextX out of bounds - setting bDone=TRUE";
                bDone:=TRUE;
            ELSE
                ! Clamp to bounds
                IF NextX>MaxX THEN
                    NextX:=MaxX;
                    TPWrite "P2: Clamped to MaxX";
                ELSEIF NextX<MinX THEN
                    NextX:=MinX;
                    TPWrite "P2: Clamped to MinX";
                ENDIF
                
                ! Step to next X column
                TPWrite "P2: Step to X=" \\Num:=NextX;
                pEnd.trans.x:=-1*NextX;
                CalcTrack:=Bed1Wyong.uframe.trans.x-NextX;
                IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
                IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
                pEnd.extax.eax_a:=CalcTrack;
                TPWrite "P2: Moving to next X column...";
                {move_cmd} pEnd,vTravel{move_suffix}
                
                ! Log force and Z after step
                CurrentJoints:=CJointT();
                CurrentPos:=CalcRobT(CurrentJoints,tHeli\WObj:=Bed1Wyong);
                myForceVector:=FCGetForce(\Tool:=tHeli);
                TPWrite "P2: Z=" \\Num:=CurrentPos.trans.z;
                TPWrite "P2: Force=" \\Num:=myForceVector.zforce;
                TPWrite "P2: Step complete";
                CurrentX:=NextX;
                
                ! Flip sweep direction
                SweepDir:=-1*SweepDir;
                IF SweepDir=1 THEN
                    EndY:=MinY;
                    TPWrite "P2: Next sweep toward MinY=" \\Num:=EndY;
                ELSE
                    EndY:=MaxY;
                    TPWrite "P2: Next sweep toward MaxY=" \\Num:=EndY;
                ENDIF
                
                ! Sweep Y
                TPWrite "P2: Sweep to Y=" \\Num:=EndY;
                pEnd.trans.y:=EndY;
                TPWrite "P2: Moving...";
                {move_cmd} pEnd,vTravel{move_suffix}
                
                ! Log force and Z after Y sweep
                CurrentJoints:=CJointT();
                CurrentPos:=CalcRobT(CurrentJoints,tHeli\WObj:=Bed1Wyong);
                myForceVector:=FCGetForce(\Tool:=tHeli);
                TPWrite "P2: Z=" \\Num:=CurrentPos.trans.z;
                TPWrite "P2: Force=" \\Num:=myForceVector.zforce;
                TPWrite "P2: Sweep complete";
            ENDIF
        ENDWHILE
        
        TPWrite "========================================";
        TPWrite "P2: Y passes complete, total=" \\Num:=PassCount;
        TPWrite "Cross-hatch complete!";
        TPWrite "========================================";
        
        ! ============================================
        ! FINISH: LIFT OFF FIRST, then stop blade, return tool
        ! CRITICAL: Must lift off before stopping blades to prevent dig-in
        ! ============================================
        TPWrite "========================================";
        TPWrite "=== FINISH ===";
        TPWrite "========================================";
        
        {fc_end}
        
        ! NOW stop the blade (tool is already off the surface)
        TPWrite "FINISH: Stopping blade...";
        HeliBladeSpeed 0,"FWD";
        WaitTime 1;
        TPWrite "FINISH: Blade stopped";
        
        ! Lift further off the bed
        TPWrite "FINISH: Lifting to safe height...";
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tHeli\\WObj:=Bed1Wyong);
        MoveJ Offs(CurrentPos,0,0,200),v100,fine,tHeli\\WObj:=Bed1Wyong;
        TPWrite "FINISH: At safe height";
        
        ! Re-enable configuration tracking
        TPWrite "FINISH: Re-enabling ConfL/ConfJ...";
        ConfL\\On;
        ConfJ\\On;
        TPWrite "FINISH: Configuration tracking enabled";
        
        ! Return tool
        TPWrite "FINISH: Dropping off helicopter...";
        Heli_Dropoff;
        TPWrite "FINISH: Helicopter dropped off";
        
        TPWrite "FINISH: Homing...";
        Home;
        
        TPWrite "========================================";
        TPWrite "Py2Heli: COMPLETE";
        TPWrite "========================================";
        
    ERROR
        HeliBladeSpeed 0,"FWD";
        {error_fc}
        RAISE;
    ENDPROC
'''
    return proc
