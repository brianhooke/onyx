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
            'vacuum_force', 'vacuum_z_range', 'vacuum_force_enabled',
            'polisher_step', 'vacuum_step', 'pan_step', 'helicopter_step',
            'pan_travel_speed', 'pan_blade_speed', 'pan_z_offset', 'pan_pattern',
            'heli_travel_speed', 'heli_blade_speed', 'heli_blade_angle', 'heli_force', 'heli_z_offset', 'heli_workzone', 'heli_pattern',
            'polisher_z_offset', 'polisher_workzone', 'polisher_start_force', 'polisher_motion_force', 'polisher_force_change',
            'polisher_approach_speed', 'polisher_retract_speed', 'polisher_pos_supv_dist',
            'screed_z_offset', 'vib_screed_speed', 'screed_angle_offset', 'z_offset',
            'serpentine_offset_x', 'serpentine_offset_y', 'serpentine_direction', 'serpentine_start_bottom'
        ]
        
        string_fields = ['vacuum_pattern', 'vacuum_workzone', 'polisher_workzone', 'heli_workzone', 'heli_pattern', 'pan_pattern']
        bool_fields = ['serpentine_start_bottom', 'vacuum_force_enabled']
        
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
