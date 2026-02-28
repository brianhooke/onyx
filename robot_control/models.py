from django.db import models


class ToolPathParameters(models.Model):
    """Stores toolpath generation parameters. Only one row should exist (singleton)."""
    
    # Bed dimensions
    bed_length_x = models.IntegerField(default=12000, help_text="Bed length X (mm)")
    bed_width_y = models.IntegerField(default=3200, help_text="Bed width Y (mm)")
    
    # Datum offsets
    bed_datum_x = models.IntegerField(default=1100, help_text="Bed datum offset X (mm)")
    bed_datum_y = models.IntegerField(default=600, help_text="Bed datum offset Y (mm)")
    
    # Panel parameters (only apply to panel workzone)
    panel_datum_x = models.IntegerField(default=1100, help_text="Panel datum offset X (mm)")
    panel_datum_y = models.IntegerField(default=600, help_text="Panel datum offset Y (mm)")
    panel_x = models.IntegerField(default=5900, help_text="Panel length X (mm)")
    panel_y = models.IntegerField(default=2200, help_text="Panel width Y (mm)")
    panel_z = models.IntegerField(default=150, help_text="Panel height Z (mm)")
    
    # Vacuum parameters
    vacuum_z_offset = models.IntegerField(default=0, help_text="Vacuum Z offset (mm)")
    vacuum_speed = models.IntegerField(default=100, help_text="Vacuum speed (mm/s)")
    vacuum_pattern = models.CharField(default='cross-hatch', max_length=50, help_text="Vacuum pattern")
    vacuum_workzone = models.CharField(default='panel', max_length=20, help_text="Vacuum workzone: panel or bed")
    vacuum_force = models.IntegerField(default=50, help_text="Vacuum target force (N, 10-150)")
    vacuum_force_enabled = models.BooleanField(default=False, help_text="Enable force control for vacuum")
    vacuum_spiral_direction = models.CharField(default='anticlockwise', max_length=20, help_text="Vacuum spiral direction: clockwise or anticlockwise")
    vacuum_formwork_offset = models.IntegerField(default=100, help_text="Vacuum spiral formwork offset from edges (mm)")
    vacuum_axis_5 = models.IntegerField(default=0, help_text="Vacuum axis 5 tilt angle (degrees)")
    
    # Cross-hatch pattern steps (per tool)
    polisher_step = models.IntegerField(default=450, help_text="Polisher step (mm)")
    vacuum_step = models.IntegerField(default=450, help_text="Vacuum step (mm)")
    pan_step = models.IntegerField(default=600, help_text="Pan step (mm)")
    helicopter_step = models.IntegerField(default=600, help_text="Helicopter step (mm)")
    
    # Pan parameters
    pan_travel_speed = models.IntegerField(default=100, help_text="Pan travel speed (mm/s)")
    pan_blade_speed = models.IntegerField(default=70, help_text="Pan blade speed (RPM, 40-140)")
    pan_z_offset = models.IntegerField(default=250, help_text="Pan Z offset (mm, -200 to 200)")
    pan_pattern = models.CharField(default='cross-hatch', max_length=50, help_text="Pan pattern")
    pan_spiral_direction = models.CharField(default='anticlockwise', max_length=20, help_text="Pan spiral direction: clockwise or anticlockwise")
    pan_formwork_offset = models.IntegerField(default=100, help_text="Pan spiral formwork offset from edges (mm)")
    pan_force = models.IntegerField(default=0, help_text="Pan force (N, 0=off, 100-500)")
    pan_force_change = models.IntegerField(default=100, help_text="Pan force change rate (N)")
    pan_pos_supv_dist = models.IntegerField(default=125, help_text="Pan position supervision distance (mm)")
    
    # Helicopter parameters
    heli_travel_speed = models.IntegerField(default=40, help_text="Helicopter travel speed (mm/s)")
    heli_blade_speed = models.IntegerField(default=70, help_text="Helicopter blade speed (RPM)")
    heli_blade_direction = models.CharField(default='FWD', max_length=10, help_text="Helicopter blade direction: FWD or REV")
    heli_blade_angle = models.IntegerField(default=0, help_text="Helicopter blade angle (degrees, 0-12)")
    heli_force = models.IntegerField(default=200, help_text="Helicopter force (N, 100-500)")
    heli_z_offset = models.IntegerField(default=0, help_text="Helicopter Z offset (mm, -50 to 400)")
    heli_workzone = models.CharField(default='panel', max_length=20, help_text="Helicopter workzone: panel or bed")
    heli_pattern = models.CharField(default='cross-hatch', max_length=50, help_text="Helicopter pattern")
    heli_spiral_direction = models.CharField(default='anticlockwise', max_length=20, help_text="Rectangular spiral direction: clockwise or anticlockwise")
    heli_formwork_offset = models.IntegerField(default=100, help_text="Rectangular spiral formwork offset from edges (mm)")
    
    # Polisher force/speed parameters
    polisher_z_offset = models.IntegerField(default=0, help_text="Polisher Z offset (mm)")
    polisher_workzone = models.CharField(default='bed', max_length=20, help_text="Polisher workzone: panel or bed")
    polisher_start_force = models.IntegerField(default=300, help_text="Polisher start force (N)")
    polisher_motion_force = models.IntegerField(default=300, help_text="Polisher motion force (N)")
    polisher_force_change = models.IntegerField(default=100, help_text="Polisher force change (N)")
    polisher_approach_speed = models.IntegerField(default=20, help_text="Polisher approach speed (mm/s)")
    polisher_retract_speed = models.IntegerField(default=50, help_text="Polisher retract speed (mm/s)")
    polisher_pos_supv_dist = models.IntegerField(default=100, help_text="Polisher position supervision distance (mm)")
    polisher_pattern = models.CharField(default='cross-hatch', max_length=50, help_text="Polisher pattern")
    polisher_speed = models.IntegerField(default=100, help_text="Polisher travel speed (mm/s)")
    polisher_spiral_direction = models.CharField(default='anticlockwise', max_length=20, help_text="Polisher spiral direction: clockwise or anticlockwise")
    polisher_formwork_offset = models.IntegerField(default=100, help_text="Polisher spiral formwork offset from edges (mm)")
    # Vib Screed parameters
    screed_z_offset = models.IntegerField(default=0, help_text="Screed Z offset (mm)")
    vib_screed_speed = models.IntegerField(default=100, help_text="Vibrating screed speed (mm/s)")
    screed_angle_offset = models.IntegerField(default=0, help_text="Screed angle offset (degrees)")
    screed_edge_offset = models.IntegerField(default=200, help_text="Screed edge offset (mm) - positive extends beyond panel edges")
    z_offset = models.IntegerField(default=0, help_text="Z offset (mm) - applies to all workzones")
    hard_y_offset = models.IntegerField(default=0, help_text="Hard Y offset (mm) - absolute minimum Y bound for all tools")
    
    # Cross-hatch pattern parameters (legacy/global - deprecated, use per-tool params below)
    serpentine_offset_x = models.IntegerField(default=100, help_text="Serpentine X offset from edges (mm)")
    serpentine_offset_y = models.IntegerField(default=100, help_text="Serpentine Y offset from edges (mm)")
    serpentine_direction = models.IntegerField(default=1, help_text="Initial sweep direction: 1=left-to-right, -1=right-to-left")
    serpentine_start_bottom = models.BooleanField(default=False, help_text="Start at bottom (True) or top (False)")
    
    # Per-tool cross-hatch parameters (diameter + overhang determine edge offset)
    # Edge offset = diameter/2 - overhang (tool center position to achieve overhang)
    # Vacuum
    vacuum_diameter = models.IntegerField(default=500, help_text="Vacuum tool diameter (mm)")
    vacuum_overhang = models.IntegerField(default=50, help_text="Vacuum edge overhang (mm)")
    vacuum_direction = models.IntegerField(default=1, help_text="Vacuum sweep direction: 1=L→R, -1=R→L")
    vacuum_start_bottom = models.BooleanField(default=True, help_text="Vacuum start at bottom")
    
    # Polisher
    polisher_diameter = models.IntegerField(default=450, help_text="Polisher tool diameter (mm)")
    polisher_overhang = models.IntegerField(default=50, help_text="Polisher edge overhang (mm)")
    polisher_direction = models.IntegerField(default=1, help_text="Polisher sweep direction: 1=L→R, -1=R→L")
    polisher_start_bottom = models.BooleanField(default=True, help_text="Polisher start at bottom")
    
    # Helicopter
    heli_diameter = models.IntegerField(default=1150, help_text="Helicopter tool diameter (mm)")
    heli_overhang = models.IntegerField(default=50, help_text="Helicopter edge overhang (mm)")
    heli_direction = models.IntegerField(default=1, help_text="Helicopter sweep direction: 1=L→R, -1=R→L")
    heli_start_bottom = models.BooleanField(default=True, help_text="Helicopter start at bottom")
    
    # Pan
    pan_diameter = models.IntegerField(default=600, help_text="Pan tool diameter (mm)")
    pan_overhang = models.IntegerField(default=50, help_text="Pan edge overhang (mm)")
    pan_direction = models.IntegerField(default=1, help_text="Pan sweep direction: 1=L→R, -1=R→L")
    pan_start_bottom = models.BooleanField(default=True, help_text="Pan start at bottom")
    
    # Trowel parameters
    trowel_z_offset = models.IntegerField(default=0, help_text="Trowel Z offset (mm)")
    trowel_speed = models.IntegerField(default=100, help_text="Trowel travel speed (mm/s)")
    trowel_force = models.IntegerField(default=0, help_text="Trowel force (N, 0=off)")
    trowel_pass_1_angle = models.IntegerField(default=0, help_text="Trowel pass 1 angle (degrees)")
    trowel_pass_1_rotation = models.IntegerField(default=0, help_text="Trowel pass 1 rotation (degrees)")
    trowel_pass_2_angle = models.IntegerField(default=0, help_text="Trowel pass 2 angle (degrees)")
    trowel_pass_2_rotation = models.IntegerField(default=0, help_text="Trowel pass 2 rotation (degrees)")
    trowel_step = models.IntegerField(default=300, help_text="Trowel step (mm)")
    trowel_diameter = models.IntegerField(default=450, help_text="Trowel tool diameter (mm)")
    trowel_overhang = models.IntegerField(default=50, help_text="Trowel edge overhang (mm)")
    trowel_spiral_direction = models.CharField(default='anticlockwise', max_length=20, help_text="Trowel spiral direction")
    trowel_formwork_offset = models.IntegerField(default=100, help_text="Trowel spiral formwork offset (mm)")
    trowel_direction = models.IntegerField(default=1, help_text="Trowel sweep direction: 1=L→R, -1=R→L")
    trowel_start_bottom = models.BooleanField(default=True, help_text="Trowel start at bottom")
    
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        verbose_name = "Toolpath Parameters"
        verbose_name_plural = "Toolpath Parameters"
    
    @classmethod
    def get_instance(cls):
        """Get or create the singleton instance."""
        instance, created = cls.objects.get_or_create(pk=1)
        return instance
    
    def to_dict(self):
        """Return parameters as dictionary."""
        return {
            'bed_length_x': self.bed_length_x,
            'bed_width_y': self.bed_width_y,
            'bed_datum_x': self.bed_datum_x,
            'bed_datum_y': self.bed_datum_y,
            'panel_datum_x': self.panel_datum_x,
            'panel_datum_y': self.panel_datum_y,
            'panel_x': self.panel_x,
            'panel_y': self.panel_y,
            'panel_z': self.panel_z,
            'vacuum_z_offset': self.vacuum_z_offset,
            'vacuum_speed': self.vacuum_speed,
            'vacuum_pattern': self.vacuum_pattern,
            'vacuum_workzone': self.vacuum_workzone,
            'vacuum_force': self.vacuum_force,
            'vacuum_force_enabled': self.vacuum_force_enabled,
            'polisher_step': self.polisher_step,
            'vacuum_step': self.vacuum_step,
            'pan_step': self.pan_step,
            'helicopter_step': self.helicopter_step,
            'pan_travel_speed': self.pan_travel_speed,
            'pan_blade_speed': self.pan_blade_speed,
            'pan_z_offset': self.pan_z_offset,
            'pan_pattern': self.pan_pattern,
            'pan_force': self.pan_force,
            'pan_force_change': self.pan_force_change,
            'pan_pos_supv_dist': self.pan_pos_supv_dist,
            'heli_travel_speed': self.heli_travel_speed,
            'heli_blade_speed': self.heli_blade_speed,
            'heli_blade_direction': self.heli_blade_direction,
            'heli_blade_angle': self.heli_blade_angle,
            'heli_force': self.heli_force,
            'heli_z_offset': self.heli_z_offset,
            'heli_workzone': self.heli_workzone,
            'heli_pattern': self.heli_pattern,
            'heli_spiral_direction': self.heli_spiral_direction,
            'heli_formwork_offset': self.heli_formwork_offset,
            'polisher_z_offset': self.polisher_z_offset,
            'polisher_workzone': self.polisher_workzone,
            'polisher_start_force': self.polisher_start_force,
            'polisher_motion_force': self.polisher_motion_force,
            'polisher_force_change': self.polisher_force_change,
            'polisher_approach_speed': self.polisher_approach_speed,
            'polisher_retract_speed': self.polisher_retract_speed,
            'polisher_pos_supv_dist': self.polisher_pos_supv_dist,
            'polisher_pattern': self.polisher_pattern,
            'polisher_speed': self.polisher_speed,
            'screed_z_offset': self.screed_z_offset,
            'vib_screed_speed': self.vib_screed_speed,
            'screed_angle_offset': self.screed_angle_offset,
            'screed_edge_offset': self.screed_edge_offset,
            'z_offset': self.z_offset,
            'hard_y_offset': self.hard_y_offset,
            'serpentine_offset_x': self.serpentine_offset_x,
            'serpentine_offset_y': self.serpentine_offset_y,
            'serpentine_direction': self.serpentine_direction,
            'serpentine_start_bottom': self.serpentine_start_bottom,
            # Per-tool cross-hatch parameters (diameter + overhang)
            'vacuum_diameter': self.vacuum_diameter,
            'vacuum_overhang': self.vacuum_overhang,
            'vacuum_direction': self.vacuum_direction,
            'vacuum_start_bottom': self.vacuum_start_bottom,
            'polisher_diameter': self.polisher_diameter,
            'polisher_overhang': self.polisher_overhang,
            'polisher_direction': self.polisher_direction,
            'polisher_start_bottom': self.polisher_start_bottom,
            'heli_diameter': self.heli_diameter,
            'heli_overhang': self.heli_overhang,
            'heli_direction': self.heli_direction,
            'heli_start_bottom': self.heli_start_bottom,
            'pan_diameter': self.pan_diameter,
            'pan_overhang': self.pan_overhang,
            'pan_direction': self.pan_direction,
            'pan_start_bottom': self.pan_start_bottom,
            # Per-tool spiral parameters
            'vacuum_spiral_direction': self.vacuum_spiral_direction,
            'vacuum_formwork_offset': self.vacuum_formwork_offset,
            'vacuum_axis_5': self.vacuum_axis_5,
            'polisher_spiral_direction': self.polisher_spiral_direction,
            'polisher_formwork_offset': self.polisher_formwork_offset,
            'pan_spiral_direction': self.pan_spiral_direction,
            'pan_formwork_offset': self.pan_formwork_offset,
            # Trowel parameters
            'trowel_z_offset': self.trowel_z_offset,
            'trowel_speed': self.trowel_speed,
            'trowel_force': self.trowel_force,
            'trowel_pass_1_angle': self.trowel_pass_1_angle,
            'trowel_pass_1_rotation': self.trowel_pass_1_rotation,
            'trowel_pass_2_angle': self.trowel_pass_2_angle,
            'trowel_pass_2_rotation': self.trowel_pass_2_rotation,
            'trowel_step': self.trowel_step,
            'trowel_diameter': self.trowel_diameter,
            'trowel_overhang': self.trowel_overhang,
            'trowel_spiral_direction': self.trowel_spiral_direction,
            'trowel_formwork_offset': self.trowel_formwork_offset,
            'trowel_direction': self.trowel_direction,
            'trowel_start_bottom': self.trowel_start_bottom,
        }
