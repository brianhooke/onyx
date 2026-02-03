"""
Polisher tool procedure generator.

Generates PROC Py2Polish() based on Andrew's Polish pattern.
Key aspects:
1. Uses tPolish tool (ToolNum = 6)
2. Force control with FCPress commands
3. Serpentine pattern across bed/panel
4. Bed1Wyong work object
"""

from .utils import get_track_limits


def generate_py2polish(params: dict) -> str:
    """
    Generate PROC Py2Polish() RAPID code.
    
    Based on Andrew's working Polish pattern with force control.
    Uses serpentine pattern across the workzone.
    
    Uses frontend parameters:
    - polisher_workzone: 'bed' or 'panel'
    - polisher_step: Step size between passes (mm)
    - polisher_z_offset: Additional Z offset (mm)
    - polisher_start_force: Initial press force (N)
    - polisher_motion_force: Motion force (N)
    - polisher_force_change: Force change threshold (N)
    - polisher_approach_speed: Approach speed (mm/s)
    - polisher_retract_speed: Retract speed (mm/s)
    - polisher_pos_supv_dist: Position supervision distance (mm)
    - Panel/bed dimensions for workzone calculation
    
    Returns:
        Complete PROC Py2Polish() as a string
    """
    # Extract parameters with defaults
    workzone = params.get('polisher_workzone', 'bed')
    step_size = params.get('polisher_step', 450)
    global_z_offset = params.get('z_offset', 0)
    polisher_z_offset = params.get('polisher_z_offset', 0)
    total_z_offset = global_z_offset + polisher_z_offset
    
    # Force control parameters (defaults from Andrew's working Polish pattern)
    start_force = params.get('polisher_start_force', 300)
    motion_force = params.get('polisher_motion_force', 300)
    force_change = params.get('polisher_force_change', 100)
    approach_speed = params.get('polisher_approach_speed', 20)
    retract_speed = params.get('polisher_retract_speed', 50)
    pos_supv_dist = params.get('polisher_pos_supv_dist', 100)
    
    # Check if force control is disabled (all 3 force params = 0)
    force_enabled = not (start_force == 0 and motion_force == 0 and force_change == 0)
    
    # Track limits (shared utility)
    track_min, track_max = get_track_limits(params)
    
    # Calculate workzone boundaries based on selected workzone
    if workzone == 'panel':
        # Panel mode: use panel datum + dimensions
        datum_x = params.get('panel_datum_x', 1100)
        datum_y = params.get('panel_datum_y', 600)
        length_x = params.get('panel_x', 5900)
        width_y = params.get('panel_y', 2200)
        work_z = 150 + total_z_offset  # FormHeight + offset
    else:  # bed
        # Bed mode: use bed datum + dimensions
        datum_x = params.get('bed_datum_x', 0)
        datum_y = params.get('bed_datum_y', 0)
        length_x = params.get('bed_length_x', 8500)
        width_y = params.get('bed_width_y', 1650)
        work_z = total_z_offset  # Bed is at Z=0
    
    # Start position offset by half step size (tool centered on first pass)
    start_x = datum_x + step_size // 2
    start_y = datum_y + step_size // 2
    end_x = datum_x + length_x
    end_y = datum_y + width_y
    
    # Polisher tool width for edge offsets (not used for boundary calc anymore)
    polish_width = 200  # Approximate polisher contact width
    
    # Generate pass code based on force control setting (NO LIFT during sweep)
    if force_enabled:
        pass_code = f'''            IF SweepDir=1 THEN
                ! Forward pass (MinX to MaxX)
                TPWrite "Forward pass to MaxX";
                
                ! Calibrate and lower to work height
                WaitTime\\inpos,0.1;
                FCCalib PolishLoad;
                MoveL Offs(pStart,0,0,50),vApproach,fine,tPolish\\WObj:=Bed1Wyong;
                
                ! Start force control
                FCPress1LStart Offs(pStart,0,0,0),vApproach,\\Fz:={start_force},15,\\ForceChange:={force_change}\\PosSupvDist:={pos_supv_dist},z5,tPolish\\WObj:=Bed1Wyong;
                
                ! Travel across with force control
                FCPressL pEnd,vTravel,{motion_force},fine,tPolish\\WObj:=Bed1Wyong;
                
                ! End force control and retract
                FCPressEnd Offs(pEnd,0,0,75),vRetract,\\DeactOnly,tPolish\\WObj:=Bed1Wyong;
                
            ELSE
                ! Reverse pass (MaxX to MinX)
                TPWrite "Reverse pass to MinX";
                
                ! Calibrate and lower to work height
                WaitTime\\inpos,0.1;
                FCCalib PolishLoad;
                MoveL Offs(pEnd,0,0,50),vApproach,fine,tPolish\\WObj:=Bed1Wyong;
                
                ! Start force control
                FCPress1LStart Offs(pEnd,0,0,0),vApproach,\\Fz:={start_force},15,\\ForceChange:={force_change}\\PosSupvDist:={pos_supv_dist},z5,tPolish\\WObj:=Bed1Wyong;
                
                ! Travel across with force control
                FCPressL pStart,vTravel,{motion_force},fine,tPolish\\WObj:=Bed1Wyong;
                
                ! End force control and retract
                FCPressEnd Offs(pStart,0,0,75),vRetract,\\DeactOnly,tPolish\\WObj:=Bed1Wyong;
            ENDIF'''
    else:
        # No force control - simple MoveL commands, STAY ON SURFACE (like helicopter)
        pass_code = '''            IF SweepDir=1 THEN
                ! Forward pass (MinX to MaxX) - NO FORCE CONTROL
                TPWrite "Forward pass to MaxX (no FC)";
                MoveL pEnd,vTravel,fine,tPolish\\WObj:=Bed1Wyong;
            ELSE
                ! Reverse pass (MaxX to MinX) - NO FORCE CONTROL
                TPWrite "Reverse pass to MinX (no FC)";
                MoveL pStart,vTravel,fine,tPolish\\WObj:=Bed1Wyong;
            ENDIF'''
    
    # Build the procedure
    proc = f'''
    PROC Py2Polish()
        ! Py2Polish - Polisher serpentine with force control
        ! Generated by Onyx Toolpath Generator v2
        ! Workzone: {workzone}
        ! Area: ({start_x},{start_y}) to ({end_x},{end_y})
        ! Z = {work_z}mm (FormHeight + offset)
        ! Step: {step_size}mm
        ! Force: {'DISABLED' if not force_enabled else f'Start={start_force}N, Motion={motion_force}N'}
        
        VAR robtarget pStart;
        VAR robtarget pEnd;
        VAR jointtarget CurrentJoints;
        VAR robtarget CurrentPos;
        VAR num WorkZ:=0;
        VAR num SafeZ:=0;
        VAR num CurrentY:=0;
        VAR num MinY:=0;
        VAR num MaxY:=0;
        VAR num MinX:=0;
        VAR num MaxX:=0;
        VAR num StepSize:={step_size};
        VAR num SweepDir:=1;
        VAR num PassCount:=0;
        VAR bool bDone:=FALSE;
        VAR speeddata vApproach:=[{approach_speed},15,2000,15];
        VAR speeddata vRetract:=[{retract_speed},15,2000,15];
        VAR speeddata vTravel:=[100,15,2000,15];
        VAR num TrackMin:={track_min};
        VAR num TrackMax:={track_max};
        VAR num CalcTrack:=0;
        
        ! Initialize runtime values
        WorkZ:={work_z};
        SafeZ:=WorkZ+200;
        MinY:={start_y};
        MaxY:={end_y};
        MinX:={start_x};
        MaxX:={end_x};
        
        TPWrite "========================================";
        TPWrite "Py2Polish: Starting";
        TPWrite "========================================";
        TPWrite "Workzone: {workzone}";
        TPWrite "MinX=" \\Num:=MinX;
        TPWrite "MaxX=" \\Num:=MaxX;
        TPWrite "MinY=" \\Num:=MinY;
        TPWrite "MaxY=" \\Num:=MaxY;
        TPWrite "WorkZ=" \\Num:=WorkZ;
        TPWrite "StepSize=" \\Num:=StepSize;
        TPWrite "Force Control: {'DISABLED' if not force_enabled else 'ENABLED'}";
        
        ! Get polisher if needed
        IF ToolNum<>6 THEN
            TPWrite "Py2Polish: Getting polisher...";
            Home;
            Polish_Pickup;
        ELSE
            ! Already have polisher - ensure safe height
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tPolish\\WObj:=wobj0);
            IF CurrentPos.trans.z<600 THEN
                MoveL Offs(CurrentPos,0,0,(600-CurrentPos.trans.z)),v500,z5,tPolish;
            ENDIF
        ENDIF
        
        ! ============================================
        ! SERPENTINE PASSES (sweep X, step in Y)
        ! Start at far Y, work back toward track
        ! ============================================
        CurrentY:=MaxY;
        SweepDir:=1;
        PassCount:=0;
        
        TPWrite "Starting serpentine at Y=" \\Num:=CurrentY;
        
        ! Initialize start position (X negated per Andrew's pattern)
        pStart.trans:=[-1*MinX,CurrentY,SafeZ];
        pStart.rot:=OrientZYX(0,0,180);
        pStart.robconf:=[0,0,0,0];
        
        ! Clamp track position to limits - arm will extend to reach target
        CalcTrack:=Bed1Wyong.uframe.trans.x+pStart.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pStart.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        
        pEnd:=pStart;
        pEnd.trans.x:=-1*MaxX;
        CalcTrack:=Bed1Wyong.uframe.trans.x+pEnd.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pEnd.extax.eax_a:=CalcTrack;
        
        ! Move to start position (safe height)
        MoveJ pStart,v500,z5,tPolish\\WObj:=Bed1Wyong;
        
        ! Disable configuration tracking
        ConfL\\Off;
        ConfJ\\Off;
        
        ! Turn on polisher (only if force control enabled)
        {'Pol_on;' if force_enabled else '! Pol_on SKIPPED - force control disabled'}
        
        ! Lower to work height ONCE before starting serpentine
        pStart.trans.z:=WorkZ;
        pEnd.trans.z:=WorkZ;
        MoveJ Offs(pStart,0,0,50),v100,z5,tPolish\\WObj:=Bed1Wyong;
        MoveL pStart,v50,fine,tPolish\\WObj:=Bed1Wyong;
        
        TPWrite "Lowered to work surface, starting serpentine...";
        
        bDone:=FALSE;
        
        ! Serpentine loop - STAY ON SURFACE throughout
        WHILE CurrentY>=MinY AND bDone=FALSE DO
            Incr PassCount;
            TPWrite "----------------------------------------";
            TPWrite "Pass " \\Num:=PassCount;
            TPWrite "CurrentY=" \\Num:=CurrentY;
            TPWrite "SweepDir=" \\Num:=SweepDir;
            
            ! Update Y position (Z stays at WorkZ)
            pStart.trans.y:=CurrentY;
            pEnd.trans.y:=CurrentY;
            
{pass_code}
            
            TPWrite "Pass complete";
            
            ! Check if we should continue
            IF (CurrentY-StepSize)<MinY THEN
                TPWrite "Last pass reached - done";
                bDone:=TRUE;
            ELSE
                ! Step to next row - STAY ON SURFACE (like helicopter)
                CurrentY:=CurrentY-StepSize;
                TPWrite "Step to Y=" \\Num:=CurrentY;
                
                ! Update Y and step while staying on surface (clamp track to limits)
                IF SweepDir=1 THEN
                    pEnd.trans.y:=CurrentY;
                    CalcTrack:=Bed1Wyong.uframe.trans.x+pEnd.trans.x;
                    IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
                    IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
                    pEnd.extax.eax_a:=CalcTrack;
                    MoveL pEnd,vTravel,fine,tPolish\\WObj:=Bed1Wyong;
                ELSE
                    pStart.trans.y:=CurrentY;
                    CalcTrack:=Bed1Wyong.uframe.trans.x+pStart.trans.x;
                    IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
                    IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
                    pStart.extax.eax_a:=CalcTrack;
                    MoveL pStart,vTravel,fine,tPolish\\WObj:=Bed1Wyong;
                ENDIF
                
                ! Flip direction
                SweepDir:=-1*SweepDir;
            ENDIF
        ENDWHILE
        
        TPWrite "========================================";
        TPWrite "Py2Polish: Complete";
        TPWrite "Total passes=" \\Num:=PassCount;
        TPWrite "========================================";
        
        ! Ensure polisher is off (only if it was turned on)
        {'Pol_off;' if force_enabled else '! Pol_off SKIPPED - motor was not running'}
        
        ! Re-enable configuration tracking
        ConfL\\On;
        ConfJ\\On;
        
        ! Return to safe position
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tPolish\\WObj:=Bed1Wyong);
        MoveL Offs(CurrentPos,0,0,200),v200,z5,tPolish\\WObj:=Bed1Wyong;
        
        ! Return tool and go home
        TPWrite "Py2Polish: Dropping off polisher...";
        Polish_Dropoff;
        TPWrite "Py2Polish: Polisher dropped off";
        
        TPWrite "Py2Polish: Homing...";
        Home;
        
        TPWrite "========================================";
        TPWrite "Py2Polish: COMPLETE";
        TPWrite "========================================";
        
    ERROR
        {'Pol_off;' if force_enabled else '! Pol_off SKIPPED'}
        TPWrite "Py2Polish ERROR: " \\Num:=ERRNO;
        RAISE;
    ENDPROC
'''
    return proc
