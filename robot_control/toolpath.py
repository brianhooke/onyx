"""
Toolpath API endpoints for parameter management.
"""
import json
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods

from .models import ToolPathParameters


@require_http_methods(["GET"])
def api_toolpath_params(request):
    """Get current toolpath parameters from database."""
    params = ToolPathParameters.get_instance()
    return JsonResponse({
        'success': True,
        'params': params.to_dict(),
        'updated_at': params.updated_at.isoformat() if params.updated_at else None
    })


@csrf_exempt
@require_http_methods(["POST"])
def api_toolpath_save_params(request):
    """Save toolpath parameters to database."""
    try:
        data = json.loads(request.body)
        params = ToolPathParameters.get_instance()
        
        # Update fields if provided
        field_names = [
            'bed_length_x', 'bed_width_y', 'bed_datum_x', 'bed_datum_y',
            'panel_datum_x', 'panel_datum_y', 'panel_x', 'panel_y', 'panel_z',
            'vacuum_z_offset', 'vacuum_speed', 'vacuum_pattern', 'vacuum_workzone',
            'vacuum_force', 'vacuum_force_enabled', 'vacuum_axis_5',
            'vacuum_spiral_direction', 'vacuum_formwork_offset',
            'vacuum_diameter', 'vacuum_overhang', 'vacuum_direction', 'vacuum_start_bottom',
            'polisher_step', 'vacuum_step', 'pan_step', 'helicopter_step',
            'polisher_pattern', 'polisher_speed', 'polisher_spiral_direction', 'polisher_formwork_offset',
            'polisher_diameter', 'polisher_overhang', 'polisher_direction', 'polisher_start_bottom',
            'pan_travel_speed', 'pan_blade_speed', 'pan_z_offset', 'pan_pattern',
            'pan_spiral_direction', 'pan_formwork_offset',
            'pan_diameter', 'pan_overhang', 'pan_direction', 'pan_start_bottom',
            'heli_travel_speed', 'heli_blade_speed', 'heli_blade_angle', 'heli_blade_direction',
            'heli_force', 'heli_z_offset', 'heli_workzone', 'heli_pattern',
            'heli_spiral_direction', 'heli_formwork_offset',
            'heli_diameter', 'heli_overhang', 'heli_direction', 'heli_start_bottom',
            'polisher_z_offset', 'polisher_workzone', 'polisher_start_force', 'polisher_motion_force', 'polisher_force_change',
            'polisher_approach_speed', 'polisher_retract_speed', 'polisher_pos_supv_dist',
            'screed_z_offset', 'vib_screed_speed', 'screed_angle_offset', 'screed_edge_offset',
            'z_offset', 'hard_y_offset',
            'serpentine_offset_x', 'serpentine_offset_y', 'serpentine_direction', 'serpentine_start_bottom',
            'trowel_z_offset', 'trowel_speed', 'trowel_force',
            'trowel_pass_1_angle', 'trowel_pass_1_rotation', 'trowel_pass_2_angle', 'trowel_pass_2_rotation',
            'trowel_step', 'trowel_diameter', 'trowel_overhang', 'trowel_spiral_direction', 'trowel_formwork_offset',
            'trowel_direction', 'trowel_start_bottom',
        ]
        
        string_fields = [
            'vacuum_pattern', 'vacuum_workzone', 'vacuum_spiral_direction',
            'polisher_workzone', 'polisher_pattern', 'polisher_spiral_direction',
            'pan_pattern', 'pan_spiral_direction',
            'heli_workzone', 'heli_pattern', 'heli_spiral_direction', 'heli_blade_direction',
            'trowel_spiral_direction',
        ]
        bool_fields = ['serpentine_start_bottom', 'vacuum_force_enabled', 'vacuum_start_bottom', 'polisher_start_bottom', 'pan_start_bottom', 'heli_start_bottom', 'trowel_start_bottom']
        
        for field in field_names:
            if field in data:
                if field in string_fields:
                    setattr(params, field, str(data[field]))
                elif field in bool_fields:
                    setattr(params, field, bool(data[field]))
                else:
                    setattr(params, field, int(data[field]))
        
        params.save()
        
        return JsonResponse({
            'success': True,
            'params': params.to_dict(),
            'updated_at': params.updated_at.isoformat()
        })
        
    except json.JSONDecodeError:
        return JsonResponse({'success': False, 'error': 'Invalid JSON'}, status=400)
    except Exception as e:
        return JsonResponse({'success': False, 'error': str(e)}, status=500)
