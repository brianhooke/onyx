"""
Polisher tool procedure generator.

Generates PROC Py2Polish() based on Andrew's Polish pattern.
Key aspects:
1. Uses tPolish tool (ToolNum = 6)
2. Force control with FCPress commands
3. Cross-hatch pattern across bed/panel (X passes then Y passes)
4. Bed1Wyong work object
"""

from .utils import get_track_limits


def generate_py2polish(params: dict) -> str:
    """
    Generate PROC Py2Polish() RAPID code.
    
    Based on Andrew's working Polish pattern with force control.
    Uses cross-hatch pattern across the workzone (X passes then Y passes).
    
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
    first_direction = params.get('polisher_first_direction', 'x')  # 'x' or 'y' - which direction to pass first
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
    travel_speed = params.get('polisher_speed', 100)
    
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
    
    # Generate pass code based on force control setting
    # NOTE: Force control start/end happens ONCE outside the loop
    # Pass code only does the sweep movement
    if force_enabled:
        pass_code = f'''            IF SweepDir=1 THEN
                ! Forward pass (MinX to MaxX) - stay on surface with force control
                TPWrite "Forward pass to MaxX";
                FCPressL pEnd,vTravel,{motion_force},fine,tPolish\\WObj:=Bed1Wyong;
            ELSE
                ! Reverse pass (MaxX to MinX) - stay on surface with force control
                TPWrite "Reverse pass to MinX";
                FCPressL pStart,vTravel,{motion_force},fine,tPolish\\WObj:=Bed1Wyong;
            ENDIF'''
        
        # Step code for force control - use FCPressL to stay on surface
        step_code = f'''                IF SweepDir=1 THEN
                    pEnd.trans.y:=CurrentY;
                    CalcTrack:=Bed1Wyong.uframe.trans.x+pEnd.trans.x;
                    IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
                    IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
                    pEnd.extax.eax_a:=CalcTrack;
                    FCPressL pEnd,vTravel,{motion_force},fine,tPolish\\WObj:=Bed1Wyong;
                ELSE
                    pStart.trans.y:=CurrentY;
                    CalcTrack:=Bed1Wyong.uframe.trans.x+pStart.trans.x;
                    IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
                    IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
                    pStart.extax.eax_a:=CalcTrack;
                    FCPressL pStart,vTravel,{motion_force},fine,tPolish\\WObj:=Bed1Wyong;
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
        
        # Step code for no force control - use MoveL
        step_code = '''                IF SweepDir=1 THEN
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
                ENDIF'''
    
    # Build Phase 2 code (always cross-hatch - both directions)
    # Note: currently Phase 1 = X passes, Phase 2 = Y passes regardless of first_direction
    # TODO: swap phases if first_direction == 'y'
    if force_enabled:
        phase2_code = f'''
        ! ============================================
        ! PHASE 2: Y PASSES (sweep Y, step in X)
        ! Cross-hatch pattern - continue from Phase 1
        ! ============================================
        TPWrite "========================================";
        TPWrite "=== PHASE 2: Y Passes ===";
        TPWrite "========================================";
        
        ! Continue from where X passes ended - NO diagonal repositioning
        ! Determine actual X position based on final sweep direction
        IF SweepDir=1 THEN
            ! Last sweep was forward, so we ended at MaxX
            CurrentX:=MaxX;
        ELSE
            ! Last sweep was reverse, so we ended at MinX
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
        
        ! First Y sweep from current position (straight Y move, no diagonal)
        TPWrite "P2: First Y sweep to EndY=" \\Num:=EndY;
        pEnd.trans.x:=-1*CurrentX;
        pEnd.trans.y:=EndY;
        CalcTrack:=Bed1Wyong.uframe.trans.x+pEnd.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pEnd.extax.eax_a:=CalcTrack;
        TPWrite "P2: Moving...";
        FCPressL pEnd,vTravel,{motion_force},fine,tPolish\\WObj:=Bed1Wyong;
        CurrentY:=EndY;
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
                TPWrite "P2: NextX out of bounds - done";
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
                
                ! Step to next X column (stay on surface)
                TPWrite "P2: Step to X=" \\Num:=NextX;
                pEnd.trans.x:=-1*NextX;
                CalcTrack:=Bed1Wyong.uframe.trans.x+pEnd.trans.x;
                IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
                IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
                pEnd.extax.eax_a:=CalcTrack;
                TPWrite "P2: Moving to next X column...";
                FCPressL pEnd,vTravel,{motion_force},fine,tPolish\\WObj:=Bed1Wyong;
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
                FCPressL pEnd,vTravel,{motion_force},fine,tPolish\\WObj:=Bed1Wyong;
                TPWrite "P2: Sweep complete";
            ENDIF
        ENDWHILE
        
        TPWrite "========================================";
        TPWrite "P2: Y passes complete, total=" \\Num:=PassCount;
        TPWrite "Cross-hatch complete!";
        TPWrite "========================================";
'''
    else:
        # No force control version
        phase2_code = f'''
        ! ============================================
        ! PHASE 2: Y PASSES (sweep Y, step in X)
        ! Cross-hatch pattern - continue from Phase 1
        ! ============================================
        TPWrite "========================================";
        TPWrite "=== PHASE 2: Y Passes ===";
        TPWrite "========================================";
        
        ! Continue from where X passes ended - NO diagonal repositioning
        ! Determine actual X position based on final sweep direction
        IF SweepDir=1 THEN
            ! Last sweep was forward, so we ended at MaxX
            CurrentX:=MaxX;
        ELSE
            ! Last sweep was reverse, so we ended at MinX
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
        
        ! First Y sweep from current position (straight Y move, no diagonal)
        TPWrite "P2: First Y sweep to EndY=" \\Num:=EndY;
        pEnd.trans.x:=-1*CurrentX;
        pEnd.trans.y:=EndY;
        CalcTrack:=Bed1Wyong.uframe.trans.x+pEnd.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pEnd.extax.eax_a:=CalcTrack;
        TPWrite "P2: Moving...";
        MoveL pEnd,vTravel,fine,tPolish\\WObj:=Bed1Wyong;
        CurrentY:=EndY;
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
                TPWrite "P2: NextX out of bounds - done";
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
                CalcTrack:=Bed1Wyong.uframe.trans.x+pEnd.trans.x;
                IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
                IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
                pEnd.extax.eax_a:=CalcTrack;
                TPWrite "P2: Moving to next X column...";
                MoveL pEnd,vTravel,fine,tPolish\\WObj:=Bed1Wyong;
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
                MoveL pEnd,vTravel,fine,tPolish\\WObj:=Bed1Wyong;
                TPWrite "P2: Sweep complete";
            ENDIF
        ENDWHILE
        
        TPWrite "========================================";
        TPWrite "P2: Y passes complete, total=" \\Num:=PassCount;
        TPWrite "Cross-hatch complete!";
        TPWrite "========================================";
'''
    
    # Pre-build strings with backslashes (can't use backslash in f-string expressions)
    if force_enabled:
        pol_on_cmd = 'Pol_on;'
        pol_off_cmd = 'Pol_off;'
        fc_comment = '! Start force control - stays active for entire cross-hatch'
        fc_wait = 'WaitTime\\inpos,0.1;'
        fc_calib = 'FCCalib PolishLoad;'
        fc_start = f'FCPress1LStart pStart,vApproach,\\Fz:={start_force},15,\\ForceChange:={force_change}\\PosSupvDist:={pos_supv_dist},z5,tPolish\\WObj:=Bed1Wyong;'
        fc_end_joints = 'CurrentJoints:=CJointT();'
        fc_end_pos = 'CurrentPos:=CalcRobT(CurrentJoints,tPolish\\WObj:=Bed1Wyong);'
        fc_end_cmd = 'FCPressEnd Offs(CurrentPos,0,0,75),vRetract,\\DeactOnly,tPolish\\WObj:=Bed1Wyong;'
        safe_lift_comment = '! Already lifted by FCPressEnd'
        safe_lift_joints = '! Moving to safe height'
        safe_lift_move = ''
    else:
        pol_on_cmd = '! Pol_on SKIPPED - force control disabled'
        pol_off_cmd = '! Pol_off SKIPPED - motor was not running'
        fc_comment = '! No force control - simple move to surface'
        fc_wait = ''
        fc_calib = ''
        fc_start = 'MoveL pStart,v50,fine,tPolish\\WObj:=Bed1Wyong;'
        fc_end_joints = ''
        fc_end_pos = ''
        fc_end_cmd = ''
        safe_lift_comment = 'CurrentJoints:=CJointT();'
        safe_lift_joints = 'CurrentPos:=CalcRobT(CurrentJoints,tPolish\\WObj:=Bed1Wyong);'
        safe_lift_move = 'MoveL Offs(CurrentPos,0,0,200),v200,z5,tPolish\\WObj:=Bed1Wyong;'
    
    # Build the procedure
    proc = f'''
    PROC Py2Polish()
        ! Py2Polish - Polisher with force control
        ! Generated by Onyx Toolpath Generator v2
        ! Workzone: {workzone}
        ! First direction: {first_direction}
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
        VAR num StepDir:=1;
        VAR num PassCount:=0;
        VAR bool bDone:=FALSE;
        VAR num CurrentX:=0;
        VAR num StartY:=0;
        VAR num EndY:=0;
        VAR num NextX:=0;
        VAR speeddata vApproach:=[{approach_speed},15,2000,15];
        VAR speeddata vRetract:=[{retract_speed},15,2000,15];
        VAR speeddata vTravel:=[{travel_speed},15,2000,15];
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
        ! PHASE 1: X PASSES (sweep X, step in Y)
        ! First direction: {first_direction}
        ! ============================================
        CurrentY:=MaxY;
        SweepDir:=1;
        PassCount:=0;
        
        TPWrite "Cross-hatch, first direction: {first_direction}";
        TPWrite "Starting P1 (X passes) at Y=" \\Num:=CurrentY;
        
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
        {pol_on_cmd}
        
        ! Lower to work height and START force control ONCE before cross-hatch
        pStart.trans.z:=WorkZ;
        pEnd.trans.z:=WorkZ;
        MoveJ Offs(pStart,0,0,50),v100,z5,tPolish\\WObj:=Bed1Wyong;
        
        {fc_comment}
        {fc_wait}
        {fc_calib}
        {fc_start}
        
        TPWrite "On work surface, starting cross-hatch...";
        
        bDone:=FALSE;
        
        ! X-pass loop - STAY ON SURFACE throughout
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
                ! Step to next row - STAY ON SURFACE
                CurrentY:=CurrentY-StepSize;
                TPWrite "Step to Y=" \\Num:=CurrentY;
                
                ! Update Y and step while staying on surface (clamp track to limits)
{step_code}
                
                ! Flip direction
                SweepDir:=-1*SweepDir;
            ENDIF
        ENDWHILE
        
        TPWrite "P1: X passes complete, total=" \\Num:=PassCount;
{phase2_code}
        ! END force control ONCE after all passes complete
        {fc_end_joints}
        {fc_end_pos}
        {fc_end_cmd}
        
        TPWrite "========================================";
        TPWrite "Py2Polish: Complete";
        TPWrite "Total passes=" \\Num:=PassCount;
        TPWrite "========================================";
        
        ! Ensure polisher is off (only if it was turned on)
        {pol_off_cmd}
        
        ! Re-enable configuration tracking
        ConfL\\On;
        ConfJ\\On;
        
        ! Return to safe position (already lifted if force control was used)
        {safe_lift_comment}
        {safe_lift_joints}
        {safe_lift_move}
        
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
        {pol_off_cmd}
        TPWrite "Py2Polish ERROR: " \\Num:=ERRNO;
        RAISE;
    ENDPROC
'''
    return proc
