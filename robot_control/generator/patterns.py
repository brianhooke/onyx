"""
Pure geometry pattern generators for robot toolpaths.

These functions generate pure XY coordinates with move type hints.
They know nothing about RAPID, robots, or tools - they just generate geometry.

The Tool class (tool_class.py) consumes these patterns and translates them
into actual RAPID code with proper track clamping, force control, etc.

Available patterns:
    - cross_hatch: Bidirectional passes (X then Y, or Y then X)
    - rectangular_spiral: Inward spiral from edges to center
    - sweep_lift: Unidirectional sweeps with lift-reposition (vacuum)
    - single_pass: Single linear pass (vibrating screed)
"""

from dataclasses import dataclass
from typing import List, Literal, Optional


@dataclass
class Point:
    """A point in the pattern with move type hint."""
    x: float
    y: float
    move_type: Literal["rapid", "work"]  # rapid=fast positioning, work=process move
    
    def __repr__(self) -> str:
        return f"Point({self.x:.0f}, {self.y:.0f}, '{self.move_type}')"


@dataclass
class PatternConfig:
    """Configuration for pattern generation - passed from Tool to pattern functions."""
    min_x: float
    max_x: float
    min_y: float
    max_y: float
    step_size: float
    # Optional pattern-specific params
    first_direction: Literal["x", "y"] = "x"
    start_corner: Literal["top_left", "top_right", "bottom_left", "bottom_right"] = "top_left"
    spiral_direction: Literal["clockwise", "anticlockwise"] = "anticlockwise"
    formwork_offset: float = 0
    lift_height: float = 200


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


def rectangular_spiral(
    min_x: float,
    max_x: float,
    min_y: float,
    max_y: float,
    step_size: float,
    formwork_offset: float,
    direction: Literal["clockwise", "anticlockwise"] = "anticlockwise",
) -> List[Point]:
    """
    Generate a rectangular spiral pattern (inward spiral).

    Intention / design notes:
    - This is a *pure geometry* generator: it only outputs XY points and move hints.
      The caller (tool generators) decides how to translate these points into robot
      motions and Z behavior.
    - The spiral is defined by a shrinking axis-aligned rectangle. We start at the
      same logical corner every time:

        start = (min_x + formwork_offset, max_y - formwork_offset)

      i.e. the **top-left** corner of the offset rectangle.
    - `formwork_offset` is the safety margin from the workzone boundary (panel or bed).
      It is applied to all four sides before the spiral begins.
    - Each completed loop moves the rectangle inwards by `step_size` on all sides:

        left  += step_size
        right -= step_size
        bottom += step_size
        top   -= step_size

      This continues until the remaining rectangle collapses (no area left).

    Direction semantics:
    - The user-facing request describes the "anticlockwise" example as starting at
      top-left, then traversing top -> right -> bottom -> left (which is clockwise
      in a conventional XY frame where +Y is up). For consistency with that request,
      this function intentionally treats:

        direction='anticlockwise'
            as: top-left -> top-right -> bottom-right -> bottom-left

        direction='clockwise'
            as the reverse traversal: top-left -> bottom-left -> bottom-right -> top-right

      (The name is preserved to match the UI/parameter names you specified.)

    Move types:
    - The first point is marked as "rapid".
    - All subsequent points are marked as "work".
    """

    points: List[Point] = []

    if step_size <= 0:
        return points

    left = min_x + formwork_offset
    right = max_x - formwork_offset
    bottom = min_y + formwork_offset
    top = max_y - formwork_offset

    if left > right or bottom > top:
        return points

    first = True
    while left <= right and bottom <= top:
        start = Point(left, top, "rapid" if first else "work")
        points.append(start)
        first = False

        if direction == "anticlockwise":
            # Requested example ordering (see docstring)
            points.append(Point(right, top, "work"))
            points.append(Point(right, bottom, "work"))
            points.append(Point(left, bottom, "work"))
        else:
            # Reverse traversal (clockwise option in UI)
            points.append(Point(left, bottom, "work"))
            points.append(Point(right, bottom, "work"))
            points.append(Point(right, top, "work"))

        # Shrink for next loop
        left += step_size
        right -= step_size
        bottom += step_size
        top -= step_size

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


def sweep_lift(
    min_x: float,
    max_x: float,
    min_y: float,
    max_y: float,
    step_size: float,
    lift_height: float = 200,
) -> List[Point]:
    """
    Generate a sweep-lift pattern for vacuum tool.
    
    Pattern:
    1. Start at max_x, min_y at safe height
    2. Sweep from max_x to min_x (work move on surface)
    3. Lift tool (rapid move)
    4. Move to min_x, step Y by step_size (rapid move)
    5. Move to max_x at new Y (rapid move)
    6. Lower to surface, sweep from max_x to min_x
    7. Repeat until Y boundary reached
    
    Key difference from cross-hatch: Tool lifts off surface for repositioning,
    only sweeps in one direction (max_x to min_x).
    
    Args:
        min_x: Left edge of workspace (sweep end)
        max_x: Right edge of workspace (sweep start)
        min_y: Bottom edge of workspace (starting Y)
        max_y: Top edge of workspace (ending Y)
        step_size: Distance to step in Y between passes
        lift_height: Height to lift during repositioning (for reference only)
    
    Returns:
        List of Points with x, y coordinates and move_type
        move_type "rapid" = lifted/repositioning moves
        move_type "work" = on-surface sweep moves
    """
    points: List[Point] = []
    
    # Generate Y positions for each pass
    y_values = _generate_steps(min_y, max_y, step_size)
    
    for i, y in enumerate(y_values):
        if i == 0:
            # First pass: rapid to start position (max_x, min_y)
            points.append(Point(max_x, y, "rapid"))
        else:
            # Subsequent passes: we're at min_x from previous sweep
            # Lift (implied by rapid), move to min_x at new Y, then to max_x
            points.append(Point(min_x, y, "rapid"))  # Step Y (lifted)
            points.append(Point(max_x, y, "rapid"))  # Move to sweep start (lifted)
        
        # Sweep from max_x to min_x (on surface)
        points.append(Point(min_x, y, "work"))
    
    return points


def single_pass(
    start_x: float,
    end_x: float,
    y_position: float,
    approach_offset: float = 50,
) -> List[Point]:
    """
    Generate a single linear pass pattern (e.g., vibrating screed).
    
    This is the simplest pattern: approach, work pass, depart.
    
    Args:
        start_x: Starting X position
        end_x: Ending X position  
        y_position: Fixed Y position for the pass
        approach_offset: X offset for approach/depart moves
    
    Returns:
        List of Points: [approach, start, end, depart]
    """
    points = [
        Point(start_x - approach_offset, y_position, "rapid"),  # Approach
        Point(start_x, y_position, "work"),  # Start of pass
        Point(end_x, y_position, "work"),    # End of pass
        Point(end_x + approach_offset, y_position, "rapid"),  # Depart
    ]
    return points


def generate_pattern(pattern_type: str, config: PatternConfig) -> List[Point]:
    """
    Factory function to generate any pattern from a PatternConfig.
    
    This is the main entry point for Tool class to use.
    
    Args:
        pattern_type: One of 'cross_hatch', 'rectangular_spiral', 'sweep_lift', 'single_pass'
        config: PatternConfig with all necessary parameters
        
    Returns:
        List of Points for the pattern
    """
    if pattern_type == 'cross_hatch':
        return cross_hatch(
            min_x=config.min_x,
            max_x=config.max_x,
            min_y=config.min_y,
            max_y=config.max_y,
            step_size=config.step_size,
            first_direction=config.first_direction,
            start_corner=config.start_corner,
        )
    elif pattern_type == 'rectangular_spiral':
        return rectangular_spiral(
            min_x=config.min_x,
            max_x=config.max_x,
            min_y=config.min_y,
            max_y=config.max_y,
            step_size=config.step_size,
            formwork_offset=config.formwork_offset,
            direction=config.spiral_direction,
        )
    elif pattern_type == 'sweep_lift':
        return sweep_lift(
            min_x=config.min_x,
            max_x=config.max_x,
            min_y=config.min_y,
            max_y=config.max_y,
            step_size=config.step_size,
            lift_height=config.lift_height,
        )
    elif pattern_type == 'single_pass':
        # For single pass, use min_x to max_x, y at center of workzone
        y_center = (config.min_y + config.max_y) / 2
        return single_pass(
            start_x=config.min_x,
            end_x=config.max_x,
            y_position=y_center,
        )
    else:
        raise ValueError(f"Unknown pattern type: {pattern_type}")
