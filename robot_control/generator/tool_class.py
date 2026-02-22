"""
Tool Class Architecture for RAPID Code Generation

This module defines a unified Tool class that generates complete RAPID procedures
for tool operations. It consolidates the duplicated code from individual tool
generators (helicopter.py, polisher.py, etc.) into a single, extensible framework.

Architecture:
    ToolConfig - Dataclass holding all tool configuration
    Tool (base class)
    ├── Helicopter - Blade speed + angle, force control
    ├── Pan - Blade speed (no angle), force control
    ├── Polisher - On/off motor, force control
    ├── Vacuum - On/off motor, no force control
    └── VibScreed - On/off motor, no force control

Flow:
    1. patterns.py generates List[Point] (pure geometry)
    2. Tool.generate_procedure() consumes points + params
    3. Tool generates complete RAPID PROC with:
       - Pickup sequence
       - Pattern execution (converts Points to MoveL/FCPressL)
       - Dropoff sequence
       - Error handling

Key design decisions:
    - Force control is a mixin behavior (tools either have it or don't)
    - Motor control varies: blade speed+angle, blade speed only, or simple on/off
    - Track clamping logic is centralized in base class
    - Pattern execution is generic - any List[Point] can be executed
"""

from dataclasses import dataclass, field
from typing import Optional, List, Literal, Dict, Any
from abc import ABC, abstractmethod
from .patterns import Point, PatternConfig, generate_pattern, cross_hatch, rectangular_spiral, sweep_lift, single_pass
from .tools.utils import get_track_limits


@dataclass
class ToolPosition:
    """Represents a robot target position for a tool operation."""
    name: str                    # e.g., "pHeli", "ptHeli"
    approach_offset: tuple = (0, 0, 100)    # XYZ offset for approach
    depart_offset: tuple = (0, 0, 500)      # XYZ offset for departure
    approach_speed: str = "v500"
    contact_speed: str = "v30"


@dataclass 
class ToolConfig:
    """Configuration for a tool - all the data needed to generate RAPID."""
    tool_num: int                # 2=Heli, 3=VS, 4=Plotter, 5=Vac, 6=Polish
    name: str                    # Human readable name
    tooldata: str                # RAPID tooldata variable (e.g., "tHeli")
    pickup_pos: ToolPosition     # Where to pick up
    dropoff_pos: ToolPosition    # Where to drop off
    power_do: Optional[str] = None       # Digital output for power (e.g., "Local_IO_0_DO5")
    error_disconnect: Optional[str] = None  # Error to raise if disconnected
    min_safe_z: int = 300        # Minimum Z height before movements
    home_pos: str = "pHome"      # Home position name


class Tool(ABC):
    """
    Base class for all tools.
    
    Handles common operations:
    - Pickup sequence (check state, move to position, grip, depart)
    - Dropoff sequence (check state, move to position, release, depart)
    - Power on/off (for tools with power)
    
    Subclasses override for tool-specific behaviors.
    """
    
    def __init__(self, config: ToolConfig):
        self.config = config
    
    @property
    def name(self) -> str:
        return self.config.name
    
    @property
    def tool_num(self) -> int:
        return self.config.tool_num
    
    def generate_pickup_proc(self) -> str:
        """Generate RAPID procedure for picking up this tool."""
        c = self.config
        
        # Build the RAPID procedure
        lines = [
            f"    PROC {c.name}_Pickup()",
            f"",
            f"        IF ToolNum=1 THEN",
            f"            WaiTtime\\inpos,0.05;",
            f"            CurrentJoints:=CJointT();",
            f"            CurrentPos:=CalcRobT(CurrentJoints,tTCmaster\\WObj:=wobj0);",
            f"            IF CurrentPos.trans.z<{c.min_safe_z} THEN",
            f"                MoveL Offs(CurrentPos,0,0,(500-CurrentPos.trans.z)),v500,z5,tTCMaster;",
            f"            ENDIF",
            f"",
            f"            MoveJ {c.home_pos},v1500,fine,tTCMaster;",
            f"            IF TestDI(Local_IO_0_DI13)<>TRUE THEN",
            f"                TC_release;",
            f"            ENDIF",
        ]
        
        # Add tool-specific pre-pickup actions
        lines.extend(self._pre_pickup_actions())
        
        # Standard pickup sequence
        pickup = c.pickup_pos
        dropoff = c.dropoff_pos
        lines.extend([
            f"",
            f"            MoveJ Offs({pickup.name},0,0,{pickup.approach_offset[2]}),{pickup.approach_speed},z5,tTCMaster;",
            f"            MoveL {pickup.name},{pickup.contact_speed},fine,tTCMaster;",
            f"            TC_grip({c.tool_num});",
        ])
        
        # Add tool-specific post-grip actions
        lines.extend(self._post_grip_actions())
        
        # Departure
        lines.extend([
            f"            MoveL Offs({dropoff.name},0,0,{dropoff.approach_offset[2]}),v50,z5,{c.tooldata};",
            f"            MoveJ Offs({dropoff.name},0,0,{dropoff.depart_offset[2]}),v500,z5,{c.tooldata};",
        ])
        
        # Add tool-specific departure moves
        lines.extend(self._pickup_departure_moves())
        
        # Error handling
        lines.extend([
            f"",
            f"        ELSE",
            f"            RAISE ERR_TC_SELECTION;",
            f"        ENDIF",
            f"",
            f"    ERROR",
            f"        RAISE ;",
            f"",
            f"    ENDPROC",
        ])
        
        return "\n".join(lines)
    
    def generate_dropoff_proc(self) -> str:
        """Generate RAPID procedure for dropping off this tool."""
        c = self.config
        pickup = c.pickup_pos
        dropoff = c.dropoff_pos
        
        lines = [
            f"    PROC {c.name}_Dropoff()",
            f"",
            f"        IF ToolNum={c.tool_num} THEN",
            f"            WaiTtime\\inpos,0.05;",
            f"            CurrentJoints:=CJointT();",
            f"            CurrentPos:=CalcRobT(CurrentJoints,{c.tooldata}\\WObj:=wobj0);",
            f"            IF (CurrentPos.trans.z<{c.min_safe_z}) THEN",
            f"                MoveL Offs(CurrentPos,0,0,({c.min_safe_z}-CurrentPos.trans.z)),v500,z5,{c.tooldata};",
            f"            ENDIF",
        ]
        
        # Add tool-specific pre-dropoff actions (turn off power, etc.)
        lines.extend(self._pre_dropoff_actions())
        
        # Approach and release
        lines.extend([
            f"",
            f"            MoveJ Offs({dropoff.name},0,0,{dropoff.depart_offset[2]}),v500,z5,{c.tooldata};",
            f"            MoveJ Offs({dropoff.name},0,0,{dropoff.approach_offset[2]}),v500,z5,{c.tooldata};",
            f"            MoveL {dropoff.name},{dropoff.contact_speed},fine,{c.tooldata};",
            f"            TC_release;",
            f"            MoveL Offs({pickup.name},0,0,50),v50,z5,tTCMaster;",
            f"            MoveJ {c.home_pos},v1500,z50,tTCMaster;",
            f"",
            f"        ELSE",
            f"            RAISE ERR_TC_SELECTION;",
            f"        ENDIF",
            f"",
            f"    ERROR",
            f"        RAISE ;",
            f"",
            f"    ENDPROC",
        ])
        
        return "\n".join(lines)
    
    def generate_power_procs(self) -> str:
        """Generate power on/off procedures if tool has power."""
        if not self.config.power_do:
            return ""
        
        c = self.config
        short_name = c.name[:3] if len(c.name) > 3 else c.name  # "Heli" -> "Hel", "VS" -> "VS"
        
        lines = [
            f"    PROC {short_name}_on()",
            f"        IF Toolnum={c.tool_num} AND testDI(Local_IO_0_DI14) THEN",
            f"            SetDO {c.power_do},1;",
            f"        ELSE",
            f"            RAISE {c.error_disconnect};",
            f"        ENDIF",
            f"    ERROR",
            f"        RAISE ;",
            f"    ENDPROC",
            f"",
            f"    PROC {short_name}_off()",
            f"        SetDO {c.power_do},0;",
            f"    ENDPROC",
        ]
        return "\n".join(lines)
    
    # Override these in subclasses for tool-specific behavior
    def _pre_pickup_actions(self) -> List[str]:
        """Actions before approaching pickup position."""
        return []
    
    def _post_grip_actions(self) -> List[str]:
        """Actions after gripping tool (e.g., homing steppers)."""
        return []
    
    def _pickup_departure_moves(self) -> List[str]:
        """Additional moves when departing pickup area."""
        return []
    
    def _pre_dropoff_actions(self) -> List[str]:
        """Actions before dropping off (e.g., turn off power)."""
        return []
    
    # =========================================================================
    # Pattern Execution - generates RAPID from List[Point]
    # =========================================================================
    
    def generate_procedure(self, params: Dict[str, Any]) -> str:
        """
        Generate complete RAPID procedure for this tool.
        
        This is the main entry point that replaces individual tool generators.
        It handles:
        1. Variable declarations
        2. Tool pickup (if not already holding)
        3. Pattern execution (from points)
        4. Tool dropoff
        5. Error handling
        
        Args:
            params: Frontend parameters dict
            
        Returns:
            Complete RAPID PROC as string
        """
        # Get pattern points based on tool's pattern type
        points = self._get_pattern_points(params)
        
        # Calculate workzone and track limits
        workzone = self._get_workzone_params(params)
        track_min, track_max = get_track_limits(params)
        
        # Build procedure
        lines = []
        lines.extend(self._generate_proc_header(params, workzone))
        lines.extend(self._generate_var_declarations(params, workzone, track_min, track_max))
        lines.extend(self._generate_init_section(params, workzone))
        lines.extend(self._generate_pickup_section())
        lines.extend(self._generate_pattern_execution(points, params, workzone))
        lines.extend(self._generate_finish_section())
        lines.extend(self._generate_error_handler())
        
        return "\n".join(lines)
    
    def _get_pattern_points(self, params: Dict[str, Any]) -> List[Point]:
        """Get pattern points for this tool. Override in subclasses."""
        # Default: cross-hatch pattern
        workzone = self._get_workzone_params(params)
        return cross_hatch(
            min_x=workzone['min_x'],
            max_x=workzone['max_x'],
            min_y=workzone['min_y'],
            max_y=workzone['max_y'],
            step_size=workzone['step_size'],
            first_direction='x',
        )
    
    def _get_workzone_params(self, params: Dict[str, Any]) -> Dict[str, Any]:
        """Calculate workzone boundaries. Override for tool-specific offsets."""
        workzone_type = params.get(f'{self.name.lower()}_workzone', 'panel')
        
        if workzone_type == 'panel':
            datum_x = params['panel_datum_x']
            datum_y = params['panel_datum_y']
            length_x = params['panel_x']
            width_y = params['panel_y']
            base_z = params['panel_z']
        else:
            datum_x = params['bed_datum_x']
            datum_y = params['bed_datum_y']
            length_x = params['bed_length_x']
            width_y = params['bed_width_y']
            base_z = 0
        
        # Apply hard_y_offset: use min of panel's max Y or hard_y_offset (absolute ceiling)
        hard_y_offset = params.get('hard_y_offset', 0)
        panel_max_y = datum_y + width_y
        effective_max_y = min(panel_max_y, hard_y_offset) if hard_y_offset > 0 else panel_max_y
        effective_width_y = effective_max_y - datum_y
        
        # Get tool-specific offsets
        z_offset = params.get('z_offset', 0) + params.get(f'{self.name.lower()}_z_offset', 0)
        tool_width = self._get_tool_width()
        step_size = params.get(f'{self.name.lower()}_step', 200)
        
        return {
            'type': workzone_type,
            'datum_x': datum_x,
            'datum_y': datum_y,
            'length_x': length_x,
            'width_y': effective_width_y,
            'min_x': datum_x + tool_width / 2,
            'max_x': datum_x + length_x - tool_width / 2,
            'min_y': datum_y + tool_width / 2,
            'max_y': effective_max_y - tool_width / 2,
            'work_z': base_z + z_offset,
            'safe_z': base_z + z_offset + 200,
            'step_size': step_size,
            'tool_width': tool_width,
        }
    
    def _get_tool_width(self) -> float:
        """Return tool contact width for boundary calculations. Override per tool."""
        return 200  # Default
    
    def _generate_proc_header(self, params: Dict, workzone: Dict) -> List[str]:
        """Generate procedure header with comments."""
        proc_name = f"Py2{self.config.name}"
        return [
            f"    PROC {proc_name}()",
            f"        ! {proc_name} - Generated by Onyx Tool Class",
            f"        ! Workzone: {workzone['type']}",
            f"        ! Area: ({workzone['min_x']:.0f},{workzone['min_y']:.0f}) to ({workzone['max_x']:.0f},{workzone['max_y']:.0f})",
            f"        ! Z = {workzone['work_z']}mm",
            f"        ! Step: {workzone['step_size']}mm",
            f"",
        ]
    
    def _generate_var_declarations(self, params: Dict, workzone: Dict, track_min: float, track_max: float) -> List[str]:
        """Generate VAR declarations."""
        travel_speed = params.get(f'{self.name.lower()}_speed', 100)
        return [
            f"        VAR robtarget pCurrent;",
            f"        VAR jointtarget CurrentJoints;",
            f"        VAR robtarget CurrentPos;",
            f"        VAR num WorkZ:={workzone['work_z']};",
            f"        VAR num SafeZ:={workzone['safe_z']};",
            f"        VAR num CurrentX:=0;",
            f"        VAR num CurrentY:=0;",
            f"        VAR speeddata vTravel:=[{travel_speed},15,2000,15];",
            f"        VAR num TrackMin:={track_min};",
            f"        VAR num TrackMax:={track_max};",
            f"        VAR num CalcTrack:=0;",
            f"",
        ]
    
    def _generate_init_section(self, params: Dict, workzone: Dict) -> List[str]:
        """Generate initialization and TPWrite statements."""
        return [
            f"        TPWrite \"========================================\";",
            f"        TPWrite \"Py2{self.config.name}: Starting\";",
            f"        TPWrite \"========================================\";",
            f"        TPWrite \"Workzone: {workzone['type']}\";",
            f"        TPWrite \"WorkZ=\" \\\\Num:=WorkZ;",
            f"",
        ]
    
    def _generate_pickup_section(self) -> List[str]:
        """Generate tool pickup logic."""
        return [
            f"        ! Get tool if needed",
            f"        IF ToolNum<>{self.config.tool_num} THEN",
            f"            TPWrite \"Py2{self.config.name}: Getting tool...\";",
            f"            Home;",
            f"            {self.config.name}_Pickup;",
            f"        ENDIF",
            f"",
            f"        ! Disable configuration tracking",
            f"        ConfL\\\\Off;",
            f"        ConfJ\\\\Off;",
            f"",
        ]
    
    def _generate_pattern_execution(self, points: List[Point], params: Dict, workzone: Dict) -> List[str]:
        """
        Generate RAPID code to execute the pattern points.
        
        This is the core method that converts List[Point] to MoveL/FCPressL commands.
        Handles axis_6 rotation if specified in points.
        """
        lines = [
            f"        ! ========================================",
            f"        ! Pattern Execution: {len(points)} points",
            f"        ! ========================================",
            f"",
        ]
        
        # Get move command based on force control
        use_fc = self._uses_force_control(params)
        move_cmd = self._get_move_command(use_fc, params)
        
        # Add force control start if needed
        if use_fc:
            lines.extend(self._generate_fc_start(params, workzone))
        
        # Track current axis 6 position for rotation moves
        current_axis_6 = None
        
        # Get axis_5 tilt angle (for vacuum tool - pipe angle)
        axis_5_angle = params.get('vacuum_axis_5', 0) if self.config.name == 'Vac' else 0
        
        # Generate moves for each point
        for i, point in enumerate(points):
            axis_6_str = f", axis_6={point.axis_6:.0f}" if point.axis_6 is not None else ""
            lines.append(f"        ! Point {i+1}: ({point.x:.0f}, {point.y:.0f}) [{point.move_type}]{axis_6_str}")
            lines.append(f"        CurrentX:={point.x:.0f};")
            lines.append(f"        CurrentY:={point.y:.0f};")
            
            # Handle Z based on move type (lifted for rapid/lift, work height for work/place)
            if point.move_type in ("rapid", "lift"):
                lines.append(f"        pCurrent.trans:=[-1*CurrentX,CurrentY,SafeZ];")
            else:
                lines.append(f"        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];")
            
            # Use point's axis_5 if specified, otherwise use tool param
            point_axis_5 = point.axis_5 if point.axis_5 is not None else axis_5_angle
            lines.append(f"        pCurrent.rot:=OrientZYX(0,{point_axis_5},180);")
            lines.append(f"        pCurrent.robconf:=[0,0,0,0];")
            lines.append(f"        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;")
            lines.append(f"        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF")
            lines.append(f"        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF")
            lines.append(f"        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];")
            
            # Handle axis 6 rotation if specified
            if point.axis_6 is not None and point.axis_6 != current_axis_6:
                lines.append(f"        ! Rotate axis 6 to {point.axis_6:.0f} degrees")
                lines.append(f"        MoveAbsJ [[0,0,0,0,0,{point.axis_6:.0f}],pCurrent.extax]\\\\NoEOffs,v100,z5,{self.config.tooldata}\\\\WObj:=Bed1Wyong;")
                current_axis_6 = point.axis_6
            
            if point.move_type == "rapid":
                lines.append(f"        MoveJ pCurrent,v500,z5,{self.config.tooldata}\\\\WObj:=Bed1Wyong;")
            else:
                lines.append(f"        {move_cmd}")
            lines.append(f"")
        
        # Add force control end if needed
        if use_fc:
            lines.extend(self._generate_fc_end(params))
        
        return lines
    
    def _uses_force_control(self, params: Dict) -> bool:
        """Check if this tool uses force control. Override in subclasses."""
        return False
    
    def _get_move_command(self, use_fc: bool, params: Dict) -> str:
        """Get the move command string."""
        if use_fc:
            force = params.get(f'{self.name.lower()}_force', 100)
            return f"FCPressL pCurrent,vTravel,{force},fine,{self.config.tooldata}\\\\WObj:=Bed1Wyong;"
        return f"MoveL pCurrent,vTravel,fine,{self.config.tooldata}\\\\WObj:=Bed1Wyong;"
    
    def _generate_fc_start(self, params: Dict, workzone: Dict) -> List[str]:
        """Generate force control start sequence. Override in FC-capable tools."""
        return []
    
    def _generate_fc_end(self, params: Dict) -> List[str]:
        """Generate force control end sequence. Override in FC-capable tools."""
        return []
    
    def _generate_finish_section(self) -> List[str]:
        """Generate finish/cleanup section."""
        lines = self._generate_motor_off()
        lines.extend([
            f"",
            f"        ! Lift to safe height",
            f"        CurrentJoints:=CJointT();",
            f"        CurrentPos:=CalcRobT(CurrentJoints,{self.config.tooldata}\\\\WObj:=Bed1Wyong);",
            f"        MoveL Offs(CurrentPos,0,0,200),v200,z5,{self.config.tooldata}\\\\WObj:=Bed1Wyong;",
            f"",
            f"        ! Re-enable configuration tracking",
            f"        ConfL\\\\On;",
            f"        ConfJ\\\\On;",
            f"",
            f"        ! Return tool and go home",
            f"        TPWrite \"Py2{self.config.name}: Dropping off tool...\";",
            f"        {self.config.name}_Dropoff;",
            f"        Home;",
            f"",
            f"        TPWrite \"========================================\";",
            f"        TPWrite \"Py2{self.config.name}: COMPLETE\";",
            f"        TPWrite \"========================================\";",
            f"",
        ])
        return lines
    
    def _generate_motor_off(self) -> List[str]:
        """Generate motor/power off commands. Override per tool."""
        return []
    
    def _generate_error_handler(self) -> List[str]:
        """Generate ERROR handler."""
        lines = self._generate_error_cleanup()
        lines.extend([
            f"        RAISE;",
            f"    ENDPROC",
        ])
        return lines
    
    def _generate_error_cleanup(self) -> List[str]:
        """Generate error cleanup commands. Override per tool."""
        return [f"    ERROR"]


# =============================================================================
# Tool Implementations
# =============================================================================

class Helicopter(Tool):
    """Helicopter trowel - has blade speed and angle control, optional force control."""
    
    def __init__(self):
        config = ToolConfig(
            tool_num=2,
            name="Heli",
            tooldata="tHeli",
            pickup_pos=ToolPosition("pHeli", approach_offset=(0, 0, 100)),
            dropoff_pos=ToolPosition("ptHeli", approach_offset=(0, 0, 100), depart_offset=(0, 0, 500)),
            error_disconnect="ERR_HELI_DISCONNECT",
            min_safe_z=250,
        )
        super().__init__(config)
    
    def _get_tool_width(self) -> float:
        return 600  # HeliBladeWidth
    
    def _pre_pickup_actions(self) -> List[str]:
        return ["            HeliBladeSpeed 0,\"FWD\";"]
    
    def _post_grip_actions(self) -> List[str]:
        return [
            "            IF TestDI(Local_IO_0_DI2)=FALSE OR StepperPos<>0 THEN",
            "                Heli_Stepper_Home;",
            "            ENDIF",
        ]
    
    def _pickup_departure_moves(self) -> List[str]:
        return [
            "            pTemp:=ptHeli;",
            "            pTemp.extax.eax_a:=ptHeli.extax.eax_a-2000;",
            "            pTemp.trans.z:=ptHeli.trans.z+800;",
            "            MoveJ Offs(pTemp,-2000,0,0),v500,fine,tHeli;",
        ]
    
    def _pre_dropoff_actions(self) -> List[str]:
        return [
            "            HeliBladeSpeed 0,\"FWD\";",
            "            HeliBlade_Angle 0;",
            "            Heli_Stepper_Home;",
        ]
    
    def _get_pattern_points(self, params: Dict[str, Any]) -> List[Point]:
        """Helicopter supports cross-hatch and rectangular_spiral patterns."""
        workzone = self._get_workzone_params(params)
        pattern = params.get('heli_pattern', 'cross-hatch')
        
        if pattern == 'rectangular_spiral':
            return rectangular_spiral(
                min_x=workzone['min_x'],
                max_x=workzone['max_x'],
                min_y=workzone['min_y'],
                max_y=workzone['max_y'],
                step_size=workzone['step_size'],
                formwork_offset=params.get('heli_formwork_offset', 0),
                direction=params.get('heli_spiral_direction', 'anticlockwise'),
            )
        else:
            return cross_hatch(
                min_x=workzone['min_x'],
                max_x=workzone['max_x'],
                min_y=workzone['min_y'],
                max_y=workzone['max_y'],
                step_size=workzone['step_size'],
                first_direction='x',
            )
    
    def _uses_force_control(self, params: Dict) -> bool:
        return params.get('heli_force', 0) > 0
    
    def _generate_var_declarations(self, params: Dict, workzone: Dict, track_min: float, track_max: float) -> List[str]:
        """Add helicopter-specific variables."""
        lines = super()._generate_var_declarations(params, workzone, track_min, track_max)
        heli_force = params.get('heli_force', 0)
        lines.insert(-1, f"        VAR num HeliForce:={heli_force};")
        lines.insert(-1, f"        VAR bool bFCActive:=FALSE;")
        lines.insert(-1, f"        VAR fcforcevector myForceVector;")
        return lines
    
    def _generate_pickup_section(self) -> List[str]:
        """Add blade setup after pickup."""
        lines = super()._generate_pickup_section()
        lines.extend([
            f"        ! Home stepper and set blade angle",
            f"        TPWrite \"Py2Heli: Homing stepper...\";",
            f"        Heli_Stepper_Home;",
            f"        ! Blade angle set via params",
            f"",
        ])
        return lines
    
    def _generate_fc_start(self, params: Dict, workzone: Dict) -> List[str]:
        force = params.get('heli_force', 100)
        force_change = 100
        pos_supv_dist = 125
        return [
            f"        ! Force control calibration",
            f"        TPWrite \"Py2Heli: Calibrating force control...\";",
            f"        FCCalib HeliLoad70rpm;",
            f"        WaitTime 0.5;",
            f"",
            f"        ! Start blade rotation",
            f"        HeliBladeSpeed {params.get('heli_blade_speed', 70)},\"{params.get('heli_blade_direction', 'FWD')}\";",
            f"        WaitTime 2;",
            f"",
            f"        ! Start force control",
            f"        FCPress1LStart pCurrent,v10,\\\\Fz:={force},15,\\\\ForceChange:={force_change}\\\\PosSupvDist:={pos_supv_dist},z5,tHeli\\\\WObj:=Bed1Wyong;",
            f"        bFCActive:=TRUE;",
            f"",
        ]
    
    def _generate_fc_end(self, params: Dict) -> List[str]:
        return [
            f"",
            f"        ! End force control before lifting",
            f"        CurrentJoints:=CJointT();",
            f"        CurrentPos:=CalcRobT(CurrentJoints,tHeli\\\\WObj:=Bed1Wyong);",
            f"        FCPressEnd Offs(CurrentPos,0,0,50),v50,\\\\DeactOnly,tHeli\\\\WObj:=Bed1Wyong;",
            f"        bFCActive:=FALSE;",
            f"",
        ]
    
    def _generate_motor_off(self) -> List[str]:
        return [
            f"        ! Stop blade rotation",
            f"        HeliBladeSpeed 0,\"FWD\";",
            f"        WaitTime 1;",
        ]
    
    def _generate_error_cleanup(self) -> List[str]:
        return [
            f"    ERROR",
            f"        HeliBladeSpeed 0,\"FWD\";",
            f"        IF bFCActive THEN",
            f"            FCPressEnd Offs(CurrentPos,0,0,100),v50,\\\\DeactOnly,tHeli\\\\WObj:=Bed1Wyong;",
            f"        ENDIF",
        ]


class VibratingScreened(Tool):
    """Vibrating screed for leveling concrete - single pass pattern."""
    
    def __init__(self):
        config = ToolConfig(
            tool_num=3,
            name="VS",
            tooldata="tVS",
            pickup_pos=ToolPosition("pVS2", approach_offset=(0, 0, 50)),
            dropoff_pos=ToolPosition("ptVS2", approach_offset=(0, 0, 100), depart_offset=(-300, 0, 700)),
            power_do="Local_IO_0_DO5",
            error_disconnect="ERR_VS_DISCONNECT",
            min_safe_z=400,
        )
        super().__init__(config)
    
    def _get_tool_width(self) -> float:
        return 700  # Screed blade width
    
    def _get_pattern_points(self, params: Dict[str, Any]) -> List[Point]:
        """VibScreed uses single pass pattern."""
        workzone = self._get_workzone_params(params)
        
        # Edge offset: positive extends beyond panel edges
        edge_offset = params.get('screed_edge_offset', 200)
        
        # Y center is max of panel center or bed center (safety - prevents hitting robot on narrow panels)
        panel_y_center = (workzone['min_y'] + workzone['max_y']) / 2
        bed_y_center = params.get('bed_datum_y', 0) + params.get('bed_width_y', 3000) / 2
        y_center = max(panel_y_center, bed_y_center)
        
        return single_pass(
            start_x=workzone['datum_x'] - edge_offset,
            end_x=workzone['datum_x'] + workzone['length_x'] + edge_offset,
            y_position=y_center,
            approach_offset=50,
        )
    
    def _generate_pickup_section(self) -> List[str]:
        """Add vibrating screed power on."""
        lines = super()._generate_pickup_section()
        lines.extend([
            f"        ! Turn on vibrating screed",
            f"        TPWrite \"Py2VS: Starting screed...\";",
            f"        VS_on;",
            f"",
        ])
        return lines
    
    def _generate_motor_off(self) -> List[str]:
        return [f"        VS_off;"]
    
    def _generate_error_cleanup(self) -> List[str]:
        return [
            f"    ERROR",
            f"        VS_off;",
            f"        TPWrite \"Py2VS ERROR: \" \\\\Num:=ERRNO;",
        ]


class Plotter(Tool):
    """Plotter/marker tool for marking concrete."""
    
    def __init__(self):
        config = ToolConfig(
            tool_num=4,
            name="Plotter",
            tooldata="tPlotter",
            pickup_pos=ToolPosition("pPlotter", approach_offset=(0, 0, 50)),
            dropoff_pos=ToolPosition("ptPlotter", approach_offset=(0, 0, 50), depart_offset=(0, 0, 600)),
            min_safe_z=700,
        )
        super().__init__(config)


class Vacuum(Tool):
    """Vacuum lifter - supports cross-hatch and sweep-lift patterns."""
    
    def __init__(self):
        config = ToolConfig(
            tool_num=5,
            name="Vac",
            tooldata="tVac",
            pickup_pos=ToolPosition("pVac", approach_offset=(0, 0, -100)),  # RelTool approach
            dropoff_pos=ToolPosition("ptVac", approach_offset=(0, 10, 100), depart_offset=(0, 80, 800)),
            power_do="Local_IO_0_DO16",
            min_safe_z=800,
        )
        super().__init__(config)
    
    def _get_tool_width(self) -> float:
        return 400  # Vacuum nozzle width
    
    def _get_pattern_points(self, params: Dict[str, Any]) -> List[Point]:
        """Vacuum supports cross-hatch and sweep-lift patterns."""
        workzone = self._get_workzone_params(params)
        pattern = params.get('vacuum_pattern', 'cross-hatch')
        
        if pattern == 'sweep-lift':
            # Vacuum tool offset: 250mm angled about axis 6, so 180° rotation = 500mm shift
            tool_offset = params.get('vacuum_tool_offset', 500)
            axis_6_initial = params.get('vacuum_axis_6_initial', 0)
            return sweep_lift(
                min_x=workzone['min_x'],
                max_x=workzone['max_x'],
                min_y=workzone['min_y'],
                max_y=workzone['max_y'],
                step_size=workzone['step_size'],
                tool_offset=tool_offset,
                axis_6_initial=axis_6_initial,
            )
        else:
            return cross_hatch(
                min_x=workzone['min_x'],
                max_x=workzone['max_x'],
                min_y=workzone['min_y'],
                max_y=workzone['max_y'],
                step_size=workzone['step_size'],
                first_direction='x',
            )
    
    def _generate_pickup_section(self) -> List[str]:
        """Add vacuum power on after pickup."""
        lines = super()._generate_pickup_section()
        lines.extend([
            f"        ! Turn on vacuum",
            f"        TPWrite \"Py2Vac: Starting vacuum...\";",
            f"        Vac_on;",
            f"        WaitTime 1;",
            f"",
        ])
        return lines
    
    def _generate_motor_off(self) -> List[str]:
        return [f"        Vac_off;"]
    
    def _generate_error_cleanup(self) -> List[str]:
        return [
            f"    ERROR",
            f"        Vac_off;",
            f"        TPWrite \"Py2Vac ERROR: \" \\\\Num:=ERRNO;",
        ]


class Polisher(Tool):
    """Polisher for surface finishing with optional force control."""
    
    def __init__(self):
        config = ToolConfig(
            tool_num=6,
            name="Polish",
            tooldata="tPolish",
            pickup_pos=ToolPosition("pPolish", approach_offset=(0, 0, -100)),  # RelTool
            dropoff_pos=ToolPosition("ptPolish", approach_offset=(0, 0, 100), depart_offset=(0, 0, 500)),
            power_do="Local_IO_0_DO15",
            error_disconnect="ERR_POLISH_DISCONNECT",
            min_safe_z=700,
        )
        super().__init__(config)
    
    def _get_tool_width(self) -> float:
        return 200  # Polisher contact width
    
    def _pre_dropoff_actions(self) -> List[str]:
        return ["            Pol_off;"]
    
    def _uses_force_control(self, params: Dict) -> bool:
        # Force control enabled if any force param > 0
        start = params.get('polisher_start_force', 0)
        motion = params.get('polisher_motion_force', 0)
        return start > 0 or motion > 0
    
    def _generate_var_declarations(self, params: Dict, workzone: Dict, track_min: float, track_max: float) -> List[str]:
        lines = super()._generate_var_declarations(params, workzone, track_min, track_max)
        if self._uses_force_control(params):
            lines.insert(-1, f"        VAR bool bFCActive:=FALSE;")
        return lines
    
    def _generate_fc_start(self, params: Dict, workzone: Dict) -> List[str]:
        start_force = params.get('polisher_start_force', 100)
        force_change = params.get('polisher_force_change', 100)
        pos_supv_dist = params.get('polisher_pos_supv_dist', 125)
        approach_speed = params.get('polisher_approach_speed', 50)
        return [
            f"        ! Turn on polisher motor",
            f"        Pol_on;",
            f"",
            f"        ! Force control calibration",
            f"        WaitTime\\\\inpos,0.1;",
            f"        FCCalib PolishLoad;",
            f"",
            f"        ! Start force control",
            f"        FCPress1LStart pCurrent,v{approach_speed},\\\\Fz:={start_force},15,\\\\ForceChange:={force_change}\\\\PosSupvDist:={pos_supv_dist},z5,tPolish\\\\WObj:=Bed1Wyong;",
            f"        bFCActive:=TRUE;",
            f"",
        ]
    
    def _generate_fc_end(self, params: Dict) -> List[str]:
        retract_speed = params.get('polisher_retract_speed', 100)
        return [
            f"",
            f"        ! End force control",
            f"        CurrentJoints:=CJointT();",
            f"        CurrentPos:=CalcRobT(CurrentJoints,tPolish\\\\WObj:=Bed1Wyong);",
            f"        FCPressEnd Offs(CurrentPos,0,0,75),v{retract_speed},\\\\DeactOnly,tPolish\\\\WObj:=Bed1Wyong;",
            f"        bFCActive:=FALSE;",
            f"",
        ]
    
    def _generate_motor_off(self) -> List[str]:
        return [f"        Pol_off;"]
    
    def _generate_error_cleanup(self) -> List[str]:
        return [
            f"    ERROR",
            f"        Pol_off;",
            f"        TPWrite \"Py2Polish ERROR: \" \\\\Num:=ERRNO;",
        ]


class Pan(Tool):
    """Pan tool - attaches to helicopter, blade speed but no angle control, optional force control."""
    
    def __init__(self):
        # Pan uses helicopter tool holder (tool_num=2) but treated as separate operation
        config = ToolConfig(
            tool_num=2,  # Uses helicopter tool holder
            name="Pan",
            tooldata="tHeli",  # Uses helicopter tooldata
            pickup_pos=ToolPosition("pHeli", approach_offset=(0, 0, 100)),
            dropoff_pos=ToolPosition("ptHeli", approach_offset=(0, 0, 100), depart_offset=(0, 0, 500)),
            error_disconnect="ERR_HELI_DISCONNECT",
            min_safe_z=250,
        )
        super().__init__(config)
    
    def _get_tool_width(self) -> float:
        return 600  # Same as helicopter blade width
    
    def _get_pattern_points(self, params: Dict[str, Any]) -> List[Point]:
        """Pan uses cross-hatch pattern only (no spiral)."""
        workzone = self._get_workzone_params(params)
        return cross_hatch(
            min_x=workzone['min_x'],
            max_x=workzone['max_x'],
            min_y=workzone['min_y'],
            max_y=workzone['max_y'],
            step_size=workzone['step_size'],
            first_direction='x',
        )
    
    def _uses_force_control(self, params: Dict) -> bool:
        return params.get('pan_force', 0) > 0
    
    def _generate_var_declarations(self, params: Dict, workzone: Dict, track_min: float, track_max: float) -> List[str]:
        lines = super()._generate_var_declarations(params, workzone, track_min, track_max)
        pan_force = params.get('pan_force', 0)
        lines.insert(-1, f"        VAR num PanForce:={pan_force};")
        if self._uses_force_control(params):
            lines.insert(-1, f"        VAR bool bFCActive:=FALSE;")
            lines.insert(-1, f"        VAR fcforcevector myForceVector;")
        return lines
    
    def _generate_pickup_section(self) -> List[str]:
        """Pan uses Heli_Pickup since it attaches to helicopter."""
        return [
            f"        ! Get helicopter tool (Pan attaches to it)",
            f"        IF ToolNum<>2 THEN",
            f"            TPWrite \"Py2Pan: Getting helicopter...\";",
            f"            Home;",
            f"            Heli_Pickup;",
            f"        ENDIF",
            f"",
            f"        ! Home stepper (blade angle = 0 for pan)",
            f"        TPWrite \"Py2Pan: Homing stepper...\";",
            f"        Heli_Stepper_Home;",
            f"        HeliBlade_Angle 0;",
            f"",
            f"        ! Disable configuration tracking",
            f"        ConfL\\\\Off;",
            f"        ConfJ\\\\Off;",
            f"",
        ]
    
    def _generate_fc_start(self, params: Dict, workzone: Dict) -> List[str]:
        force = params.get('pan_force', 100)
        force_change = params.get('pan_force_change', 100)
        pos_supv_dist = params.get('pan_pos_supv_dist', 125)
        blade_speed = params.get('pan_blade_speed', 70)
        return [
            f"        ! Force control calibration",
            f"        TPWrite \"Py2Pan: Calibrating force control...\";",
            f"        FCCalib HeliLoad70rpm;",
            f"        WaitTime 0.5;",
            f"",
            f"        ! Start blade rotation",
            f"        HeliBladeSpeed {blade_speed},\"FWD\";",
            f"        WaitTime 2;",
            f"",
            f"        ! Start force control",
            f"        FCPress1LStart pCurrent,v10,\\\\Fz:={force},15,\\\\ForceChange:={force_change}\\\\PosSupvDist:={pos_supv_dist},z5,tHeli\\\\WObj:=Bed1Wyong;",
            f"        bFCActive:=TRUE;",
            f"",
        ]
    
    def _generate_fc_end(self, params: Dict) -> List[str]:
        return [
            f"",
            f"        ! End force control",
            f"        CurrentJoints:=CJointT();",
            f"        CurrentPos:=CalcRobT(CurrentJoints,tHeli\\\\WObj:=Bed1Wyong);",
            f"        FCPressEnd Offs(CurrentPos,0,0,50),v50,\\\\DeactOnly,tHeli\\\\WObj:=Bed1Wyong;",
            f"        bFCActive:=FALSE;",
            f"",
        ]
    
    def _generate_motor_off(self) -> List[str]:
        return [
            f"        ! Stop blade rotation",
            f"        HeliBladeSpeed 0,\"FWD\";",
            f"        WaitTime 1;",
        ]
    
    def _generate_finish_section(self) -> List[str]:
        """Pan uses Heli_Dropoff."""
        lines = self._generate_motor_off()
        lines.extend([
            f"",
            f"        ! Lift to safe height",
            f"        CurrentJoints:=CJointT();",
            f"        CurrentPos:=CalcRobT(CurrentJoints,tHeli\\\\WObj:=Bed1Wyong);",
            f"        MoveL Offs(CurrentPos,0,0,200),v200,z5,tHeli\\\\WObj:=Bed1Wyong;",
            f"",
            f"        ! Re-enable configuration tracking",
            f"        ConfL\\\\On;",
            f"        ConfJ\\\\On;",
            f"",
            f"        ! Return tool and go home",
            f"        TPWrite \"Py2Pan: Dropping off helicopter...\";",
            f"        Heli_Dropoff;",
            f"        Home;",
            f"",
            f"        TPWrite \"========================================\";",
            f"        TPWrite \"Py2Pan: COMPLETE\";",
            f"        TPWrite \"========================================\";",
            f"",
        ])
        return lines
    
    def _generate_error_cleanup(self) -> List[str]:
        return [
            f"    ERROR",
            f"        HeliBladeSpeed 0,\"FWD\";",
            f"        IF bFCActive THEN",
            f"            FCPressEnd Offs(CurrentPos,0,0,100),v50,\\\\DeactOnly,tHeli\\\\WObj:=Bed1Wyong;",
            f"        ENDIF",
        ]


# =============================================================================
# Tool Registry - Single source of truth for all tools
# =============================================================================

TOOLS = {
    'helicopter': Helicopter(),
    'vib_screed': VibratingScreened(),
    'plotter': Plotter(),
    'vacuum': Vacuum(),
    'polisher': Polisher(),
    'pan': Pan(),
}

# Also index by tool number for backward compatibility
TOOLS_BY_NUM = {
    2: TOOLS['helicopter'],
    3: TOOLS['vib_screed'],
    4: TOOLS['plotter'],
    5: TOOLS['vacuum'],
    6: TOOLS['polisher'],
}


def get_tool(name_or_num) -> Tool:
    """Get tool instance by name (str) or number (int)."""
    if isinstance(name_or_num, int):
        return TOOLS_BY_NUM.get(name_or_num)
    return TOOLS.get(name_or_num)


def generate_all_tool_procs() -> str:
    """Generate all pickup/dropoff procedures for all tools."""
    lines = []
    for tool in TOOLS.values():
        lines.append(tool.generate_pickup_proc())
        lines.append("")
        lines.append(tool.generate_dropoff_proc())
        lines.append("")
        if power_procs := tool.generate_power_procs():
            lines.append(power_procs)
            lines.append("")
    return "\n".join(lines)


# =============================================================================
# Convenience function for generator.py integration
# =============================================================================

def generate_tool_procedure(tool_num: int, params: Dict[str, Any]) -> str:
    """
    Generate complete RAPID procedure for a tool.
    
    This is the main entry point for generator.py to use.
    Replaces individual generate_py2heli(), generate_py2polish(), etc. functions.
    
    Args:
        tool_num: Tool number (2=Heli, 3=VS, 4=Plotter, 5=Vac, 6=Polish)
        params: Frontend parameters dict
        
    Returns:
        Complete RAPID PROC as string
    """
    tool = get_tool(tool_num)
    if tool:
        return tool.generate_procedure(params)
    return ""


# =============================================================================
# Example usage
# =============================================================================

if __name__ == "__main__":
    # Demo: generate complete procedure for polisher
    print("=" * 60)
    print("TOOL CLASS DEMO")
    print("=" * 60)
    
    # Sample params (mimics frontend/DB values)
    sample_params = {
        'panel_datum_x': 500,
        'panel_datum_y': 500,
        'panel_x': 3000,
        'panel_y': 2000,
        'panel_z': 150,
        'bed_datum_x': 0,
        'bed_datum_y': 0,
        'bed_length_x': 6000,
        'bed_width_y': 3000,
        'z_offset': 0,
        'track_start': 0,
        'track_end': 6000,
        # Polisher params
        'polish_workzone': 'panel',
        'polish_step': 200,
        'polish_z_offset': 0,
        'polish_speed': 100,
        'polisher_start_force': 100,
        'polisher_motion_force': 80,
        'polisher_force_change': 100,
        'polisher_pos_supv_dist': 125,
        'polisher_approach_speed': 50,
        'polisher_retract_speed': 100,
    }
    
    polisher = Polisher()
    print("\nGENERATED Py2Polish PROCEDURE (first 50 lines):")
    print("-" * 60)
    proc = polisher.generate_procedure(sample_params)
    for i, line in enumerate(proc.split('\n')[:50]):
        print(line)
    print("...")
    print(f"\nTotal lines: {len(proc.split(chr(10)))}")
