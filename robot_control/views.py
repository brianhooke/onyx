from django.shortcuts import render
from django.http import JsonResponse
from django.views.decorators.http import require_http_methods
from django.views.decorators.csrf import csrf_exempt
import json

from .irc5_client import IRC5Client


def dashboard(request):
    """Main robot control dashboard."""
    return render(request, 'robot_control/dashboard.html')


@require_http_methods(["GET"])
def api_status(request):
    """Get current robot status including position and program info."""
    client = IRC5Client()
    
    try:
        connection = client.test_connection()
        if not connection['connected']:
            return JsonResponse({
                'connected': False,
                'error': connection.get('error', 'Connection failed')
            })
        
        # Get extended status if requested
        extended = request.GET.get('extended', 'false') == 'true'
        
        response_data = {
            'connected': True,
            'robotware_version': connection.get('robotware_version'),
            'controller_state': client.get_controller_state(),
            'operation_mode': client.get_operation_mode(),
            'execution_state': client.get_execution_state(),
            'speed_ratio': client.get_speed_ratio(),
        }
        
        if extended:
            response_data['tcp_position'] = client.get_robot_position()
            response_data['joint_positions'] = client.get_joint_positions()
            response_data['program_pointer'] = client.get_program_pointer()
        
        return JsonResponse(response_data)
    except Exception as e:
        return JsonResponse({
            'connected': False,
            'error': str(e)
        }, status=500)


@require_http_methods(["GET"])
def api_position(request):
    """Get current robot position (TCP, joints, and track)."""
    client = IRC5Client()
    
    try:
        return JsonResponse({
            'tcp': client.get_robot_position(),
            'joints': client.get_joint_positions(),
            'track': client.get_track_position(),
        })
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)


@require_http_methods(["GET"])
def api_events(request):
    """Get recent event log entries."""
    client = IRC5Client()
    
    try:
        num = int(request.GET.get('num', 5))
        events = client.get_event_log(num)
        return JsonResponse({'events': events})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)


@require_http_methods(["GET"])
def api_force_torque(request):
    """Get force/torque sensor values (requires ForceMonitor.mod on controller)."""
    client = IRC5Client()
    
    try:
        data = client.get_force_torque()
        return JsonResponse(data)
    except Exception as e:
        return JsonResponse({'status': 'error', 'error': str(e)}, status=500)


@require_http_methods(["GET"])
def api_tasks(request):
    """Get list of RAPID tasks."""
    client = IRC5Client()
    
    try:
        tasks = client.get_tasks()
        return JsonResponse({'tasks': tasks})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)


@require_http_methods(["GET"])
def api_modules(request, task):
    """Get list of modules for a task."""
    client = IRC5Client()
    
    try:
        modules = client.get_modules(task)
        return JsonResponse({'modules': modules})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)


@csrf_exempt
@require_http_methods(["POST"])
def api_start(request):
    """Start RAPID execution. Works in AUTO or MANUAL mode (with deadman held)."""
    client = IRC5Client()
    
    try:
        success = client.start_execution()
        return JsonResponse({'success': success})
    except Exception as e:
        return JsonResponse({'success': False, 'error': str(e)}, status=500)


@csrf_exempt
@require_http_methods(["POST"])
def api_stop(request):
    """Stop RAPID execution."""
    client = IRC5Client()
    
    try:
        success = client.stop_execution()
        return JsonResponse({'success': success})
    except Exception as e:
        return JsonResponse({'success': False, 'error': str(e)}, status=500)


@csrf_exempt
@require_http_methods(["POST"])
def api_reset_pp(request):
    """Reset program pointer."""
    client = IRC5Client()
    
    try:
        data = json.loads(request.body) if request.body else {}
        task = data.get('task', 'T_ROB1')
        success = client.reset_program_pointer(task)
        return JsonResponse({'success': success})
    except Exception as e:
        return JsonResponse({'success': False, 'error': str(e)}, status=500)


@csrf_exempt
@require_http_methods(["POST"])
def api_set_pp(request):
    """Set program pointer to specific routine."""
    client = IRC5Client()
    
    try:
        data = json.loads(request.body)
        task = data.get('task', 'T_ROB1')
        module = data.get('module', 'MainModule')
        routine = data.get('routine', 'main')
        
        success = client.set_program_pointer(task, module, routine)
        return JsonResponse({'success': success})
    except Exception as e:
        return JsonResponse({'success': False, 'error': str(e)}, status=500)
