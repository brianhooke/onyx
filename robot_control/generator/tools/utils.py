"""
Shared utilities for tool procedure generators.

Contains common functions and constants used across multiple tools.
"""

# Track limits from MOC.cfg (T710_1 arm)
# -lower_joint_bound -0.309 -upper_joint_bound 10.15 (meters)
DEFAULT_TRACK_MIN = -300   # mm, with safety buffer
DEFAULT_TRACK_MAX = 10050  # mm, with safety buffer (10150 - 100)


def get_track_limits(params: dict) -> tuple:
    """
    Get track limits from params or use defaults.
    
    Args:
        params: Dictionary of parameters
        
    Returns:
        Tuple of (track_min, track_max) in mm
    """
    track_min = params.get('track_min', DEFAULT_TRACK_MIN)
    track_max = params.get('track_max', DEFAULT_TRACK_MAX)
    return track_min, track_max


def rapid_track_variables() -> str:
    """
    Generate RAPID variable declarations for track clamping.
    
    Returns:
        RAPID code string with variable declarations
    """
    return """        VAR num TrackMin:=0;
        VAR num TrackMax:=0;
        VAR num CalcTrack:=0;"""


def rapid_track_init(track_min: int, track_max: int) -> str:
    """
    Generate RAPID code to initialize track limits.
    
    Args:
        track_min: Minimum track position in mm
        track_max: Maximum track position in mm
        
    Returns:
        RAPID code string
    """
    return f"""        TrackMin:={track_min};
        TrackMax:={track_max};
        TPWrite "Track limits: " \\Num:=TrackMin;
        TPWrite " to " \\Num:=TrackMax;"""


def rapid_clamp_extax(target_var: str, trans_x_expr: str) -> str:
    """
    Generate RAPID code to calculate and clamp extax value.
    
    The track position is clamped to limits. The robot arm's IK
    will extend joints to reach the target TCP position beyond
    the track's physical range.
    
    Args:
        target_var: Variable to assign (e.g., 'pStart.extax.eax_a')
        trans_x_expr: Expression for trans.x (e.g., 'pStart.trans.x')
        
    Returns:
        RAPID code string with clamping logic
    """
    return f"""            CalcTrack:=Bed1Wyong.uframe.trans.x+{trans_x_expr};
            IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
            IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
            {target_var}:=CalcTrack;"""


def rapid_clamp_extax_inline(trans_x_expr: str) -> str:
    """
    Generate inline RAPID code for clamping - returns expression lines
    that set CalcTrack and can be used before assigning extax.
    
    Args:
        trans_x_expr: Expression for trans.x (e.g., 'pEnd.trans.x')
        
    Returns:
        RAPID code lines (without final assignment)
    """
    return f"""CalcTrack:=Bed1Wyong.uframe.trans.x+{trans_x_expr};
                    IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
                    IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF"""
