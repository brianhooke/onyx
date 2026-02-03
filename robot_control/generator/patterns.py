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


def serpentine(
    min_x: float,
    max_x: float,
    min_y: float,
    max_y: float,
    step_y: float,
    start_corner: Literal["top_left", "top_right", "bottom_left", "bottom_right"] = "top_left",
) -> List[Point]:
    """
    Generate a serpentine (lawn-mower) pattern.
    
    The pattern sweeps back and forth in X while stepping in Y.
    
    Args:
        min_x: Left edge of workspace
        max_x: Right edge of workspace
        min_y: Bottom edge of workspace (closest to track)
        max_y: Top edge of workspace (furthest from track)
        step_y: Distance to step between rows
        start_corner: Which corner to start from
    
    Returns:
        List of Points with x, y coordinates and move_type
    """
    points: List[Point] = []
    
    # Determine directions based on start corner
    if start_corner in ("top_left", "top_right"):
        y_values = _generate_steps(max_y, min_y, -step_y)
    else:
        y_values = _generate_steps(min_y, max_y, step_y)
    
    if start_corner in ("top_left", "bottom_left"):
        first_x, second_x = min_x, max_x
    else:
        first_x, second_x = max_x, min_x
    
    # Generate the serpentine
    for i, y in enumerate(y_values):
        if i % 2 == 0:
            # Even rows: go from first_x to second_x
            if i == 0:
                points.append(Point(first_x, y, "rapid"))  # First point is rapid move
            else:
                points.append(Point(first_x, y, "work"))   # Step to new row
            points.append(Point(second_x, y, "work"))      # Sweep across
        else:
            # Odd rows: go from second_x to first_x
            points.append(Point(second_x, y, "work"))      # Step to new row
            points.append(Point(first_x, y, "work"))       # Sweep back
    
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
