"""
Toolpath Pattern Generators

Contains logic for generating various toolpath patterns used by robot tools.
"""

from dataclasses import dataclass
from typing import List, Tuple, Literal


@dataclass
class SerpentineParams:
    """Parameters for serpentine pattern generation."""
    
    # Workspace bounds (mm)
    workspace_min_x: float
    workspace_max_x: float
    workspace_min_y: float
    workspace_max_y: float
    
    # Safety offsets (mm)
    offset_x: float
    offset_y: float
    
    # Pattern settings
    step_size: float  # Distance between rows along Y (mm)
    initial_sweep_direction: int  # +1 (left to right) or -1 (right to left)
    start_at_bottom: bool  # True = start at bottom, False = start at top


@dataclass
class SerpentineMove:
    """Represents a single move in the serpentine pattern."""
    x: float
    y: float
    move_type: Literal["sweep", "step"]  # sweep = along X, step = along Y


def generate_serpentine_path(params: SerpentineParams) -> List[SerpentineMove]:
    """
    Generate a serpentine (lawn mower) pattern path.
    
    The robot sweeps left-right along X axis and steps up-down along Y axis.
    Stays inside safe edges using offsets.
    
    Args:
        params: SerpentineParams with workspace bounds and pattern settings
        
    Returns:
        List of SerpentineMove objects representing the path
    """
    moves = []
    
    # Calculate working area (inside safety margins)
    work_min_x = params.workspace_min_x + params.offset_x
    work_max_x = params.workspace_max_x - params.offset_x
    work_min_y = params.workspace_min_y + params.offset_y
    work_max_y = params.workspace_max_y - params.offset_y
    
    # Validate working area
    if work_min_x >= work_max_x or work_min_y >= work_max_y:
        raise ValueError("Working area is invalid after applying offsets")
    
    # Initialize starting position and directions
    if params.start_at_bottom:
        current_y = work_min_y
        y_step_direction = 1  # Step upward
    else:
        current_y = work_max_y
        y_step_direction = -1  # Step downward
    
    sweep_direction = params.initial_sweep_direction
    
    # Main movement loop
    while True:
        # Determine sweep start/end based on direction
        if sweep_direction == 1:
            start_x = work_min_x
            end_x = work_max_x
        else:
            start_x = work_max_x
            end_x = work_min_x
        
        # Move to row start
        moves.append(SerpentineMove(x=start_x, y=current_y, move_type="step"))
        
        # Sweep across row
        moves.append(SerpentineMove(x=end_x, y=current_y, move_type="sweep"))
        
        # Check if next row is possible
        next_y = current_y + (y_step_direction * params.step_size)
        
        if y_step_direction == 1 and next_y > work_max_y:
            # Pattern complete (reached top)
            break
        elif y_step_direction == -1 and next_y < work_min_y:
            # Pattern complete (reached bottom)
            break
        
        # Clamp next_y to working bounds for partial last step
        if next_y > work_max_y:
            next_y = work_max_y
        elif next_y < work_min_y:
            next_y = work_min_y
        
        # Step to next row
        moves.append(SerpentineMove(x=end_x, y=next_y, move_type="step"))
        current_y = next_y
        
        # Reverse sweep direction for next row
        sweep_direction = -sweep_direction
    
    return moves


def calculate_serpentine_stats(params: SerpentineParams) -> dict:
    """
    Calculate statistics for a serpentine pattern without generating full path.
    
    Args:
        params: SerpentineParams with workspace bounds and pattern settings
        
    Returns:
        Dictionary with pattern statistics
    """
    work_min_x = params.workspace_min_x + params.offset_x
    work_max_x = params.workspace_max_x - params.offset_x
    work_min_y = params.workspace_min_y + params.offset_y
    work_max_y = params.workspace_max_y - params.offset_y
    
    width = work_max_x - work_min_x
    height = work_max_y - work_min_y
    
    if width <= 0 or height <= 0:
        return {
            'valid': False,
            'error': 'Working area is invalid after applying offsets'
        }
    
    num_passes = int(height / params.step_size) + 1
    sweep_distance = width * num_passes
    step_distance = params.step_size * (num_passes - 1)
    total_distance = sweep_distance + step_distance
    
    return {
        'valid': True,
        'work_area_width': width,
        'work_area_height': height,
        'num_passes': num_passes,
        'sweep_distance': sweep_distance,
        'step_distance': step_distance,
        'total_distance': total_distance,
    }


def serpentine_to_rapid_moves(
    params: SerpentineParams,
    z_height: float,
    speed_sweep: int,
    speed_step: int,
    tool_name: str = "tVac",
    wobj_name: str = "Bed1Wyong"
) -> List[str]:
    """
    Generate RAPID move commands for a serpentine pattern.
    
    Args:
        params: SerpentineParams with workspace bounds and pattern settings
        z_height: Z height for all moves
        speed_sweep: Speed for sweep moves (mm/s)
        speed_step: Speed for step moves (mm/s)
        tool_name: RAPID tool name
        wobj_name: RAPID workobject name
        
    Returns:
        List of RAPID move command strings
    """
    moves = generate_serpentine_path(params)
    rapid_commands = []
    
    for i, move in enumerate(moves):
        # Use MoveJ for first move, MoveL for rest
        if i == 0:
            cmd = f'MoveJ [[{-move.x},{move.y},{z_height}],' \
                  f'[0.00615322,-0.709926,0.704246,-0.00239206],[1,-1,0,0],' \
                  f'[Bed1Wyong.uframe.trans.x-{move.x},9E+09,9E+09,9E+09,9E+09,9E+09]],' \
                  f'v500,z5,{tool_name}\\WObj:={wobj_name};'
        else:
            speed = f'v{speed_sweep}' if move.move_type == "sweep" else f'v{speed_step}'
            zone = 'z5' if move.move_type == "sweep" else 'fine'
            cmd = f'MoveL [[{-move.x},{move.y},{z_height}],' \
                  f'[0.00615322,-0.709926,0.704246,-0.00239206],[1,-1,0,0],' \
                  f'[Bed1Wyong.uframe.trans.x-{move.x},9E+09,9E+09,9E+09,9E+09,9E+09]],' \
                  f'{speed},{zone},{tool_name}\\WObj:={wobj_name};'
        
        rapid_commands.append(cmd)
    
    return rapid_commands
