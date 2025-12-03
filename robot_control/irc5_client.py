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
            response = self._get("/rw/system")
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
