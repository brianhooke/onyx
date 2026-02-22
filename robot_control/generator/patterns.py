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


# Vacuum rotation constraints (axis 6 mechanical limits)
# Rotation is cumulative - we track total rotation from initial position (0°)
# Positive rotation = clockwise (CW), Negative = anticlockwise (ACW)
MAX_CW_ROTATION = 270.0   # Maximum clockwise rotation (positive degrees)
MAX_ACW_ROTATION = -270.0  # Maximum anticlockwise rotation (negative degrees)


@dataclass
class Point:
    """A point in the pattern with move type hint."""
    x: float
    y: float
    move_type: Literal["rapid", "work", "lift", "place"]  # rapid=fast positioning, work=process move, lift/place=vacuum transitions
    axis_5: Optional[float] = None  # Axis 5 tilt angle in degrees (vacuum pipe tilts towards max_x/far end of bed, None = unchanged)
    axis_6: Optional[float] = None  # Axis 6 rotation in degrees (None = unchanged)
    
    def __repr__(self) -> str:
        extras = []
        if self.axis_5 is not None:
            extras.append(f"axis_5={self.axis_5:.0f}")
        if self.axis_6 is not None:
            extras.append(f"axis_6={self.axis_6:.0f}")
        if extras:
            return f"Point({self.x:.0f}, {self.y:.0f}, '{self.move_type}', {', '.join(extras)})"
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


def check_and_unwind(points: List[Point], current_axis_6: float, new_axis_6: float, 
                     current_x: float, current_y: float) -> float:
    """
    Check if rotation would exceed limits. If so, add unwind moves and return adjusted angle.
    
    The unwind routine:
    1. Lift at current position
    2. Rotate back to 0° (neutral position)
    3. Rotate to new target angle from 0°
    4. Place back down
    
    Returns the new_axis_6 value (which may be normalized if we unwound).
    """
    # Check if new rotation would exceed limits
    if new_axis_6 > MAX_CW_ROTATION or new_axis_6 < MAX_ACW_ROTATION:
        # Need to unwind - lift, rotate to 0, then to new angle (normalized)
        points.append(Point(current_x, current_y, "lift", axis_6=current_axis_6))
        points.append(Point(current_x, current_y, "rapid", axis_6=0.0))  # Unwind to neutral
        
        # Normalize new_axis_6 to be within limits (closest equivalent angle)
        normalized = new_axis_6 % 360
        if normalized > 180:
            normalized -= 360
        elif normalized < -180:
            normalized += 360
        
        points.append(Point(current_x, current_y, "place", axis_6=normalized))
        return normalized
    
    return new_axis_6


def cross_hatch(
    min_x: float,
    max_x: float,
    min_y: float,
    max_y: float,
    step_size: float,
    first_direction: Literal["x", "y"] = "x",
    start_corner: Literal["top_left", "top_right", "bottom_left", "bottom_right"] = "top_left",
    tool: str = "",
    handle_length: float = 250,
) -> List[Point]:
    """
    Generate a cross-hatch pattern.
    
    Phase 1: Sweeps in first_direction while stepping in the perpendicular direction.
    Phase 2: Continues from where Phase 1 ended, sweeping perpendicular and stepping in first_direction.
    
    The key behavior: Phase 2 starts from wherever Phase 1 ended - no diagonal repositioning.
    
    Vacuum-specific behavior:
    - axis_6 tracks tool orientation (handle points OPPOSITE to travel direction)
    - At direction changes: lift, rotate, offset by handle_length, place
    
    Args:
        min_x: Left edge of workspace
        max_x: Right edge of workspace
        min_y: Bottom edge of workspace (closest to track)
        max_y: Top edge of workspace (furthest from track)
        step_size: Distance to step between passes
        first_direction: 'x' for X passes first, 'y' for Y passes first
        start_corner: Which corner to start from
        tool: Tool type (e.g., "vacuum" for special handling)
        handle_length: Vacuum handle offset at corners (default 250mm)
    
    Returns:
        List of Points with x, y coordinates and move_type
    """
    points: List[Point] = []
    is_vacuum = tool == "vacuum"
    
    # Vacuum axis_6 angles (handle points OPPOSITE to travel direction)
    # Moving right (+X): handle faces left = 180°
    # Moving left (-X): handle faces right = 0°
    # Moving up (+Y): handle faces down = -90° (or 270°)
    # Moving down (-Y): handle faces up = 90°
    AXIS6_MOVE_RIGHT = 180.0
    AXIS6_MOVE_LEFT = 0.0
    AXIS6_MOVE_UP = -90.0
    AXIS6_MOVE_DOWN = 90.0
    
    current_axis_6 = 0.0  # Will be set based on first sweep direction
    
    def get_axis6_for_direction(dx: float, dy: float) -> float:
        """Get axis_6 angle for given travel direction."""
        if abs(dx) > abs(dy):
            return AXIS6_MOVE_RIGHT if dx > 0 else AXIS6_MOVE_LEFT
        else:
            return AXIS6_MOVE_UP if dy > 0 else AXIS6_MOVE_DOWN
    
    def add_vacuum_corner(from_x: float, from_y: float, to_x: float, to_y: float) -> tuple:
        """
        Handle vacuum corner transition: lift, rotate, offset, place.
        Checks rotation limits and unwinds if necessary.
        Returns adjusted (x, y) where work should resume.
        """
        nonlocal current_axis_6
        
        # Calculate new direction
        dx = to_x - from_x
        dy = to_y - from_y
        new_axis_6 = get_axis6_for_direction(dx, dy)
        
        # Check if rotation would exceed limits - unwind if needed
        new_axis_6 = check_and_unwind(points, current_axis_6, new_axis_6, from_x, from_y)
        
        # If we didn't unwind, do normal lift
        if len(points) == 0 or points[-1].move_type != "place":
            points.append(Point(from_x, from_y, "lift", axis_6=current_axis_6))
        
        # Update rotation
        current_axis_6 = new_axis_6
        
        # Calculate offset position (move handle_length in new direction)
        if abs(dx) > abs(dy):
            offset_x = from_x + (handle_length if dx > 0 else -handle_length)
            offset_y = from_y
        else:
            offset_x = from_x
            offset_y = from_y + (handle_length if dy > 0 else -handle_length)
        
        # Place at offset position (if we unwound, we already placed, so just move)
        if len(points) > 0 and points[-1].move_type == "place":
            # Already placed from unwind, add work move to offset
            points.append(Point(offset_x, offset_y, "work", axis_6=current_axis_6))
        else:
            points.append(Point(offset_x, offset_y, "place", axis_6=current_axis_6))
        
        return offset_x, offset_y
    
    # Determine initial directions based on start corner
    if start_corner in ("top_left", "top_right"):
        y_start, y_end, y_step = max_y, min_y, -step_size
    else:
        y_start, y_end, y_step = min_y, max_y, step_size
    
    if start_corner in ("top_left", "bottom_left"):
        x_start, x_end, x_step = min_x, max_x, step_size
    else:
        x_start, x_end, x_step = max_x, min_x, -step_size
    
    # Track current position
    current_x = x_start
    current_y = y_start
    sweep_dir_x = 1  # 1 = toward x_end, -1 = toward x_start
    sweep_dir_y = 1  # 1 = toward y_end, -1 = toward y_start
    
    if first_direction == "x":
        # PHASE 1: X passes (sweep X, step in Y)
        y_values = _generate_steps(y_start, y_end, y_step)
        
        for i, y in enumerate(y_values):
            current_y = y
            sweeping_right = (i % 2 == 0) if sweep_dir_x == 1 else (i % 2 == 1)
            
            if i % 2 == 0:
                target_x = x_end if sweep_dir_x == 1 else x_start
            else:
                target_x = x_start if sweep_dir_x == 1 else x_end
            
            if i == 0:
                # First point - rapid to start
                start_x = x_start if sweep_dir_x == 1 else x_end
                if is_vacuum:
                    current_axis_6 = get_axis6_for_direction(target_x - start_x, 0)
                    points.append(Point(start_x, y, "rapid", axis_6=current_axis_6))
                else:
                    points.append(Point(start_x, y, "rapid"))
            else:
                # Step in Y then sweep X - this is a direction change for vacuum
                if is_vacuum:
                    # Lift, rotate, offset, place for the Y step + X sweep
                    add_vacuum_corner(current_x, points[-1].y if points else y_start, target_x, y)
                else:
                    points.append(Point(current_x, y, "work"))  # Step in Y
            
            # Sweep X
            current_x = target_x
            if is_vacuum:
                points.append(Point(current_x, y, "work", axis_6=current_axis_6))
            else:
                points.append(Point(current_x, y, "work"))
        
        # PHASE 2: Y passes (sweep Y, step in X) - cover full width
        x_positions = _generate_steps(min_x, max_x, step_size)
        
        if current_y <= (min_y + max_y) / 2:
            y_sweep_start = min_y
            y_sweep_end = max_y
        else:
            y_sweep_start = max_y
            y_sweep_end = min_y
        
        for i, x in enumerate(x_positions):
            sweeping_up = (i % 2 == 0) if y_sweep_end > y_sweep_start else (i % 2 == 1)
            y_target = y_sweep_end if i % 2 == 0 else y_sweep_start
            
            if i == 0:
                # Transition from Phase 1 to Phase 2 - direction change
                if is_vacuum:
                    add_vacuum_corner(current_x, current_y, x, y_target)
                else:
                    points.append(Point(x, current_y, "work"))
            else:
                # Step in X then sweep Y - direction change
                if is_vacuum:
                    add_vacuum_corner(current_x, current_y, x, y_target)
                else:
                    points.append(Point(x, current_y, "work"))
            
            current_x = x
            
            # Sweep Y
            if is_vacuum:
                points.append(Point(current_x, y_target, "work", axis_6=current_axis_6))
            else:
                points.append(Point(current_x, y_target, "work"))
            current_y = y_target
    
    else:  # first_direction == "y"
        # PHASE 1: Y passes (sweep Y, step in X)
        x_values = _generate_steps(x_start, x_end, x_step)
        
        for i, x in enumerate(x_values):
            current_x = x
            sweeping_up = (i % 2 == 0) if sweep_dir_y == 1 else (i % 2 == 1)
            
            if i % 2 == 0:
                target_y = y_end if sweep_dir_y == 1 else y_start
            else:
                target_y = y_start if sweep_dir_y == 1 else y_end
            
            if i == 0:
                # First point - rapid to start
                start_y = y_start if sweep_dir_y == 1 else y_end
                if is_vacuum:
                    current_axis_6 = get_axis6_for_direction(0, target_y - start_y)
                    points.append(Point(x, start_y, "rapid", axis_6=current_axis_6))
                else:
                    points.append(Point(x, start_y, "rapid"))
            else:
                # Step in X then sweep Y - direction change
                if is_vacuum:
                    add_vacuum_corner(points[-1].x if points else x_start, current_y, x, target_y)
                else:
                    points.append(Point(x, current_y, "work"))
            
            # Sweep Y
            current_y = target_y
            if is_vacuum:
                points.append(Point(x, current_y, "work", axis_6=current_axis_6))
            else:
                points.append(Point(x, current_y, "work"))
        
        # PHASE 2: X passes (sweep X, step in Y) - cover full height
        y_positions = _generate_steps(min_y, max_y, step_size)
        
        if current_x <= (min_x + max_x) / 2:
            x_sweep_start = min_x
            x_sweep_end = max_x
        else:
            x_sweep_start = max_x
            x_sweep_end = min_x
        
        for i, y in enumerate(y_positions):
            sweeping_right = (i % 2 == 0) if x_sweep_end > x_sweep_start else (i % 2 == 1)
            x_target = x_sweep_end if i % 2 == 0 else x_sweep_start
            
            if i == 0:
                # Transition from Phase 1 to Phase 2 - direction change
                if is_vacuum:
                    add_vacuum_corner(current_x, current_y, x_target, y)
                else:
                    points.append(Point(current_x, y, "work"))
            else:
                # Step in Y then sweep X - direction change
                if is_vacuum:
                    add_vacuum_corner(current_x, current_y, x_target, y)
                else:
                    points.append(Point(current_x, y, "work"))
            
            current_y = y
            
            # Sweep X
            if is_vacuum:
                points.append(Point(x_target, current_y, "work", axis_6=current_axis_6))
            else:
                points.append(Point(x_target, current_y, "work"))
            current_x = x_target
    
    return points


def rectangular_spiral(
    min_x: float,
    max_x: float,
    min_y: float,
    max_y: float,
    step_size: float,
    formwork_offset: float,
    direction: Literal["clockwise", "anticlockwise"] = "anticlockwise",
    tool: str = "",
    handle_length: float = 0,
) -> List[Point]:
    """
    Generate a continuous rectangular spiral pattern (inward spiral).

    The spiral starts at the top-left corner and continuously traces inward,
    stepping in by step_size after each edge, creating a true spiral path
    with no jumps or teleportation.

    Args:
        min_x, max_x, min_y, max_y: Workzone boundaries
        step_size: Distance to step inward after each edge
        formwork_offset: Safety margin from workzone boundary (applied to all sides)
        direction: 'anticlockwise' = TL→TR→BR→BL (visually clockwise when Y-up)
                   'clockwise' = TL→BL→BR→TR (visually anticlockwise when Y-up)
        tool: Tool name (e.g., 'vacuum') for tool-specific handling
        handle_length: For vacuum, the handle length (250mm) used for corner offset

    Move types:
    - First point is "rapid" (approach)
    - All subsequent points are "work" (on surface)
    - For vacuum: "lift" at corners, then rotate, offset, and "place"
    
    Vacuum-specific behavior:
    - At each corner: lift off, rotate 90°, move handle_length in new direction, place
    - axis_6 tracks cumulative rotation for the vacuum tool
    """
    points: List[Point] = []

    if step_size <= 0:
        return points

    # Apply formwork offset to get working boundaries
    left = min_x + formwork_offset
    right = max_x - formwork_offset
    bottom = min_y + formwork_offset
    top = max_y - formwork_offset

    if left >= right or bottom >= top:
        return points

    is_vacuum = tool == "vacuum"
    
    # For vacuum, track cumulative rotation (axis_6)
    # Handle should point OPPOSITE to direction of travel (like sweep pattern)
    # In sweep: moving left (-X) = axis_6=0, moving right (+X) = axis_6=180
    # So heading +X means handle faces -X = axis_6=180
    # anticlockwise: first edge goes right (+X), handle faces left = 180°
    # clockwise: first edge goes down (-Y), handle faces up = 90°
    if direction == "anticlockwise":
        current_axis_6 = 180.0  # Moving right, handle faces left
    else:
        current_axis_6 = 90.0  # Moving down, handle faces up

    def add_corner_transition(corner_x: float, corner_y: float, next_dx: float, next_dy: float):
        """
        For vacuum: lift at corner, rotate 90°, move handle_length in new direction, place.
        Checks rotation limits and unwinds if necessary.
        For other tools: just add the corner point.
        Returns the adjusted (x, y) where work resumes.
        """
        nonlocal current_axis_6
        
        if not is_vacuum:
            points.append(Point(corner_x, corner_y, "work"))
            return corner_x, corner_y
        
        # Calculate new rotation (90° based on spiral direction)
        # anticlockwise spiral = clockwise rotation at corners (-90°)
        # clockwise spiral = anticlockwise rotation at corners (+90°)
        if direction == "anticlockwise":
            new_axis_6 = current_axis_6 - 90.0
        else:
            new_axis_6 = current_axis_6 + 90.0
        
        # Check if rotation would exceed limits - unwind if needed
        new_axis_6 = check_and_unwind(points, current_axis_6, new_axis_6, corner_x, corner_y)
        
        # If we didn't unwind, do normal lift
        if len(points) == 0 or points[-1].move_type != "place":
            points.append(Point(corner_x, corner_y, "lift", axis_6=current_axis_6))
        
        # Update rotation
        current_axis_6 = new_axis_6
        
        # Move handle_length in new direction of travel
        offset_x = corner_x + next_dx * handle_length
        offset_y = corner_y + next_dy * handle_length
        
        # Place at offset position (if we unwound, we already placed, so just move)
        if len(points) > 0 and points[-1].move_type == "place":
            points.append(Point(offset_x, offset_y, "work", axis_6=current_axis_6))
        else:
            points.append(Point(offset_x, offset_y, "place", axis_6=current_axis_6))
        
        return offset_x, offset_y

    # Start at top-left
    if is_vacuum:
        points.append(Point(left, top, "rapid", axis_6=current_axis_6))
    else:
        points.append(Point(left, top, "rapid"))

    if direction == "anticlockwise":
        # Anticlockwise: TL → TR → BR → BL → step in → continue
        # Edge directions: right(+X,0), down(0,-Y), left(-X,0), up(0,+Y)
        while True:
            # Move right along top edge to TR
            if left < right:
                if is_vacuum:
                    points.append(Point(right, top, "work", axis_6=current_axis_6))
                else:
                    points.append(Point(right, top, "work"))
            else:
                break
            
            # Step inward (top edge done)
            top -= step_size
            
            # Corner: TR, next direction is down (0, -1)
            if bottom < top:
                if is_vacuum:
                    _, _ = add_corner_transition(right, top + step_size, 0, -1)
                    # Move down to BR (adjusted for handle offset already applied)
                    points.append(Point(right, bottom, "work", axis_6=current_axis_6))
                else:
                    points.append(Point(right, bottom, "work"))
            else:
                if bottom <= top + step_size:
                    if is_vacuum:
                        points.append(Point(right, bottom, "work", axis_6=current_axis_6))
                    else:
                        points.append(Point(right, bottom, "work"))
                break
            
            # Step inward (right edge done)
            right -= step_size
            
            # Corner: BR, next direction is left (-1, 0)
            if left < right:
                if is_vacuum:
                    _, _ = add_corner_transition(right + step_size, bottom, -1, 0)
                    points.append(Point(left, bottom, "work", axis_6=current_axis_6))
                else:
                    points.append(Point(left, bottom, "work"))
            else:
                if left <= right + step_size:
                    if is_vacuum:
                        points.append(Point(left, bottom, "work", axis_6=current_axis_6))
                    else:
                        points.append(Point(left, bottom, "work"))
                break
            
            # Step inward (bottom edge done)
            bottom += step_size
            
            # Corner: BL, next direction is up (0, +1)
            if bottom < top:
                if is_vacuum:
                    _, _ = add_corner_transition(left, bottom - step_size, 0, 1)
                    points.append(Point(left, top, "work", axis_6=current_axis_6))
                else:
                    points.append(Point(left, top, "work"))
            else:
                if bottom <= top + step_size:
                    if is_vacuum:
                        points.append(Point(left, top, "work", axis_6=current_axis_6))
                    else:
                        points.append(Point(left, top, "work"))
                break
            
            # Step inward (left edge done)
            left += step_size
            
            # Corner: TL (inner), next direction is right (+1, 0)
            if left < right and bottom < top:
                if is_vacuum:
                    _, _ = add_corner_transition(left - step_size, top, 1, 0)
            
            # Check if we still have room to continue
            if left >= right or bottom >= top:
                break
    else:
        # Clockwise: TL → BL → BR → TR → step in → continue
        # Edge directions: down(0,-Y), right(+X,0), up(0,+Y), left(-X,0)
        while True:
            # Move down along left edge to BL
            if bottom < top:
                if is_vacuum:
                    points.append(Point(left, bottom, "work", axis_6=current_axis_6))
                else:
                    points.append(Point(left, bottom, "work"))
            else:
                break
            
            # Step inward (left edge done)
            left += step_size
            
            # Corner: BL, next direction is right (+1, 0)
            if left < right:
                if is_vacuum:
                    _, _ = add_corner_transition(left - step_size, bottom, 1, 0)
                    points.append(Point(right, bottom, "work", axis_6=current_axis_6))
                else:
                    points.append(Point(right, bottom, "work"))
            else:
                if left <= right + step_size:
                    if is_vacuum:
                        points.append(Point(right, bottom, "work", axis_6=current_axis_6))
                    else:
                        points.append(Point(right, bottom, "work"))
                break
            
            # Step inward (bottom edge done)
            bottom += step_size
            
            # Corner: BR, next direction is up (0, +1)
            if bottom < top:
                if is_vacuum:
                    _, _ = add_corner_transition(right, bottom - step_size, 0, 1)
                    points.append(Point(right, top, "work", axis_6=current_axis_6))
                else:
                    points.append(Point(right, top, "work"))
            else:
                if bottom <= top + step_size:
                    if is_vacuum:
                        points.append(Point(right, top, "work", axis_6=current_axis_6))
                    else:
                        points.append(Point(right, top, "work"))
                break
            
            # Step inward (right edge done)
            right -= step_size
            
            # Corner: TR, next direction is left (-1, 0)
            if left < right:
                if is_vacuum:
                    _, _ = add_corner_transition(right + step_size, top, -1, 0)
                    points.append(Point(left, top, "work", axis_6=current_axis_6))
                else:
                    points.append(Point(left, top, "work"))
            else:
                if left <= right + step_size:
                    if is_vacuum:
                        points.append(Point(left, top, "work", axis_6=current_axis_6))
                    else:
                        points.append(Point(left, top, "work"))
                break
            
            # Step inward (top edge done)
            top -= step_size
            
            # Corner: TL (inner), next direction is down (0, -1)
            if left < right and bottom < top:
                if is_vacuum:
                    _, _ = add_corner_transition(left, top + step_size, 0, -1)
            
            # Check if we still have room to continue
            if left >= right or bottom >= top:
                break

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
    tool_offset: float = 500,
    axis_6_initial: float = 0,
) -> List[Point]:
    """
    Generate a bidirectional sweep-lift pattern for vacuum tool.
    
    The vacuum tool is angled 250mm about the 6th axis, so rotating 180 degrees
    moves the contact point by 500mm (tool_offset). The pattern accounts for this
    by offsetting the start position after each rotation.
    
    Pattern (bidirectional with axis 6 rotation):
    1. Start at max_x, min_y (axis_6 = 0, facing left)
    2. Sweep to min_x (work move)
    3. Lift tool, step in Y direction
    4. Rotate axis 6 by 180 degrees (contact point shifts by tool_offset)
    5. Sweep to max_x (work move)
    6. Lift, step Y, rotate back, repeat alternating
    
    Args:
        min_x: Left edge of workspace
        max_x: Right edge of workspace
        min_y: Bottom edge of workspace (starting Y)
        max_y: Top edge of workspace (ending Y)
        step_size: Distance to step in Y between passes
        lift_height: Height to lift during repositioning (for reference only)
        tool_offset: Contact point shift when rotating 180° (default 500mm)
        axis_6_initial: Initial axis 6 rotation (default 0 = facing left/negative X)
    
    Returns:
        List of Points with x, y coordinates, move_type, and axis_6 rotation
        move_type "rapid" = lifted/repositioning moves
        move_type "work" = on-surface sweep moves
        axis_6 = rotation angle for 6th axis (0 or 180)
    """
    points: List[Point] = []
    
    # Axis 6 positions
    axis_facing_left = axis_6_initial        # 0 degrees - tool facing left (negative X direction)
    axis_facing_right = axis_6_initial + 180 # 180 degrees - tool facing right (positive X direction)
    
    # Generate Y positions for each pass
    y_values = _generate_steps(min_y, max_y, step_size)
    
    for i, y in enumerate(y_values):
        sweeping_left = (i % 2 == 0)  # Alternate: even passes go left, odd passes go right
        
        if i == 0:
            # First pass: rapid to start position (max_x), facing left
            points.append(Point(max_x, y, "rapid", axis_6=axis_facing_left))
            # Sweep left (on surface) to min_x
            points.append(Point(min_x, y, "work", axis_6=axis_facing_left))
        else:
            if sweeping_left:
                # We just finished sweeping right, ended at max_x
                # Step Y (lifted), then rotate to face left, then sweep
                points.append(Point(max_x, y, "rapid", axis_6=axis_facing_right))  # Step Y (still facing right)
                points.append(Point(max_x, y, "rapid", axis_6=axis_facing_left))   # Rotate to face left
                # Sweep left (on surface) to min_x
                points.append(Point(min_x, y, "work", axis_6=axis_facing_left))
            else:
                # We just finished sweeping left, ended at min_x
                # Step Y (lifted), then rotate to face right, then sweep
                points.append(Point(min_x, y, "rapid", axis_6=axis_facing_left))   # Step Y (still facing left)
                points.append(Point(min_x, y, "rapid", axis_6=axis_facing_right))  # Rotate to face right
                # Sweep right (on surface) to max_x
                points.append(Point(max_x, y, "work", axis_6=axis_facing_right))
    
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
            tool_offset=getattr(config, 'tool_offset', 500),
            axis_6_initial=getattr(config, 'axis_6_initial', 0),
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
