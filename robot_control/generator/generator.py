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

# Tool class-based generation (all tools)
from .tool_class import TOOLS, get_tool
from .tools.sequences import generate_seq_bed_clean


# Paths
SCRIPT_DIR = Path(__file__).parent
TEMPLATES_DIR = SCRIPT_DIR / "templates"
TEMPLATES_TEMP_DIR = SCRIPT_DIR / "templates_temp"  # Staging directory for testing migrations
TEMPLATES_FROM_IRC5_DIR = SCRIPT_DIR / "templates_from_irc5"  # Pulled from IRC5 controller

# Files to copy without modification
STATIC_FILES = [
    "FixedParameters.mod",
    "ErrorHandling.mod",
    "MainModule.mod",
    "Tools.mod",
    "FCtesting.mod",
    "Toolstations.mod",  # Safety interlocks for tool station lids
]

# ToolPaths.mod is processed separately
TOOLPATHS_FILE = "ToolPaths.mod"


class ToolpathGenerator:
    """
    Main generator class called by views.py.
    
    Generates RAPID modules with user parameters and Py2 menu structure.
    """
    
    # Required parameters - all must be provided from DB, no defaults here
    REQUIRED_PARAMS = [
        'bed_length_x',
        'bed_width_y',
        'bed_datum_x',
        'bed_datum_y',
        'panel_datum_x',
        'panel_datum_y',
        'panel_x',
        'panel_y',
        'panel_z',
        'vacuum_z_offset',
        'vacuum_speed',
        'vacuum_pattern',
        'vacuum_workzone',
        'vacuum_force',
        'vacuum_force_enabled',
        'polisher_step',
        'vacuum_step',
        'pan_step',
        'helicopter_step',
        'pan_travel_speed',
        'pan_blade_speed',
        'pan_z_offset',
        'pan_pattern',
        'pan_force',
        'pan_force_change',
        'pan_pos_supv_dist',
        'heli_travel_speed',
        'heli_blade_speed',
        'heli_blade_angle',
        'heli_force',
        'heli_z_offset',
        'heli_workzone',
        'heli_pattern',
        'heli_spiral_direction',
        'heli_formwork_offset',
        'polisher_z_offset',
        'polisher_workzone',
        'polisher_start_force',
        'polisher_motion_force',
        'polisher_force_change',
        'polisher_approach_speed',
        'polisher_retract_speed',
        'polisher_pos_supv_dist',
        'polisher_pattern',
        'polisher_speed',
        'screed_z_offset',
        'vib_screed_speed',
        'screed_angle_offset',
        'z_offset',
        'serpentine_offset_x',
        'serpentine_offset_y',
        'serpentine_direction',
        'serpentine_start_bottom',
    ]
    
    def __init__(self, params: dict, use_temp_templates: bool = False, use_irc5_templates: bool = True):
        """
        Initialize the generator.
        
        Args:
            params: Dictionary of required parameters from DB
            use_temp_templates: If True, use templates_temp directory for testing
                               migrations before committing to production templates
            use_irc5_templates: If True (default), use templates_from_irc5 directory
                               and only generate ToolPaths.mod (engineer workflow)
        """
        # Validate all required parameters are present
        missing = [p for p in self.REQUIRED_PARAMS if p not in params]
        if missing:
            raise ValueError(f"Missing required parameters from DB: {', '.join(missing)}")
        
        self.params = dict(params)
        self.timestamp = datetime.now().strftime("%d-%b_%H:%M").lower()
        
        # Select templates directory (priority: irc5 > temp > default)
        self.use_irc5_templates = use_irc5_templates
        if use_irc5_templates and TEMPLATES_FROM_IRC5_DIR.exists():
            self.templates_dir = TEMPLATES_FROM_IRC5_DIR
        elif use_temp_templates:
            self.templates_dir = TEMPLATES_TEMP_DIR
        else:
            self.templates_dir = TEMPLATES_DIR
        self.using_temp_templates = use_temp_templates
    
    def generate(self) -> Dict:
        """
        Generate RAPID modules.
        
        Returns:
            Dict with output_dir, files list, params, timestamp
        """
        output_dir = Path(tempfile.mkdtemp(prefix="onyx_rapid_"))
        generated_files: List[str] = []
        
        # When using IRC5 templates, ONLY generate ToolPaths.mod
        # (other files stay on IRC5 as engineer maintains them)
        if not self.use_irc5_templates:
            # Legacy mode: Copy static files (from selected templates directory)
            for filename in STATIC_FILES:
                src = self.templates_dir / filename
                dst = output_dir / filename
                if src.exists():
                    shutil.copy2(src, dst)
                    generated_files.append(filename)
        
        # Process ToolPaths.mod (always done)
        toolpaths_src = self.templates_dir / TOOLPATHS_FILE
        if toolpaths_src.exists():
            content = toolpaths_src.read_text(encoding='utf-8', errors='ignore')
            content = self._process_toolpaths(content)
            (output_dir / TOOLPATHS_FILE).write_text(content, encoding='utf-8')
            generated_files.append(TOOLPATHS_FILE)
        
        return {
            'output_dir': str(output_dir),
            'files': generated_files,
            'params': self.params,
            'timestamp': self.timestamp,
            'using_temp_templates': self.using_temp_templates,
            'using_irc5_templates': self.use_irc5_templates,
            'templates_dir': str(self.templates_dir),
        }
    
    def _process_toolpaths(self, content: str) -> str:
        """
        Process ToolPaths.mod:
        1. Inject Py2 procedures before ENDMODULE
        """
        import re
        
        # Generate tool procedures using Tool class
        py2heli_proc = TOOLS['helicopter'].generate_procedure(self.params)
        py2polish_proc = TOOLS['polisher'].generate_procedure(self.params)
        py2vacuum_proc = TOOLS['vacuum'].generate_procedure(self.params)
        py2pan_proc = TOOLS['pan'].generate_procedure(self.params)
        py2vib_screed_proc = TOOLS['vib_screed'].generate_procedure(self.params)
        py2trowel_proc = TOOLS['trowel'].generate_procedure(self.params)
        seq_bed_clean_proc = generate_seq_bed_clean(self.params)
        
        # Generate the main Py2 menu procedure
        py2main_proc = self._generate_py2main()
        
        # Generate MainMenu procedure (injected with other Py2 procedures)
        new_mainmenu = f'''
    PROC MainMenu()
        VAR num iTask;
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
        
        # Find ENDMODULE and insert our procedures before it
        if "ENDMODULE" in content:
            # Remove any existing Py2 procedures first
            content = self._remove_existing_py2_procs(content)
            
            # Insert new procedures (including MainMenu)
            insert_block = f"""
    
    ! ========== PY2 GENERATED PROCEDURES ==========
    ! Generated: {self.timestamp}
    ! Do not edit manually - regenerate via web interface
    
{new_mainmenu}

{py2main_proc}

{py2heli_proc}

{py2polish_proc}

{py2vacuum_proc}

{py2pan_proc}

{py2vib_screed_proc}

{py2trowel_proc}

{seq_bed_clean_proc}
    
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
        TPReadNum iChoice,"1:Heli,2:Polish,3:Vac,4:Pan,5:Screed,6:Trowel,7:BedClean";
        
        TEST iChoice
        CASE 1:
            Py2Heli;
        CASE 2:
            Py2Polish;
        CASE 3:
            Py2Vac;
        CASE 4:
            Py2Pan;
        CASE 5:
            Py2VS;
        CASE 6:
            Py2Trowel;
        CASE 7:
            SeqBedClean;
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
