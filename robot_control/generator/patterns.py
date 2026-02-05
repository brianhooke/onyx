"""
Pure geometry pattern generators.

These functions know nothing about RAPID or robots.
They just generate lists of coordinates for different patterns.
"""

from dataclasses import dataclass
from typing import List, Literal


@dataclass
class Point:
    """A point in the pattern with move type hint."""
    x: float
    y: float
    move_type: Literal["rapid", "work"]  # rapid=fast positioning, work=process move


def cross_hatch(
    min_x: float,
    max_x: float,
    min_y: float,
    max_y: float,
    step_size: float,
    first_direction: Literal["x", "y"] = "x",
    start_corner: Literal["top_left", "top_right", "bottom_left", "bottom_right"] = "top_left",
) -> List[Point]:
    """
    Generate a cross-hatch pattern.
    
    Phase 1: Sweeps in first_direction while stepping in the perpendicular direction.
    Phase 2: Continues from where Phase 1 ended, sweeping perpendicular and stepping in first_direction.
    
    The key behavior: Phase 2 starts from wherever Phase 1 ended - no diagonal repositioning.
    
    Args:
        min_x: Left edge of workspace
        max_x: Right edge of workspace
        min_y: Bottom edge of workspace (closest to track)
        max_y: Top edge of workspace (furthest from track)
        step_size: Distance to step between passes
        first_direction: 'x' for X passes first, 'y' for Y passes first
        start_corner: Which corner to start from
    
    Returns:
        List of Points with x, y coordinates and move_type
    """
    points: List[Point] = []
    
    # Determine initial directions based on start corner
    if start_corner in ("top_left", "top_right"):
        y_start, y_end, y_step = max_y, min_y, -step_size
    else:
        y_start, y_end, y_step = min_y, max_y, step_size
    
    if start_corner in ("top_left", "bottom_left"):
        x_start, x_end, x_step = min_x, max_x, step_size
    else:
        x_start, x_end, x_step = max_x, min_x, -step_size
    
    # Track current position (will be updated as we generate points)
    current_x = x_start
    current_y = y_start
    sweep_dir_x = 1  # 1 = toward x_end, -1 = toward x_start
    sweep_dir_y = 1  # 1 = toward y_end, -1 = toward y_start
    
    if first_direction == "x":
        # PHASE 1: X passes (sweep X, step in Y)
        y_values = _generate_steps(y_start, y_end, y_step)
        for i, y in enumerate(y_values):
            current_y = y
            if i % 2 == 0:
                target_x = x_end if sweep_dir_x == 1 else x_start
            else:
                target_x = x_start if sweep_dir_x == 1 else x_end
            
            if i == 0:
                points.append(Point(x_start if sweep_dir_x == 1 else x_end, y, "rapid"))
            else:
                points.append(Point(current_x, y, "work"))  # Step in Y
            
            current_x = target_x
            points.append(Point(current_x, y, "work"))  # Sweep X
        
        # PHASE 2: Y passes (sweep Y, step in X) - continue from where Phase 1 ended
        # Determine Y sweep direction based on where we ended
        if current_y <= (min_y + max_y) / 2:
            y_sweep_target = max_y
        else:
            y_sweep_target = min_y
        
        # First Y sweep from current position
        points.append(Point(current_x, y_sweep_target, "work"))
        current_y = y_sweep_target
        
        # Continue stepping in X and sweeping Y
        x_values = _generate_steps(current_x, x_start if x_step < 0 else x_end, -x_step if current_x > (min_x + max_x) / 2 else x_step)
        for i, x in enumerate(x_values[1:], 1):  # Skip first since we're already there
            current_x = x
            points.append(Point(current_x, current_y, "work"))  # Step in X
            
            # Sweep Y in opposite direction
            y_sweep_target = min_y if current_y >= (min_y + max_y) / 2 else max_y
            current_y = y_sweep_target
            points.append(Point(current_x, current_y, "work"))  # Sweep Y
    
    else:  # first_direction == "y"
        # PHASE 1: Y passes (sweep Y, step in X)
        x_values = _generate_steps(x_start, x_end, x_step)
        for i, x in enumerate(x_values):
            current_x = x
            if i % 2 == 0:
                target_y = y_end if sweep_dir_y == 1 else y_start
            else:
                target_y = y_start if sweep_dir_y == 1 else y_end
            
            if i == 0:
                points.append(Point(x, y_start if sweep_dir_y == 1 else y_end, "rapid"))
            else:
                points.append(Point(x, current_y, "work"))  # Step in X
            
            current_y = target_y
            points.append(Point(x, current_y, "work"))  # Sweep Y
        
        # PHASE 2: X passes (sweep X, step in Y) - continue from where Phase 1 ended
        # Determine X sweep direction based on where we ended
        if current_x <= (min_x + max_x) / 2:
            x_sweep_target = max_x
        else:
            x_sweep_target = min_x
        
        # First X sweep from current position
        points.append(Point(x_sweep_target, current_y, "work"))
        current_x = x_sweep_target
        
        # Continue stepping in Y and sweeping X
        y_values = _generate_steps(current_y, y_start if y_step < 0 else y_end, -y_step if current_y > (min_y + max_y) / 2 else y_step)
        for i, y in enumerate(y_values[1:], 1):  # Skip first since we're already there
            current_y = y
            points.append(Point(current_x, current_y, "work"))  # Step in Y
            
            # Sweep X in opposite direction
            x_sweep_target = min_x if current_x >= (min_x + max_x) / 2 else max_x
            current_x = x_sweep_target
            points.append(Point(current_x, current_y, "work"))  # Sweep X
    
    return points


def _generate_steps(start: float, end: float, step: float) -> List[float]:
    """Generate a list of values from start toward end with given step."""
    values = []
    current = start
    
    if step > 0:
        while current <= end:
            values.append(current)
            current += step
        # Ensure we hit the end exactly if we haven't
        if values and values[-1] < end:
            values.append(end)
    else:
        while current >= end:
            values.append(current)
            current += step  # step is negative
        # Ensure we hit the end exactly if we haven't
        if values and values[-1] > end:
            values.append(end)
    
    return values
