#!/usr/bin/env python3
"""
RAPID Code Generator
Generates dynamic RAPID modules based on user-defined parameters.
"""

import os
import re
import shutil
from datetime import datetime
from pathlib import Path

# Generation timestamp (dd-mm_hh-mm format, e.g., "20-01_17-50")
generation_timestamp = datetime.now().strftime("%d-%m_%H-%M")

# === USER INPUT PARAMETERS ===
# Panel dimensions (mm)
panel_x = 5900       # Panel length in X direction
panel_y = 2200       # Panel width in Y direction  
panel_z = 150        # Panel height above bed (FormHeight)

# Process step parameters (mm)
polisher_step = 450      # Polisher overlap/step distance
pan_step = 600           # Pan (helicopter trowel) overlap/step distance
helicopter_step = 600    # Helicopter tool step distance (HeliTrowelLR uses this)
vib_screed_speed = 100   # Vibrating screed travel speed (mm/s)

# Z offset parameter (mm)
# - Helicopter/Pan: operates at panel_z + z_offset above bed
# - Screed/Polisher/Plotter/Vacuum: operates at z_offset above bed (panel_z=0 for these)
z_offset = 0

# Datum offset parameters (mm) - offset from Bed1Wyong origin (0,0)
# These define the panel near corner (closest to track)
# Panel near corner = datum + datum_offset_x/y
# Panel far corner = datum + datum_offset_x/y + panel_x/y
datum_offset_x = 1100    # Offset from datum in X direction (positive)
datum_offset_y = 600     # Offset from datum in Y direction (positive, away from track)

# === PATHS ===
SCRIPT_DIR = Path(__file__).parent
RAPID_ROOT = SCRIPT_DIR.parent
SOURCE_PROGMOD = RAPID_ROOT / "RAPID" / "TASK1" / "PROGMOD"
OUTPUT_PROGMOD = RAPID_ROOT / "RAPID" / "TASK1" / "PROGMOD_python"

# Files to copy without modification
STATIC_FILES = [
    "Brian.mod",
    "ErrorHandling.mod",
    "MainModule.mod",
    "RobotTargets.mod",
    "Tools.mod",
    "Toolstations.mod",
    "WebController.mod",
]

# Files that need parameter substitution
DYNAMIC_FILES = [
    "ToolPaths.mod",
    "FCtesting.mod",
]


def process_toolpaths(content: str) -> str:
    """Process ToolPaths.mod with parameter substitutions."""
    
    # === MENU RESTRUCTURING ===
    # Change menu from: 1:Home,2:Panel1,3:Panel2,4:PackAway,5:Sync,6:BH Test
    # To: 1:Home,2:PackAway,3:Sync,4:Python_{date}
    
    # Update the main menu prompt
    content = re.sub(
        r'TPReadNum iTask,"Enter: 1:Home,2:Panel1,3:Panel2,4:PackAway,5:Sync,6:BH Test";',
        f'TPReadNum iTask,"1:Home,2:PackAway,3:Sync,4:Py_{generation_timestamp}";',
        content
    )
    
    # Update submenu to add PolishTest option (7)
    content = re.sub(
        r'TPReadNum iTaskno,"Enter: 1: Plot, 2: Screed 3: Polish, 4: Vac, 5: Heli, 6: Pan";',
        'TPReadNum iTaskno,"1:Plot,2:Screed,3:Polish,4:Vac,5:Heli,6:Pan,7:PolTest,8:Datum,9:PyHeli";',
        content
    )
    
    # Add CASE 7 for PolishTest - insert before first DEFAULT in Python submenu
    # Find the submenu prompt and locate the DEFAULT after it
    lines = content.split('\n')
    submenu_found = False
    insert_idx = None
    for i, line in enumerate(lines):
        if '1:Plot,2:Screed,3:Polish,4:Vac,5:Heli,6:Pan,7:PolTest,8:Datum,9:PyHeli' in line:
            submenu_found = True
        if submenu_found and line.strip() == 'DEFAULT:':
            insert_idx = i
            break
    
    if insert_idx:
        lines.insert(insert_idx, '            CASE 7:')
        lines.insert(insert_idx + 1, '                PolishTest;')
        lines.insert(insert_idx + 2, '            CASE 8:')
        lines.insert(insert_idx + 3, '                Datum;')
        lines.insert(insert_idx + 4, '            CASE 9:')
        lines.insert(insert_idx + 5, '                PyHeli;')
        content = '\n'.join(lines)
    
    # Remove CASE 3 (Panel2) entirely - it spans from "CASE 3:" to just before "CASE 4:"
    # This regex matches CASE 3 block up to but not including CASE 4
    content = re.sub(
        r'\n        CASE 3:\s*\n            FormXLength:=5200;.*?(?=\n        CASE 4:)',
        '',
        content,
        flags=re.DOTALL
    )
    
    # Now renumber the cases:
    # Old CASE 4 (PackAway) -> CASE 2
    # Old CASE 5 (Sync) -> CASE 3  
    # Old CASE 2 (Panel1) -> CASE 4
    # Old CASE 6 (BH Test) -> remove
    
    # First, temporarily rename old CASE 2 to CASE_PANEL
    content = re.sub(
        r'(\n        )CASE 2:(\s*\n            FormXLength:=)',
        r'\1CASE_PANEL:\2',
        content
    )
    
    # Rename CASE 4 (PackAway) to CASE 2
    content = re.sub(
        r'(\n        )CASE 4:(\s*\n            PackAway;)',
        r'\1CASE 2:\2',
        content
    )
    
    # Rename CASE 5 (Sync) to CASE 3
    content = re.sub(
        r'(\n        )CASE 5:(\s*\n            MoveAbsJ)',
        r'\1CASE 3:\2',
        content
    )
    
    # Rename CASE_PANEL back to CASE 4
    content = re.sub(
        r'CASE_PANEL:',
        'CASE 4:',
        content
    )
    
    # Remove CASE 6 (BH Test)
    content = re.sub(
        r'\n        CASE 6:\s*\n            BHTestTask;',
        '',
        content
    )
    
    # === PARAMETER SUBSTITUTIONS ===
    
    # Replace FormXLength assignment
    # Original: FormXLength:=6300;
    content = re.sub(
        r'FormXLength:=\d+;',
        f'FormXLength:={panel_x};',
        content
    )
    
    # Replace FormYlength assignment in PetePanels (CASE 2)
    # Original: FormYlength:=2960;
    content = re.sub(
        r'FormYlength:=\d+;',
        f'FormYlength:={panel_y};',
        content
    )
    
    # Replace FormHeight constant
    # Original: CONST num FormHeight:=150;
    content = re.sub(
        r'CONST num FormHeight:=\d+;',
        f'CONST num FormHeight:={panel_z};',
        content
    )
    
    # Replace HeliOverlapMin constant - now we need two separate values
    # For helicopter procedures (HeliTrowelLR), use helicopter_step
    # For pan procedures (HeliPanLR), use pan_step
    # Since they share the same constant, we'll use helicopter_step as the base
    # and add a new constant for pan
    content = re.sub(
        r'CONST num HeliOverlapMin:=\d+;',
        f'CONST num HeliOverlapMin:={helicopter_step};\n    CONST num PanOverlapMin:={pan_step};',
        content
    )
    
    # Update HeliPanLR to use PanOverlapMin instead of HeliOverlapMin
    # Find the HeliPanLR procedure and replace HeliOverlapMin references within it
    content = replace_in_procedure(
        content, 
        'HeliPanLR', 
        'HeliOverlapMin', 
        'PanOverlapMin'
    )
    
    # Replace vVS speeddata - first element is TCP speed
    # Original: VAR speeddata vVS:=[100,15,2000,15];
    content = re.sub(
        r'VAR speeddata vVS:=\[\d+,',
        f'VAR speeddata vVS:=[{vib_screed_speed},',
        content
    )
    
    # Replace PanZOffset - used for pan/helicopter operations
    # Original: VAR num PanZOffset:=250;
    content = re.sub(
        r'VAR num PanZOffset:=\d+;',
        f'VAR num PanZOffset:={z_offset};',
        content
    )
    
    # Replace DummyZOffs - used for dummy runs
    # Original: VAR num DummyZOffs:=250;
    content = re.sub(
        r'VAR num DummyZOffs:=\d+;',
        f'VAR num DummyZOffs:={z_offset};',
        content
    )
    
    # Replace PlotterZ - for plotter operations (panel_z=0, so just z_offset)
    # Original: VAR num PlotterZ:=-20;
    # Note: PlotterZ is relative to work object, currently -20 means 20mm below
    # We'll add z_offset to bring it up
    content = re.sub(
        r'VAR num PlotterZ:=-?\d+;',
        f'VAR num PlotterZ:={z_offset};',
        content
    )
    
    # Add Datum procedure - draws circle at Bed1Wyong origin (0,0)
    datum_proc = f'''
    PROC Datum()
        ! Datum - draws small circle at Bed1Wyong origin (0,0)
        ! Uses MoveJ for all movements to avoid joint limits
        ! Generated by rapid_generator.py
        VAR robtarget pDatumCenter;
        VAR robtarget pDatumCircle;
        VAR num DatumZ:={z_offset};
        VAR num DatumRadius:=100;
        VAR num SafeZ:=500;
        VAR num i;
        
        ! Confirm tool state
        TPWrite "Datum: ToolNum=" \\Num:=ToolNum;
        IF ToolNum<>4 THEN
            TPWrite "No plotter! Will pickup plotter.";
            Stop;
            Home;
            Plotter_Pickup;
        ELSE
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tPlotter\\WObj:=wobj0);
            IF CurrentPos.trans.z<600 THEN
                MoveL Offs(CurrentPos,0,0,(600-CurrentPos.trans.z)),v500,z5,tPlotter;
            ENDIF
        ENDIF
        
        ! Disable configuration monitoring for joint flexibility
        ConfL\\Off;
        ConfJ\\Off;
        
        ! Setup datum center at Bed1Wyong origin (0,0)
        pDatumCenter:=[[0,0,DatumZ],[0,0,1,0],[0,0,0,0],[0,9E+09,9E+09,9E+09,9E+09,9E+09]];
        pDatumCenter.rot:=OrientZYX(-90,0,180);
        ! Track position - robot base near FormStartX area to reach origin
        pDatumCenter.extax.eax_a:=6500;
        
        TPWrite "Datum: Drawing circle at origin";
        TPWrite "Press Play to continue";
        Stop;
        
        ! Move to safe height above center
        pDatumCircle:=pDatumCenter;
        pDatumCircle.trans.z:=SafeZ;
        MoveJ pDatumCircle,v500,z5,tPlotter\\WObj:=Bed1Wyong;
        
        ! Lower to drawing height at first point of circle (radius in +X)
        pDatumCircle.trans.x:=DatumRadius;
        pDatumCircle.trans.z:=DatumZ;
        MoveJ pDatumCircle,v500,z5,tPlotter\\WObj:=Bed1Wyong;
        
        ! Draw circle using 8 MoveJ waypoints
        FOR i FROM 1 TO 8 DO
            pDatumCircle.trans.x:=DatumRadius*Cos(i*45);
            pDatumCircle.trans.y:=DatumRadius*Sin(i*45);
            MoveJ pDatumCircle,v100,fine,tPlotter\\WObj:=Bed1Wyong;
        ENDFOR
        
        ! Move to center of datum and hold
        pDatumCircle.trans.x:=0;
        pDatumCircle.trans.y:=0;
        pDatumCircle.trans.z:=DatumZ;
        MoveJ pDatumCircle,v100,fine,tPlotter\\WObj:=Bed1Wyong;
        
        TPWrite "Plotter at datum center (0,0)";
        TPWrite "Press Play to return tool";
        Stop;
        
        ! Lift and return home
        pDatumCircle.trans.z:=SafeZ;
        MoveJ pDatumCircle,v500,z5,tPlotter\\WObj:=Bed1Wyong;
        
        ! Restore configuration monitoring
        ConfL\\On;
        ConfJ\\On;
        
        Plotter_Dropoff;
        Home;
        
        TPWrite "Datum Complete";
    ERROR
        RAISE;
    ENDPROC

'''
    
    # Insert before ENDMODULE
    content = content.replace('ENDMODULE', datum_proc + 'ENDMODULE')
    
    # Add PyHeli procedure - helicopter with datum-based coordinates
    # Near corner = datum + offset, Far corner = datum + offset + panel
    # X is negated in robot frame, Y is positive away from track
    pyheli_proc = f'''
    PROC PyHeli()
        ! PyHeli - Helicopter procedure with datum-based coordinates
        ! Near corner (closest to track): datum + datum_offset
        ! Far corner: datum + datum_offset + panel dimensions
        ! Serpentine pattern: X passes with Y stepping (+Y away from track)
        ! Generated by rapid_generator.py
        
        VAR robtarget pHeliPos;
        VAR robtarget pHeliTemp;
        VAR num HeliZ:={panel_z}+{z_offset};
        VAR num SafeZ:=500;
        VAR num NearX:={datum_offset_x};
        VAR num NearY:={datum_offset_y};
        VAR num FarX:={datum_offset_x}+{panel_x};
        VAR num FarY:={datum_offset_y}+{panel_y};
        VAR num StepY:={helicopter_step};
        VAR num NumPasses;
        VAR num CurrentY;
        VAR num i;
        VAR num HeliSpeed:=80;
        VAR num HeliAngle:=6;
        
        ! Calculate number of passes needed
        NumPasses:=Trunc((FarY-NearY)/StepY)+1;
        
        ! Confirm tool state
        TPWrite "PyHeli: ToolNum=" \\Num:=ToolNum;
        IF ToolNum<>2 THEN
            TPWrite "No helicopter! Will pickup.";
            Stop;
            Home;
            Heli_Pickup;
        ENDIF
        
        ! Disable configuration monitoring
        ConfL\\Off;
        ConfJ\\Off;
        
        ! Setup initial position at near corner
        ! X is negated in robot frame
        pHeliPos:=[[0,0,HeliZ],[0,0,1,0],[0,0,0,0],[0,9E+09,9E+09,9E+09,9E+09,9E+09]];
        pHeliPos.rot:=OrientZYX(0,0,180);
        
        ! Calculate track position for near corner
        ! Track needs to be positioned so robot can reach the work area
        pHeliPos.extax.eax_a:=Bed1Wyong.uframe.trans.x-NearX;
        
        TPWrite "PyHeli: Starting serpentine pattern";
        TPWrite "Passes=" \\Num:=NumPasses;
        Stop;
        
        ! Move to safe height above near corner start
        pHeliPos.trans.x:=-NearX;
        pHeliPos.trans.y:=NearY;
        pHeliPos.trans.z:=SafeZ;
        MoveJ pHeliPos,v500,z5,tHeli\\WObj:=Bed1Wyong;
        
        ! Lower slowly to working height
        pHeliPos.trans.z:=HeliZ;
        MoveL pHeliPos,v50,fine,tHeli\\WObj:=Bed1Wyong;
        
        ! Turn blades on
        HeliBlade_Angle HeliAngle;
        HeliBladeSpeed HeliSpeed,"FWD";
        WaitTime\\InPos,3;
        
        ! Serpentine pattern
        CurrentY:=NearY;
        FOR i FROM 1 TO NumPasses DO
            IF (i MOD 2)=1 THEN
                ! Odd pass: travel in -X direction (toward far X)
                pHeliPos.trans.x:=-FarX;
                pHeliPos.trans.y:=CurrentY;
                pHeliPos.extax.eax_a:=Bed1Wyong.uframe.trans.x-FarX;
                MoveL pHeliPos,v100,fine,tHeli\\WObj:=Bed1Wyong;
            ELSE
                ! Even pass: travel in +X direction (back toward near X)
                pHeliPos.trans.x:=-NearX;
                pHeliPos.trans.y:=CurrentY;
                pHeliPos.extax.eax_a:=Bed1Wyong.uframe.trans.x-NearX;
                MoveL pHeliPos,v100,fine,tHeli\\WObj:=Bed1Wyong;
            ENDIF
            
            ! Step in Y direction if not last pass
            IF i<NumPasses THEN
                CurrentY:=CurrentY+StepY;
                IF CurrentY>FarY THEN
                    CurrentY:=FarY;
                ENDIF
                pHeliPos.trans.y:=CurrentY;
                MoveL pHeliPos,v100,fine,tHeli\\WObj:=Bed1Wyong;
            ENDIF
        ENDFOR
        
        ! Turn blades off
        HeliBladeSpeed 0,"FWD";
        WaitTime\\InPos,3;
        
        ! Lift to safe height
        pHeliPos.trans.z:=SafeZ;
        MoveL pHeliPos,v100,z5,tHeli\\WObj:=Bed1Wyong;
        
        ! Restore configuration monitoring
        ConfL\\On;
        ConfJ\\On;
        
        ! Return tool
        Heli_Dropoff;
        Home;
        
        TPWrite "PyHeli Complete";
    ERROR
        HeliBladeSpeed 0,"FWD";
        RAISE;
    ENDPROC

'''
    
    # Insert PyHeli before ENDMODULE
    content = content.replace('ENDMODULE', pyheli_proc + 'ENDMODULE')
    
    return content


def process_fctesting(content: str) -> str:
    """Process FCtesting.mod with parameter substitutions."""
    
    # Replace PolishOverlap variable
    # Original: VAR num PolishOverlap:=450;
    content = re.sub(
        r'VAR num PolishOverlap:=\d+;',
        f'VAR num PolishOverlap:={polisher_step};',
        content
    )
    
    # NOTE: Polisher positions (pPolStart1/2, pPolishSide) are NOT modified by z_offset
    # The polisher uses force control to push down onto the concrete surface at Z≈0
    # The taught Z=75mm is an approach height above the bed, not the panel top
    
    # Add ToolNum confirmation to Polish() procedure
    content = content.replace(
        'PROC Polish()\n\n        IF ToolNum<>6 THEN',
        '''PROC Polish()
        ! Confirm tool state before proceeding
        TPWrite "Polish: ToolNum=" \\Num:=ToolNum;
        IF ToolNum<>6 THEN
            TPWrite "No polisher! Set ToolNum=6 or Play to pickup";
            Stop;'''
    )
    
    # Add PolishTest procedure - uses z_offset + 75mm, NO force control
    # Insert before the last ENDMODULE
    polish_test_proc = f'''
    PROC PolishTest()
        ! PolishTest - runs polisher path at Z=75+z_offset with motor
        ! Y offset -150mm (closer to track) to dodge precast panel
        ! Uses LIFT-TRAVEL-LOWER pattern to avoid axis 3 limits
        ! Generated by rapid_generator.py
        VAR robtarget pPolTestTemp;
        VAR robtarget pPolTestTemp2;
        VAR num PolTestZ:={75 + z_offset};
        VAR num YPanelDodge:=-150;
        VAR num SafeZ:=500;
        
        ! Confirm tool state before proceeding
        TPWrite "PolishTest: ToolNum=" \\Num:=ToolNum;
        IF ToolNum<>6 THEN
            TPWrite "No polisher! Set ToolNum=6 or Play to pickup";
            Stop;
            Home;
            Polish_Pickup;
        ELSE
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tPolish\\WObj:=wobj0);
            IF CurrentPos.trans.z<600 THEN
                MoveL Offs(CurrentPos,0,0,(600-CurrentPos.trans.z)),v500,z5,tPolish;
            ENDIF
        ENDIF
        
        MoveJ pPolHome,v500,z5,tPolish;
        
        ! Disable configuration monitoring for joint flexibility
        ConfL\\Off;
        ConfJ\\Off;
        
        ! Setup start positions - near and far track ends
        pPolTestTemp:=pPolStart1;
        pPolTestTemp.trans.z:=PolTestZ;
        pPolTestTemp2:=pPolStart1;
        pPolTestTemp2.trans.z:=PolTestZ;
        pPolTestTemp2.extax.eax_a:=pPolStart2.extax.eax_a;
        pPolTestTemp2.trans.x:=pPolStart2.trans.x;
        
        TPWrite "PolishTest: Running at Z=" \\Num:=PolTestZ;
        TPWrite "Press Play to start test path";
        Stop;
        
        ! Hybrid serpentine: Y-step at working Z, lift-travel-lower for 7m track
        ! Motor on/off each pass to allow safe lift during track travel
        
        FOR i FROM 0 TO 3 DO
            IF (i*PolishOverlap)<1750 THEN
                IF (i MOD 2)=0 THEN
                    ! Even pass: near -> far (down the track)
                    ! Start at near position
                    pPolTestTemp.trans.y:=pPolStart1.trans.y+i*PolishOverlap+YPanelDodge;
                    pPolTestTemp2.trans.y:=pPolStart1.trans.y+i*PolishOverlap+YPanelDodge;
                    
                    ! Approach at safe height, lower to work
                    MoveJ Offs(pPolTestTemp,0,0,SafeZ-PolTestZ),v500,z5,tPolish\\WObj:=Bed1Wyong;
                    MoveL pPolTestTemp,v100,fine,tPolish\\WObj:=Bed1Wyong;
                    
                    Pol_on;
                    WaitTime 0.3;
                    
                    ! Lift, travel to far end, lower
                    MoveL Offs(pPolTestTemp,0,0,SafeZ-PolTestZ),v500,z5,tPolish\\WObj:=Bed1Wyong;
                    MoveJ Offs(pPolTestTemp2,0,0,SafeZ-PolTestZ),v500,z5,tPolish\\WObj:=Bed1Wyong;
                    MoveL pPolTestTemp2,v100,fine,tPolish\\WObj:=Bed1Wyong;
                    
                    WaitTime 0.3;
                    Pol_off;
                    
                ELSE
                    ! Odd pass: far -> near (back up the track)
                    ! Start at far position  
                    pPolTestTemp.trans.y:=pPolStart1.trans.y+i*PolishOverlap+YPanelDodge;
                    pPolTestTemp2.trans.y:=pPolStart1.trans.y+i*PolishOverlap+YPanelDodge;
                    
                    ! Approach at safe height, lower to work
                    MoveJ Offs(pPolTestTemp2,0,0,SafeZ-PolTestZ),v500,z5,tPolish\\WObj:=Bed1Wyong;
                    MoveL pPolTestTemp2,v100,fine,tPolish\\WObj:=Bed1Wyong;
                    
                    Pol_on;
                    WaitTime 0.3;
                    
                    ! Lift, travel to near end, lower
                    MoveL Offs(pPolTestTemp2,0,0,SafeZ-PolTestZ),v500,z5,tPolish\\WObj:=Bed1Wyong;
                    MoveJ Offs(pPolTestTemp,0,0,SafeZ-PolTestZ),v500,z5,tPolish\\WObj:=Bed1Wyong;
                    MoveL pPolTestTemp,v100,fine,tPolish\\WObj:=Bed1Wyong;
                    
                    WaitTime 0.3;
                    Pol_off;
                ENDIF
            ENDIF
        ENDFOR
        
        ! Lift before returning home
        MoveJ Offs(pPolTestTemp,0,0,SafeZ-PolTestZ),v500,z5,tPolish\\WObj:=Bed1Wyong;
        
        ! Restore configuration monitoring
        ConfL\\On;
        ConfJ\\On;
        
        MoveJ pPolHome,v500,z5,tPolish;
        Polish_Dropoff;
        Home;
        
        TPWrite "PolishTest Complete";
    ERROR
        RAISE;
    ENDPROC

'''
    
    # Insert before ENDMODULE
    content = content.replace('ENDMODULE', polish_test_proc + 'ENDMODULE')
    
    return content


def replace_in_procedure(content: str, proc_name: str, old_var: str, new_var: str) -> str:
    """Replace a variable name within a specific procedure."""
    # Find the procedure boundaries
    proc_pattern = rf'(PROC {proc_name}\([^)]*\).*?ENDPROC)'
    
    def replace_in_match(match):
        proc_content = match.group(1)
        # Replace the variable within this procedure
        proc_content = proc_content.replace(old_var, new_var)
        return proc_content
    
    content = re.sub(proc_pattern, replace_in_match, content, flags=re.DOTALL)
    return content


def generate_modules():
    """Generate the modified RAPID modules."""
    
    # Create output directory
    if OUTPUT_PROGMOD.exists():
        shutil.rmtree(OUTPUT_PROGMOD)
    OUTPUT_PROGMOD.mkdir(parents=True)
    
    print(f"\nCreated output directory: {OUTPUT_PROGMOD}")
    
    # Copy static files
    print("\nCopying static files:")
    for filename in STATIC_FILES:
        src = SOURCE_PROGMOD / filename
        dst = OUTPUT_PROGMOD / filename
        if src.exists():
            shutil.copy2(src, dst)
            print(f"  ✓ {filename}")
        else:
            print(f"  ✗ {filename} (not found)")
    
    # Process dynamic files
    print("\nProcessing dynamic files:")
    
    for filename in DYNAMIC_FILES:
        src = SOURCE_PROGMOD / filename
        dst = OUTPUT_PROGMOD / filename
        
        if not src.exists():
            print(f"  ✗ {filename} (not found)")
            continue
        
        # Read source file
        with open(src, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        
        # Apply transformations
        if filename == "ToolPaths.mod":
            content = process_toolpaths(content)
        elif filename == "FCtesting.mod":
            content = process_fctesting(content)
        
        # Write modified file
        with open(dst, 'w', encoding='utf-8') as f:
            f.write(content)
        
        print(f"  ✓ {filename} (modified)")
    
    print("\n" + "="*50)
    print("Generation complete!")
    print(f"Output: {OUTPUT_PROGMOD}")


def main():
    print("="*50)
    print("       RAPID Code Generator")
    print("="*50)
    print(f"\nInput Parameters:")
    print(f"  panel_x:          {panel_x} mm")
    print(f"  panel_y:          {panel_y} mm")
    print(f"  panel_z:          {panel_z} mm")
    print(f"  z_offset:         {z_offset} mm")
    print(f"  polisher_step:    {polisher_step} mm")
    print(f"  pan_step:         {pan_step} mm")
    print(f"  helicopter_step:  {helicopter_step} mm")
    print(f"  vib_screed_speed: {vib_screed_speed} mm/s")
    print(f"  datum_offset_x:   {datum_offset_x} mm")
    print(f"  datum_offset_y:   {datum_offset_y} mm")
    
    print(f"\nSource: {SOURCE_PROGMOD}")
    print(f"Output: {OUTPUT_PROGMOD}")
    
    generate_modules()


if __name__ == "__main__":
    main()
