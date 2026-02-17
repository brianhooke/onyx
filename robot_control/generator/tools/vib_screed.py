"""
Vibrating Screed tool procedure generator.

Generates PROC Py2VibScreed() for screeding operations.

Key aspects:
1. Uses tVS tool (ToolNum = 3)
2. Bed1Wyong work object
3. Track position calculated from X position
4. Supports Z offset and angle offset adjustments
5. Single pass from start X to end X at fixed Y position
"""

from .utils import get_track_limits


def generate_py2vib_screed(params: dict) -> str:
    """
    Generate PROC Py2VibScreed() RAPID code.
    
    Uses frontend parameters:
    - screed_workzone: 'bed' or 'panel'
    - screed_z_offset: Z offset for screed height (mm)
    - screed_angle_offset: Angle offset for screed tilt (degrees)
    - screed_panel_offset: Offset from panel edges (mm)
    - vib_screed_speed: Travel speed (mm/s)
    - Panel/bed dimensions for workzone calculation
    
    Returns:
        Complete PROC Py2VibScreed() as a string
    """
    # Extract parameters (no defaults - values always provided by frontend/DB)
    workzone = params.get('screed_workzone', 'panel')
    global_z_offset = params['z_offset']
    screed_z_offset = params.get('screed_z_offset', 0)
    total_z_offset = global_z_offset + screed_z_offset
    angle_offset = params.get('screed_angle_offset', 0)
    panel_offset = params.get('screed_panel_offset', 200)
    travel_speed = params.get('vib_screed_speed', 100)
    
    # Track limits (shared utility)
    track_min, track_max = get_track_limits(params)
    
    # Calculate workzone boundaries based on selected workzone
    if workzone == 'panel':
        # Panel mode: use panel datum + dimensions
        datum_x = params['panel_datum_x']
        datum_y = params['panel_datum_y']
        length_x = params['panel_x']
        width_y = params['panel_y']
        panel_z = params['panel_z']
        work_z = panel_z + total_z_offset
    else:  # bed
        # Bed mode: use bed datum + dimensions
        datum_x = params['bed_datum_x']
        datum_y = params['bed_datum_y']
        length_x = params['bed_length_x']
        width_y = params['bed_width_y']
        panel_z = 0
        work_z = total_z_offset  # Bed is at Z=0
    
    # Screed start/end X positions (with panel offset)
    start_x = datum_x + panel_offset
    end_x = datum_x + length_x - panel_offset
    
    # Screed Y position (center of workzone)
    screed_y = datum_y + width_y // 2
    
    # Generate the RAPID procedure
    rapid_code = f'''PROC Py2VibScreed()
    ! ========================================
    ! Py2VibScreed - Python-generated Vibrating Screed
    ! ========================================
    ! Generated procedure for vibrating screed operation
    ! Workzone: {workzone}
    ! Start X: {start_x}, End X: {end_x}
    ! Y Position: {screed_y}
    ! Z Offset: {total_z_offset}, Angle Offset: {angle_offset}
    ! Speed: {travel_speed} mm/s
    ! ========================================
    
    VAR robtarget pScreedStart;
    VAR robtarget pScreedEnd;
    VAR num CalcTrack;
    VAR num WorkZ;
    VAR num SafeZ;
    VAR num TrackMin;
    VAR num TrackMax;
    VAR speeddata vScreed;
    
    ! Initialize speed
    vScreed:=[{travel_speed},15,2000,15];
    
    ! Initialize runtime values
    WorkZ:={work_z};
    SafeZ:=WorkZ+200;
    TrackMin:={track_min};
    TrackMax:={track_max};
    
    TPWrite "========================================";
    TPWrite "Py2VibScreed: Starting";
    TPWrite "========================================";
    TPWrite "Start X=" \\Num:={start_x};
    TPWrite "End X=" \\Num:={end_x};
    TPWrite "Y Position=" \\Num:={screed_y};
    TPWrite "Work Z=" \\Num:=WorkZ;
    TPWrite "Angle Offset=" \\Num:={angle_offset};
    
    ! Get vib screed tool if needed (ToolNum 3 = tVS)
    IF ToolNum<>3 THEN
        TPWrite "Py2VibScreed: Getting vib screed tool...";
        Home;
        VS_Pickup;
    ENDIF
    
    ! Initialize start position (X negated per Bed1Wyong)
    ! Use pVSstart.rot from Tools.mod - tool is already in correct orientation after pickup
    pScreedStart.trans:=[-1*{start_x},{screed_y},WorkZ];
    pScreedStart.rot:=pVSstart.rot;
    pScreedStart.robconf:=[1,0,-3,0];
    
    ! Calculate track position for start
    CalcTrack:=Bed1Wyong.uframe.trans.x+pScreedStart.trans.x+700;
    IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
    IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
    pScreedStart.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
    
    ! Initialize end position
    pScreedEnd:=pScreedStart;
    pScreedEnd.trans.x:=-1*{end_x};
    
    ! Calculate track position for end
    CalcTrack:=Bed1Wyong.uframe.trans.x+pScreedEnd.trans.x+700;
    IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
    IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
    pScreedEnd.extax.eax_a:=CalcTrack;
    
    ! Move to start position at safe height
    TPWrite "Moving to start position...";
    MoveL Offs(pScreedStart,100,0,SafeZ-WorkZ),v500,fine,tVS\\WObj:=Bed1Wyong;
    
    ! Apply angle offset and lower to approach height
    MoveL Offs(RelTool(pScreedStart,0,0,0\\Ry:={angle_offset}),50,0,100),v500,fine,tVS\\WObj:=Bed1Wyong;
    
    ! Turn on vibrating screed
    TPWrite "Vibrating screed ON";
    VS_on;
    
    ! Lower to work height
    MoveL Offs(RelTool(pScreedStart,0,0,0\\Ry:={angle_offset}),20,0,0),v50,z5,tVS\\WObj:=Bed1Wyong;
    
    ! Screed pass
    TPWrite "Screeding...";
    MoveL Offs(RelTool(pScreedEnd,0,0,0\\Ry:={angle_offset}),-140,0,0),vScreed,z5,tVS\\WObj:=Bed1Wyong;
    
    ! Lift and turn off
    MoveL Offs(RelTool(pScreedEnd,0,0,0\\Ry:={angle_offset}),-140,0,100),v100,z5,tVS\\WObj:=Bed1Wyong;
    TPWrite "Vibrating screed OFF";
    VS_off;
    
    ! Return tool and go home
    TPWrite "Py2VibScreed: Dropping off vib screed...";
    VS_Dropoff;
    TPWrite "Py2VibScreed: Vib screed dropped off";
    
    TPWrite "Py2VibScreed: Homing...";
    Home;
    
    TPWrite "========================================";
    TPWrite "Py2VibScreed: Complete";
    TPWrite "========================================";
    
ENDPROC
'''
    
    return rapid_code
