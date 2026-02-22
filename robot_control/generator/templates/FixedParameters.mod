MODULE FixedParameters
    !*******************************************************************
    !
    !  FIXED PARAMETERS MODULE
    !  Onyx Precast Robot System - ABB IRC5 Controller
    !
    !  Consolidated calibration data, tool definitions, and robot positions.
    !  All CONST and PERS data that doesn't change at runtime.
    !  Maintained via Python toolpath generator.
    !
    !*******************************************************************
    !
    !  TABLE OF CONTENTS
    !  -----------------
    !  1. TOOL DEFINITIONS (line ~35)
    !     - tTCMaster    : Tool Changer Master (tool 1)
    !     - tHeli        : Helicopter trowel (tool 2)
    !     - tVS          : Vibrating Screed (tool 3)
    !     - tPlotter     : Plotter/marker (tool 4)
    !     - tVac         : Vacuum lifter (tool 5)
    !     - tPolish      : Polisher (tool 6)
    !     - toolscribe   : Scribe tool
    !
    !  2. WORKOBJECT DEFINITIONS (line ~60)
    !     - Bed1         : Main concrete bed coordinate frame
    !     - Bed1Wyong    : Wyong site bed coordinate frame
    !
    !  3. CALIBRATION CONSTANTS (line ~75)
    !     - Stepper motor parameters
    !     - Helicopter blade geometry
    !     - Formwork dimensions
    !     - Pattern overlap minimums
    !
    !  4. LOAD DATA - Force Control (line ~100)
    !     - TestLoad, PolishLoad, HeliLoad variants
    !
    !  5. RUNTIME VARIABLES (line ~115)
    !     - pTemp, pTemp2 : Temporary robtargets for calculations
    !     - CurrentPos, CurrentJoints : Current robot position/joints
    !
    !  6. ROBOT TARGETS (line ~125)
    !     - Tool pickup positions (pHeli, pVS, pPlotter, pVac, pPolish)
    !     - Tool dropoff positions (ptHeli, ptVS, ptPlotter, ptVac, ptPolish)
    !     - Home and safe positions
    !     - Working positions
    !     - Force control testing positions
    !
    !*******************************************************************
    !
    !  DATA TYPE REFERENCE
    !  -------------------
    !  CONST  : Compile-time constant, cannot be changed
    !  PERS   : Persistent data, saved to flash memory, survives power cycles
    !  VAR    : Runtime variable, reset on program restart (not used here)
    !  TASK PERS : Task-local persistent, saved per task
    !
    !  robtarget format: [[x,y,z],[q1,q2,q3,q4],[cf1,cf4,cf6,cfx],[eax_a,...]]
    !    - [x,y,z]           : TCP position in mm
    !    - [q1,q2,q3,q4]     : Orientation as quaternion
    !    - [cf1,cf4,cf6,cfx] : Robot configuration (axis quadrants)
    !    - [eax_a,...]       : External axis positions (track position in mm)
    !
    !*******************************************************************


    !===================================================================
    ! 1. TOOL DEFINITIONS
    !===================================================================
    ! Each tool has calibrated TCP (Tool Center Point) and load data.
    ! Format: [robhold, tframe, tload]
    !   robhold: TRUE = robot holds tool
    !   tframe : [[x,y,z],[q1,q2,q3,q4]] - TCP offset from flange
    !   tload  : [mass, [cogx,cogy,cogz], [q1,q2,q3,q4], ix,iy,iz] - load properties
    !-------------------------------------------------------------------
    
    ! Tool 1: Tool Changer Master - mounted on robot flange
    PERS tooldata tTCMaster:=[TRUE,[[0,0,207.5],[1,0,0,0]],[35.1,[-43.8,-5.8,88.2],[1,0,0,0],1.89,2.404,2.185]];
    
    ! Tool 2: Helicopter Trowel - large rotating concrete finishing tool
    PERS tooldata tHeli:= [TRUE,[[3.62043,-1.97066,832.975],[1,0,0,0]],[126.195,[57.114,-1.07346,391.24],[1,0,0,0],7.566,7.566,1.232]];
    
    ! Tool 3: Vibrating Screed - concrete leveling tool
    PERS tooldata tVS:=[TRUE,[[-160.393,-0.542707,442.126],[0.999896,0.0028071,-0.004385,-0.0134527]],[63.3,[-68.9,-1.3,146],[1,0,0,0],21.289,6.038,20.201]];
    
    ! Tool 4: Plotter - marking/plotting tool
    PERS tooldata tPlotter:=[TRUE,[[-1713.88,3.06465,517.985],[1,0,0,0]],[51.3,[-156.1,-2.6,95.3],[1,0,0,0],2.987,13.114,10.95]];
    
    ! Tool 5: Vacuum Lifter - panel handling tool
    PERS tooldata tVac:=[TRUE,[[-1506.14,-102.387,605.248],[1,0,0,0]],[55,[-309.6,-23.7,189.4],[1,0,0,0],0,25.787,22.646]];
    
    ! Tool 6: Polisher - surface finishing tool with force control
    PERS tooldata tPolish:=[TRUE,[[-73.9437,0.320318,577.592],[1,0,0,0]],[98.6,[46.8,-4.7,321.4],[1,0,0,0],8.622,12.165,6.339]];
    
    ! Scribe tool - for marking/scribing (task-local)
    TASK PERS tooldata toolscribe:=[TRUE,[[-1649.26,45.4029,529.7],[1,0,0,0]],[35,[0,0,0],[1,0,0,0],0,0,0]];


    !===================================================================
    ! 2. WORKOBJECT DEFINITIONS
    !===================================================================
    ! Workobjects define coordinate frames for the concrete bed.
    ! Format: [robhold, ufprog, ufmec, uframe, oframe]
    !   uframe: User frame - position/orientation of workobject origin
    !   oframe: Object frame - additional offset (usually identity)
    !-------------------------------------------------------------------
    
    ! Main bed coordinate frame (Z=185.66 at measurement, Track=-230.02)
    TASK PERS wobjdata Bed1:=[FALSE,TRUE,"",[[1000.00,930.569,220.66],[1,0.000655845,-0.000507562,-0.00020191]],[[0,0,0],[1,0,0,0]]];
    
    ! Wyong site bed coordinate frame
    TASK PERS wobjdata Bed1Wyong:=[FALSE,TRUE,"",[[7989.63,1005.26,-267.803],[0.999997,0.00206543,0.00107668,-0.000243432]],[[0,0,0],[1,0,0,0]]];


    !===================================================================
    ! 3. CALIBRATION CONSTANTS
    !===================================================================
    ! Fixed values for mechanical systems and geometry.
    ! These should only change if hardware is modified.
    !-------------------------------------------------------------------
    
    ! Helicopter blade angle stepper motor parameters
    CONST num StepsPerRevolution:=32;   ! Stepper motor steps per revolution
    CONST num RevstoAngle:=0.81;        ! Revolutions to blade angle conversion
    CONST num RPMtoAVoltage:=13.26;     ! RPM to analog voltage conversion
    
    ! Helicopter blade geometry (mm)
    CONST num HeliBladeWidth:=1150;     ! Width of helicopter blade assembly
    
    ! Formwork geometry (mm)
    CONST num FormHeight:=150;          ! Standard formwork height
    CONST num FormWidth:=65;            ! Standard formwork width
    
    ! Toolpath pattern overlap minimums (mm)
    CONST num HeliOverlapMin:=450;      ! Min overlap between helicopter passes
    CONST num PanOverlapMin:=500;       ! Min overlap between pan passes
    
    ! Helicopter blade pitch Z offset - PERS because adjusted at runtime
    PERS num PitchZOffset:=0;


    !===================================================================
    ! 4. LOAD DATA - Force Control Calibration
    !===================================================================
    ! Load identification data for force control operations.
    ! Format: [mass, [cogx,cogy,cogz], [q1,q2,q3,q4], ix,iy,iz]
    ! Obtained via FCLoadId procedure with tool attached.
    !-------------------------------------------------------------------
    
    ! Active load data - updated by FCLoadId, PERS for runtime updates
    PERS loaddata TestLoad:=[130.053,[103.062,-36.4441,383.799],[1,0,0,0],0,0,0];
    
    ! Polisher load calibration
    CONST loaddata PolishLoad:=[87.0357,[37.5519,8.24935,283.334],[1,0,0,0],0,0,0];
    
    ! Helicopter load calibrations at different blade speeds
    CONST loaddata HeliLoad70rpm:=[122.72,[317.395,-30.8887,388.598],[1,0,0,0],0,0,0];
    CONST loaddata HeliLoad100rpm:=[127.767,[21.072,5.44091,390.299],[1,0,0,0],0,0,0];
    CONST loaddata HeliLoad140rpm:=[130.053,[103.062,-36.4441,383.799],[1,0,0,0],0,0,0];


    !===================================================================
    ! 5. RUNTIME VARIABLES
    !===================================================================
    ! Temporary robtargets used for position calculations in procedures.
    ! PERS persists across power cycles, VAR resets on restart.
    !-------------------------------------------------------------------
    
    PERS robtarget pTemp;               ! Temporary position for calculations
    VAR robtarget pTemp2;               ! Temporary position (non-persistent)
    VAR robtarget CurrentPos;           ! Current robot TCP position
    VAR jointtarget CurrentJoints;      ! Current robot joint angles


    !===================================================================
    ! 6. ROBOT TARGETS
    !===================================================================
    ! All positions are calibrated robtargets for tool operations.
    ! Naming convention:
    !   p{Tool}     : Pickup position (approach with tTCMaster)
    !   pt{Tool}    : Dropoff/tool position (approach with tool attached)
    !   p{Tool}Home : Safe home position for that tool
    !   p{Tool}Lid  : Position near toolbox lid
    !-------------------------------------------------------------------


    !-------------------------------------------------------------------
    ! 5a. Tool Pickup Positions
    ! Robot approaches these with tTCMaster to pick up tools
    !-------------------------------------------------------------------
    CONST robtarget pheli:=[[8943.10,2959.75,265.50],[6.43098E-05,0.707244,-0.706967,-0.00194682],[1,0,0,0],[9020.58,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVS:=[[10885.25,2694.24,-85.90],[7.1103E-05,0.00253236,0.999994,0.00232889],[0,0,0,0],[9400,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pPlotter:=[[8711.90,1480.27,-92.24],[7.95004E-05,0.000723003,0.999997,0.00233815],[0,0,0,0],[7000,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVac:=[[8710.42,2016.87,-57.34],[8.16993E-05,-3.02533E-05,0.999997,0.00233675],[0,0,0,0],[8008.49,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pPolish:=[[10187.84,2909.45,124.99],[0.210696,-0.480812,0.841761,0.12596],[0,-1,0,0],[9669.05,9E+09,9E+09,9E+09,9E+09,9E+09]];


    !-------------------------------------------------------------------
    ! 5b. Tool Dropoff Positions
    ! Robot approaches these with tool attached to drop off
    !-------------------------------------------------------------------
    CONST robtarget ptHeli:=[[8943.29,2957.80,-359.98],[6.38917E-05,0.707244,-0.706967,-0.00194727],[1,0,0,0],[9020.58,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget ptHeliLid:=[[394.24,1985.52,994.74],[0.00461872,0.67616,-0.736727,-0.00450529],[1,0,0,0],[1200,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget ptVS:=[[11045.67,2693.97,-320.50],[0.00448015,-0.0109106,0.99993,-0.000490788],[0,0,0,0],[9400,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget ptVSLid:=[[-1258.81,1496.40,1264.32],[0.00538869,0.999881,0.014392,-0.00114313],[1,0,-1,0],[-300,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget ptPlotter:=[[10425.84,1482.31,-402.44],[7.96616E-05,0.000723746,0.999997,0.00233849],[0,0,0,0],[7000,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget ptVac:=[[10216.63,1916.43,-455.32],[8.13591E-05,-3.02535E-05,0.999997,0.00233577],[0,0,0,0],[8008.49,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget ptPolish:=[[10307.20,3119.00,-165.31],[0.210696,-0.480814,0.84176,0.12596],[0,-1,0,0],[9669.05,9E+09,9E+09,9E+09,9E+09,9E+09]];


    !-------------------------------------------------------------------
    ! 5c. Home and Safe Positions
    ! Safe positions for parking, tool changes, and synchronization
    !-------------------------------------------------------------------
    CONST robtarget pHome:=[[9788.10,1111.58,1428.55],[0.00172327,-0.707218,0.706991,0.0015985],[0,0,-1,0],[9669.05,9E+09,9E+09,9E+09,9E+09,9E+09]];           ! Main home position
    CONST robtarget pHomeLoadout:=[[10727.04,861.31,1157.29],[0.00106715,-0.495112,0.868828,0.000646025],[0,0,-1,0],[10083.3,9E+09,9E+09,9E+09,9E+09,9E+09]];  ! Loadout/end position
    CONST robtarget pHTSHome:=[[-170.79,1515.79,1481.97],[0.00236128,0.676173,-0.736739,0.000524318],[0,0,0,0],[-230.006,9E+09,9E+09,9E+09,9E+09,9E+09]];      ! Heli tool station home
    CONST robtarget pVSTSHome:=[[-170.79,1515.79,1481.97],[0.00236128,0.676173,-0.736739,0.000524318],[0,0,0,0],[1200,9E+09,9E+09,9E+09,9E+09,9E+09]];         ! VS tool station home
    CONST robtarget pHeliLid:=[[300,2000,1481.97],[0.00236128,0.676173,-0.736739,0.000524318],[0,0,0,0],[1200,9E+09,9E+09,9E+09,9E+09,9E+09]];                  ! Heli toolbox lid position
    CONST robtarget pVSLid:=[[-1100,1500,1500],[0.00814298,0.999961,0.000966756,0.00335392],[0,-1,-2,0],[-300,9E+09,9E+09,9E+09,9E+09,9E+09]];                  ! VS toolbox lid position
    CONST robtarget ptPlotterHome:=[[-28.06,3222.40,1164.30],[0.0023643,0.676174,-0.736738,0.000527345],[0,0,0,0],[-230.006,9E+09,9E+09,9E+09,9E+09,9E+09]];   ! Plotter home
    CONST robtarget pVSHome:=[[9585.25,2694.24,650],[7.1103E-05,0.00253236,0.999994,0.00232889],[0,0,0,0],[8700,9E+09,9E+09,9E+09,9E+09,9E+09]];                ! VS safe home
    CONST robtarget ptPolishHome:=[[9800,2600,700],[0.00170969,-0.70722,0.706989,0.00159033],[0,0,-1,0],[9669.05,9E+09,9E+09,9E+09,9E+09,9E+09]];               ! Polisher safe home
    CONST robtarget pPolishHOME:=[[-165.83,1588.02,1111.56],[0.00236618,0.676177,-0.736735,0.000524777],[0,0,0,0],[-230.006,9E+09,9E+09,9E+09,9E+09,9E+09]];   ! Polisher alt home
    CONST robtarget psafetysync:=[[1398.85,1929.78,822.76],[0.00987552,-0.710785,0.703215,0.013256],[0,0,-1,0],[1388.92,9E+09,9E+09,9E+09,9E+09,9E+09]];        ! Safety sync position


    !-------------------------------------------------------------------
    ! 5d. Working Positions
    ! Intermediate and approach positions for various operations
    !-------------------------------------------------------------------
    CONST robtarget pheliFlat:=[[1539.97,3060.81,188.30],[0.00869284,-0.711152,0.702867,0.0128866],[1,-1,-1,0],[2550.86,9E+09,9E+09,9E+09,9E+09,9E+09]];        ! Heli flat orientation
    CONST robtarget pauto1:=[[-778.40,2128.06,1481.94],[0.022656,0.969999,-0.241976,-0.00596024],[1,0,-1,0],[882.621,9E+09,9E+09,9E+09,9E+09,9E+09]];           ! Auto sequence pos 1
    CONST robtarget pauto11:=[[3681.78,3060.67,2088.41],[0.374917,-0.637445,0.551185,0.386389],[0,0,-1,0],[3637.95,9E+09,9E+09,9E+09,9E+09,9E+09]];             ! Auto sequence pos 11
    CONST robtarget pauto21:=[[10834.94,586.90,1323.18],[0.0589615,0.154699,-0.985821,0.0273665],[0,-1,0,0],[9151.19,9E+09,9E+09,9E+09,9E+09,9E+09]];           ! Auto sequence pos 21
    CONST robtarget p30:=[[-8200.33,3455.89,-25.52],[0.00615322,-0.709926,0.704246,-0.00239206],[1,-1,0,0],[700.017,9E+09,9E+09,9E+09,9E+09,9E+09]];            ! Working pos 30
    CONST robtarget pVS2:=[[10884.11,2694.01,-84.00],[0.000422431,0.00399926,-0.999989,-0.00231643],[0,0,-4,0],[9400.01,9E+09,9E+09,9E+09,9E+09,9E+09]];        ! VS alternate pickup
    CONST robtarget ptVS2:=[[11044.30,2695.84,-318.76],[0.00400447,-0.0174424,0.99984,-0.00046851],[0,0,-4,0],[9400.01,9E+09,9E+09,9E+09,9E+09,9E+09]];         ! VS alternate dropoff
    CONST robtarget pVSHome2:=[[8270.42,2695.81,568.34],[0.00400107,-0.0174495,0.99984,-0.00047725],[1,-1,-3,0],[9348.32,9E+09,9E+09,9E+09,9E+09,9E+09]];       ! VS alternate home
    CONST robtarget pVSstart:=[[0,1910,152.62],[0.00447556,-0.0129767,0.999906,0.000222253],[1,0,-3,0],[8013.81,9E+09,9E+09,9E+09,9E+09,9E+09]];                 ! VS path start
    CONST robtarget pVSend:=[[-7901.85,1910,136.34],[0.00447498,-0.0129641,0.999906,0.000216841],[1,-1,-3,0],[1001.47,9E+09,9E+09,9E+09,9E+09,9E+09]];          ! VS path end
    CONST robtarget pPolori:=[[-7500.00,699.99,61.10],[0.00290121,-0.00953475,0.99995,-0.000307041],[1,-1,-3,0],[1082.85,9E+09,9E+09,9E+09,9E+09,9E+09]];       ! Polisher orientation ref
    CONST robtarget pWyongheli:=[[-1079.05,1074.88,154.71],[0.000446787,0.711247,-0.702933,-0.00362622],[1,0,0,0],[8410.48,9E+09,9E+09,9E+09,9E+09,9E+09]];     ! Wyong heli position
    CONST robtarget pWyongpolside:=[[-315.45,397.96,85.25],[0.000625449,0.713919,-0.700225,0.00227362],[1,-1,0,0],[7736.06,9E+09,9E+09,9E+09,9E+09,9E+09]];     ! Wyong polisher side
    CONST robtarget pVSint1:=[[9801.17,1585.88,785.87],[0.000745595,-0.16668,-0.986008,-0.00229112],[0,0,-3,0],[9489.51,9E+09,9E+09,9E+09,9E+09,9E+09]];        ! VS intermediate 1


    !-------------------------------------------------------------------
    ! 5e. Force Control Testing Positions
    ! Calibrated positions for force control development and testing
    !-------------------------------------------------------------------
    CONST robtarget pPolish10:=[[599.99,749.95,18.22],[0.00292005,0.00951812,-0.999919,-0.00792942],[0,0,0,0],[1082.85,9E+09,9E+09,9E+09,9E+09,9E+09]];         ! Polish test pos 10
    CONST robtarget pPolish20:=[[600.19,749.03,23.00],[0.012269,0.999868,0.009605,0.00451214],[0,-1,-2,0],[1082.85,9E+09,9E+09,9E+09,9E+09,9E+09]];             ! Polish test pos 20
    CONST robtarget pPolishSide:=[[-253.57,398.37,75],[0.000625449,0.713919,-0.700225,0.00227362],[1,-1,0,0],[7736,9E+09,9E+09,9E+09,9E+09,9E+09]];             ! Polish side approach
    CONST robtarget pPolStart1:=[[-600,250,75],[1.04259E-05,-0.999952,-0.00961003,-0.00172456],[1,-1,-1,0],[9582.85,9E+09,9E+09,9E+09,9E+09,9E+09]];            ! Polish path start 1
    CONST robtarget pPolStart2:=[[-7000,700,75],[0.00290121,-0.00953475,0.99995,-0.000307041],[1,-1,-3,0],[1082.85,9E+09,9E+09,9E+09,9E+09,9E+09]];             ! Polish path start 2
    CONST robtarget pPolHome:=[[8100.03,2300.00,699.99],[0.00170896,-0.707216,0.706994,0.00158688],[0,0,-1,0],[7969.05,9E+09,9E+09,9E+09,9E+09,9E+09]];         ! Polish test home


ENDMODULE
