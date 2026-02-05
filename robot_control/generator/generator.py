"""
Main RAPID code generator.

Orchestrates the generation of RAPID modules by:
1. Copying static files from PROGMOD baseline
2. Generating tool procedures using pattern generators
3. Injecting procedures into ToolPaths.mod
4. Creating menu structure for Py2_{date}_{time}
"""

import shutil
import tempfile
from datetime import datetime
from pathlib import Path
from typing import Dict, List

from .tools.helicopter import generate_py2heli
from .tools.polisher import generate_py2polish
from .tools.vacuum import generate_py2vacuum


# Paths
SCRIPT_DIR = Path(__file__).parent
PROJECT_ROOT = SCRIPT_DIR.parent.parent
RAPID_ROOT = PROJECT_ROOT / "RAPID" / "RAPID"
SOURCE_PROGMOD = RAPID_ROOT / "TASK1" / "PROGMOD"

# Files to copy without modification
STATIC_FILES = [
    "Brian.mod",
    "ErrorHandling.mod",
    "MainModule.mod",
    "RobotTargets.mod",
    "Tools.mod",
    "Toolstations.mod",
    "WebController.mod",
    "FCtesting.mod",
]

# ToolPaths.mod is processed separately
TOOLPATHS_FILE = "ToolPaths.mod"


class ToolpathGenerator:
    """
    Main generator class called by views.py.
    
    Generates RAPID modules with user parameters and Py2 menu structure.
    """
    
    DEFAULT_PARAMS = {
        'bed_length_x': 12000,
        'bed_width_y': 3200,
        'bed_datum_x': 1100,
        'bed_datum_y': 600,
        'panel_datum_x': 1100,
        'panel_datum_y': 600,
        'panel_x': 5900,
        'panel_y': 2200,
        'panel_z': 150,
        'vacuum_z_offset': 0,
        'vacuum_speed': 100,
        'vacuum_pattern': 'cross-hatch',
        'vacuum_workzone': 'panel',
        'vacuum_force': 50,
        'vacuum_z_min': -20,
        'vacuum_z_max': 50,
        'vacuum_force_enabled': False,
        'polisher_step': 450,
        'vacuum_step': 450,
        'pan_step': 600,
        'helicopter_step': 600,
        'pan_travel_speed': 100,
        'pan_blade_speed': 70,
        'pan_z_offset': 250,
        'pan_pattern': 'cross-hatch',
        'heli_travel_speed': 40,
        'heli_blade_speed': 70,
        'heli_blade_angle': 0,
        'heli_force': 200,
        'heli_z_offset': 0,
        'heli_workzone': 'panel',
        'heli_pattern': 'cross-hatch',
        'polisher_z_offset': 0,
        'polisher_workzone': 'bed',
        'polisher_start_force': 300,
        'polisher_motion_force': 300,
        'polisher_force_change': 100,
        'polisher_approach_speed': 20,
        'polisher_retract_speed': 50,
        'polisher_pos_supv_dist': 100,
        'polisher_pattern': 'cross-hatch',
        'polisher_speed': 100,
        'screed_z_offset': 0,
        'vib_screed_speed': 100,
        'screed_angle_offset': 0,
        'z_offset': 0,
        'serpentine_offset_x': 100,
        'serpentine_offset_y': 100,
        'serpentine_direction': 1,
        'serpentine_start_bottom': False,
    }
    
    def __init__(self, params: dict = None):
        merged = dict(self.DEFAULT_PARAMS)
        if params:
            merged.update(params)
        self.params = merged
        self.timestamp = datetime.now().strftime("%d-%b_%H:%M").lower()
    
    def generate(self) -> Dict:
        """
        Generate RAPID modules.
        
        Returns:
            Dict with output_dir, files list, params, timestamp
        """
        output_dir = Path(tempfile.mkdtemp(prefix="onyx_rapid_"))
        generated_files: List[str] = []
        
        # 1. Copy static files
        for filename in STATIC_FILES:
            src = SOURCE_PROGMOD / filename
            dst = output_dir / filename
            if src.exists():
                shutil.copy2(src, dst)
                generated_files.append(filename)
        
        # 2. Process ToolPaths.mod
        toolpaths_src = SOURCE_PROGMOD / TOOLPATHS_FILE
        if toolpaths_src.exists():
            content = toolpaths_src.read_text(encoding='utf-8', errors='ignore')
            content = self._process_toolpaths(content)
            (output_dir / TOOLPATHS_FILE).write_text(content, encoding='utf-8')
            generated_files.append(TOOLPATHS_FILE)
        
        # 3. Update MainModule.mod to call MainMenu instead of PetePanels
        mainmod_path = output_dir / "MainModule.mod"
        if mainmod_path.exists():
            content = mainmod_path.read_text(encoding='utf-8', errors='ignore')
            content = content.replace('PetePanels', 'MainMenu')
            mainmod_path.write_text(content, encoding='utf-8')
        
        return {
            'output_dir': str(output_dir),
            'files': generated_files,
            'params': self.params,
            'timestamp': self.timestamp,
        }
    
    def _process_toolpaths(self, content: str) -> str:
        """
        Process ToolPaths.mod:
        1. Replace entire PetePanels proc with simplified version
        2. Inject Py2 procedures
        """
        import re
        
        # Generate tool procedures
        py2heli_proc = generate_py2heli(self.params)
        py2polish_proc = generate_py2polish(self.params)
        py2vacuum_proc = generate_py2vacuum(self.params)
        
        # Generate the main Py2 menu procedure
        py2main_proc = self._generate_py2main()
        
        # === REPLACE ENTIRE PetePanels with MainMenu ===
        # The baseline has complex nested TEST/CASE - replace the whole thing
        petepanels_pattern = r'PROC PetePanels\(\).*?ENDPROC'
        
        new_mainmenu = f'''PROC MainMenu()
        TPErase;
        TPReadNum iTask,"1:Home,2:Py2_{self.timestamp}";
        TEST iTask
        CASE 1:
            Home;
        CASE 2:
            Py2Main;
        DEFAULT:
            RAISE ERR_INVALID_INPUT;
        ENDTEST
    ERROR
        RAISE;
    ENDPROC'''
        
        content = re.sub(petepanels_pattern, new_mainmenu, content, flags=re.DOTALL)
        
        # Find ENDMODULE and insert our procedures before it
        if "ENDMODULE" in content:
            # Remove any existing Py2 procedures first
            content = self._remove_existing_py2_procs(content)
            
            # Insert new procedures
            insert_block = f"""
    
    ! ========== PY2 GENERATED PROCEDURES ==========
    ! Generated: {self.timestamp}
    ! Do not edit manually - regenerate via web interface
    
{py2main_proc}

{py2heli_proc}

{py2polish_proc}

{py2vacuum_proc}
    
    ! ========== END PY2 GENERATED PROCEDURES ==========

"""
            content = content.replace("ENDMODULE", insert_block + "ENDMODULE")
        
        return content
    
    def _generate_py2main(self) -> str:
        """
        Generate Py2Main procedure with submenu for all Py2 tools.
        
        Menu option in main menu will be: "Py2_{timestamp}"
        Submenu options: 1:Heli (more added later)
        """
        proc = f'''
    PROC Py2Main()
        ! Py2Main - Python-generated tools menu
        ! Generated: {self.timestamp}
        
        VAR num iChoice;
        
        TPErase;
        TPWrite "=== Py2 Tools ({self.timestamp}) ===";
        TPWrite "Panel X: " \\Num:={self.params['panel_x']};
        TPWrite "Panel Y: " \\Num:={self.params['panel_y']};
        TPReadNum iChoice,"1:Heli,2:Polish,3:Vacuum";
        
        TEST iChoice
        CASE 1:
            Py2Heli;
        CASE 2:
            Py2Polish;
        CASE 3:
            Py2Vacuum;
        DEFAULT:
            TPWrite "Invalid choice";
        ENDTEST
    ENDPROC
'''
        return proc
    
    def _remove_existing_py2_procs(self, content: str) -> str:
        """Remove any existing Py2 generated block."""
        import re
        # Remove the entire Py2 generated block if it exists
        pattern = r'\n\s*! ========== PY2 GENERATED PROCEDURES ==========.*?! ========== END PY2 GENERATED PROCEDURES ==========\s*\n'
        content = re.sub(pattern, '\n', content, flags=re.DOTALL)
        return content
