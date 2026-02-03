"""
RAPID code emission helpers.

This module knows RAPID syntax but nothing about patterns.
It converts coordinates and parameters into valid RAPID code strings.
"""

from typing import List, Optional
from .patterns import Point


class RapidEmitter:
    """Generates RAPID code for robot movements."""
    
    def __init__(
        self,
        tool: str,
        wobj: str,
        default_speed: int = 100,
        default_zone: str = "z5",
    ):
        self.tool = tool
        self.wobj = wobj
        self.default_speed = default_speed
        self.default_zone = default_zone
    
    def move_j(
        self,
        x: float,
        y: float,
        z: float,
        speed: Optional[int] = None,
        zone: Optional[str] = None,
        extax: Optional[float] = None,
    ) -> str:
        """
        Generate a MoveJ (joint move) command.
        
        Uses a fixed orientation suitable for helicopter/pan tools.
        """
        s = speed or self.default_speed
        zn = zone or self.default_zone
        ext = self._format_extax(extax)
        
        return (
            f'MoveJ [[{x},{y},{z}],'
            f'[0.000446787,0.711247,-0.702933,-0.00362622],'
            f'[1,0,0,0],'
            f'[{ext},9E+09,9E+09,9E+09,9E+09,9E+09]],'
            f'v{s},{zn},{self.tool}\\WObj:={self.wobj};'
        )
    
    def move_l(
        self,
        x: float,
        y: float,
        z: float,
        speed: Optional[int] = None,
        zone: Optional[str] = None,
        extax: Optional[float] = None,
    ) -> str:
        """
        Generate a MoveL (linear move) command.
        
        Uses a fixed orientation suitable for helicopter/pan tools.
        """
        s = speed or self.default_speed
        zn = zone or self.default_zone
        ext = self._format_extax(extax)
        
        return (
            f'MoveL [[{x},{y},{z}],'
            f'[0.000446787,0.711247,-0.702933,-0.00362622],'
            f'[1,0,0,0],'
            f'[{ext},9E+09,9E+09,9E+09,9E+09,9E+09]],'
            f'v{s},{zn},{self.tool}\\WObj:={self.wobj};'
        )
    
    def _format_extax(self, extax: Optional[float]) -> str:
        """Format external axis value."""
        if extax is None:
            return "9E+09"
        return f"{extax:.2f}"
    
    def path_from_points(
        self,
        points: List[Point],
        z: float,
        speed: Optional[int] = None,
        calc_extax: Optional[callable] = None,
    ) -> List[str]:
        """
        Convert pattern points to RAPID move commands.
        
        Args:
            points: List of Point objects from pattern generator
            z: Z height for all moves
            speed: Override speed (uses default if None)
            calc_extax: Optional function(x, y) -> extax value
        
        Returns:
            List of RAPID move command strings
        """
        lines = []
        for i, p in enumerate(points):
            extax = calc_extax(p.x, p.y) if calc_extax else None
            
            if p.move_type == "rapid":
                lines.append(self.move_j(p.x, p.y, z, speed, extax=extax))
            else:
                lines.append(self.move_l(p.x, p.y, z, speed, extax=extax))
        
        return lines


def indent(lines: List[str], spaces: int = 8) -> str:
    """Indent a list of lines and join them."""
    prefix = " " * spaces
    return "\n".join(prefix + line for line in lines)
