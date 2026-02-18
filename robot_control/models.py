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
    vacuum_z_range = models.IntegerField(default=30, help_text="Vacuum Z range around offset (+/- mm)")
    vacuum_force_enabled = models.BooleanField(default=False, help_text="Enable force control for vacuum")
    
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
    pan_force = models.IntegerField(default=0, help_text="Pan force (N, 0=off, 100-500)")
    pan_force_change = models.IntegerField(default=100, help_text="Pan force change rate (N)")
    pan_pos_supv_dist = models.IntegerField(default=125, help_text="Pan position supervision distance (mm)")
    
    # Helicopter parameters
    heli_travel_speed = models.IntegerField(default=40, help_text="Helicopter travel speed (mm/s)")
    heli_blade_speed = models.IntegerField(default=70, help_text="Helicopter blade speed (RPM)")
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
    polisher_first_direction = models.CharField(default='x', max_length=10, help_text="Polisher first pass direction: x or y")
    polisher_pattern = models.CharField(default='cross-hatch', max_length=50, help_text="Polisher pattern")
    polisher_speed = models.IntegerField(default=100, help_text="Polisher travel speed (mm/s)")
    # Vib Screed parameters
    screed_z_offset = models.IntegerField(default=0, help_text="Screed Z offset (mm)")
    vib_screed_speed = models.IntegerField(default=100, help_text="Vibrating screed speed (mm/s)")
    screed_angle_offset = models.IntegerField(default=0, help_text="Screed angle offset (degrees)")
    z_offset = models.IntegerField(default=0, help_text="Z offset (mm) - applies to all workzones")
    
    # Cross-hatch pattern parameters
    serpentine_offset_x = models.IntegerField(default=100, help_text="Serpentine X offset from edges (mm)")
    serpentine_offset_y = models.IntegerField(default=100, help_text="Serpentine Y offset from edges (mm)")
    serpentine_direction = models.IntegerField(default=1, help_text="Initial sweep direction: 1=left-to-right, -1=right-to-left")
    serpentine_start_bottom = models.BooleanField(default=False, help_text="Start at bottom (True) or top (False)")
    
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
            'vacuum_z_range': self.vacuum_z_range,
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
            'polisher_first_direction': self.polisher_first_direction,
            'polisher_pattern': self.polisher_pattern,
            'polisher_speed': self.polisher_speed,
            'screed_z_offset': self.screed_z_offset,
            'vib_screed_speed': self.vib_screed_speed,
            'screed_angle_offset': self.screed_angle_offset,
            'z_offset': self.z_offset,
            'serpentine_offset_x': self.serpentine_offset_x,
            'serpentine_offset_y': self.serpentine_offset_y,
            'serpentine_direction': self.serpentine_direction,
            'serpentine_start_bottom': self.serpentine_start_bottom,
        }
