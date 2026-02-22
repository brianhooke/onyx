"""
IRC5 Robot Web Services Client

Handles communication with ABB IRC5 controller via Robot Web Services (RWS) API.
Uses a singleton session to avoid exhausting IRC5's connection limit (70 max).
"""

import requests
from requests.auth import HTTPDigestAuth
from django.conf import settings
import xml.etree.ElementTree as ET
import threading


# Global singleton session to reuse connections
_session = None
_session_lock = threading.Lock()


def get_shared_session(host, username, password):
    """Get or create a shared session for IRC5 communication."""
    global _session
    with _session_lock:
        if _session is None:
            _session = requests.Session()
            _session.auth = HTTPDigestAuth(username, password)
            _session.headers.update({
                'Accept': 'application/xhtml+xml;v=2.0',
                'Content-Type': 'application/x-www-form-urlencoded'
            })
        return _session


class IRC5Client:
    """Client for communicating with ABB IRC5 controller via RWS."""
    
    def __init__(self, host=None, username=None, password=None):
        self.host = host or settings.IRC5_HOST
        self.username = username or settings.IRC5_USERNAME
        self.password = password or settings.IRC5_PASSWORD
        self.base_url = f"http://{self.host}"
        # Use shared session to avoid connection exhaustion
        self.session = get_shared_session(self.host, self.username, self.password)
    
    def _get(self, endpoint):
        """Make GET request to RWS endpoint."""
        url = f"{self.base_url}{endpoint}"
        response = self.session.get(url, timeout=10)
        response.raise_for_status()
        return response
    
    def _post(self, endpoint, data=None):
        """Make POST request to RWS endpoint."""
        url = f"{self.base_url}{endpoint}"
        response = self.session.post(url, data=data, timeout=10)
        response.raise_for_status()
        return response
    
    def _parse_xml_value(self, xml_text, class_name):
        """Extract value from RWS XML response by class name."""
        try:
            root = ET.fromstring(xml_text)
            # RWS uses XHTML namespace
            ns = {'html': 'http://www.w3.org/1999/xhtml'}
            element = root.find(f".//*[@class='{class_name}']", ns)
            if element is None:
                # Try without namespace
                for elem in root.iter():
                    if elem.get('class') == class_name:
                        return elem.text
            return element.text if element is not None else None
        except ET.ParseError:
            return None
    
    # =========================================================================
    # Connection & System Info
    # =========================================================================
    
    def test_connection(self):
        """Test connection to IRC5 controller."""
        try:
            # Use short timeout for connection test to avoid blocking UI
            url = f"{self.base_url}/rw/system"
            response = self.session.get(url, timeout=2)
            return {
                'connected': True,
                'status_code': response.status_code,
                'robotware_version': self._parse_xml_value(response.text, 'rwversion')
            }
        except requests.exceptions.RequestException as e:
            return {
                'connected': False,
                'error': str(e)
            }
    
    def get_system_info(self):
        """Get system information from IRC5."""
        response = self._get("/rw/system")
        return {
            'robotware_version': self._parse_xml_value(response.text, 'rwversion'),
            'controller_name': self._parse_xml_value(response.text, 'name'),
            'start_time': self._parse_xml_value(response.text, 'starttm')
        }
    
    # =========================================================================
    # Controller State
    # =========================================================================
    
    def get_controller_state(self):
        """Get current controller state (init, motoron, motoroff, guardstop, emergencystop, sysfail)."""
        response = self._get("/rw/panel/ctrlstate")
        return self._parse_xml_value(response.text, 'ctrlstate')
    
    def get_operation_mode(self):
        """Get operation mode (init, manualreduced, manualfullspeed, auto, undefined)."""
        response = self._get("/rw/panel/opmode")
        return self._parse_xml_value(response.text, 'opmode')
    
    # =========================================================================
    # RAPID Execution
    # =========================================================================
    
    def get_execution_state(self):
        """Get RAPID execution state (running, stopped)."""
        response = self._get("/rw/rapid/execution")
        return self._parse_xml_value(response.text, 'ctrlexecstate')
    
    def _request_mastership(self):
        """Request RAPID mastership."""
        try:
            self._post("/rw/mastership/rapid?action=request")
        except:
            pass  # May already have mastership
    
    def _release_mastership(self):
        """Release RAPID mastership."""
        try:
            self._post("/rw/mastership/rapid?action=release")
        except:
            pass
    
    def start_execution(self, cycle='once', mode='continue', task='T_ROB1'):
        """
        Start RAPID program execution.
        
        Args:
            cycle: 'forever', 'asis', 'once'
            mode: 'continue', 'stepin', 'stepover', 'stepout', 'steplast', 'stepmotion'
            task: Task name (default T_ROB1)
        """
        # Request mastership first
        self._request_mastership()
        
        # Start execution
        data = {
            'regain': 'continue',
            'execmode': mode,
            'cycle': cycle,
            'condition': 'none',
            'stopatbp': 'disabled',
            'alltaskbytsp': 'false'
        }
        response = self._post("/rw/rapid/execution?action=start", data=data)
        
        # Release mastership
        self._release_mastership()
        
        return response.status_code == 204
    
    def stop_execution(self):
        """Stop RAPID program execution."""
        self._request_mastership()
        response = self._post("/rw/rapid/execution?action=stop")
        self._release_mastership()
        return response.status_code == 204
    
    def reset_program_pointer(self, task='T_ROB1'):
        """Reset program pointer to main entry point."""
        self._request_mastership()
        response = self._post(f"/rw/rapid/tasks/{task}?action=resetpp")
        self._release_mastership()
        return response.status_code == 204
    
    # =========================================================================
    # RAPID Tasks & Programs
    # =========================================================================
    
    def get_tasks(self):
        """Get list of RAPID tasks."""
        response = self._get("/rw/rapid/tasks")
        tasks = []
        try:
            root = ET.fromstring(response.text)
            for elem in root.iter():
                if elem.get('class') == 'rap-task-li':
                    task_name = None
                    for child in elem.iter():
                        if child.get('class') == 'name':
                            task_name = child.text
                            break
                    if task_name:
                        tasks.append(task_name)
        except ET.ParseError:
            pass
        return tasks
    
    def get_modules(self, task='T_ROB1'):
        """Get list of RAPID modules for a task."""
        response = self._get(f"/rw/rapid/tasks/{task}/modules")
        modules = []
        try:
            root = ET.fromstring(response.text)
            for elem in root.iter():
                if elem.get('class') == 'rap-module-info-li':
                    module_name = None
                    for child in elem.iter():
                        if child.get('class') == 'name':
                            module_name = child.text
                            break
                    if module_name:
                        modules.append(module_name)
        except ET.ParseError:
            pass
        return modules
    
    def set_program_pointer(self, task='T_ROB1', module='MainModule', routine='main'):
        """Set program pointer to specific routine."""
        self._post("/rw/rapid/execution?action=requestmastership")
        data = {
            'module': module,
            'routine': routine
        }
        response = self._post(f"/rw/rapid/tasks/{task}?action=setpp", data=data)
        self._post("/rw/rapid/execution?action=releasemastership")
        return response.status_code == 204
    
    # =========================================================================
    # I/O Signals
    # =========================================================================
    
    def get_signal(self, signal_name):
        """Get value of an I/O signal."""
        response = self._get(f"/rw/iosystem/signals/{signal_name}")
        return self._parse_xml_value(response.text, 'lvalue')
    
    def set_signal(self, signal_name, value):
        """Set value of an I/O signal."""
        data = {'lvalue': str(value)}
        response = self._post(f"/rw/iosystem/signals/{signal_name}?action=set", data=data)
        return response.status_code == 204
    
    # =========================================================================
    # Robot Position & Mechanical Units
    # =========================================================================
    
    def get_robot_position(self, mechunit='ROB_1'):
        """
        Get current robot TCP position.
        
        Args:
            mechunit: Mechanical unit name (default ROB_1)
        
        Returns:
            dict with x, y, z, q1, q2, q3, q4 (position and quaternion)
        """
        try:
            response = self._get(f"/rw/motionsystem/mechunits/{mechunit}/robtarget")
            return {
                'x': self._parse_xml_value(response.text, 'x'),
                'y': self._parse_xml_value(response.text, 'y'),
                'z': self._parse_xml_value(response.text, 'z'),
                'q1': self._parse_xml_value(response.text, 'q1'),
                'q2': self._parse_xml_value(response.text, 'q2'),
                'q3': self._parse_xml_value(response.text, 'q3'),
                'q4': self._parse_xml_value(response.text, 'q4'),
            }
        except:
            return None
    
    def get_joint_positions(self, mechunit='ROB_1'):
        """Get current joint angles in degrees."""
        try:
            response = self._get(f"/rw/motionsystem/mechunits/{mechunit}/jointtarget")
            return {
                'j1': self._parse_xml_value(response.text, 'rax_1'),
                'j2': self._parse_xml_value(response.text, 'rax_2'),
                'j3': self._parse_xml_value(response.text, 'rax_3'),
                'j4': self._parse_xml_value(response.text, 'rax_4'),
                'j5': self._parse_xml_value(response.text, 'rax_5'),
                'j6': self._parse_xml_value(response.text, 'rax_6'),
            }
        except:
            return None
    
    def get_track_position(self):
        """Get current track position in mm."""
        try:
            response = self._get("/rw/motionsystem/mechunits/TRACK_1/jointtarget")
            return self._parse_xml_value(response.text, 'rax_1')
        except:
            return None
    
    def get_speed_ratio(self):
        """Get current speed override percentage."""
        try:
            response = self._get("/rw/panel/speedratio")
            return self._parse_xml_value(response.text, 'speedratio')
        except:
            return None
    
    # =========================================================================
    # Program Pointer & Execution Info
    # =========================================================================
    
    def get_program_pointer(self, task='T_ROB1'):
        """Get current program pointer location."""
        try:
            response = self._get(f"/rw/rapid/tasks/{task}/pcp")
            return {
                'module': self._parse_xml_value(response.text, 'modulename'),
                'routine': self._parse_xml_value(response.text, 'routinename'),
                'line': self._parse_xml_value(response.text, 'range'),
            }
        except:
            return None
    
    # =========================================================================
    # Force/Torque Sensor (requires ForceMonitor.mod loaded)
    # =========================================================================
    
    def get_rapid_variable(self, module, variable, task='T_ROB1'):
        """Read a RAPID variable value."""
        try:
            response = self._get(f"/rw/rapid/symbol/data/RAPID/{task}/{module}/{variable}")
            return self._parse_xml_value(response.text, 'value')
        except:
            return None
    
    def get_force_torque(self):
        """
        Get force/torque sensor values from ForceMonitor module.
        Returns dict with fx, fy, fz (N) and tx, ty, tz (Nm), or None if not available.
        """
        try:
            fx = self.get_rapid_variable('ForceMonitor', 'fm_fx')
            fy = self.get_rapid_variable('ForceMonitor', 'fm_fy')
            fz = self.get_rapid_variable('ForceMonitor', 'fm_fz')
            tx = self.get_rapid_variable('ForceMonitor', 'fm_tx')
            ty = self.get_rapid_variable('ForceMonitor', 'fm_ty')
            tz = self.get_rapid_variable('ForceMonitor', 'fm_tz')
            status = self.get_rapid_variable('ForceMonitor', 'fm_status')
            
            if status and float(status) == 1:
                return {
                    'fx': float(fx) if fx else 0,
                    'fy': float(fy) if fy else 0,
                    'fz': float(fz) if fz else 0,
                    'tx': float(tx) if tx else 0,
                    'ty': float(ty) if ty else 0,
                    'tz': float(tz) if tz else 0,
                    'status': 'ok'
                }
            else:
                return {'status': 'not_running'}
        except Exception as e:
            return {'status': 'error', 'error': str(e)}
    
    # =========================================================================
    # Event Log / Alarms
    # =========================================================================
    
    def get_event_log(self, num_entries=5):
        """Get recent event log entries."""
        try:
            response = self._get(f"/rw/elog/0?lang=en&num={num_entries}")
            events = []
            root = ET.fromstring(response.text)
            for elem in root.iter():
                if elem.get('class') == 'elog-message-li':
                    event = {}
                    for child in elem.iter():
                        cls = child.get('class')
                        if cls == 'msgtype':
                            event['type'] = child.text
                        elif cls == 'tstamp':
                            event['timestamp'] = child.text
                        elif cls == 'title':
                            event['title'] = child.text
                    if event:
                        events.append(event)
            return events
        except:
            return []
    
    def get_event_log_detailed(self, count=50):
        """
        Get detailed event log with message type classification.
        Returns events categorized as info, warning, or error.
        Uses regex parsing since RWS returns XHTML with namespaces.
        """
        import re
        try:
            response = self._get(f"/rw/elog/0?lang=en")
            text = response.text
            
            events = []
            # Find all event list items
            li_pattern = r'<li class="elog-message-li"[^>]*>(.*?)</li>'
            matches = re.findall(li_pattern, text, re.DOTALL)
            
            for match in matches[:count]:
                event = {}
                
                # Extract span values using regex
                def get_span(cls):
                    pattern = rf'<span class="{cls}"[^>]*>([^<]*)</span>'
                    m = re.search(pattern, match)
                    return m.group(1) if m else None
                
                msg_type = get_span('msgtype')
                if msg_type:
                    event['type'] = 'info' if msg_type == '1' else 'warning' if msg_type == '2' else 'error'
                    event['msgtype'] = msg_type
                
                event['code'] = get_span('code')
                event['timestamp'] = get_span('tstamp')
                event['title'] = get_span('title')
                event['description'] = get_span('desc')
                event['source'] = get_span('src-name')
                event['consequences'] = get_span('conseqs')
                event['causes'] = get_span('causes')
                event['actions'] = get_span('actions')
                
                if event.get('title'):
                    events.append(event)
            
            return events
        except Exception as e:
            return []
    
    # =========================================================================
    # System Diagnostics & I/O Monitoring
    # =========================================================================
    
    # Define diagnostic signal groups with expected signal names
    # Note: Actual signal names may vary by controller configuration
    # Tool Changer signals for diagnostics
    TOOL_CHANGER_SIGNALS = {
        'DO13_Release': 'Local_IO_0_DO13',      # Release solenoid command
        'DO14_Grip': 'Local_IO_0_DO14',         # Grip solenoid command  
        'DI13_Released': 'Local_IO_0_DI13',     # Released feedback sensor
        'DI14_Gripped': 'Local_IO_0_DI14',      # Gripped feedback sensor
        'DI2_HeliHome': 'Local_IO_0_DI2',       # Heli stepper home sensor
    }
    
    DIAGNOSTIC_SIGNALS = {
        'safety': {
            'label': 'Safety System',
            'critical': True,
            'signals': [
                {'name': 'LocalEmergencyStopStatus', 'label': 'E-Stop Status', 'type': 'DI', 'invert': False},
                {'name': 'SafetyEnable', 'label': 'Safety Enable', 'type': 'DI', 'invert': False},
                {'name': 'DriveEnable', 'label': 'Drive Enable', 'type': 'DI', 'invert': False},
            ]
        },
        'drives': {
            'label': 'Drives & Motors',
            'critical': True,
            'signals': [
                {'name': 'DRV1BRAKEOK', 'label': 'Brake OK', 'type': 'DI', 'invert': False},
                {'name': 'DRV1LIM1', 'label': 'Limit 1', 'type': 'DI', 'invert': False},
                {'name': 'DRV1LIM2', 'label': 'Limit 2', 'type': 'DI', 'invert': False},
                {'name': 'DRV1EXTCONT', 'label': 'External Contactor', 'type': 'DI', 'invert': False},
                {'name': 'DRV1PTCINT', 'label': 'PTC Temp Internal', 'type': 'DI', 'invert': True},
                {'name': 'DRV1PTCEXT', 'label': 'PTC Temp External', 'type': 'DI', 'invert': True},
            ]
        },
        'mode': {
            'label': 'Operation Mode',
            'critical': False,
            'signals': [
                {'name': 'AutomaticMode', 'label': 'Auto Mode', 'type': 'DI', 'info_only': True},
                {'name': 'ManualMode', 'label': 'Manual Mode', 'type': 'DI', 'info_only': True},
                {'name': 'ManualFullSpeedMode', 'label': 'Full Speed', 'type': 'DI', 'info_only': True},
                {'name': 'DriveEnableFeedback', 'label': 'Motors On', 'type': 'DI', 'info_only': True},
                {'name': 'DRV1BRAKEFB', 'label': 'Brakes Released', 'type': 'DI', 'info_only': True},
            ]
        },
        'status': {
            'label': 'System Status',
            'critical': False,
            'signals': [
                {'name': 'MOTLMP', 'label': 'Motor Lamp', 'type': 'DO', 'info_only': True},
                {'name': 'STLEDGR', 'label': 'LED Green', 'type': 'DO', 'info_only': True},
                {'name': 'STLEDRED', 'label': 'LED Red', 'type': 'DO', 'invert': True},
                {'name': 'ExternalPowerControlFeedback', 'label': 'Ext Power FB', 'type': 'DI', 'info_only': True},
            ]
        },
        'safety_ctrl': {
            'label': 'Safety Controller',
            'critical': True,
            'signals': [
                {'name': 'SC1CBCERR', 'label': 'SC1 Error', 'type': 'DO', 'invert': True},
                {'name': 'SC1CBCWAR', 'label': 'SC1 Warning', 'type': 'DO', 'invert': True},
            ]
        },
        'tools': {
            'label': 'Tool Status',
            'critical': False,
            'signals': [
                {'name': 'Local_IO_0_DI14', 'label': 'Polisher Connected', 'type': 'DI', 'info_only': True},
                {'name': 'Local_IO_0_DO15', 'label': 'Polisher Motor', 'type': 'DO', 'info_only': True},
            ]
        },
    }
    
    def get_signals_list(self):
        """Get list of all available I/O signals from the controller."""
        try:
            response = self._get("/rw/iosystem/signals")
            signals = []
            root = ET.fromstring(response.text)
            for elem in root.iter():
                if elem.get('class') == 'ios-signal-li':
                    signal = {}
                    for child in elem.iter():
                        cls = child.get('class')
                        if cls == 'name':
                            signal['name'] = child.text
                        elif cls == 'type':
                            signal['type'] = child.text
                        elif cls == 'lvalue':
                            signal['value'] = child.text
                    if signal.get('name'):
                        signals.append(signal)
            return signals
        except Exception as e:
            return []
    
    def get_diagnostic_signals(self):
        """
        Get all diagnostic I/O signals organized by category.
        Returns dict with categories, each containing signals with their current values.
        """
        result = {}
        
        for category_key, category_info in self.DIAGNOSTIC_SIGNALS.items():
            category_result = {
                'label': category_info['label'],
                'critical': category_info.get('critical', False),
                'signals': []
            }
            
            for signal_def in category_info['signals']:
                info_only = signal_def.get('info_only', False)
                invert = signal_def.get('invert', False)
                
                signal_data = {
                    'name': signal_def['name'],
                    'label': signal_def['label'],
                    'type': signal_def['type'],
                    'info_only': info_only,
                    'value': None,
                    'status': 'unknown',
                    'available': False
                }
                
                try:
                    raw_value = self.get_signal(signal_def['name'])
                    if raw_value is not None:
                        signal_data['available'] = True
                        signal_data['value'] = int(float(raw_value))
                        
                        # Info-only signals just show on/off, no fault status
                        if info_only:
                            signal_data['status'] = 'on' if signal_data['value'] == 1 else 'off'
                        # Inverted signals: 1=bad, 0=good (e.g., error/warning flags)
                        elif invert:
                            signal_data['status'] = 'fault' if signal_data['value'] == 1 else 'ok'
                        # Normal signals: 1=good, 0=bad
                        else:
                            signal_data['status'] = 'ok' if signal_data['value'] == 1 else 'fault'
                except:
                    pass
                
                category_result['signals'].append(signal_data)
            
            result[category_key] = category_result
        
        return result
    
    # =========================================================================
    # File Operations (RAPID Module Upload)
    # =========================================================================
    
    def get_file_list(self, path='$HOME'):
        """Get list of files in a directory on the controller."""
        try:
            response = self._get(f"/fileservice/{path}")
            files = []
            root = ET.fromstring(response.text)
            for elem in root.iter():
                if elem.get('class') == 'fs-file':
                    file_info = {}
                    for child in elem.iter():
                        cls = child.get('class')
                        if cls == 'fs-filename':
                            file_info['name'] = child.text
                        elif cls == 'fs-filesize':
                            file_info['size'] = child.text
                    if file_info.get('name'):
                        files.append(file_info)
            return files
        except Exception as e:
            return []
    
    def upload_file(self, local_path, remote_path):
        """
        Upload a file to the IRC5 controller.
        
        Args:
            local_path: Path to local file
            remote_path: Destination path on controller (e.g., '$HOME/RAPID/TASK1/PROGMOD/ToolPaths.mod')
        
        Returns:
            dict with 'success' and optional 'error'
        """
        try:
            with open(local_path, 'rb') as f:
                file_content = f.read()
            
            url = f"{self.base_url}/fileservice/{remote_path}"
            
            # Use PUT to upload/overwrite file
            response = self.session.put(
                url,
                data=file_content,
                headers={'Content-Type': 'application/octet-stream'},
                timeout=30
            )
            
            if response.status_code in [200, 201, 204]:
                return {'success': True}
            else:
                return {'success': False, 'error': f'HTTP {response.status_code}: {response.text}'}
        except Exception as e:
            return {'success': False, 'error': str(e)}
    
    def request_mastership(self, domain='rapid'):
        """
        Request mastership for a domain (rapid, cfg, motion).
        Required before making changes to the controller.
        """
        try:
            response = self.session.post(
                f"{self.base_url}/rw/mastership/{domain}?action=request",
                headers={'Content-Type': 'application/x-www-form-urlencoded'},
                timeout=10
            )
            return response.status_code in [200, 204]
        except:
            return False
    
    def release_mastership(self, domain='rapid'):
        """Release mastership for a domain."""
        try:
            response = self.session.post(
                f"{self.base_url}/rw/mastership/{domain}?action=release",
                headers={'Content-Type': 'application/x-www-form-urlencoded'},
                timeout=10
            )
            return response.status_code in [200, 204]
        except:
            return False
    
    def reload_program(self, task='T_ROB1'):
        """
        Reload the currently loaded program to pick up file changes.
        Requires mastership.
        """
        try:
            program_name = self.get_loaded_program_name(task)
            if not program_name:
                return {'success': False, 'error': 'Could not get program name'}
            
            # Request mastership
            if not self.request_mastership('rapid'):
                return {'success': False, 'error': 'Could not get mastership - is FlexPendant in control?'}
            
            try:
                # Load program with replace mode
                prog_path = f'$HOME/{program_name}/{program_name}.pgf'
                response = self.session.post(
                    f"{self.base_url}/rw/rapid/tasks/{task}/program?action=loadprog",
                    data={'progpath': prog_path, 'loadmode': 'replace'},
                    headers={'Content-Type': 'application/x-www-form-urlencoded'},
                    timeout=30
                )
                
                if response.status_code in [200, 204]:
                    return {'success': True, 'program': program_name}
                else:
                    return {'success': False, 'error': f'Load failed: {response.status_code}'}
            finally:
                self.release_mastership('rapid')
                
        except Exception as e:
            self.release_mastership('rapid')
            return {'success': False, 'error': str(e)}
    
    def get_loaded_program_name(self, task='T_ROB1'):
        """Get the name of the currently loaded RAPID program."""
        try:
            response = self._get(f"/rw/rapid/tasks/{task}/program")
            root = ET.fromstring(response.text)
            for elem in root.iter():
                if elem.get('class') == 'rap-program':
                    name = elem.find(".//*[@class='name']")
                    if name is not None and name.text:
                        return name.text
            # Fallback: parse from title attribute
            for elem in root.iter('li'):
                if elem.get('class') == 'rap-program':
                    return elem.get('title')
            return None
        except Exception as e:
            return None
    
    def upload_rapid_module(self, local_path, module_name, task='T_ROB1', program_name=None):
        """
        Upload a RAPID module to the controller's program directory.
        
        Args:
            local_path: Path to local .mod file
            module_name: Name of the module (e.g., 'ToolPaths.mod')
            task: Task name (default T_ROB1)
            program_name: Program folder name (auto-detected if None)
        
        Returns:
            dict with 'success' and optional 'error'
        """
        if program_name is None:
            program_name = self.get_loaded_program_name(task)
            if program_name is None:
                return {'success': False, 'error': 'Could not detect loaded program name'}
        
        remote_path = f'$HOME/{program_name}/{module_name}'
        return self.upload_file(local_path, remote_path)
    
    def download_file(self, remote_path, local_path):
        """
        Download a file from the IRC5 controller.
        
        Args:
            remote_path: Path on controller (e.g., '$HOME/RAPID/TASK1/PROGMOD/ToolPaths.mod')
            local_path: Local destination path
        
        Returns:
            dict with 'success' and optional 'error'
        """
        try:
            url = f"{self.base_url}/fileservice/{remote_path}"
            response = self.session.get(url, timeout=30)
            
            if response.status_code == 200:
                # Ensure directory exists
                import os
                os.makedirs(os.path.dirname(local_path), exist_ok=True)
                
                with open(local_path, 'wb') as f:
                    f.write(response.content)
                return {'success': True}
            elif response.status_code == 404:
                return {'success': False, 'error': 'File not found'}
            else:
                return {'success': False, 'error': f'HTTP {response.status_code}'}
        except Exception as e:
            return {'success': False, 'error': str(e)}
    
    def backup_rapid_module(self, module_name, backup_dir, task='T_ROB1', program_name=None):
        """
        Backup a RAPID module from the controller to a local directory.
        
        Args:
            module_name: Name of the module (e.g., 'ToolPaths.mod')
            backup_dir: Local directory to save backup
            task: Task name (default T_ROB1)
            program_name: Program folder name (auto-detected if None)
        
        Returns:
            dict with 'success', 'path' and optional 'error'
        """
        if program_name is None:
            program_name = self.get_loaded_program_name(task)
            if program_name is None:
                return {'success': False, 'error': 'Could not detect loaded program name'}
        
        remote_path = f'$HOME/{program_name}/{module_name}'
        local_path = f'{backup_dir}/{module_name}'
        
        result = self.download_file(remote_path, local_path)
        if result['success']:
            result['path'] = local_path
        return result
    
    def upload_rapid_modules(self, module_paths, task='T_ROB1'):
        """
        Upload multiple RAPID modules to the controller.
        
        Args:
            module_paths: List of (local_path, module_name) tuples
            task: Task name (default T_ROB1)
        
        Returns:
            dict with 'success', 'uploaded', 'failed' lists, 'program_name'
        """
        uploaded = []
        failed = []
        
        # Get program name once for all uploads
        program_name = self.get_loaded_program_name(task)
        if program_name is None:
            return {
                'success': False,
                'uploaded': [],
                'failed': [{'name': 'all', 'error': 'Could not detect loaded program name'}],
                'program_name': None
            }
        
        for local_path, module_name in module_paths:
            result = self.upload_rapid_module(local_path, module_name, task, program_name)
            if result['success']:
                uploaded.append(module_name)
            else:
                failed.append({'name': module_name, 'error': result.get('error', 'Unknown error')})
        
        return {
            'success': len(failed) == 0,
            'uploaded': uploaded,
            'failed': failed,
            'program_name': program_name
        }
    
    def get_tool_changer_status(self):
        """Get current tool changer I/O status for diagnostics."""
        status = {
            'signals': {},
            'tool_state': 'unknown'
        }
        
        for label, signal_name in self.TOOL_CHANGER_SIGNALS.items():
            try:
                value = self.get_signal(signal_name)
                status['signals'][label] = {
                    'signal': signal_name,
                    'value': value,
                    'active': value == '1' or value == 1
                }
            except:
                status['signals'][label] = {
                    'signal': signal_name,
                    'value': None,
                    'active': None
                }
        
        # Determine tool state from signals
        di13 = status['signals'].get('DI13_Released', {}).get('active')
        di14 = status['signals'].get('DI14_Gripped', {}).get('active')
        do13 = status['signals'].get('DO13_Release', {}).get('active')
        do14 = status['signals'].get('DO14_Grip', {}).get('active')
        
        if di14 and not di13:
            status['tool_state'] = 'gripped'
        elif di13 and not di14:
            status['tool_state'] = 'released'
        elif do13 and not di13:
            status['tool_state'] = 'releasing'  # Command sent but not confirmed
        elif do14 and not di14:
            status['tool_state'] = 'gripping'   # Command sent but not confirmed
        elif not di13 and not di14:
            status['tool_state'] = 'error'      # Neither sensor active
        
        return status
    
    def get_rapid_variable(self, module, name, task='T_ROB1'):
        """Get a RAPID variable value."""
        try:
            response = self._get(f"/rw/rapid/symbol/data/RAPID/{task}/{module}/{name}")
            root = ET.fromstring(response.text)
            for elem in root.iter():
                if elem.get('class') == 'rap-data':
                    value_elem = elem.find(".//*[@class='value']")
                    if value_elem is not None:
                        return value_elem.text
            return None
        except:
            return None
    
    def get_system_health_summary(self):
        """Get a quick health summary based on critical signals."""
        diagnostics = self.get_diagnostic_signals()
        
        issues = []
        warnings = []
        available_count = 0
        total_count = 0
        
        for category_key, category_data in diagnostics.items():
            is_critical = category_data.get('critical', False)
            
            for signal in category_data['signals']:
                total_count += 1
                if signal['available']:
                    available_count += 1
                    # Only count actual faults, not info_only signals
                    if signal['status'] == 'fault':
                        if is_critical:
                            issues.append(f"{signal['label']}")
                        else:
                            warnings.append(f"{signal['label']}")
        
        if issues:
            health = 'critical'
        elif warnings:
            health = 'warning'
        elif available_count > 0:
            health = 'ok'
        else:
            health = 'unknown'
        
        return {
            'health': health,
            'issues': issues,
            'warnings': warnings,
            'signals_available': available_count,
            'signals_total': total_count,
            'diagnostics': diagnostics
        }
