"""
IRC5 Robot Web Services Client

Handles communication with ABB IRC5 controller via Robot Web Services (RWS) API.
"""

import requests
from requests.auth import HTTPDigestAuth
from django.conf import settings
import xml.etree.ElementTree as ET


class IRC5Client:
    """Client for communicating with ABB IRC5 controller via RWS."""
    
    def __init__(self, host=None, username=None, password=None):
        self.host = host or settings.IRC5_HOST
        self.username = username or settings.IRC5_USERNAME
        self.password = password or settings.IRC5_PASSWORD
        self.base_url = f"http://{self.host}"
        self.session = requests.Session()
        self.session.auth = HTTPDigestAuth(self.username, self.password)
        self.session.headers.update({
            'Accept': 'application/xhtml+xml;v=2.0',
            'Content-Type': 'application/x-www-form-urlencoded'
        })
    
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
    
    def start_execution(self, cycle='forever', mode='continue', task='T_ROB1'):
        """
        Start RAPID program execution.
        
        Args:
            cycle: 'forever', 'asis', 'once'
            mode: 'continue', 'stepin', 'stepover', 'stepout', 'steplast', 'stepmotion'
            task: Task name (default T_ROB1)
        """
        # Request mastership first
        self._post(f"/rw/rapid/execution?action=requestmastership")
        
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
        self._post(f"/rw/rapid/execution?action=releasemastership")
        
        return response.status_code == 204
    
    def stop_execution(self):
        """Stop RAPID program execution."""
        self._post("/rw/rapid/execution?action=requestmastership")
        response = self._post("/rw/rapid/execution?action=stop")
        self._post("/rw/rapid/execution?action=releasemastership")
        return response.status_code == 204
    
    def reset_program_pointer(self, task='T_ROB1'):
        """Reset program pointer to main entry point."""
        self._post("/rw/rapid/execution?action=requestmastership")
        response = self._post(f"/rw/rapid/tasks/{task}?action=resetpp")
        self._post("/rw/rapid/execution?action=releasemastership")
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
