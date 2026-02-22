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
BACKUP_DIR = Path(__file__).parent / 'data' / 'backups'
MAX_BACKUPS = 5  # Keep only the last N backup folders


def cleanup_old_backups():
    """Remove old backup folders, keeping only the most recent MAX_BACKUPS."""
    if not BACKUP_DIR.exists():
        return
    
    # Get all backup subdirectories sorted by modification time (newest first)
    backup_dirs = sorted(
        [d for d in BACKUP_DIR.iterdir() if d.is_dir()],
        key=lambda d: d.stat().st_mtime,
        reverse=True
    )
    
    # Delete old backups beyond MAX_BACKUPS
    import shutil
    for old_dir in backup_dirs[MAX_BACKUPS:]:
        shutil.rmtree(old_dir, ignore_errors=True)


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
def api_live_log(request):
    """Get a lightweight live snapshot for the Toolpath Generator live log panel."""
    client = IRC5Client()

    # Fast-fail if not connected (avoid multiple 10s timeouts)
    conn = client.test_connection()
    if not conn['connected']:
        return JsonResponse({'lines': [], 'current_tool': 'disconnected'})

    try:
        contains = request.GET.get('contains', 'LIVE:')

        # Current tool
        tool_num = client.get_rapid_variable('Tools', 'ToolNum')
        tool_names = {
            '1': 'TCMaster (empty)',
            '2': 'Helicopter',
            '3': 'Vibrating Screed',
            '4': 'Plotter',
            '5': 'Vacuum',
            '6': 'Polisher'
        }
        tool_name = tool_names.get(str(tool_num), f'Unknown ({tool_num})')

        # TCP snapshot (world)
        tcp = client.get_robot_position() or {}
        x = tcp.get('x')
        y = tcp.get('y')

        # Helicopter blade pitch (degrees) derived from stepper position
        stepper_pos = client.get_rapid_variable('Tools', 'StepperPos')
        steps_per_rev = client.get_rapid_variable('Tools', 'StepsPerRevolution')
        revs_to_angle = client.get_rapid_variable('Tools', 'RevstoAngle')

        pitch_deg = None
        try:
            if stepper_pos is not None and steps_per_rev is not None and revs_to_angle is not None:
                denom = float(steps_per_rev) * float(revs_to_angle)
                if denom != 0:
                    pitch_deg = float(stepper_pos) / denom
        except (TypeError, ValueError):
            pitch_deg = None

        ts = datetime.now().strftime("%H:%M:%S")
        lines = []

        # Filtered recent event log lines (e.g. TPWrite output)
        try:
            events = client.get_event_log_detailed(30)
            for e in events:
                title = e.get('title')
                if not title:
                    continue
                if contains and contains not in title:
                    continue
                # Prefer controller timestamp if present; otherwise fall back to local time
                evt_ts = e.get('timestamp') or ts
                lines.append(f"{evt_ts} {title}")
        except Exception:
            pass

        if x is not None and y is not None:
            lines.append(f"{ts} Heli XY: x={x}, y={y}")
        if pitch_deg is not None:
            lines.append(f"{ts} Heli Pitch: {pitch_deg:.2f}°")

        return JsonResponse({
            'current_tool': tool_name,
            'tool_num': tool_num,
            'x': x,
            'y': y,
            'blade_pitch_deg': pitch_deg,
            'lines': lines,
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
    return render(request, 'robot_control/toolpath_generator_compact.html', {'defaults': defaults})


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
        
        # Load all parameters from DB first (single source of truth)
        db_params = ToolPathParameters.get_instance().to_dict()
        
        # Overlay with any values from POST data
        params = dict(db_params)
        for key in ToolpathGenerator.REQUIRED_PARAMS:
            if key in data and data[key] is not None:
                if key in ('vacuum_pattern', 'vacuum_workzone', 'polisher_workzone', 'polisher_pattern', 'heli_workzone', 'heli_pattern', 'heli_spiral_direction', 'pan_pattern'):
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
            
            # Clean up old backups, keeping only the most recent ones
            cleanup_old_backups()
            
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
        original_progmod = Path(__file__).parent / 'generator' / 'templates_original'
        
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


@require_http_methods(["POST"])
@csrf_exempt
def api_pattern_points(request):
    """Get pattern points for a tool given current parameters."""
    from .generator.patterns import cross_hatch, rectangular_spiral, sweep_lift, single_pass
    
    try:
        data = json.loads(request.body)
        tool = data.get('tool', 'polisher')
        
        # Get workzone parameters
        panel_datum_x = data.get('panel_datum_x', 0)
        panel_datum_y = data.get('panel_datum_y', 0)
        panel_x = data.get('panel_x', 3000)
        panel_y = data.get('panel_y', 2000)
        bed_length_x = data.get('bed_length_x', 12000)
        bed_width_y = data.get('bed_width_y', 3300)
        
        # Tool-specific parameters
        # edge_offset = diameter/2 - overhang (tool center position to achieve overhang)
        tool_config = {
            'polisher': {
                'workzone': data.get('polisher_workzone', 'panel'),
                'step': data.get('polisher_step', 200),
                'pattern': data.get('polisher_pattern', 'cross-hatch'),
                'formwork_offset': data.get('polisher_formwork_offset', 50),
                'spiral_direction': data.get('polisher_spiral_direction', 'anticlockwise'),
                'diameter': data.get('polisher_diameter', 450),
                'overhang': data.get('polisher_overhang', 50),
            },
            'helicopter': {
                'workzone': data.get('heli_workzone', 'panel'),
                'step': data.get('helicopter_step', 150),
                'pattern': data.get('heli_pattern', 'cross-hatch'),
                'formwork_offset': data.get('heli_formwork_offset', 50),
                'spiral_direction': data.get('heli_spiral_direction', 'anticlockwise'),
                'diameter': data.get('heli_diameter', 1150),
                'overhang': data.get('heli_overhang', 50),
            },
            'pan': {
                'workzone': 'panel',
                'step': data.get('pan_step', 200),
                'pattern': data.get('pan_pattern', 'cross-hatch'),
                'formwork_offset': data.get('pan_formwork_offset', 50),
                'spiral_direction': data.get('pan_spiral_direction', 'anticlockwise'),
                'diameter': data.get('pan_diameter', 600),
                'overhang': data.get('pan_overhang', 50),
            },
            'vacuum': {
                'workzone': data.get('vacuum_workzone', 'panel'),
                'step': data.get('vacuum_step', 400),
                'pattern': data.get('vacuum_pattern', 'cross-hatch'),
                'tool_offset': data.get('vacuum_tool_offset', 500),
                'axis_6_initial': data.get('vacuum_axis_6_initial', 0),
                'axis_5': data.get('vacuum_axis_5', 0),  # Vacuum pipe tilt angle
                'formwork_offset': data.get('vacuum_formwork_offset', 50),
                'spiral_direction': data.get('vacuum_spiral_direction', 'anticlockwise'),
                'handle_length': 250,  # Vacuum handle length for corner offset
                'diameter': data.get('vacuum_diameter', 500),
                'overhang': data.get('vacuum_overhang', 50),
            },
            'screed': {
                'workzone': 'panel',
                'step': 0,
                'pattern': 'single-pass',
                'diameter': 0,
                'overhang': 0,
            },
        }
        
        config = tool_config.get(tool, tool_config['polisher'])
        
        # Calculate workzone bounds
        hard_y_offset = data.get('hard_y_offset', 0)
        if config['workzone'] == 'bed':
            min_x, max_x = 0, bed_length_x
            min_y, max_y = 0, bed_width_y
        else:
            min_x = panel_datum_x
            max_x = panel_datum_x + panel_x
            min_y = panel_datum_y
            # Apply hard_y_offset: use min of panel's Y or hard_y_offset (absolute ceiling)
            panel_max_y = panel_datum_y + panel_y
            max_y = min(panel_max_y, hard_y_offset) if hard_y_offset > 0 else panel_max_y
        
        step = config['step'] or 200
        pattern_type = config['pattern']
        
        # Calculate edge offset from diameter and overhang
        # edge_offset = diameter/2 - overhang (tool center position to achieve overhang)
        diameter = config.get('diameter', 0)
        overhang = config.get('overhang', 0)
        edge_offset = (diameter / 2) - overhang if diameter > 0 else 0
        
        # Apply edge offset to workzone bounds for cross-hatch patterns
        xhatch_min_x = min_x + edge_offset
        xhatch_max_x = max_x - edge_offset
        xhatch_min_y = min_y + edge_offset
        xhatch_max_y = max_y - edge_offset
        
        # Generate pattern points
        if pattern_type in ('rectangular-spiral', 'rectangular_spiral'):
            points = rectangular_spiral(
                min_x=min_x, max_x=max_x, min_y=min_y, max_y=max_y,
                step_size=step,
                formwork_offset=config.get('formwork_offset', 50),
                direction=config.get('spiral_direction', 'anticlockwise'),
                tool=tool,
                handle_length=config.get('handle_length', 0),
            )
        elif pattern_type == 'sweep-lift':
            points = sweep_lift(
                min_x=min_x, max_x=max_x, min_y=min_y, max_y=max_y,
                step_size=step,
                tool_offset=config.get('tool_offset', 500),
                axis_6_initial=config.get('axis_6_initial', 0),
            )
        elif pattern_type == 'single-pass':
            # Y center is max of panel center or bed center (safety - prevents hitting robot on narrow panels)
            panel_y_center = (min_y + max_y) / 2
            bed_y_center = bed_width_y / 2
            y_center = max(panel_y_center, bed_y_center)
            # Edge offset: positive extends beyond panel edges
            edge_offset = data.get('screed_edge_offset', 200)
            points = single_pass(
                start_x=min_x - edge_offset, end_x=max_x + edge_offset, y_position=y_center,
            )
        else:  # cross-hatch
            points = cross_hatch(
                min_x=xhatch_min_x, max_x=xhatch_max_x, min_y=xhatch_min_y, max_y=xhatch_max_y,
                step_size=step, first_direction='x',
                tool=tool,
                handle_length=250 if tool == 'vacuum' else 0,
            )
        
        # Convert to list of dicts (include axis_6 if present)
        result = [{'x': p.x, 'y': p.y, 'move_type': p.move_type, 'axis_6': p.axis_6} for p in points]
        
        return JsonResponse({'success': True, 'points': result, 'tool': tool})
    except Exception as e:
        return JsonResponse({'success': False, 'error': str(e)}, status=500)


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
