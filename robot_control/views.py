from django.shortcuts import render
from django.http import JsonResponse
from django.views.decorators.http import require_http_methods
from django.views.decorators.csrf import csrf_exempt
import json
import os
from datetime import datetime
from pathlib import Path

from .irc5_client import IRC5Client
from .generator import ToolpathGenerator
from .models import ToolPathParameters

# Backup directory for RAPID modules
BACKUP_DIR = Path(__file__).parent.parent / 'backups'


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
def api_events_detailed(request):
    """Get detailed event log with error classification and descriptions."""
    client = IRC5Client()
    
    try:
        count = int(request.GET.get('count', 20))
        events = client.get_event_log_detailed(count)
        
        # Filter to just errors if requested
        errors_only = request.GET.get('errors', 'false') == 'true'
        if errors_only:
            events = [e for e in events if e.get('type') == 'error']
        
        return JsonResponse({
            'events': events,
            'count': len(events),
            'timestamp': datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        })
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)


@require_http_methods(["GET"])
def api_events_latest(request):
    """Get the latest event message - useful for real-time monitoring."""
    client = IRC5Client()
    
    try:
        events = client.get_event_log_detailed(5)
        latest = events[0] if events else None
        
        # Also get any errors/warnings in the last few
        alerts = [e for e in events if e.get('type') in ('error', 'warning')]
        
        return JsonResponse({
            'latest': latest,
            'alerts': alerts[:3],
            'timestamp': datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
            'refresh_hint': 'Poll every 2-3 seconds for real-time updates'
        })
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


@require_http_methods(["GET"])
def api_diagnostics(request):
    """Get system diagnostics and I/O signal status."""
    client = IRC5Client()
    
    try:
        # Check if full diagnostics or just health summary
        summary_only = request.GET.get('summary', 'false') == 'true'
        
        if summary_only:
            return JsonResponse(client.get_system_health_summary())
        else:
            return JsonResponse(client.get_system_health_summary())
    except Exception as e:
        return JsonResponse({
            'health': 'error',
            'error': str(e),
            'diagnostics': {}
        }, status=500)


@require_http_methods(["GET"])
def api_signals_list(request):
    """Get list of all available I/O signals from the controller."""
    client = IRC5Client()
    
    try:
        signals = client.get_signals_list()
        return JsonResponse({'signals': signals})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)


# =============================================================================
# Toolpath Generator
# =============================================================================

def toolpath_generator(request):
    """Toolpath generator page with parameter form."""
    # Load saved parameters from database, fall back to code defaults
    params, _ = ToolPathParameters.objects.get_or_create(pk=1)
    defaults = params.to_dict()
    return render(request, 'robot_control/toolpath_generator.html', {'defaults': defaults})


@csrf_exempt
@require_http_methods(["POST"])
def api_generate_toolpath(request):
    """
    Generate RAPID modules with provided parameters and upload to IRC5.
    
    POST body (JSON):
        panel_x, panel_y, panel_z: Panel dimensions (mm)
        polisher_step, pan_step, helicopter_step: Process steps (mm)
        vib_screed_speed: Vibrating screed speed (mm/s)
        z_offset: Z offset (mm)
        datum_offset_x, datum_offset_y: Datum offsets (mm)
        upload_to_irc5: Boolean - whether to upload to controller
    """
    try:
        data = json.loads(request.body)
        
        # Extract parameters (use defaults for missing)
        params = {}
        for key in ToolpathGenerator.DEFAULT_PARAMS.keys():
            if key in data and data[key] is not None:
                if key in ('vacuum_pattern', 'vacuum_workzone', 'polisher_workzone', 'heli_workzone', 'heli_pattern', 'pan_pattern'):
                    params[key] = str(data[key])
                elif key == 'serpentine_start_bottom':
                    params[key] = bool(int(data[key])) if data[key] != '' else False
                else:
                    params[key] = int(data[key])
        
        upload_to_irc5 = data.get('upload_to_irc5', True)
        
        # Generate modules
        generator = ToolpathGenerator(params)
        result = generator.generate()
        
        response_data = {
            'success': True,
            'generated_files': result['files'],
            'params': result['params'],
            'timestamp': result['timestamp'],
        }
        
        # Upload to IRC5 if requested
        if upload_to_irc5:
            client = IRC5Client()
            
            # Check connection first
            conn_test = client.test_connection()
            if not conn_test['connected']:
                response_data['upload_success'] = False
                response_data['upload_error'] = 'IRC5 not connected'
                return JsonResponse(response_data)
            
            # Get loaded program name
            program_name = client.get_loaded_program_name()
            if not program_name:
                response_data['upload_success'] = False
                response_data['upload_error'] = 'Could not detect loaded program name on IRC5'
                return JsonResponse(response_data)
            
            response_data['program_name'] = program_name
            
            # Create backup of existing files before upload
            backup_timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            backup_subdir = BACKUP_DIR / f"{program_name}_{backup_timestamp}"
            backup_subdir.mkdir(parents=True, exist_ok=True)
            
            backed_up = []
            for filename in result['files']:
                backup_result = client.backup_rapid_module(filename, str(backup_subdir), program_name=program_name)
                if backup_result['success']:
                    backed_up.append(filename)
            
            response_data['backup_dir'] = str(backup_subdir)
            response_data['backed_up_files'] = backed_up
            
            # Compare generated files with backed up files - only upload changed files
            output_dir = Path(result['output_dir'])
            changed_files = []
            unchanged_files = []
            
            for filename in result['files']:
                generated_path = output_dir / filename
                backup_path = backup_subdir / filename
                
                if not generated_path.exists():
                    continue
                
                # Check if file changed
                file_changed = True
                if backup_path.exists():
                    with open(generated_path, 'r', encoding='utf-8', errors='ignore') as f:
                        generated_content = f.read()
                    with open(backup_path, 'r', encoding='utf-8', errors='ignore') as f:
                        backup_content = f.read()
                    file_changed = generated_content != backup_content
                
                if file_changed:
                    changed_files.append((str(generated_path), filename))
                else:
                    unchanged_files.append(filename)
            
            response_data['changed_files'] = [f[1] for f in changed_files]
            response_data['unchanged_files'] = unchanged_files
            response_data['upload_timestamp'] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            
            # Only upload changed files
            if changed_files:
                upload_result = client.upload_rapid_modules(changed_files)
                response_data['upload_success'] = upload_result['success']
                response_data['uploaded_files'] = upload_result['uploaded']
                if upload_result['failed']:
                    response_data['upload_failed'] = upload_result['failed']
            else:
                response_data['upload_success'] = True
                response_data['uploaded_files'] = []
                response_data['no_changes'] = True
        
        return JsonResponse(response_data)
        
    except json.JSONDecodeError:
        return JsonResponse({'success': False, 'error': 'Invalid JSON'}, status=400)
    except Exception as e:
        return JsonResponse({'success': False, 'error': str(e)}, status=500)


@csrf_exempt
@require_http_methods(["POST"])
def api_upload_original_progmod(request):
    """
    Upload the original RAPID modules from RAPID/RAPID/TASK1/PROGMOD to IRC5.
    These are Andrew's original program files.
    """
    try:
        client = IRC5Client()
        
        # Check connection first
        conn_test = client.test_connection()
        if not conn_test['connected']:
            return JsonResponse({
                'success': False,
                'error': 'IRC5 not connected'
            })
        
        # Get loaded program name
        program_name = client.get_loaded_program_name()
        if not program_name:
            return JsonResponse({
                'success': False,
                'error': 'Could not detect loaded program name on IRC5'
            })
        
        # Original PROGMOD directory
        original_progmod = Path(__file__).parent.parent / 'RAPID' / 'RAPID' / 'TASK1' / 'PROGMOD'
        
        if not original_progmod.exists():
            return JsonResponse({
                'success': False,
                'error': f'Original PROGMOD directory not found: {original_progmod}'
            })
        
        # Get all .mod files
        mod_files = list(original_progmod.glob('*.mod'))
        if not mod_files:
            return JsonResponse({
                'success': False,
                'error': 'No .mod files found in original PROGMOD directory'
            })
        
        # Create backup of existing files before upload
        backup_timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_subdir = BACKUP_DIR / f"{program_name}_original_{backup_timestamp}"
        backup_subdir.mkdir(parents=True, exist_ok=True)
        
        backed_up = []
        for mod_file in mod_files:
            backup_result = client.backup_rapid_module(mod_file.name, str(backup_subdir), program_name=program_name)
            if backup_result['success']:
                backed_up.append(mod_file.name)
        
        # Upload all .mod files
        module_paths = [(str(f), f.name) for f in mod_files]
        upload_result = client.upload_rapid_modules(module_paths)
        
        return JsonResponse({
            'success': upload_result['success'],
            'program_name': program_name,
            'uploaded_files': upload_result['uploaded'],
            'failed_files': upload_result.get('failed', []),
            'backed_up_files': backed_up,
            'backup_dir': str(backup_subdir),
            'source_dir': str(original_progmod),
            'upload_timestamp': datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        })
        
    except Exception as e:
        return JsonResponse({'success': False, 'error': str(e)}, status=500)


@require_http_methods(["GET"])
def api_toolpath_defaults(request):
    """Get default toolpath parameters."""
    return JsonResponse(ToolpathGenerator.DEFAULT_PARAMS)


@require_http_methods(["GET"])
def api_activity_log(request):
    """Get detailed activity log with categorized events."""
    client = IRC5Client()
    
    try:
        count = int(request.GET.get('count', 50))
        events = client.get_event_log_detailed(count)
        
        # Separate into activity (info) and alerts (warning/error)
        activity = [e for e in events if e.get('type') == 'info']
        alerts = [e for e in events if e.get('type') in ('warning', 'error')]
        
        return JsonResponse({
            'activity': activity,
            'alerts': alerts,
            'total': len(events)
        })
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)


@require_http_methods(["GET"])
def api_tool_changer(request):
    """Get tool changer status and ToolNum variable."""
    client = IRC5Client()
    
    try:
        status = client.get_tool_changer_status()
        
        # Also get ToolNum RAPID variable
        tool_num = client.get_rapid_variable('Tools', 'ToolNum')
        status['tool_num'] = tool_num
        
        # Map tool numbers to names
        tool_names = {
            '1': 'TCMaster (empty)',
            '2': 'Helicopter',
            '3': 'Vibrating Screed',
            '4': 'Plotter',
            '5': 'Vacuum',
            '6': 'Polisher'
        }
        status['tool_name'] = tool_names.get(str(tool_num), f'Unknown ({tool_num})')
        
        return JsonResponse(status)
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)


@csrf_exempt
@require_http_methods(["POST"])
def api_reload_program(request):
    """Reload the RAPID program on the controller to pick up file changes."""
    client = IRC5Client()
    
    try:
        conn_test = client.test_connection()
        if not conn_test['connected']:
            return JsonResponse({'success': False, 'error': 'IRC5 not connected'})
        
        result = client.reload_program()
        return JsonResponse(result)
    except Exception as e:
        return JsonResponse({'success': False, 'error': str(e)}, status=500)
