from django.shortcuts import render
from django.http import JsonResponse
from django.views.decorators.http import require_http_methods
import json

from .irc5_client import IRC5Client


def dashboard(request):
    """Main robot control dashboard."""
    return render(request, 'robot_control/dashboard.html')


@require_http_methods(["GET"])
def api_status(request):
    """Get current robot status."""
    client = IRC5Client()
    
    try:
        connection = client.test_connection()
        if not connection['connected']:
            return JsonResponse({
                'connected': False,
                'error': connection.get('error', 'Connection failed')
            })
        
        return JsonResponse({
            'connected': True,
            'robotware_version': connection.get('robotware_version'),
            'controller_state': client.get_controller_state(),
            'operation_mode': client.get_operation_mode(),
            'execution_state': client.get_execution_state(),
        })
    except Exception as e:
        return JsonResponse({
            'connected': False,
            'error': str(e)
        }, status=500)


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


@require_http_methods(["POST"])
def api_start(request):
    """Start RAPID execution."""
    client = IRC5Client()
    
    try:
        # Check if in AUTO mode
        op_mode = client.get_operation_mode()
        if op_mode != 'AUTO':
            return JsonResponse({
                'success': False,
                'error': f'Controller must be in AUTO mode (currently: {op_mode})'
            }, status=400)
        
        success = client.start_execution()
        return JsonResponse({'success': success})
    except Exception as e:
        return JsonResponse({'success': False, 'error': str(e)}, status=500)


@require_http_methods(["POST"])
def api_stop(request):
    """Stop RAPID execution."""
    client = IRC5Client()
    
    try:
        success = client.stop_execution()
        return JsonResponse({'success': success})
    except Exception as e:
        return JsonResponse({'success': False, 'error': str(e)}, status=500)


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
