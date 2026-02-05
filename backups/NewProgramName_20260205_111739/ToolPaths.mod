MODULE ToolPaths

    PERS jointtarget CurrentJoints5:=[[111.289,20.3366,35.7518,0.0387684,32.6999,-249.807],[1082.85,9E+09,9E+09,9E+09,9E+09,9E+09]];
    PERS jointtarget CurrentJoints6:=[[105.901,37.7221,15.0236,0.230043,36.0283,-255.346],[1082.85,9E+09,9E+09,9E+09,9E+09,9E+09]];


    TASK PERS wobjdata Bed1:=[FALSE,TRUE,"",[[1000.00,930.569,220.66],[1,0.000655845,-0.000507562,-0.00020191]],[[0,0,0],[1,0,0,0]]];
    !Z 185.66
    !Track -230.02 at measurement

    PERS robtarget pScreed1:=[[-1100,1500,1500],[0.00814298,0.999961,0.000966756,0.00335392],[0,-1,-2,0],[-300,9E+09,9E+09,9E+09,9E+09,9E+09]];
    PERS robtarget pScreed2:=[[-1100,1500,1500],[0.00814298,0.999961,0.000966756,0.00335392],[0,-1,-2,0],[-300,9E+09,9E+09,9E+09,9E+09,9E+09]];

    CONST num HeliOverlapMin:=450;
    CONST num PanOverlapMin:=500;
    CONST num HeliBladeWidth:=1150;
    VAR num HeliPasses;
    VAR num HeliPassWidth;
    CONST num ScreedYpos:=2955;
    CONST num wBedXmin:=1600;
    CONST num wBedXmax:=10200;
    CONST num wBedYmin:=955;
    CONST num wBedYmax:=4955;
    CONST num FormHeight:=150;
    CONST num FormWidth:=65;
    PERS num PitchZOffset:=0;

    VAR speeddata vVS:=[50,15,2000,15];
    ![mm/s TCP, degrees/s TCP, mm/s external axes, degrees/s external axes]
    VAR speeddata vHeli:=[40,10,2000,15];
    VAR speeddata vPlotter:=[1000,30,2000,15];
    VAR zonedata zVS:=z5;
    VAR zonedata zHeli:=z5;
    VAR zonedata zPlotter:=z0;


    VAR robtarget Plotterp1:=[[1000,1000,-10],[0.000337803,0.93262,-0.36086,0.000225436],[0,-1,-2,0],[3400,9E+09,9E+09,9E+09,9E+09,9E+09]];
    PERS robtarget Plotterp2:=[[-2250,790,-20],[6.12303E-17,1,0,0],[0,-1,-1,0],[8453.51,9E+09,9E+09,9E+09,9E+09,9E+09]];
    PERS robtarget Plotterp3:=[[-6000,3500,-20],[4.32964E-17,0.707107,-0.707107,-4.32964E-17],[0,-1,-1,0],[1989.63,9E+09,9E+09,9E+09,9E+09,9E+09]];
    PERS robtarget Plotterp4:=[[-6000,500,-20],[6.12303E-17,1,0,0],[1,-1,0,0],[4703.51,9E+09,9E+09,9E+09,9E+09,9E+09]];
    PERS robtarget Plotterp5:=[[1000,1000,-20],[5.65694E-17,0.92388,-0.382683,-2.34318E-17],[1,-1,0,0],[390.38,9E+09,9E+09,9E+09,9E+09,9E+09]];
    PERS robtarget Plotterc5:=[[-2250,3250,-20],[0.00237199,0.67253,-0.740066,0.000521901],[0,-1,-1,0],[0,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR num Plotterc5r:=500;
    VAR robtarget PlotterTemp:=[[1500,3000,-10],[0.00237199,0.67253,-0.740066,0.000521901],[0,-1,-1,0],[3400,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget PlotterTemp2:=[[1500,3000,-10],[0.00237199,0.67253,-0.740066,0.000521901],[0,-1,-1,0],[3400,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget PlotterTemp3:=[[1500,3000,-10],[0.00237199,0.67253,-0.740066,0.000521901],[0,-1,-1,0],[3400,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR num PlotterZ:=300;
    VAR num PlotterZOri;

    VAR robtarget pHeliStart:=[[-900,900,163.71],[0.000446787,0.711247,-0.702933,-0.00362622],[1,0,0,0],[7000,9E+09,9E+09,9E+09,9E+09,9E+09]];
    ![0.00497429,-0.71119,0.702786,0.0165738],[0,0,-1,0]
    VAR robtarget pHeliEnd:=[[-2590,2800,163.71],[0.000446787,0.711247,-0.702933,-0.00362622],[1,0,0,0],[5500,9E+09,9E+09,9E+09,9E+09,9E+09]];
    !154.71],[0.000446787,0.711247,-0.702933,-0.00362622],[1,0,0,0]
    VAR robtarget pHeliTempS;
    VAR robtarget pHeliTempE;
    VAR robtarget pHeliTemp1;
    VAR robtarget pHeliTemp2;

    VAR robtarget pScreedStart:=[[500,1900,145],[0.00523034,0.999956,0.00749019,-0.00219287],[0,-1,-2,0],[2000,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget pScreedEnd:=[[6500,1900,145],[0.00523034,0.999956,0.00749019,-0.00219287],[0,-1,-2,0],[7700,9E+09,9E+09,9E+09,9E+09,9E+09]];


    VAR num iTaskno:=-1;
    VAR num iPlotType:=-1;
    VAR num iAngle:=-1;
    VAR num iPlotSide:=-1;
    VAR num iCoord1x:=-1;
    VAR num iCoord1y:=-1;
    VAR num iCoord2x:=-1;
    VAR num iCoord2y:=-1;
    VAR num iCoord3x:=-1;
    VAR num iCoord3y:=-1;
    VAR num iCoord4x:=-1;
    VAR num iCoord4y:=-1;
    VAR num iCoordTemp:=-1;
    VAR num iHeliBladeSpeed:=-1;
    VAR num iHeliBladeAngle:=-1;
    VAR num iZoffset:=0;
    VAR num iHeliPan:=-1;
    VAR num iLRUD:=-1;

    CONST num TieInWidth:=25;
    CONST num GroutWidth:=50;
    CONST num GroutHeight:=500;
    CONST num TriangleBase:=25;
    CONST num TriangleHeight:=50;
    CONST num PlotCircleD:=60;
    VAR num TriangleAngle:=0;
    VAR num CrossHairExt:=10;

    CONST num BedXmin:=10;
    CONST num BedXmax:=8000;
    CONST num BedYmin:=10;
    CONST num BedYmax:=3800;

    CONST num PlotA6Max:=45;
    !45;
    CONST num PlotWaitTime:=0.3;
    PERS num anglex:=179.861;
    PERS num angley:=-0.241379;
    PERS num anglez:=-95.4741;
    VAR pose Object;

    PERS num BedZread:=-8.28;

    VAR robtarget p10maps:=[[-350,150,250],[0.00321343,0.67631,-0.736609,0.000689698],[0,0,-1,0],[7700,9E+09,9E+09,9E+09,9E+09,9E+09]];

    !VAR num BedZreads{4,24}:=[
    !  [13.28, 12.88, 12.68, 14.03, 15.46, 10.94,  8.17,  6.79,  4.83,  2.37,  0.97,  0.30,  0.00,  0.24,  0.47, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    !  [15.76, 14.97, 14.36, 15.69, 16.55, 13.22, 10.94,  9.86,  7.97,  6.00,  4.27,  3.57,  2.82,  2.70,  1.69, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    !  [16.92, 16.33, 16.18, 17.01, 17.20, 14.79, 12.97, 12.12, 10.27,  8.39,  6.92,  5.72,  4.82,  4.65,  2.84, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    !  [17.97, 18.08, 18.34, 18.15, 17.16, 15.42, 14.97, 14.02, 12.65, 11.42,  9.54,  8.23,  6.97,  6.59,  4.58, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    !];

    VAR num BedZreads{4,24}:=[
  [2.28,1.88,1.68,3.03,4.46,-0.06,-2.83,-4.21,-6.17,-8.63,-10.03,-10.70,-11.00,-10.76,-10.53,0,0,0,0,0,0,0,0,0],
  [4.76,3.97,3.36,4.69,5.55,2.22,-0.06,-1.14,-3.03,-5.00,-6.73,-7.43,-8.18,-8.30,-9.31,0,0,0,0,0,0,0,0,0],
  [5.92,5.33,5.18,6.01,6.20,3.79,1.97,1.12,-0.73,-2.61,-4.08,-5.28,-6.18,-6.35,-8.16,0,0,0,0,0,0,0,0,0],
  [6.97,7.08,7.34,7.15,6.16,4.42,3.97,3.02,1.65,0.42,-1.46,-2.77,-4.03,-4.41,-6.42,0,0,0,0,0,0,0,0,0]
];

    VAR num BedZpos{4,24,2}:=[[
    [-350,2100],[-850,2100],[-1350,2100],[-1850,2100],[-2350,2100],[-2850,2100],[-3350,2100],[-3850,2100],[-4350,2100],[-4850,2100],[-5350,2100],[-5850,2100],[-6350,2100],[-6850,2100],[-7350,2100],[-7850,2100],[-8350,2100],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]],

   [[-350,1450],[-850,1450],[-1350,1450],[-1850,1450],[-2350,1450],[-2850,1450],[-3350,1450],[-3850,1450],[-4350,1450],[-4850,1450],[-5350,1450],[-5850,1450],[-6350,1450],[-6850,1450],[-7350,1450],[-7850,1450],[-8350,1450],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]],

   [[-350,800],[-850,800],[-1350,800],[-1850,800],[-2350,800],[-2850,800],[-3350,800],[-3850,800],[-4350,800],[-4850,800],[-5350,800],[-5850,800],[-6350,800],[-6850,800],[-7350,800],[-7850,800],[-8350,800],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]],

    [[-350,150],[-850,150],[-1350,150],[-1850,150],[-2350,150],[-2850,150],[-3350,150],[-3850,150],[-4350,150],[-4850,150],[-5350,150],[-5850,150],[-6350,150],[-6850,150],[-7350,150],[-7850,150],[-8350,150],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]]];


    PERS num Bed1Zread{10,20}:=[[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                                 [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                                 [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                                 [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                                 [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                                 [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                                 [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                                 [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                                 [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                                 [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]];

    PERS num Bed1Zpos{10,20,2}:=[[[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]],

                               [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]],

                               [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]],

                               [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]],

                               [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]],

                               [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]],

                               [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]],

                               [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]],

                               [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]],

                               [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]]];

    CONST num XGridSpacing:=460;
    CONST num YGridSpacing:=400;


    PERS num ScrInitialD:=50;

    PERS num HeliZOffs:=0;
    !Offset based on bed heights

    VAR num SEnddiv:=0;
    VAR num SStartdiv:=0;

    VAR num ScrBedZ;

    PERS num HeliZArray{30}:=[-50,-50,-50,-50,-50,-50,-50,-50,-50,-50,-50,-50,-50,-50,-50,-50,-50,-50,-50,-50,-50,-50,-50,-50,-50,-50,-50,-50,-50,-50];
    VAR bool WithinBlades:=FALSE;
    PERS num HeliZArrayCounter:=1;
    PERS num HeliDiv:=12;
    PERS num PreviousHighest:=-50;

    !CONST robtarget p10:=[[-8200.58,3455.68,-35.54],[0.000477585,0.709995,-0.70418,0.00603077],[1,-1,0,0],[700.099,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVacStart:=[[-8200.58,3455.68,-35.54],[0.00615322,-0.709926,0.704246,-0.00239206],[1,-1,0,0],[700,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVacStart2:=[[-72.58,1432.35,-35.54],[0.00615322,-0.709926,0.704246,-0.00239206],[1,-1,0,0],[8680,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR num iTask:=-1;
    VAR num iPete:=-1;
    VAR num PeteXoffset:=0;
    VAR num PeteYoffset:=0;
    VAR num FormStartX:=7300;
    VAR num FormStartY:=3500;
    VAR num FormXLength:=5650;
    VAR num FormYlength:=2000;
    VAR num CrnrMarkLngth:=300;
    VAR speeddata PanTrvSpd:=[100,30,2000,15];
    VAR num PanBldSpd:=70;
    VAR num PanZOffset:=300;
    VAR num VSZOffset:=0;
    VAR num VSAngleOffset:=0;
    VAR num DummyRun:=0;
    VAR num DummyZOffs:=300;

    PROC MainMenu()
        TPErase;
        TPReadNum iTask,"1:Home,2:Py2_05-feb_10:18";
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
    ENDPROC


    PROC DemoScreen()
        TPErase;
        TPReadNum iTask,"1:Home,2:Py_03-feb_8:59am,3:Pack,4:Sync";
        TEST iTask
        CASE 1:
            TPErase;
            TPReadNum iTaskno,"1Plt,2Scr,3Pol,4Vac,5Hel,6Pan,7Dat,8PH,9PV,10PP,11PN";
            TEST iTaskno
            CASE 1:
                Home;
            CASE 2:
                RobbiePlot;
            CASE 3:
                Screed 500,6000,0,11;
            CASE 4:
                PolishDemo;
            CASE 5:
                VacuumBed;
            DEFAULT:
                RAISE ERR_INVALID_INPUT;
            ENDTEST

        CASE 2:
            TaskToDo;
        DEFAULT:
            RAISE ERR_INVALID_INPUT;
        ENDTEST
    ERROR
        RAISE ;
    ENDPROC


    PROC TaskToDo()
        TPErase;
        TPReadNum iTaskno,"1Plt,2Scr,3Pol,4Vac,5Hel,6Pan,7Dat,8PH,9PV,10PP,11PN";
        TEST iTaskno
        CASE 1:
            Home;
        CASE 2:
            Home;
            MoveJ pHomeLoadout,v500,z50,tTCMaster;
        CASE 3:
            TPErase;
            TPWrite "Plotting: Enter 1 for formbox, 2 for circle/cross, 3 for grout tube,";
            TPWrite " 4 for square/cross, 5 for triangle.";
            TPReadNum iPlotType,"Enter Selection:";
            TPErase;
            IF iPlotType=1 THEN
                !Form box
                TPWrite "Enter the coordinates for each corner of the formwork.";
                TPReadNum iCoord1x,"Enter first coordinate X value";
                TPReadNum iCoord1y,"Enter first coordinate y value";
                TPReadNum iCoord2x,"Enter second coordinate X value";
                TPReadNum iCoord2y,"Enter second coordinate y value";
                TPReadNum iCoord3x,"Enter third coordinate X value";
                TPReadNum iCoord3y,"Enter third coordinate y value";
                TPReadNum iCoord4x,"Enter fourth coordinate X value";
                TPReadNum iCoord4y,"Enter fourth coordinate y value";
                IF iCoord1x<BedXmin OR iCoord1y<BedYmin OR iCoord2x<BedXmin OR iCoord2y<BedYmin OR iCoord3x<BedXmin OR iCoord3y<BedYmin OR iCoord4x<BedXmin OR iCoord4y<BedYmin OR iCoord1x>BedXmax OR iCoord1y>BedYmax OR iCoord2x>BedXmax OR iCoord2y>BedYmax OR iCoord3x>BedXmax OR iCoord3y>BedYmax OR iCoord4x>BedXmax OR iCoord4y>BedYmax OR (iCoord1x*iCoord1x+iCoord1y*iCoord1y<2560000) OR (iCoord2x*iCoord2x+iCoord2y*iCoord2y<2560000) OR (iCoord3x*iCoord3x+iCoord3y*iCoord3y<2560000) OR (iCoord4x*iCoord4x+iCoord4y*iCoord4y<2560000) THEN
                    RAISE ERR_INVALID_INPUT;
                ENDIF
                PlotRect iCoord1x,iCoord1y,iCoord2x,iCoord2y,iCoord3x,iCoord3y,iCoord4x,iCoord4y;

            ELSEIF iPlotType=2 THEN
                !ferrule - Circle with cross
                TPWrite "Enter the coordinates for the centre position of the ferrule.";
                TPReadNum iCoord1x,"Enter centre coordinate X value";
                TPReadNum iCoord1y,"Enter centre coordinate y value";

                IF (iCoord1x-PlotCircleD)<BedXmin OR (iCoord1y-PlotCircleD)<BedYmin OR (iCoord1x+PlotCircleD)>BedXmax OR (iCoord1y+PlotCircleD)>BedYmax OR ((iCoord1x-PlotCircleD)*(iCoord1x-PlotCircleD)+(iCoord1y-PlotCircleD)*(iCoord1y-PlotCircleD)<2560000) THEN
                    RAISE ERR_INVALID_INPUT;
                ENDIF
                PlotCirc iCoord1x,iCoord1y,(PlotCircleD/2);
                PlotLine(iCoord1x-PlotCircleD/2-CrossHairExt),iCoord1y,(iCoord1x+PlotCircleD/2+CrossHairExt),iCoord1y;
                PlotLine iCoord1x,(iCoord1y-PlotCircleD/2-CrossHairExt),iCoord1x,(iCoord1y+PlotCircleD/2+CrossHairExt);

            ELSEIF iPlotType=3 THEN
                !Grout Rectangle
                TPWrite "Enter the edge coordinate coordinate, followed by the angle.";
                TPReadNum iCoord1x,"Enter centre coordinate X value";
                TPReadNum iCoord1y,"Enter centre coordinate y value";
                TPWrite "0 degrees is perpendicular, -90 degrees is left/CCW, +90 is right/CW.,";
                TPReadNum iAngle,"Enter the angle";
                TPErase;
                TPWrite "Enter the side for the grout tube to be placed.";
                TPWrite " ------3------ ";
                TPWrite " |           | ";
                TPWrite "2|     X     |4";
                TPWrite " |           | ";
                TPWrite " ------1------ ";
                TPWrite "ROBOT/TRACK SIDE";
                TPReadNum iPlotSide,"Enter side:";

                IF iAngle<-90 OR iAngle>90 THEN
                    RAISE ERR_INVALID_INPUT;
                ENDIF

                TEST iPlotSide
                CASE 1:
                    IF iCoord1x-GroutWidth/2*Cos(iAngle)<BedXmin OR iCoord1y+GroutWidth/2*Sin(iAngle)<BedYmin OR iCoord1x-GroutWidth/2*Cos(iAngle)+GroutHeight*Sin(iAngle)<BedXmin OR iCoord1y+GroutHeight*Cos(iAngle)+GroutWidth/2*Sin(iAngle)<BedYmin OR iCoord1x+GroutWidth/2*Cos(iAngle)+GroutHeight*Sin(iAngle)<BedXmin OR iCoord1y+GroutHeight*Cos(iAngle)-GroutWidth/2*Sin(iAngle)<BedYmin OR iCoord1x+GroutWidth/2*Cos(iAngle)<BedXmin OR iCoord1y-GroutWidth/2*Sin(iAngle)<BedYmin OR ((iCoord1x-GroutHeight)*(iCoord1x-GroutWidth)+(iCoord1y-GroutHeight)*(iCoord1y-GroutWidth)<2560000) THEN
                        RAISE ERR_INVALID_INPUT;
                    ENDIF

                    IF iCoord1x-GroutWidth/2*Cos(iAngle)>BedXmax OR iCoord1y+GroutWidth/2*Sin(iAngle)>BedYmax OR iCoord1x-GroutWidth/2*Cos(iAngle)+GroutHeight*Sin(iAngle)>BedXmax OR iCoord1y+GroutHeight*Cos(iAngle)+GroutWidth/2*Sin(iAngle)>BedYmax OR iCoord1x+GroutWidth/2*Cos(iAngle)+GroutHeight*Sin(iAngle)>BedXmax OR iCoord1y+GroutHeight*Cos(iAngle)-GroutWidth/2*Sin(iAngle)>BedYmax OR iCoord1x+GroutWidth/2*Cos(iAngle)>BedXmax OR iCoord1y-GroutWidth/2*Sin(iAngle)>BedYmax THEN
                        RAISE ERR_INVALID_INPUT;
                    ENDIF

                    PlotRect iCoord1x-GroutWidth/2*Cos(iAngle),iCoord1y+GroutWidth/2*Sin(iAngle),iCoord1x-GroutWidth/2*Cos(iAngle)+GroutHeight*Sin(iAngle),iCoord1y+GroutHeight*Cos(iAngle)+GroutWidth/2*Sin(iAngle),iCoord1x+GroutWidth/2*Cos(iAngle)+GroutHeight*Sin(iAngle),iCoord1y+GroutHeight*Cos(iAngle)-GroutWidth/2*Sin(iAngle),iCoord1x+GroutWidth/2*Cos(iAngle),iCoord1y-GroutWidth/2*Sin(iAngle);

                CASE 2:

                    IF iCoord1x-GroutWidth/2*Sin(iAngle)<BedXmin OR iCoord1y-GroutWidth/2*Cos(iAngle)<BedYmin OR iCoord1x+GroutWidth/2*Sin(iAngle)<BedXmin OR iCoord1y+GroutWidth/2*Cos(iAngle)<BedYmin OR iCoord1x+GroutWidth/2*Sin(iAngle)+GroutHeight*Cos(iAngle)<BedXmin OR iCoord1y-GroutHeight*Sin(iAngle)+GroutWidth/2*Cos(iAngle)<BedYmin OR iCoord1x-GroutWidth/2*Sin(iAngle)+GroutHeight*Cos(iAngle)<BedXmin OR iCoord1y-GroutHeight*Sin(iAngle)-GroutWidth/2*Cos(iAngle)<BedYmin OR ((iCoord1x-GroutHeight)*(iCoord1x-GroutWidth)+(iCoord1y-GroutHeight)*(iCoord1y-GroutWidth)<2560000) THEN
                        RAISE ERR_INVALID_INPUT;
                    ENDIF

                    IF iCoord1x-GroutWidth/2*Sin(iAngle)>BedXmax OR iCoord1y-GroutWidth/2*Cos(iAngle)>BedYmax OR iCoord1x+GroutWidth/2*Sin(iAngle)>BedXmax OR iCoord1y+GroutWidth/2*Cos(iAngle)>BedYmax OR iCoord1x+GroutWidth/2*Sin(iAngle)+GroutHeight*Cos(iAngle)>BedXmax OR iCoord1y-GroutHeight*Sin(iAngle)+GroutWidth/2*Cos(iAngle)>BedYmax OR iCoord1x-GroutWidth/2*Sin(iAngle)+GroutHeight*Cos(iAngle)>BedXmax OR iCoord1y-GroutHeight*Sin(iAngle)-GroutWidth/2*Cos(iAngle)>BedYmax THEN
                        RAISE ERR_INVALID_INPUT;
                    ENDIF

                    PlotRect iCoord1x-GroutWidth/2*Sin(iAngle),iCoord1y-GroutWidth/2*Cos(iAngle),iCoord1x+GroutWidth/2*Sin(iAngle),iCoord1y+GroutWidth/2*Cos(iAngle),iCoord1x+GroutWidth/2*Sin(iAngle)+GroutHeight*Cos(iAngle),iCoord1y-GroutHeight*Sin(iAngle)+GroutWidth/2*Cos(iAngle),iCoord1x-GroutWidth/2*Sin(iAngle)+GroutHeight*Cos(iAngle),iCoord1y-GroutHeight*Sin(iAngle)-GroutWidth/2*Cos(iAngle);

                CASE 3:

                    IF iCoord1x-GroutWidth/2*Cos(iAngle)-GroutHeight*Sin(iAngle)<BedXmin OR iCoord1y-GroutHeight*Cos(iAngle)+GroutWidth/2*Sin(iAngle)<BedYmin OR iCoord1x-GroutWidth/2*Cos(iAngle)<BedXmin OR iCoord1y+GroutWidth/2*Sin(iAngle)<BedYmin OR iCoord1x+GroutWidth/2*Cos(iAngle)<BedXmin OR iCoord1y-GroutWidth/2*Sin(iAngle)<BedYmin OR iCoord1x+GroutWidth/2*Cos(iAngle)-GroutHeight*Sin(iAngle)<BedXmin OR iCoord1y-GroutHeight*Cos(iAngle)-GroutWidth/2*Sin(iAngle)<BedYmin OR ((iCoord1x-GroutHeight)*(iCoord1x-GroutWidth)+(iCoord1y-GroutHeight)*(iCoord1y-GroutWidth)<2560000) THEN
                        RAISE ERR_INVALID_INPUT;
                    ENDIF

                    IF iCoord1x-GroutWidth/2*Cos(iAngle)-GroutHeight*Sin(iAngle)>BedXmax OR iCoord1y-GroutHeight*Cos(iAngle)+GroutWidth/2*Sin(iAngle)>BedYmax OR iCoord1x-GroutWidth/2*Cos(iAngle)>BedXmax OR iCoord1y+GroutWidth/2*Sin(iAngle)>BedYmax OR iCoord1x+GroutWidth/2*Cos(iAngle)>BedXmax OR iCoord1y-GroutWidth/2*Sin(iAngle)>BedYmax OR iCoord1x+GroutWidth/2*Cos(iAngle)-GroutHeight*Sin(iAngle)>BedXmax OR iCoord1y-GroutHeight*Cos(iAngle)-GroutWidth/2*Sin(iAngle)>BedYmax THEN
                        RAISE ERR_INVALID_INPUT;
                    ENDIF

                    PlotRect iCoord1x-GroutWidth/2*Cos(iAngle)-GroutHeight*Sin(iAngle),iCoord1y-GroutHeight*Cos(iAngle)+GroutWidth/2*Sin(iAngle),iCoord1x-GroutWidth/2*Cos(iAngle),iCoord1y+GroutWidth/2*Sin(iAngle),iCoord1x+GroutWidth*Cos(iAngle),iCoord1y-GroutWidth/2*Sin(iAngle),iCoord1x+GroutWidth/2*Cos(iAngle)-GroutHeight*Sin(iAngle),iCoord1y-GroutHeight*Cos(iAngle)-GroutWidth/2*Sin(iAngle);


                CASE 4:

                    IF iCoord1x-GroutWidth/2*Sin(iAngle)-GroutHeight*Cos(iAngle)<BedXmin OR iCoord1y+GroutHeight*Sin(iAngle)-GroutWidth/2*Cos(iAngle)<BedYmin OR iCoord1x+GroutWidth/2*Sin(iAngle)-GroutHeight*Cos(iAngle)<BedXmin OR iCoord1y+GroutHeight*Sin(iAngle)+GroutWidth/2*Cos(iAngle)<BedYmin OR iCoord1x+GroutWidth/2*Sin(iAngle)<BedXmin OR iCoord1y+GroutWidth/2*Cos(iAngle)<BedYmin OR iCoord1x-GroutWidth/2*Sin(iAngle)<BedXmin OR iCoord1y-GroutWidth/2*Cos(iAngle)<BedYmin OR ((iCoord1x-GroutHeight)*(iCoord1x-GroutWidth)+(iCoord1y-GroutHeight)*(iCoord1y-GroutWidth)<2560000) THEN
                        RAISE ERR_INVALID_INPUT;
                    ENDIF

                    IF iCoord1x-GroutWidth/2*Sin(iAngle)-GroutHeight*Cos(iAngle)>BedXmax OR iCoord1y+GroutHeight*Sin(iAngle)-GroutWidth/2*Cos(iAngle)>BedYmax OR iCoord1x+GroutWidth/2*Sin(iAngle)-GroutHeight*Cos(iAngle)>BedXmax OR iCoord1y+GroutHeight*Sin(iAngle)+GroutWidth/2*Cos(iAngle)>BedYmax OR iCoord1x+GroutWidth/2*Sin(iAngle)>BedXmax OR iCoord1y+GroutWidth/2*Cos(iAngle)>BedYmax OR iCoord1x-GroutWidth/2*Sin(iAngle)>BedXmax OR iCoord1y-GroutWidth/2*Cos(iAngle)>BedYmax THEN
                        RAISE ERR_INVALID_INPUT;
                    ENDIF

                    PlotRect iCoord1x-GroutWidth/2*Sin(iAngle)-GroutHeight*Cos(iAngle),iCoord1y+GroutHeight*Sin(iAngle)-GroutWidth/2*Cos(iAngle),iCoord1x+GroutWidth/2*Sin(iAngle)-GroutHeight*Cos(iAngle),iCoord1y+GroutHeight*Sin(iAngle)+GroutWidth/2*Cos(iAngle),iCoord1x+GroutWidth/2*Sin(iAngle),iCoord1y+GroutWidth/2*Cos(iAngle),iCoord1x-GroutWidth/2*Sin(iAngle),iCoord1y-GroutWidth/2*Cos(iAngle);
                DEFAULT:
                    RAISE ERR_INVALID_INPUT;

                ENDTEST

            ELSEIF iPlotType=4 THEN
                ! Rectangle with cross
                TPWrite "Enter the centre coordinate";
                TPReadNum iCoord1x,"Enter centre coordinate X value";
                TPReadNum iCoord1y,"Enter centre coordinate y value";

                IF (iCoord1x-TieInWidth/2)<BedXmin OR (iCoord1y-TieInWidth/2)<BedYmin OR (iCoord1x+TieInWidth/2)>BedXmax OR (iCoord1y+TieInWidth/2)>BedYmax OR (iCoord1x*iCoord1x+iCoord1y*iCoord1y<2560000) THEN
                    RAISE ERR_INVALID_INPUT;
                ENDIF
                PlotRect iCoord1x-TieInWidth/2,iCoord1y-TieInWidth/2,iCoord1x-TieInWidth/2,iCoord1y+TieInWidth/2,iCoord1x+TieInWidth/2,iCoord1y+TieInWidth/2,iCoord1x+TieInWidth/2,iCoord1y-TieInWidth/2;
                PlotLine iCoord1x,iCoord1y-TieInWidth/2,iCoord1x,iCoord1y+TieInWidth/2;
                PlotLine iCoord1x-TieInWidth/2,iCoord1y,iCoord1x+TieInWidth/2,iCoord1y;


            ELSEIF iPlotType=5 THEN
                !triangle
                TPWrite "Enter the edge coordinate and angle";
                TPReadNum iCoord1x,"Enter centre coordinate X value";
                TPReadNum iCoord1y,"Enter centre coordinate y value";
                TPWrite "0 degrees is up, 90 is pointing right/CW, 180 pointing down, 270 pointing left.";
                TPReadNum iAngle,"Enter the angle";

                IF (iAngle>=0 AND iAngle<=45) OR (iAngle>315 AND iAngle<=360) THEN
                    TriangleAngle:=iAngle;
                    IF iCoord1x-TriangleBase/2*Cos(TriangleAngle)<BedXmin OR iCoord1y+TriangleBase/2*Sin(TriangleAngle)<BedYmin OR iCoord1x+TriangleHeight*Sin(TriangleAngle)<BedXmin OR iCoord1y+TriangleHeight*Cos(TriangleAngle)<BedYmin OR iCoord1x+TriangleBase/2*Cos(TriangleAngle)<BedXmin OR iCoord1y-TriangleBase/2*Sin(TriangleAngle)<BedYmin OR iCoord1x-TriangleBase/2*Cos(TriangleAngle)>BedXmax OR iCoord1y+TriangleBase/2*Sin(TriangleAngle)>BedYmax OR iCoord1x+TriangleHeight*Sin(TriangleAngle)>BedXmax OR iCoord1y+TriangleHeight*Cos(TriangleAngle)>BedYmax OR iCoord1x+TriangleBase/2*Cos(TriangleAngle)>BedXmax OR iCoord1y-TriangleBase/2*Sin(TriangleAngle)>BedYmax OR (iCoord1x*iCoord1x+iCoord1y*iCoord1y<2560000) THEN
                        RAISE ERR_INVALID_INPUT;
                    ENDIF
                    PlotLine iCoord1x-TriangleBase/2*Cos(TriangleAngle),iCoord1y+TriangleBase/2*Sin(TriangleAngle),iCoord1x+TriangleHeight*Sin(TriangleAngle),iCoord1y+TriangleHeight*Cos(TriangleAngle);
                    PlotLine iCoord1x+TriangleHeight*Sin(TriangleAngle),iCoord1y+TriangleHeight*Cos(TriangleAngle),iCoord1x+TriangleBase/2*Cos(TriangleAngle),iCoord1y-TriangleBase/2*Sin(TriangleAngle);
                    PlotLine iCoord1x+TriangleBase/2*Cos(TriangleAngle),iCoord1y-TriangleBase/2*Sin(TriangleAngle),iCoord1x-TriangleBase/2*Cos(TriangleAngle),iCoord1y+TriangleBase/2*Sin(TriangleAngle);

                ELSEIF iAngle<=135 AND iAngle>45 THEN
                    TriangleAngle:=iAngle-90;
                    IF iCoord1x-TriangleBase/2*Sin(TriangleAngle)<BedXmin OR iCoord1y-TriangleBase/2*Cos(TriangleAngle)<BedYmin OR iCoord1x+TriangleBase/2*Sin(TriangleAngle)<BedXmin OR iCoord1y-TriangleBase/2*Sin(TriangleAngle)<BedYmin OR iCoord1x+TriangleHeight*Cos(TriangleAngle)<BedXmin OR iCoord1y-TriangleHeight*Sin(TriangleAngle)<BedYmin OR iCoord1x-TriangleBase/2*Sin(TriangleAngle)>BedXmax OR iCoord1y-TriangleBase/2*Cos(TriangleAngle)>BedYmax OR iCoord1x+TriangleBase/2*Sin(TriangleAngle)>BedXmax OR iCoord1y-TriangleBase/2*Sin(TriangleAngle)>BedYmax OR iCoord1x+TriangleHeight*Cos(TriangleAngle)>BedXmax OR iCoord1y-TriangleHeight*Sin(TriangleAngle)>BedYmax OR (iCoord1x*iCoord1x+iCoord1y*iCoord1y<2560000) THEN

                        RAISE ERR_INVALID_INPUT;
                    ENDIF
                    PlotLine iCoord1x-TriangleBase/2*Sin(TriangleAngle),iCoord1y-TriangleBase/2*Cos(TriangleAngle),iCoord1x+TriangleBase/2*Sin(TriangleAngle),iCoord1y+TriangleBase/2*Cos(TriangleAngle);
                    PlotLine iCoord1x+TriangleBase/2*Sin(TriangleAngle),iCoord1y+TriangleBase/2*Cos(TriangleAngle),iCoord1x+TriangleHeight*Cos(TriangleAngle),iCoord1y-TriangleHeight*Sin(TriangleAngle);
                    PlotLine iCoord1x+TriangleHeight*Cos(TriangleAngle),iCoord1y-TriangleHeight*Sin(TriangleAngle),iCoord1x-TriangleBase/2*Sin(TriangleAngle),iCoord1y-TriangleBase/2*Cos(TriangleAngle);

                ELSEIF iAngle<=225 AND iAngle>135 THEN
                    TriangleAngle:=iAngle-180;
                    IF iCoord1x-TriangleHeight*Sin(TriangleAngle)<BedXmin OR iCoord1y-TriangleHeight*Sin(TriangleAngle)<BedYmin OR iCoord1x-TriangleBase/2*Cos(TriangleAngle)<BedXmin OR iCoord1y+TriangleBase/2*Sin(TriangleAngle)<BedYmin OR iCoord1x+TriangleBase/2*Cos(TriangleAngle)<BedXmin OR iCoord1y-TriangleBase/2*Sin(TriangleAngle)<BedYmin OR iCoord1x-TriangleHeight*Sin(TriangleAngle)>BedXmax OR iCoord1y-TriangleHeight*Sin(TriangleAngle)>BedYmax OR iCoord1x-TriangleBase/2*Cos(TriangleAngle)>BedXmax OR iCoord1y+TriangleBase/2*Sin(TriangleAngle)>BedYmax OR iCoord1x+TriangleBase/2*Cos(TriangleAngle)>BedXmax OR iCoord1y-TriangleBase/2*Sin(TriangleAngle)>BedYmax OR (iCoord1x*iCoord1x+iCoord1y*iCoord1y<2560000) THEN

                        RAISE ERR_INVALID_INPUT;
                    ENDIF
                    PlotLine iCoord1x-TriangleHeight*Sin(TriangleAngle),iCoord1y-TriangleHeight*Cos(TriangleAngle),iCoord1x-TriangleBase/2*Cos(TriangleAngle),iCoord1y+TriangleBase/2*Sin(TriangleAngle);
                    PlotLine iCoord1x-TriangleBase/2*Cos(TriangleAngle),iCoord1y+TriangleBase/2*Sin(TriangleAngle),iCoord1x+TriangleBase/2*Cos(TriangleAngle),iCoord1y-TriangleBase/2*Sin(TriangleAngle);
                    PlotLine iCoord1x+TriangleBase/2*Cos(TriangleAngle),iCoord1y-TriangleBase/2*Sin(TriangleAngle),iCoord1x-TriangleHeight*Sin(TriangleAngle),iCoord1y-TriangleHeight*Cos(TriangleAngle);

                ELSEIF iAngle<=315 AND iAngle>225 THEN
                    TriangleAngle:=iAngle-270;
                    IF iCoord1x-TriangleBase/2*Sin(TriangleAngle)<BedXmin OR iCoord1y-TriangleBase/2*Cos(TriangleAngle)<BedYmin OR iCoord1x+TriangleHeight*Cos(TriangleAngle)<BedXmin OR iCoord1y-TriangleHeight*Sin(TriangleAngle)<BedYmin OR iCoord1x+TriangleBase/2*Sin(TriangleAngle)<BedXmin OR iCoord1y+TriangleBase/2*Cos(TriangleAngle)<BedYmin OR iCoord1x-TriangleBase/2*Sin(TriangleAngle)>BedXmax OR iCoord1y-TriangleBase/2*Cos(TriangleAngle)>BedYmax OR iCoord1x+TriangleHeight*Cos(TriangleAngle)>BedXmax OR iCoord1y-TriangleHeight*Sin(TriangleAngle)>BedYmax OR iCoord1x+TriangleBase/2*Sin(TriangleAngle)>BedXmax OR iCoord1y+TriangleBase/2*Cos(TriangleAngle)>BedYmax OR (iCoord1x*iCoord1x+iCoord1y*iCoord1y<2560000) THEN
                        RAISE ERR_INVALID_INPUT;
                    ENDIF

                    PlotLine iCoord1x-TriangleBase/2*Sin(TriangleAngle),iCoord1y-TriangleBase/2*Cos(TriangleAngle),iCoord1x-TriangleHeight*Cos(TriangleAngle),iCoord1y+TriangleHeight*Sin(TriangleAngle);
                    PlotLine iCoord1x-TriangleHeight*Cos(TriangleAngle),iCoord1y+TriangleHeight*Sin(TriangleAngle),iCoord1x+TriangleBase/2*Sin(TriangleAngle),iCoord1y+TriangleBase/2*Cos(TriangleAngle);
                    PlotLine iCoord1x+TriangleBase/2*Sin(TriangleAngle),iCoord1y+TriangleBase/2*Cos(TriangleAngle),iCoord1x-TriangleBase/2*Sin(TriangleAngle),iCoord1y-TriangleBase/2*Cos(TriangleAngle);



                ELSE
                    RAISE ERR_INVALID_INPUT;
                ENDIF

            ELSE
                RAISE ERR_INVALID_INPUT;
            ENDIF

        CASE 4:
            TPWrite "Enter the x coordinates for the start and end positions of the formwork.";
            TPReadNum iCoord1x,"Enter first coordinate X value";
            TPReadNum iCoord2x,"Enter second coordinate x value";
            TPReadNum iZoffset,"Enter Z offset (-ve for lower, +ve for higher, 0 for no change:";
            IF iCoord1x<0 OR iCoord2x<0 OR iCoord1x>7900 OR iCoord2x>7900 THEN
                RAISE ERR_INVALID_INPUT;
            ENDIF

            IF iCoord1x>iCoord2x THEN
                iCoordTemp:=iCoord1x;
                iCoord1x:=iCoord2x;
                iCoord2x:=iCoordTemp;
            ENDIF

            Screed iCoord1x,iCoord2x,iZoffset,11;

        CASE 5:
            TPWrite "Enter the coordinates for the corner closest to the robot home position.";
            TPReadNum iCoord1x,"Enter first coordinate X value";
            TPReadNum iCoord1y,"Enter first coordinate y value";
            TPWrite "Enter the coordinates for the corner furthest from the robot home position.";
            TPReadNum iCoord2x,"Enter second coordinate X value";
            TPReadNum iCoord2y,"Enter second coordinate y value";
            TPReadNum iHeliBladeSpeed,"Enter speed of heli blades (rpm from 0 - 140).";
            TPReadNum iHeliBladeAngle,"Enter heli blade angle (degrees from 0 - 12).";
            TPReadNum iZoffset,"Enter Z offset (-ve for lower, +ve for higher, 0 for no change:";
            TPReadNum iHeliPan,"Enter 1 for pan attachment or 2 for just blades:";
            !TPReadNum iLRUD,"Enter 1 for left/right movement or 2 for up/down movement:";

            IF iCoord1x<0 OR iCoord1y<0 OR iCoord2x<0 OR iCoord2y<0 OR iCoord1x>8800 OR iCoord1y>2400 OR iCoord2x>8800 OR iCoord2y>2400 OR iHeliBladeSpeed<0 OR iHeliBladeSpeed>140 OR iHeliBladeAngle<0 OR iHeliBladeAngle>12 OR iCoord2y<iCoord1y OR iCoord2x<iCoord1x OR iHeliPan<1 OR iHeliPan>2 THEN
                RAISE ERR_INVALID_INPUT;
            ENDIF
            !IF iLRUD=1 THEN
            HeliTrowelLR iCoord1x,iCoord1y,iCoord2x,iCoord2y,iHeliBladeSpeed,iHeliBladeAngle,iZoffset,iHeliPan;
            !ELSEIF iLRUD=2 THEN
            !    HeliTrowelUD iCoord1x,iCoord1y,iCoord2x,iCoord2y,iHeliBladeSpeed,iHeliBladeAngle,iZoffset,iHeliPan;
            !ELSE
            !    RAISE ERR_INVALID_INPUT;
            !ENDIF

        CASE 6:
            VacuumBed;

        CASE 7:
            Polish;
        DEFAULT:
            RAISE ERR_INVALID_INPUT;
        ENDTEST
    ERROR
        RAISE ;
    ENDPROC

    PROC HeliTrowelLR(num HeliStartX,num HeliStartY,num HeliEndX,num HeliEndY,num HeliSpeed,num HeliAngle,num HeliZoffset,num IsPan)

        pHeliStart.trans:=[HeliStartX,HeliStartY,(FormHeight+HeliZoffset)];
        pHeliEnd.trans:=[HeliEndX,HeliEndY,(FormHeight+HeliZoffset)];

        IF ToolNum<>2 THEN
            Home;
            Heli_Pickup;
        ENDIF

        IF pHeliStart.trans.y<1800 THEN
            pHeliStart.extax.eax_a:=Bed1Wyong.uframe.trans.x-pHeliStart.trans.x+1000+HeliBladeWidth/2;
            pHeliEnd.extax.eax_a:=Bed1Wyong.uframe.trans.x-pHeliEnd.trans.x+1000-HeliBladeWidth/2;
        ELSE
            pHeliStart.extax.eax_a:=Bed1Wyong.uframe.trans.x-pHeliStart.trans.x+HeliBladeWidth/2;
            pHeliEnd.extax.eax_a:=Bed1Wyong.uframe.trans.x-pHeliEnd.trans.x-HeliBladeWidth/2;
        ENDIF

        IF (pHeliEnd.trans.y-pHeliStart.trans.y)<HeliBladeWidth THEN
            HeliPasses:=1;
            HeliPassWidth:=0;
        ELSE
            HeliPasses:=((pHeliEnd.trans.y-pHeliStart.trans.y-HeliBladeWidth) DIV HeliOverlapMin);
            IF HeliPasses MOD 2<>0 THEN
                Incr HeliPasses;
            ENDIF
            IF HeliPasses<1 THEN
                HeliPasses:=1;
            ENDIF
            HeliPassWidth:=(pHeliEnd.trans.y-(HeliBladeWidth/2)-(pHeliStart.trans.y+(HeliBladeWidth/2)))/HeliPasses;
        ENDIF

        pHeliTempS:=pHeliStart;
        pHeliTempE:=pHeliEnd;
        pHeliTempS.trans.x:=pHeliStart.trans.x-(HeliBladeWidth/2)+300;
        pHeliTempS.trans.y:=pHeliStart.trans.y+(HeliBladeWidth/2);
        pHeliTempE.trans.x:=pHeliEnd.trans.x-(HeliBladeWidth/2)-300;
        pHeliTempE.trans.y:=pHeliEnd.trans.y-(HeliBladeWidth/2);
        pHeliTempS.trans.z:=FormHeight+HeliZoffset;
        pHeliTempE.trans.z:=FormHeight+HeliZoffset;

        MoveJ Offs(pHeliTempS,0,0,300),v500,z5,tHeli\WObj:=Bed1Wyong;

        IF IsPan=2 THEN
            HeliBlade_Angle HeliAngle;
            HeliBladeSpeed HeliSpeed,"FWD";
            WaitTime\inpos,4;
        ENDIF

        IF IsPan=1 THEN
            MoveJ Offs(pHeliTempS,0,0,75),v500,z5,tHeli\WObj:=Bed1Wyong;
            Stop;
        ENDIF
        HeliZ pHeliTempS.trans.x,pHeliTempS.trans.y,TRUE;
        HeliZOffs:=HighestArray(HeliZArrayCounter);

        MoveL Offs(pHeliTempS,0,0,PitchZOffset+HeliZOffs),v50,z5,tHeli\WObj:=Bed1Wyong;
        pHeliTemp1:=pHeliTempS;
        pHeliTemp2:=pHeliTempS;
        pHeliTemp2.trans.x:=pHeliTempE.trans.x;
        pHeliTemp2.extax.eax_a:=pHeliTempE.extax.eax_a;

        IF IsPan=1 THEN
            Stop;
            HeliBlade_Angle HeliAngle;
            HeliBladeSpeed HeliSpeed,"FWD";
            WaitTime\inpos,5;
        ENDIF

        HeliDiv:=(pHeliTempE.trans.x-pHeliTempS.trans.x) DIV XGridSpacing;

        FOR i FROM 0 to (2*HeliPasses) DO
            IF (i MOD 2)=0 THEN

                !Needs fixing of -1*x
                FOR M FROM 0 TO (HeliDiv-1) DO
                    HeliZ(pHeliTemp1.trans.x-M*XGridSpacing+XGridSpacing),(pHeliTemp1.trans.y+HeliPassWidth*i/2),TRUE;
                    HeliZOffs:=HighestArray(HeliZArrayCounter);
                    IF (HeliPassWidth*i/2+pHeliTemp1.trans.y)>1600 THEN
                        pHeliTemp1.extax.eax_a:=pHeliTemp1.trans.x+Bed1Wyong.uframe.trans.x-M*XGridSpacing;
                    ELSE
                        pHeliTemp1.extax.eax_a:=pHeliTemp1.trans.x+Bed1Wyong.uframe.trans.x+1000-M*XGridSpacing;
                    ENDIF
                    MoveL Offs(pHeliTemp1,-1*M*XGridSpacing,HeliPassWidth*i/2,PitchZOffset+HeliZOffs),vHeli,z5,tHeli\WObj:=Bed1Wyong;
                    !Across Right
                ENDFOR

                IF (HeliPassWidth*i/2+pHeliTemp2.trans.y)>1600 THEN
                    pHeliTemp2.extax.eax_a:=pHeliTemp2.trans.x+Bed1Wyong.uframe.trans.x;
                ELSE
                    pHeliTemp2.extax.eax_a:=pHeliTemp2.trans.x+Bed1Wyong.uframe.trans.x+1000;
                ENDIF
                HeliZ(pHeliTemp2.trans.x),(pHeliTemp1.trans.y+HeliPassWidth*i/2),TRUE;
                HeliZOffs:=HighestArray(HeliZArrayCounter);
                MoveL Offs(pHeliTemp2,0,HeliPassWidth*i/2,PitchZOffset+HeliZOffs),vHeli,z5,tHeli\WObj:=Bed1Wyong;
                !Across Right

                IF i=(2*HeliPasses) THEN
                ELSE
                    HeliZ(pHeliTemp2.trans.x),(pHeliTemp1.trans.y+HeliPassWidth*(i+1)/2),TRUE;
                    HeliZOffs:=HighestArray(HeliZArrayCounter);
                    IF (HeliPassWidth*(i+1)/2+pHeliTemp2.trans.y)>1600 THEN
                        pHeliTemp2.extax.eax_a:=pHeliTemp2.trans.x+Bed1Wyong.uframe.trans.x;
                    ELSE
                        pHeliTemp2.extax.eax_a:=pHeliTemp2.trans.x+Bed1Wyong.uframe.trans.x+1000;
                    ENDIF
                    MoveL Offs(pHeliTemp2,0,HeliPassWidth*(i+1)/2,PitchZOffset+HeliZOffs),vHeli,z5,tHeli\WObj:=Bed1Wyong;
                    !Up

                    FOR M FROM (HeliDiv-1) TO 0 DO
                        HeliZ(pHeliTemp1.trans.x-M*XGridSpacing),(pHeliTemp1.trans.y+HeliPassWidth*(i+1)/2),TRUE;
                        HeliZOffs:=HighestArray(HeliZArrayCounter);
                        IF (HeliPassWidth*(i+1)/2+pHeliTemp1.trans.y)>1600 THEN
                            pHeliTemp1.extax.eax_a:=pHeliTemp1.trans.x+Bed1Wyong.uframe.trans.x-M*XGridSpacing;
                        ELSE
                            pHeliTemp1.extax.eax_a:=pHeliTemp1.trans.x+Bed1Wyong.uframe.trans.x+1000-M*XGridSpacing;
                        ENDIF
                        MoveL Offs(pHeliTemp1,-1*M*XGridSpacing,HeliPassWidth*(i+1)/2,PitchZOffset+HeliZOffs),vHeli,z5,tHeli\WObj:=Bed1Wyong;
                        !Across Left
                    ENDFOR

                ENDIF

            ENDIF
        ENDFOR

        IF IsPan=1 THEN
            WaitTime\InPos,0.1;
            HeliBladeSpeed 0,"FWD";
            WaitTime\inpos,8;
            MoveL Offs(pHeliTemp2,0,HeliPassWidth*2*HeliPasses/2,18+PitchZOffset+HeliZOffs),v50,fine,tHeli\WObj:=Bed1Wyong;
            HeliBladeSpeed 20,"REV";
            WaitTime\inpos,0.6;
            HeliBladeSpeed 0,"FWD";
            Stop;
        ENDIF
        MoveL Offs(pHeliTemp2,0,HeliPassWidth*2*HeliPasses/2,50+PitchZOffset+HeliZOffs),v50,z5,tHeli\WObj:=Bed1Wyong;

        HeliBladeSpeed 0,"FWD";
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tHeli\WObj:=wobj0);
        MoveJ Offs(pHeliTemp2,0,2500-CurrentPos.trans.y,300),v500,z5,tHeli\WObj:=Bed1Wyong;
        MoveJ Offs(ptHeli,0,0,500),v500,fine,tHeli;

    ENDPROC

    PROC HeliPanLR(num HeliStartX,num HeliStartY,num HeliEndX,num HeliEndY,speeddata HeliVTCP,num HeliSpeed,num HeliZoffset)

        pHeliStart.trans:=[-1*HeliStartX,HeliStartY,(FormHeight+14+HeliZoffset)];
        pHeliEnd.trans:=[-1*HeliEndX,HeliEndY,(FormHeight+14+HeliZoffset)];

        IF ToolNum<>2 THEN
            Home;
            Heli_Pickup;
        ELSE
            pTemp:=ptHeli;
            pTemp.extax.eax_a:=ptHeli.extax.eax_a-2000;
            pTemp.trans.z:=ptHeli.trans.z+800;
            MoveJ Offs(pTemp,-2000,0,0),v500,fine,tHeli;
        ENDIF

        IF pHeliStart.trans.y<1800 THEN
            pHeliStart.extax.eax_a:=Bed1Wyong.uframe.trans.x+pHeliStart.trans.x+1000+HeliBladeWidth/2;
            pHeliEnd.extax.eax_a:=Bed1Wyong.uframe.trans.x+pHeliEnd.trans.x+1000-HeliBladeWidth/2;
        ELSE
            pHeliStart.extax.eax_a:=Bed1Wyong.uframe.trans.x+pHeliStart.trans.x+HeliBladeWidth/2;
            pHeliEnd.extax.eax_a:=Bed1Wyong.uframe.trans.x+pHeliEnd.trans.x-HeliBladeWidth/2;
        ENDIF

        IF (pHeliEnd.trans.y-pHeliStart.trans.y)<HeliBladeWidth THEN
            HeliPasses:=1;
            HeliPassWidth:=0;
        ELSE
            HeliPasses:=((pHeliEnd.trans.y-pHeliStart.trans.y-HeliBladeWidth) DIV PanOverlapMin);
            IF HeliPasses MOD 2<>0 THEN
                Incr HeliPasses;
            ENDIF
            IF HeliPasses<1 THEN
                HeliPasses:=1;
            ENDIF
            HeliPassWidth:=(pHeliEnd.trans.y-(HeliBladeWidth/2)-(pHeliStart.trans.y+(HeliBladeWidth/2)))/HeliPasses;
        ENDIF

        pHeliTempS:=pHeliStart;
        pHeliTempE:=pHeliEnd;
        pHeliTempS.trans.x:=pHeliStart.trans.x+(HeliBladeWidth/2)-300;
        pHeliTempS.trans.y:=pHeliStart.trans.y+(HeliBladeWidth/2);
        pHeliTempE.trans.x:=pHeliEnd.trans.x-(HeliBladeWidth/2)+300;
        pHeliTempE.trans.y:=pHeliEnd.trans.y-(HeliBladeWidth/2);
        pHeliTempS.trans.z:=FormHeight+HeliZoffset;
        pHeliTempE.trans.z:=FormHeight+HeliZoffset;

        MoveJ Offs(pHeliTempS,0,0,300),v500,z5,tHeli\WObj:=Bed1Wyong;

        MoveJ Offs(pHeliTempS,0,0,75),v500,z5,tHeli\WObj:=Bed1Wyong;
        TPWrite "Place pan under blades.";
        Stop;

        HeliZ pHeliTempS.trans.x,pHeliTempS.trans.y,TRUE;
        HeliZOffs:=HighestArray(HeliZArrayCounter);

        MoveL Offs(pHeliTempS,0,0,PitchZOffset+HeliZOffs),v50,z5,tHeli\WObj:=Bed1Wyong;
        pHeliTemp1:=pHeliTempS;
        pHeliTemp2:=pHeliTempS;
        pHeliTemp2.trans.x:=pHeliTempE.trans.x;
        pHeliTemp2.extax.eax_a:=pHeliTempE.extax.eax_a;

        TPWrite "Check blades are under tabs plane";
        Stop;
        HeliBlade_Angle 0;
        HeliBladeSpeed HeliSpeed,"FWD";
        WaitTime\inpos,5;

        HeliDiv:=(abs(pHeliTempE.trans.x)-abs(pHeliTempS.trans.x)) DIV XGridSpacing;

        FOR i FROM 0 to (2*HeliPasses) DO
            IF (i MOD 2)=0 THEN


                FOR M FROM 0 TO (HeliDiv-1) DO
                    HeliZ(pHeliTemp1.trans.x-M*XGridSpacing-XGridSpacing),(pHeliTemp1.trans.y+HeliPassWidth*i/2),TRUE;
                    HeliZOffs:=HighestArray(HeliZArrayCounter);
                    IF (HeliPassWidth*i/2+pHeliTemp1.trans.y)>1600 THEN
                        pHeliTemp1.extax.eax_a:=Bed1Wyong.uframe.trans.x+pHeliTemp1.trans.x-M*XGridSpacing;
                    ELSE
                        pHeliTemp1.extax.eax_a:=Bed1Wyong.uframe.trans.x+pHeliTemp1.trans.x+1000-M*XGridSpacing;
                    ENDIF
                    MoveL Offs(pHeliTemp1,-1*M*XGridSpacing,HeliPassWidth*i/2,PitchZOffset+HeliZOffs),HeliVTCP,z5,tHeli\WObj:=Bed1Wyong;
                    !Across Left
                ENDFOR

                IF (HeliPassWidth*i/2+pHeliTemp2.trans.y)>1600 THEN
                    pHeliTemp2.extax.eax_a:=Bed1Wyong.uframe.trans.x+pHeliTemp2.trans.x;
                ELSE
                    pHeliTemp2.extax.eax_a:=Bed1Wyong.uframe.trans.x+pHeliTemp2.trans.x+1000;
                ENDIF
                HeliZ(pHeliTemp2.trans.x),(pHeliTemp1.trans.y+HeliPassWidth*i/2),TRUE;
                HeliZOffs:=HighestArray(HeliZArrayCounter);
                MoveL Offs(pHeliTemp2,0,HeliPassWidth*i/2,PitchZOffset+HeliZOffs),HeliVTCP,z5,tHeli\WObj:=Bed1Wyong;
                !Across Left final position

                IF i=(2*HeliPasses) THEN
                ELSE
                    HeliZ(pHeliTemp2.trans.x),(pHeliTemp1.trans.y+HeliPassWidth*(i+1)/2),TRUE;
                    HeliZOffs:=HighestArray(HeliZArrayCounter);
                    IF (HeliPassWidth*(i+1)/2+pHeliTemp2.trans.y)>1600 THEN
                        pHeliTemp2.extax.eax_a:=Bed1Wyong.uframe.trans.x+pHeliTemp2.trans.x;
                    ELSE
                        pHeliTemp2.extax.eax_a:=Bed1Wyong.uframe.trans.x+pHeliTemp2.trans.x+1000;
                    ENDIF
                    MoveL Offs(pHeliTemp2,0,HeliPassWidth*(i+1)/2,PitchZOffset+HeliZOffs),HeliVTCP,z5,tHeli\WObj:=Bed1Wyong;
                    !Up

                    FOR M FROM (HeliDiv-1) TO 0 DO
                        HeliZ(pHeliTemp1.trans.x-M*XGridSpacing),(pHeliTemp1.trans.y+HeliPassWidth*(i+1)/2),TRUE;
                        HeliZOffs:=HighestArray(HeliZArrayCounter);
                        IF (HeliPassWidth*(i+1)/2+pHeliTemp1.trans.y)>1600 THEN
                            pHeliTemp1.extax.eax_a:=Bed1Wyong.uframe.trans.x+pHeliTemp1.trans.x-M*XGridSpacing;
                        ELSE
                            pHeliTemp1.extax.eax_a:=Bed1Wyong.uframe.trans.x+pHeliTemp1.trans.x+1000-M*XGridSpacing;
                        ENDIF
                        MoveL Offs(pHeliTemp1,-1*M*XGridSpacing,HeliPassWidth*(i+1)/2,PitchZOffset+HeliZOffs),HeliVTCP,z5,tHeli\WObj:=Bed1Wyong;
                        !Across Right
                    ENDFOR

                ENDIF

            ENDIF
        ENDFOR


        WaitTime\InPos,0.1;
        HeliBladeSpeed 0,"FWD";
        WaitTime\inpos,8;
        MoveL Offs(pHeliTemp2,0,HeliPassWidth*2*HeliPasses/2,18+PitchZOffset+HeliZOffs),v50,fine,tHeli\WObj:=Bed1Wyong;
        HeliBladeSpeed 20,"REV";
        WaitTime\inpos,0.6;
        HeliBladeSpeed 0,"FWD";
        TPWrite "Check pan is dettached.";
        Stop;


        MoveL Offs(pHeliTemp2,0,HeliPassWidth*2*HeliPasses/2,50+PitchZOffset+HeliZOffs),v50,z5,tHeli\WObj:=Bed1Wyong;

        HeliBladeSpeed 0,"FWD";
        pTemp:=ptHeli;
        pTemp.extax.eax_a:=ptHeli.extax.eax_a-2000;
        pTemp.trans.z:=ptHeli.trans.z+500;
        MoveJ Offs(pTemp,-2000,0,0),v500,fine,tHeli;
        CurrentJoints:=CJointT();
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tHeli\WObj:=wobj0);
        MoveJ Offs(pHeliTemp2,0,2500-CurrentPos.trans.y,300),v500,z5,tHeli\WObj:=Bed1Wyong;
        TPWrite "Clean off pan.";
        Stop;

    ENDPROC

    PROC HeliTrowelUD(num HeliStartX,num HeliStartY,num HeliEndX,num HeliEndY,num HeliSpeed,num HeliAngle,num HeliZoffset,num IsPan)

        pHeliStart.trans:=[-1*HeliStartX,HeliStartY,(FormHeight+30+HeliZoffset)];
        pHeliEnd.trans:=[-1*HeliEndX,HeliEndY,(FormHeight+30+HeliZoffset)];

        IF ToolNum<>2 THEN
            Home;
            Heli_Pickup;
        ENDIF

        IF pHeliStart.trans.y<1600 THEN
            pHeliStart.extax.eax_a:=pHeliStart.trans.x+Bed1Wyong.uframe.trans.x+1000+HeliBladeWidth/2;
            pHeliEnd.extax.eax_a:=pHeliEnd.trans.x+Bed1Wyong.uframe.trans.x+1000+HeliBladeWidth/2;
        ELSE
            pHeliStart.extax.eax_a:=pHeliStart.trans.x+Bed1Wyong.uframe.trans.x+HeliBladeWidth/2;
            pHeliEnd.extax.eax_a:=pHeliEnd.trans.x+Bed1Wyong.uframe.trans.x+HeliBladeWidth/2;
        ENDIF


        IF (abs(pHeliEnd.trans.x)-abs(pHeliStart.trans.x))<HeliBladeWidth THEN
            HeliPasses:=1;
            HeliPassWidth:=0;
        ELSE
            HeliPasses:=((abs(pHeliEnd.trans.x)-abs(pHeliStart.trans.x)-HeliBladeWidth) DIV HeliOverlapMin);
            IF HeliPasses MOD 2<>0 THEN
                Incr HeliPasses;
            ENDIF
            IF HeliPasses<1 THEN
                HeliPasses:=1;
            ENDIF
            HeliPassWidth:=(abs(pHeliEnd.trans.x)-(abs(pHeliStart.trans.x))-HeliBladeWidth)/HeliPasses;
        ENDIF

        pHeliTempS:=pHeliStart;
        pHeliTempE:=pHeliEnd;
        pHeliTempS.trans.x:=pHeliStart.trans.x-(HeliBladeWidth/2)+300;
        pHeliTempS.trans.y:=pHeliStart.trans.y+(HeliBladeWidth/2);
        pHeliTempE.trans.x:=pHeliEnd.trans.x+(HeliBladeWidth/2)-300;
        pHeliTempE.trans.y:=pHeliEnd.trans.y-(HeliBladeWidth/2);
        pHeliTempS.trans.z:=FormHeight+30+HeliZoffset;
        pHeliTempE.trans.z:=FormHeight+30+HeliZoffset;

        MoveJ Offs(pHeliTempS,0,0,300),v500,z5,tHeli\WObj:=Bed1Wyong;

        IF IsPan=2 THEN
            HeliBlade_Angle HeliAngle;
            HeliBladeSpeed HeliSpeed,"FWD";
            WaitTime\inpos,4;
        ENDIF

        IF IsPan=1 THEN
            MoveJ Offs(pHeliTempS,0,0,75),v500,z5,tHeli\WObj:=Bed1Wyong;
            Stop;
        ENDIF
        HeliZ pHeliTempS.trans.x,pHeliTempS.trans.y,TRUE;
        HeliZOffs:=HighestArray(HeliZArrayCounter);

        MoveL Offs(pHeliTempS,0,0,PitchZOffset+HeliZOffs),v50,z5,tHeli\WObj:=Bed1Wyong;
        pHeliTemp1:=pHeliTempS;
        pHeliTemp2:=pHeliTempS;
        pHeliTemp2.trans.y:=pHeliTempE.trans.y;
        pHeliTemp2.extax.eax_a:=pHeliTempE.extax.eax_a;

        IF IsPan=1 THEN
            HeliBlade_Angle HeliAngle;
            HeliBladeSpeed HeliSpeed,"FWD";
            WaitTime\inpos,5;
        ENDIF


        HeliDiv:=(pHeliTempE.trans.y-pHeliTempS.trans.y) DIV YGridSpacing;


        FOR i FROM 0 to (HeliPasses) DO

            FOR M FROM 0 TO (HeliDiv-1) DO
                HeliZ(pHeliTemp1.trans.x-HeliPassWidth*i),(pHeliTemp1.trans.y+M*YGridSpacing+YGridSpacing),TRUE;
                HeliZOffs:=HighestArray(HeliZArrayCounter);
                IF (pHeliTemp1.trans.y+M*YGridSpacing+YGridSpacing)>1600 THEN
                    pHeliTemp1.extax.eax_a:=pHeliTemp1.trans.x-1*HeliPassWidth*i+Bed1Wyong.uframe.trans.x;
                ELSE
                    pHeliTemp1.extax.eax_a:=pHeliTemp1.trans.x-1*HeliPassWidth*i+Bed1Wyong.uframe.trans.x+1000;
                ENDIF
                MoveL Offs(pHeliTemp1,-1*HeliPassWidth*i,M*YGridSpacing,PitchZOffset+HeliZOffs),vHeli,z5,tHeli\WObj:=Bed1Wyong;
                !Up
            ENDFOR

            IF (pHeliTemp2.trans.y)>1600 THEN
                pHeliTemp2.extax.eax_a:=pHeliTemp2.trans.x-1*HeliPassWidth*i+Bed1Wyong.uframe.trans.x;
            ELSE
                pHeliTemp2.extax.eax_a:=pHeliTemp2.trans.x-1*HeliPassWidth*i+Bed1Wyong.uframe.trans.x+1000;
            ENDIF
            HeliZ(pHeliTemp2.trans.x),(pHeliTemp1.trans.y+HeliPassWidth*i/2),TRUE;
            HeliZOffs:=HighestArray(HeliZArrayCounter);
            MoveL Offs(pHeliTemp2,-1*HeliPassWidth*i,0,PitchZOffset+HeliZOffs),vHeli,z5,tHeli\WObj:=Bed1Wyong;
            !Up

            IF i=HeliPasses THEN
            ELSE
                HeliZ(pHeliTemp2.trans.x-HeliPassWidth*(i+1)),(pHeliTemp1.trans.y),TRUE;
                HeliZOffs:=HighestArray(HeliZArrayCounter);
                IF (pHeliTemp2.trans.y)>1600 THEN
                    pHeliTemp2.extax.eax_a:=pHeliTemp2.trans.x-1*HeliPassWidth*(i+1)+Bed1Wyong.uframe.trans.x;
                ELSE
                    pHeliTemp2.extax.eax_a:=pHeliTemp2.trans.x-1*HeliPassWidth*(i+1)+Bed1Wyong.uframe.trans.x+1000;
                ENDIF
                MoveL Offs(pHeliTemp2,-1*HeliPassWidth*(i+1),0,PitchZOffset+HeliZOffs),vHeli,z5,tHeli\WObj:=Bed1Wyong;
                !Right

                FOR M FROM (HeliDiv-1) TO 0 DO
                    HeliZ(pHeliTemp1.trans.x-HeliPassWidth*(i+1)),(pHeliTemp1.trans.y+M*YGridSpacing),TRUE;
                    HeliZOffs:=HighestArray(HeliZArrayCounter);
                    IF (pHeliTemp1.trans.y+M*YGridSpacing)>1600 THEN
                        pHeliTemp1.extax.eax_a:=pHeliTemp1.trans.x-1*HeliPassWidth*(i+1)+Bed1Wyong.uframe.trans.x;
                    ELSE
                        pHeliTemp1.extax.eax_a:=pHeliTemp1.trans.x-1*HeliPassWidth*(i+1)+Bed1Wyong.uframe.trans.x+1000;
                    ENDIF
                    MoveL Offs(pHeliTemp1,-1*HeliPassWidth*(i+1),M*YGridSpacing,PitchZOffset+HeliZOffs),vHeli,z5,tHeli\WObj:=Bed1Wyong;
                    !Down
                ENDFOR

            ENDIF

        ENDFOR

        IF IsPan=1 THEN
            WaitTime\InPos,0.1;
            HeliBladeSpeed 0,"FWD";
            WaitTime\inpos,8;
            MoveL Offs(pHeliTemp2,HeliPassWidth*(2*HeliPasses)/2,0,18+PitchZOffset+HeliZOffs),v50,fine,tHeli\WObj:=Bed1Wyong;
            HeliBladeSpeed 20,"REV";
            WaitTime\inpos,0.6;
            HeliBladeSpeed 0,"FWD";
            Stop;
        ENDIF
        MoveL Offs(pHeliTemp2,HeliPassWidth*2*HeliPasses/2,0,50+PitchZOffset+HeliZOffs),v50,z5,tHeli\WObj:=Bed1Wyong;

        HeliBladeSpeed 0,"FWD";
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tHeli\WObj:=wobj0);
        MoveL Offs(pHeliTemp2,HeliPassWidth*(2*HeliPasses)/2,2000-CurrentPos.trans.y,300),v500,z5,tHeli\WObj:=Bed1Wyong;
        MoveJ Offs(ptHeli,0,0,500),v500,z5,tHeli;

    ENDPROC

    PROC Screed(num ScrStart,num ScrEnd,num ScrZoffset,num ScrAoffset)
        VAR num StartOffset;
        VAR num EndOffset;
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tVS\WObj:=Bed1Wyong);
        IF ToolNum<>3 THEN
            Home;
            VS_Pickup;
        ELSEIF (CurrentPos.trans.z<800) THEN
            MoveL Offs(CurrentPos,0,0,(800-CurrentPos.trans.z)),v200,z5,tVS\WObj:=Bed1Wyong;
        ENDIF

        StartOffset:=((pVSend.trans.z-pVSstart.trans.z)/(pVSend.trans.x-pVSstart.trans.x))*((-1*ScrStart-pVSstart.trans.x));
        EndOffset:=((pVSend.trans.z-pVSstart.trans.z)/(pVSend.trans.x-pVSstart.trans.x))*((-1*ScrEnd-pVSstart.trans.x));


        pScreedStart.trans:=[(-1*ScrStart),1910,pVSstart.trans.z+ScrZoffset+StartOffset];
        pScreedEnd.trans:=[(-1*ScrEnd),1910,pVSstart.trans.z+ScrZoffset+EndOffset];

        pScreedStart.rot:=pVSstart.rot;
        pScreedEnd.rot:=pVSend.rot;

        pScreedStart.extax.eax_a:=pScreedStart.trans.x+Bed1Wyong.uframe.trans.x+700;
        pScreedEnd.extax.eax_a:=pScreedEnd.trans.x+Bed1Wyong.uframe.trans.x+700;

        !        ScrInitialD:=(pScreedStart.trans.x) MOD 1000;
        !        IF ScrInitialD>350 AND ScrInitialD<=850 THEN
        !            ScrInitialD:=850-ScrInitialD;
        !        ELSEIF ScrInitialD>850 THEN
        !            ScrInitialD:=1000-ScrInitialD+350;
        !        ELSE
        !            ScrInitialD:=350-ScrInitialD;
        !        ENDIF

        !        IF pScreedStart.trans.x<350 THEN
        !            SStartdiv:=1;
        !            ScrBedZ:=BedZreads{1,1};
        !            pScreedStart.trans.z:=pScreedStart.trans.z+ScrBedZ;
        !        ELSEIF pScreedStart.trans.x<BedZpos{1,18,1} THEN
        !            SStartdiv:=(pScreedStart.trans.x+ScrInitialD-BedZpos{1,1,1}) DIV 500;
        !            ScrBedZ:=BedZreads{1,SStartdiv}*(1-Abs(pScreedStart.trans.x-BedZpos{1,SStartdiv,1})/500)+BedZreads{1,SStartdiv+1}*(1-Abs(pScreedStart.trans.x-BedZpos{1,SStartdiv,1+1})/500);
        !            pScreedStart.trans.z:=pScreedStart.trans.z+ScrBedZ;
        !        ELSE
        !            SStartdiv:=18;
        !            ScrBedZ:=BedZreads{1,18};
        !            pScreedStart.trans.z:=pScreedStart.trans.z+ScrBedZ;
        !        ENDIF


        !        IF pScreedEnd.trans.x<350 THEN
        !            SEnddiv:=1;
        !            ScrBedZ:=BedZreads{1,1};
        !            pScreedEnd.trans.z:=pScreedEnd.trans.z+ScrBedZ;
        !        ELSEIF pScreedEnd.trans.x<BedZpos{1,18,1} THEN
        !            SEnddiv:=(pScreedEnd.trans.x-(pScreedStart.trans.x+ScrInitialD)) DIV 500;
        !            ScrBedZ:=BedZreads{1,SEnddiv+SStartdiv}*(1-Abs(pScreedEnd.trans.x-BedZpos{1,SEnddiv+SStartdiv,1})/500)+BedZreads{1,SEnddiv+SStartdiv-1}*(1-Abs(pScreedEnd.trans.x-BedZpos{1,SEnddiv+SStartdiv-1,1})/500);
        !            pScreedEnd.trans.z:=pScreedEnd.trans.z+ScrBedZ;
        !        ELSE
        !            ScrBedZ:=BedZreads{1,18};
        !            SEnddiv:=18;
        !            pScreedEnd.trans.z:=pScreedEnd.trans.z+ScrBedZ;
        !        ENDIF

        !        MoveJ Offs(pScreedStart,-20,0,100),v1000,z5,tVS\WObj:=Bed1;
        !        VS_on;
        !        MoveL Offs(pScreedStart,-20,0,0),v100,z5,tVS\WObj:=Bed1;

        !        pScreedStart.extax.eax_a:=pScreedStart.extax.eax_a+ScrInitialD;
        !        MoveL Offs(pScreedStart,(ScrInitialD),0,BedZreads{1,(SStartdiv)}),vVS,z5,tVS\WObj:=Bed1;

        !        FOR i FROM (SStartdiv+1) TO (SEnddiv+SStartdiv) DO
        !            pScreedStart.extax.eax_a:=pScreedStart.extax.eax_a+500;
        !            MoveL Offs(pScreedStart,((i+1-(SStartdiv+1))*500+ScrInitialD),0,BedZreads{1,(i+1)}),vVS,z5,tVS\WObj:=Bed1;
        !        ENDFOR

        MoveL Offs(pScreedStart,100,0,800),v500,fine,tVS\WObj:=Bed1Wyong;
        MoveL Offs(RelTool(pScreedStart,0,0,0\Ry:=ScrAoffset),50,0,100),v500,fine,tVS\WObj:=Bed1Wyong;
        VS_on;
        MoveL Offs(RelTool(pScreedStart,0,0,0\Ry:=ScrAoffset),20,0,0),v50,z5,tVS\WObj:=Bed1Wyong;
        MoveL Offs(RelTool(pScreedEnd,0,0,0\Ry:=ScrAoffset),-140,0,0),vVS,z5,tVS\WObj:=Bed1Wyong;
        MoveL Offs(RelTool(pScreedEnd,0,0,0\Ry:=ScrAoffset),-140,0,100),v100,z5,tVS\WObj:=Bed1Wyong;
        VS_off;

        VS_Dropoff;

    ENDPROC

    PROC PlotRect(num Xcord1,num Ycord1,num Xcord2,num Ycord2,num Xcord3,num Ycord3,num Xcord4,num Ycord4)


        IF ToolNum<>4 THEN
            Home;
            Plotter_Pickup;
        ELSE
            !Check position and move to safe position if needed
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tPlotter\WObj:=Bed1Wyong);

            IF (CurrentPos.trans.z<(Bed1Wyong.uframe.trans.z-30)) OR (((CurrentPos.trans.x+CurrentPos.extax.eax_a)>Bed1Wyong.uframe.trans.x) AND CurrentPos.trans.z<300) THEN
                !Robot in TS
                TPWrite("Jog robot out of tool station AND HOME");
                Stop;
            ENDIF
        ENDIF

        Plotterp1.trans:=[-1*Xcord1,Ycord1,PlotterZ];
        Plotterp2.trans:=[-1*Xcord2,Ycord2,PlotterZ];
        Plotterp3.trans:=[-1*Xcord3,Ycord3,PlotterZ];
        Plotterp4.trans:=[-1*Xcord4,Ycord4,PlotterZ];

        IF Plotterp1.trans.y>0 THEN
            IF Plotterp1.trans.y<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(Plotterp1.trans.y/abs(tPlotter.tframe.trans.x));
                IF PlotterZOri>PlotA6Max THEN
                    PlotterZOri:=90;
                ENDIF
                Plotterp1.rot:=OrientZYX(-90+PlotterZOri,0,180);
                Plotterp1.trans.y:=Plotterp1.trans.y-((abs(tPlotter.tframe.trans.x)-Ycord1)*(9/((abs(tPlotter.tframe.trans.x)-540))));
            ELSE
                PlotterZOri:=0;
                Plotterp1.rot:=OrientZYX(-90,0,180);
            ENDIF
        ELSE
            RAISE ERR_PLOT_POS;
        ENDIF
        IF PlotterP1.trans.y>(abs(tPlotter.tframe.trans.x)+250) THEN
            Plotterp1.extax:=[(Plotterp1.trans.x+Bed1Wyong.uframe.trans.x),9E+09,9E+09,9E+09,9E+09,9E+09];
        ELSE
            Plotterp1.extax:=[(Plotterp1.trans.x+Bed1Wyong.uframe.trans.x+1000+Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri))),9E+09,9E+09,9E+09,9E+09,9E+09];
        ENDIF


        IF Plotterp2.trans.y>0 THEN
            IF Plotterp2.trans.y<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(Plotterp2.trans.y/abs(tPlotter.tframe.trans.x));

                IF PlotterZOri>PlotA6Max THEN
                    PlotterZOri:=90;
                ENDIF
                Plotterp2.rot:=OrientZYX(-90+PlotterZOri,0,180);
                Plotterp2.trans.y:=Plotterp2.trans.y-((abs(tPlotter.tframe.trans.x)-Ycord2)*(9/((abs(tPlotter.tframe.trans.x)-540))));
            ELSE
                PlotterZOri:=0;
                Plotterp2.rot:=OrientZYX(-90,0,180);
            ENDIF
        ELSE
            RAISE ERR_PLOT_POS;
        ENDIF
        IF PlotterP2.trans.y>(abs(tPlotter.tframe.trans.x)+250) THEN
            Plotterp2.extax:=[(Plotterp2.trans.x+Bed1Wyong.uframe.trans.x),9E+09,9E+09,9E+09,9E+09,9E+09];
        ELSE
            Plotterp2.extax:=[(Plotterp2.trans.x+Bed1Wyong.uframe.trans.x+1000+Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri))),9E+09,9E+09,9E+09,9E+09,9E+09];
        ENDIF

        IF Plotterp3.trans.y>0 THEN
            IF Plotterp3.trans.y<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(Plotterp3.trans.y/abs(tPlotter.tframe.trans.x));

                IF PlotterZOri>PlotA6Max THEN
                    PlotterZOri:=90;
                ENDIF
                Plotterp3.rot:=OrientZYX(-90+PlotterZOri,0,180);
                Plotterp3.trans.y:=Plotterp3.trans.y-((abs(tPlotter.tframe.trans.x)-Ycord3)*(9/((abs(tPlotter.tframe.trans.x)-540))));

            ELSE
                PlotterZOri:=0;
                Plotterp3.rot:=OrientZYX(-90,0,180);
            ENDIF
        ELSE
            RAISE ERR_PLOT_POS;
        ENDIF
        IF PlotterP3.trans.y>(abs(tPlotter.tframe.trans.x)+250) THEN
            Plotterp3.extax:=[(Plotterp3.trans.x+Bed1Wyong.uframe.trans.x),9E+09,9E+09,9E+09,9E+09,9E+09];
        ELSE
            Plotterp3.extax:=[(Plotterp3.trans.x+Bed1Wyong.uframe.trans.x+1000+Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri))),9E+09,9E+09,9E+09,9E+09,9E+09];
        ENDIF

        IF Plotterp4.trans.y>0 THEN
            IF Plotterp4.trans.y<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(Plotterp4.trans.y/abs(tPlotter.tframe.trans.x));
                IF PlotterZOri>PlotA6Max THEN
                    PlotterZOri:=90;
                ENDIF
                Plotterp4.rot:=OrientZYX(-90+PlotterZOri,0,180);
                Plotterp4.trans.y:=Plotterp4.trans.y-((abs(tPlotter.tframe.trans.x)-Ycord4)*(9/((abs(tPlotter.tframe.trans.x)-540))));
            ELSE
                PlotterZOri:=0;
                Plotterp4.rot:=OrientZYX(-90,0,180);
            ENDIF
        ELSE
            RAISE ERR_PLOT_POS;
        ENDIF

        IF PlotterP4.trans.y>(abs(tPlotter.tframe.trans.x)+250) THEN
            Plotterp4.extax:=[(Plotterp4.trans.x+Bed1Wyong.uframe.trans.x),9E+09,9E+09,9E+09,9E+09,9E+09];
        ELSE
            Plotterp4.extax:=[(Plotterp4.trans.x+Bed1Wyong.uframe.trans.x+1000+Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri))),9E+09,9E+09,9E+09,9E+09,9E+09];
        ENDIF

        IF Plotterp1.extax.eax_a>10150 THEN
            Plotterp1.extax.eax_a:=10100;
        ENDIF
        IF Plotterp2.extax.eax_a>10150 THEN
            Plotterp2.extax.eax_a:=10100;
        ENDIF
        IF Plotterp3.extax.eax_a>10150 THEN
            Plotterp3.extax.eax_a:=10100;
        ENDIF
        IF Plotterp4.extax.eax_a>10150 THEN
            Plotterp4.extax.eax_a:=10100;
        ENDIF

        IF Plotterp1.extax.eax_a<0 THEN
            Plotterp1.extax.eax_a:=0;
        ENDIF
        IF Plotterp2.extax.eax_a<0 THEN
            Plotterp2.extax.eax_a:=0;
        ENDIF
        IF Plotterp3.extax.eax_a<0 THEN
            Plotterp3.extax.eax_a:=0;
        ENDIF
        IF Plotterp4.extax.eax_a<0 THEN
            Plotterp4.extax.eax_a:=0;
        ENDIF

        vPlotter:=[100,15,2000,15];

        MoveJ Offs(Plotterp1,0,0,50),v2000,z5,tPlotter\WObj:=Bed1Wyong;
        ConfL\off;
        ConfJ\off;
        MoveL Plotterp1,v10,fine,tPlotter\WObj:=Bed1Wyong;
        WaitTime\inpos,PlotWaitTime;
        MoveL Plotterp2,vPlotter,zPlotter,tPlotter\WObj:=Bed1Wyong;
        WaitTime\inpos,PlotWaitTime;
        MoveL Plotterp3,vPlotter,fine,tPlotter\WObj:=Bed1Wyong;
        WaitTime\inpos,PlotWaitTime;
        MoveL Plotterp4,vPlotter,zPlotter,tPlotter\WObj:=Bed1Wyong;
        WaitTime\inpos,PlotWaitTime;
        MoveL Plotterp1,vPlotter,zPlotter,tPlotter\WObj:=Bed1Wyong;
        MoveL Offs(Plotterp1,0,0,50),v100,z5,tPlotter\WObj:=Bed1Wyong;
        MoveJ Offs(Plotterp1,0,0,200),v500,fine,tPlotter\WObj:=Bed1Wyong;

        ConfL\on;
        ConfJ\on;

    ERROR
        RAISE ;


    ENDPROC

    PROC PlotLineNoLift(num Xcord1,num Ycord1,num Xcord2,num Ycord2)

        IF ToolNum<>4 THEN
            Home;
            Plotter_Pickup;
        ELSE

        ENDIF

        IF Xcord1<=Xcord2 THEN
            Plotterp1.trans:=[-1*Xcord1,Ycord1,PlotterZ];
            Plotterp2.trans:=[-1*Xcord2,Ycord2,PlotterZ];
        ELSE
            Plotterp1.trans:=[-1*Xcord2,Ycord2,PlotterZ];
            Plotterp2.trans:=[-1*Xcord1,Ycord1,PlotterZ];
        ENDIF

        IF Plotterp1.trans.y>0 THEN
            IF ABS(Plotterp1.trans.y)<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(Plotterp1.trans.y/abs(tPlotter.tframe.trans.x));
                IF ABS(PlotterZOri)>PlotA6Max THEN
                    PlotterZOri:=90;
                ENDIF
                Plotterp1.rot:=OrientZYX(-90+PlotterZOri,0,180);
                Plotterp1.trans.y:=Plotterp1.trans.y-((abs(tPlotter.tframe.trans.x)-Ycord1)*(9/((abs(tPlotter.tframe.trans.x)-540))));
            ELSEIF Plotterp1.trans.y<2000 THEN
                PlotterZOri:=15;
                Plotterp1.rot:=OrientZYX(-90,0,180);
            ELSE
                PlotterZOri:=0;
                Plotterp1.rot:=OrientZYX(-90,0,180);
            ENDIF
        ELSE
            RAISE ERR_PLOT_POS;
        ENDIF

        IF PlotterP1.trans.y>(abs(tPlotter.tframe.trans.x)+290) THEN
            Plotterp1.extax:=[(Bed1Wyong.uframe.trans.x+Plotterp1.trans.x),9E+09,9E+09,9E+09,9E+09,9E+09];
        ELSE
            Plotterp1.extax:=[(Bed1Wyong.uframe.trans.x+Plotterp1.trans.x+1000+Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri))),9E+09,9E+09,9E+09,9E+09,9E+09];
        ENDIF

        IF Plotterp2.trans.y>0 THEN
            IF Plotterp2.trans.y<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(Plotterp2.trans.y/abs(tPlotter.tframe.trans.x));
                IF Plotterp1.trans.y<abs(tPlotter.tframe.trans.x) THEN
                    PlotterZOri:=PlotterZOri+25;
                ENDIF

                IF PlotterZOri>PlotA6Max THEN
                    PlotterZOri:=90;
                ENDIF
                Plotterp2.rot:=OrientZYX(-90+PlotterZOri,0,180);
                Plotterp2.trans.y:=Plotterp2.trans.y-((abs(tPlotter.tframe.trans.x)-Ycord2)*(9/((abs(tPlotter.tframe.trans.x)-540))));
            ELSEIF Plotterp2.trans.y<2000 THEN
                PlotterZOri:=15;
                Plotterp2.rot:=OrientZYX(-90,0,180);
            ELSE
                PlotterZOri:=0;
                Plotterp2.rot:=OrientZYX(-90,0,180);
            ENDIF
        ELSE
            RAISE ERR_PLOT_POS;
        ENDIF

        IF PlotterP2.trans.y>(abs(tPlotter.tframe.trans.x)+250) THEN
            Plotterp2.extax:=[(Plotterp2.trans.x+Bed1Wyong.uframe.trans.x),9E+09,9E+09,9E+09,9E+09,9E+09];
        ELSE
            Plotterp2.extax:=[(Plotterp2.trans.x+Bed1Wyong.uframe.trans.x+1000+Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri))),9E+09,9E+09,9E+09,9E+09,9E+09];
        ENDIF

        IF Plotterp1.extax.eax_a>10150 THEN
            Plotterp1.extax.eax_a:=10100;
        ENDIF
        IF Plotterp2.extax.eax_a>10150 THEN
            Plotterp2.extax.eax_a:=10100;
        ENDIF

        IF Plotterp1.extax.eax_a<0 THEN
            Plotterp1.extax.eax_a:=0;
        ENDIF
        IF Plotterp2.extax.eax_a<0 THEN
            Plotterp2.extax.eax_a:=0;
        ENDIF

        ConfJ\Off;
        ConfL\Off;
        MoveL Plotterp1,v30,zPlotter,tPlotter\WObj:=Bed1Wyong;
        MoveL Plotterp2,vPlotter,fine,tPlotter\WObj:=Bed1Wyong;

        ConfL\on;
        ConfJ\on;

    ERROR
        RAISE ;

    ENDPROC

    PROC PlotLineStartLift(num Xcord1,num Ycord1,num Xcord2,num Ycord2)

        WaitTime\inpos,0.1;
        IF ToolNum<>4 THEN
            Home;
            Plotter_Pickup;
        ENDIF

        IF Xcord1<=Xcord2 THEN
            Plotterp1.trans:=[-1*Xcord1,Ycord1,PlotterZ];
            Plotterp2.trans:=[-1*Xcord2,Ycord2,PlotterZ];
        ELSE
            Plotterp1.trans:=[-1*Xcord2,Ycord2,PlotterZ];
            Plotterp2.trans:=[-1*Xcord1,Ycord1,PlotterZ];
        ENDIF

        IF Plotterp1.trans.y>0 THEN
            IF ABS(Plotterp1.trans.y)<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(Plotterp1.trans.y/abs(tPlotter.tframe.trans.x));
                IF ABS(PlotterZOri)>PlotA6Max THEN
                    PlotterZOri:=90;
                ENDIF
                Plotterp1.rot:=OrientZYX(-90+PlotterZOri,0,180);
                Plotterp1.trans.y:=Plotterp1.trans.y-((abs(tPlotter.tframe.trans.x)-Ycord1)*(9/((abs(tPlotter.tframe.trans.x)-540))));
            ELSEIF Plotterp1.trans.y<2000 THEN
                PlotterZOri:=15;
                Plotterp1.rot:=OrientZYX(-90,0,180);
            ELSE
                PlotterZOri:=0;
                Plotterp1.rot:=OrientZYX(-90,0,180);
            ENDIF
        ELSE
            RAISE ERR_PLOT_POS;
        ENDIF

        IF PlotterP1.trans.y>(abs(tPlotter.tframe.trans.x)+290) THEN
            Plotterp1.extax:=[(Bed1Wyong.uframe.trans.x+Plotterp1.trans.x),9E+09,9E+09,9E+09,9E+09,9E+09];
        ELSE
            Plotterp1.extax:=[(Bed1Wyong.uframe.trans.x+Plotterp1.trans.x+1000+Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri))),9E+09,9E+09,9E+09,9E+09,9E+09];
        ENDIF

        IF Plotterp2.trans.y>0 THEN
            IF Plotterp2.trans.y<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(Plotterp2.trans.y/abs(tPlotter.tframe.trans.x));
                IF Plotterp1.trans.y<abs(tPlotter.tframe.trans.x) THEN
                    PlotterZOri:=PlotterZOri+25;
                ENDIF

                IF PlotterZOri>PlotA6Max THEN
                    PlotterZOri:=90;
                ENDIF
                Plotterp2.rot:=OrientZYX(-90+PlotterZOri,0,180);
                Plotterp2.trans.y:=Plotterp2.trans.y-((abs(tPlotter.tframe.trans.x)-Ycord2)*(9/((abs(tPlotter.tframe.trans.x)-540))));
            ELSEIF Plotterp2.trans.y<2000 THEN
                PlotterZOri:=15;
                Plotterp2.rot:=OrientZYX(-90,0,180);
            ELSE
                PlotterZOri:=0;
                Plotterp2.rot:=OrientZYX(-90,0,180);
            ENDIF
        ELSE
            RAISE ERR_PLOT_POS;
        ENDIF

        IF PlotterP2.trans.y>(abs(tPlotter.tframe.trans.x)+250) THEN
            Plotterp2.extax:=[(Plotterp2.trans.x+Bed1Wyong.uframe.trans.x),9E+09,9E+09,9E+09,9E+09,9E+09];
        ELSE
            Plotterp2.extax:=[(Plotterp2.trans.x+Bed1Wyong.uframe.trans.x+1000+Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri))),9E+09,9E+09,9E+09,9E+09,9E+09];
        ENDIF

        IF Plotterp1.extax.eax_a>10150 THEN
            Plotterp1.extax.eax_a:=10100;
        ENDIF
        IF Plotterp2.extax.eax_a>10150 THEN
            Plotterp2.extax.eax_a:=10100;
        ENDIF

        IF Plotterp1.extax.eax_a<0 THEN
            Plotterp1.extax.eax_a:=0;
        ENDIF
        IF Plotterp2.extax.eax_a<0 THEN
            Plotterp2.extax.eax_a:=0;
        ENDIF

        ConfJ\Off;
        ConfL\Off;
        MoveJ Offs(Plotterp1,0,0,50),v2000,z5,tPlotter\WObj:=Bed1Wyong;
        ConfL\off;
        ConfJ\off;
        MoveL Plotterp1,v30,zPlotter,tPlotter\WObj:=Bed1Wyong;
        MoveL Plotterp2,vPlotter,fine,tPlotter\WObj:=Bed1Wyong;
        ConfL\on;
        ConfJ\on;

    ERROR
        RAISE ;

    ENDPROC

    PROC PlotLine(num Xcord1,num Ycord1,num Xcord2,num Ycord2)

        WaitTime\inpos,0.1;
        IF ToolNum<>4 THEN
            Home;
            Plotter_Pickup;
        ELSE
            !Check position and move to safe position if needed
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tPlotter\WObj:=Bed1Wyong);

            IF (CurrentPos.trans.z<(Bed1Wyong.uframe.trans.z-30)) OR (((CurrentPos.trans.x+CurrentPos.extax.eax_a)>Bed1Wyong.uframe.trans.x) AND CurrentPos.trans.z<300) THEN
                !Robot in TS
                TPWrite("Jog robot out of tool station AND HOME");
                Stop;
            ENDIF
        ENDIF

        IF Xcord1<=Xcord2 THEN
            Plotterp1.trans:=[-1*Xcord1,Ycord1,PlotterZ];
            Plotterp2.trans:=[-1*Xcord2,Ycord2,PlotterZ];
        ELSE
            Plotterp1.trans:=[-1*Xcord2,Ycord2,PlotterZ];
            Plotterp2.trans:=[-1*Xcord1,Ycord1,PlotterZ];
        ENDIF

        IF Plotterp1.trans.y>0 THEN
            IF ABS(Plotterp1.trans.y)<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(Plotterp1.trans.y/abs(tPlotter.tframe.trans.x));
                IF ABS(PlotterZOri)>PlotA6Max THEN
                    PlotterZOri:=90;
                ENDIF
                Plotterp1.rot:=OrientZYX(-90+PlotterZOri,0,180);
                Plotterp1.trans.y:=Plotterp1.trans.y-((abs(tPlotter.tframe.trans.x)-Ycord1)*(9/((abs(tPlotter.tframe.trans.x)-540))));

            ELSEIF Plotterp1.trans.y<2000 THEN
                PlotterZOri:=15;
                Plotterp1.rot:=OrientZYX(-90,0,180);
            ELSE
                PlotterZOri:=0;
                Plotterp1.rot:=OrientZYX(-90,0,180);
            ENDIF
        ELSE
            RAISE ERR_PLOT_POS;
        ENDIF

        IF PlotterP1.trans.y>(abs(tPlotter.tframe.trans.x)+290) THEN
            Plotterp1.extax:=[(Bed1Wyong.uframe.trans.x+Plotterp1.trans.x),9E+09,9E+09,9E+09,9E+09,9E+09];
        ELSE
            Plotterp1.extax:=[(Bed1Wyong.uframe.trans.x+Plotterp1.trans.x+1000+Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri))),9E+09,9E+09,9E+09,9E+09,9E+09];
        ENDIF

        IF Plotterp2.trans.y>0 THEN
            IF Plotterp2.trans.y<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(Plotterp2.trans.y/abs(tPlotter.tframe.trans.x));
                IF Plotterp1.trans.y<abs(tPlotter.tframe.trans.x) THEN
                    PlotterZOri:=PlotterZOri+25;
                ENDIF

                IF PlotterZOri>PlotA6Max THEN
                    PlotterZOri:=90;
                ENDIF
                Plotterp2.rot:=OrientZYX(-90+PlotterZOri,0,180);
                Plotterp2.trans.y:=Plotterp2.trans.y-((abs(tPlotter.tframe.trans.x)-Ycord2)*(9/((abs(tPlotter.tframe.trans.x)-540))));

            ELSEIF Plotterp2.trans.y<2000 THEN
                PlotterZOri:=15;
                Plotterp2.rot:=OrientZYX(-90,0,180);
            ELSE
                PlotterZOri:=0;
                Plotterp2.rot:=OrientZYX(-90,0,180);
            ENDIF
        ELSE
            RAISE ERR_PLOT_POS;
        ENDIF

        IF PlotterP2.trans.y>(abs(tPlotter.tframe.trans.x)+250) THEN
            Plotterp2.extax:=[(Plotterp2.trans.x+Bed1Wyong.uframe.trans.x),9E+09,9E+09,9E+09,9E+09,9E+09];
        ELSE
            Plotterp2.extax:=[(Plotterp2.trans.x+Bed1Wyong.uframe.trans.x+1000+Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri))),9E+09,9E+09,9E+09,9E+09,9E+09];
        ENDIF

        IF Plotterp1.extax.eax_a>10150 THEN
            Plotterp1.extax.eax_a:=10100;
        ENDIF
        IF Plotterp2.extax.eax_a>10150 THEN
            Plotterp2.extax.eax_a:=10100;
        ENDIF

        IF Plotterp1.extax.eax_a<0 THEN
            Plotterp1.extax.eax_a:=0;
        ENDIF
        IF Plotterp2.extax.eax_a<0 THEN
            Plotterp2.extax.eax_a:=0;
        ENDIF

        ConfJ\Off;
        ConfL\Off;
        MoveJ Offs(Plotterp1,0,0,50),v2000,z5,tPlotter\WObj:=Bed1Wyong;
        ConfL\off;
        ConfJ\off;
        MoveL Plotterp1,v30,zPlotter,tPlotter\WObj:=Bed1Wyong;
        MoveL Plotterp2,vPlotter,fine,tPlotter\WObj:=Bed1Wyong;
        MoveL Offs(Plotterp2,0,0,50),v100,z5,tPlotter\WObj:=Bed1Wyong;
        MoveJ Offs(Plotterp2,0,0,200),v500,fine,tPlotter\WObj:=Bed1Wyong;

        ConfL\on;
        ConfJ\on;

    ERROR
        RAISE ;

    ENDPROC


    PROC PlotLineEndLift(num Xcord1,num Ycord1,num Xcord2,num Ycord2)

        WaitTime\inpos,0.1;
        IF ToolNum<>4 THEN
            Home;
            Plotter_Pickup;

        ENDIF

        IF Xcord1<=Xcord2 THEN
            Plotterp1.trans:=[-1*Xcord1,Ycord1,PlotterZ];
            Plotterp2.trans:=[-1*Xcord2,Ycord2,PlotterZ];
        ELSE
            Plotterp1.trans:=[-1*Xcord2,Ycord2,PlotterZ];
            Plotterp2.trans:=[-1*Xcord1,Ycord1,PlotterZ];
        ENDIF

        IF Plotterp1.trans.y>0 THEN
            IF ABS(Plotterp1.trans.y)<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(Plotterp1.trans.y/abs(tPlotter.tframe.trans.x));
                IF ABS(PlotterZOri)>PlotA6Max THEN
                    PlotterZOri:=90;
                ENDIF
                Plotterp1.rot:=OrientZYX(-90+PlotterZOri,0,180);
                Plotterp1.trans.y:=Plotterp1.trans.y-((abs(tPlotter.tframe.trans.x)-Ycord1)*(9/((abs(tPlotter.tframe.trans.x)-540))));
            ELSEIF Plotterp1.trans.y<2000 THEN
                PlotterZOri:=15;
                Plotterp1.rot:=OrientZYX(-90,0,180);
            ELSE
                PlotterZOri:=0;
                Plotterp1.rot:=OrientZYX(-90,0,180);
            ENDIF
        ELSE
            RAISE ERR_PLOT_POS;
        ENDIF

        IF PlotterP1.trans.y>(abs(tPlotter.tframe.trans.x)+290) THEN
            Plotterp1.extax:=[(Bed1Wyong.uframe.trans.x+Plotterp1.trans.x),9E+09,9E+09,9E+09,9E+09,9E+09];
        ELSE
            Plotterp1.extax:=[(Bed1Wyong.uframe.trans.x+Plotterp1.trans.x+1000+Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri))),9E+09,9E+09,9E+09,9E+09,9E+09];
        ENDIF

        IF Plotterp2.trans.y>0 THEN
            IF Plotterp2.trans.y<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(Plotterp2.trans.y/abs(tPlotter.tframe.trans.x));
                IF Plotterp1.trans.y<abs(tPlotter.tframe.trans.x) THEN
                    PlotterZOri:=PlotterZOri+25;
                ENDIF

                IF PlotterZOri>PlotA6Max THEN
                    PlotterZOri:=90;
                ENDIF
                Plotterp2.rot:=OrientZYX(-90+PlotterZOri,0,180);
                Plotterp2.trans.y:=Plotterp2.trans.y-((abs(tPlotter.tframe.trans.x)-Ycord2)*(9/((abs(tPlotter.tframe.trans.x)-540))));

            ELSEIF Plotterp2.trans.y<2000 THEN
                PlotterZOri:=15;
                Plotterp2.rot:=OrientZYX(-90,0,180);
            ELSE
                PlotterZOri:=0;
                Plotterp2.rot:=OrientZYX(-90,0,180);
            ENDIF
        ELSE
            RAISE ERR_PLOT_POS;
        ENDIF

        IF PlotterP2.trans.y>(abs(tPlotter.tframe.trans.x)+250) THEN
            Plotterp2.extax:=[(Plotterp2.trans.x+Bed1Wyong.uframe.trans.x),9E+09,9E+09,9E+09,9E+09,9E+09];
        ELSE
            Plotterp2.extax:=[(Plotterp2.trans.x+Bed1Wyong.uframe.trans.x+1000+Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri))),9E+09,9E+09,9E+09,9E+09,9E+09];
        ENDIF

        IF Plotterp1.extax.eax_a>10150 THEN
            Plotterp1.extax.eax_a:=10100;
        ENDIF
        IF Plotterp2.extax.eax_a>10150 THEN
            Plotterp2.extax.eax_a:=10100;
        ENDIF

        IF Plotterp1.extax.eax_a<0 THEN
            Plotterp1.extax.eax_a:=0;
        ENDIF
        IF Plotterp2.extax.eax_a<0 THEN
            Plotterp2.extax.eax_a:=0;
        ENDIF

        ConfJ\Off;
        ConfL\Off;
        MoveL Plotterp1,v30,zPlotter,tPlotter\WObj:=Bed1Wyong;
        MoveL Plotterp2,vPlotter,fine,tPlotter\WObj:=Bed1Wyong;
        MoveL Offs(Plotterp2,0,0,50),v100,z5,tPlotter\WObj:=Bed1Wyong;
        MoveJ Offs(Plotterp2,0,0,200),v500,fine,tPlotter\WObj:=Bed1Wyong;

        ConfL\on;
        ConfJ\on;

    ERROR
        RAISE ;

    ENDPROC

    PROC PlotArc(num StartXcord,num StartYcord,num MidXcord,num MidYcord,num EndXcord,num EndYcord)
        IF ToolNum<>4 THEN
            Home;
            Plotter_Pickup;
        ELSE
            !Check position and move to safe position if needed
            !Check position and move to safe position if needed
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tPlotter\WObj:=Bed1Wyong);

            IF (CurrentPos.trans.z<(Bed1Wyong.uframe.trans.z-30)) OR (((CurrentPos.trans.x+CurrentPos.extax.eax_a)>Bed1Wyong.uframe.trans.x) AND CurrentPos.trans.z<300) THEN
                !Robot in TS
                TPWrite("Jog robot out of tool station AND HOME");
                Stop;
            ENDIF
        ENDIF

        !Plot Circle
        Plotterc5.trans:=[(-1*StartXcord),StartYcord,PlotterZ];
        PlotterTemp.trans:=[Plotterc5.trans.x,Plotterc5.trans.y,PlotterZ];

        IF PlotterTemp.trans.y>0 THEN
            IF PlotterTemp.trans.y<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(PlotterTemp.trans.y/abs(tPlotter.tframe.trans.x));
                IF PlotterZOri>PlotA6Max THEN
                    PlotterZOri:=90;
                ENDIF
                PlotterTemp.rot:=OrientZYX(-90+PlotterZOri,0,180);
                PlotterTemp.trans.y:=PlotterTemp.trans.y-((abs(tPlotter.tframe.trans.x)-StartYcord)*(9/((abs(tPlotter.tframe.trans.x)-540))));
            ELSE
                PlotterTemp.rot:=OrientZYX(-90,0,180);
            ENDIF
        ELSE
            RAISE ERR_PLOT_POS;
        ENDIF

        IF PlotterTemp.trans.y+Bed1.uframe.trans.y>2800 THEN
            PlotterTemp.extax.eax_a:=(PlotterTemp.trans.x+Bed1Wyong.uframe.trans.x);
        ELSE
            PlotterTemp.extax.eax_a:=(PlotterTemp.trans.x+Bed1Wyong.uframe.trans.x+1000+Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri)));
        ENDIF

        IF PlotterTemp.extax.eax_a>10150 THEN
            PlotterTemp.extax.eax_a:=10100;
        ELSEIF PlotterTemp.extax.eax_a<0 THEN
            PlotterTemp.extax.eax_a:=0;
        ENDIF

        WaitTime\inpos,0.1;
        ConfJ\Off;
        ConfL\Off;

        MoveJ Offs(PlotterTemp,0,0,50),v1500,z5,tPlotter\WObj:=Bed1Wyong;
        MoveL PlotterTemp,v10,fine,tPlotter\WObj:=Bed1Wyong;

        PlotterTemp2.trans:=[(-1*MidXcord),MidYcord,PlotterZ];
        IF PlotterTemp2.trans.y>0 THEN
            IF PlotterTemp2.trans.y<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(PlotterTemp2.trans.y/abs(tPlotter.tframe.trans.x));
                IF PlotterZOri>PlotA6Max THEN
                    PlotterZOri:=90;
                ENDIF
                PlotterTemp2.rot:=OrientZYX(-90+PlotterZOri,0,180);
                PlotterTemp2.trans.y:=PlotterTemp2.trans.y-((abs(tPlotter.tframe.trans.x)-MidYcord)*(9/((abs(tPlotter.tframe.trans.x)-540))));
            ELSE
                PlotterZOri:=0;
                PlotterTemp3.rot:=OrientZYX(-90,0,180);
            ENDIF
        ELSE
            RAISE ERR_PLOT_POS;
        ENDIF
        IF PlotterTemp2.trans.y+Bed1.uframe.trans.y>2800 THEN
            PlotterTemp2.extax.eax_a:=(PlotterTemp2.trans.x+Bed1Wyong.uframe.trans.x);
        ELSE
            PlotterTemp2.extax.eax_a:=(PlotterTemp2.trans.x+Bed1Wyong.uframe.trans.x+1000+Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri)));
        ENDIF

        IF PlotterTemp2.extax.eax_a>10150 THEN
            PlotterTemp2.extax.eax_a:=10100;
        ELSEIF PlotterTemp2.extax.eax_a<0 THEN
            PlotterTemp2.extax.eax_a:=0;
        ENDIF

        PlotterTemp3.trans:=[(-1*EndXcord),EndYcord,PlotterZ];
        IF PlotterTemp3.trans.y>0 THEN
            IF PlotterTemp3.trans.y<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(PlotterTemp3.trans.y/abs(tPlotter.tframe.trans.x));
                IF PlotterZOri>PlotA6Max THEN
                    PlotterZOri:=90;
                ENDIF
                PlotterTemp3.rot:=OrientZYX(-90+PlotterZOri,0,180);
                PlotterTemp3.trans.y:=PlotterTemp3.trans.y-((abs(tPlotter.tframe.trans.x)-EndYcord)*(9/((abs(tPlotter.tframe.trans.x)-540))));
            ELSE
                PlotterZOri:=0;
                PlotterTemp3.rot:=OrientZYX(-90,0,180);
            ENDIF
        ELSE
            RAISE ERR_PLOT_POS;
        ENDIF
        IF PlotterTemp3.trans.y+Bed1Wyong.uframe.trans.y>2800 THEN
            PlotterTemp3.extax:=[(PlotterTemp3.trans.x+Bed1Wyong.uframe.trans.x),9E+09,9E+09,9E+09,9E+09,9E+09];
        ELSE
            PlotterTemp3.extax:=[(PlotterTemp3.trans.x+Bed1Wyong.uframe.trans.x+1000+Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri))),9E+09,9E+09,9E+09,9E+09,9E+09];
        ENDIF

        IF PlotterTemp3.extax.eax_a>10150 THEN
            PlotterTemp3.extax.eax_a:=10100;
        ELSEIF PlotterTemp3.extax.eax_a<0 THEN
            PlotterTemp3.extax.eax_a:=0;
        ENDIF
        MoveC PlotterTemp2,PlotterTemp3,vPlotter,fine,tPlotter\WObj:=Bed1Wyong;
        MoveL Offs(PlotterTemp3,0,0,50),v100,z5,tPlotter\WObj:=Bed1Wyong;
        MoveJ Offs(PlotterTemp3,0,0,200),v500,fine,tPlotter\WObj:=Bed1Wyong;
        ConfJ\On;
        ConfL\On;

    ENDPROC


    PROC PlotCirc(num Xcord,num Ycord,num Rad)
        IF ToolNum<>4 THEN
            Home;
            Plotter_Pickup;
        ELSE
            !Check position and move to safe position if needed
            !Check position and move to safe position if needed
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tPlotter\WObj:=Bed1Wyong);

            IF (CurrentPos.trans.z<(Bed1Wyong.uframe.trans.z-30)) OR (((CurrentPos.trans.x+CurrentPos.extax.eax_a)>Bed1Wyong.uframe.trans.x) AND CurrentPos.trans.z<300) THEN
                !Robot in TS
                TPWrite("Jog robot out of tool station AND HOME");
                Stop;
            ENDIF
        ENDIF


        IF Rad<100 THEN
            vPlotter:=[10,5,2000,15];
        ELSE
            vPlotter:=[50,15,2000,15];
        ENDIF


        !Plot Circle
        Plotterc5.trans:=[(-1*Xcord),Ycord,PlotterZ];
        PlotterTemp.trans:=[Plotterc5.trans.x+Rad,Plotterc5.trans.y,PlotterZ];

        IF PlotterTemp.trans.y>0 THEN
            IF PlotterTemp.trans.y<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(PlotterTemp.trans.y/abs(tPlotter.tframe.trans.x));
                IF PlotterZOri>PlotA6Max THEN
                    PlotterZOri:=90;
                ENDIF
                PlotterTemp.rot:=OrientZYX(-90+PlotterZOri,0,180);
                PlotterTemp.trans.y:=PlotterTemp.trans.y-((abs(tPlotter.tframe.trans.x)-Ycord)*(9/((abs(tPlotter.tframe.trans.x)-540))));
            ELSEIF PlotterTemp.trans.y<2500 THEN
                PlotterZori:=25;
                PlotterTemp.rot:=OrientZYX(-90+PlotterZOri,0,180);
            ELSE
                PlotterTemp.rot:=OrientZYX(-90,0,180);
            ENDIF
        ELSE
            RAISE ERR_PLOT_POS;
        ENDIF

        IF PlotterTemp.trans.y+Bed1.uframe.trans.y>2800 THEN
            PlotterTemp.extax.eax_a:=(PlotterTemp.trans.x+Bed1Wyong.uframe.trans.x);
        ELSE
            PlotterTemp.extax.eax_a:=(PlotterTemp.trans.x+Bed1Wyong.uframe.trans.x+1000+Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri)));
        ENDIF

        IF PlotterTemp.extax.eax_a>10150 THEN
            PlotterTemp.extax.eax_a:=10100;
        ELSEIF PlotterTemp.extax.eax_a<0 THEN
            PlotterTemp.extax.eax_a:=0;
        ENDIF

        WaitTime\inpos,0.1;
        ConfJ\Off;
        ConfL\Off;

        MoveJ Offs(PlotterTemp,0,0,50),v1500,z5,tPlotter\WObj:=Bed1Wyong;
        MoveL PlotterTemp,v10,fine,tPlotter\WObj:=Bed1Wyong;

        PlotterTemp2.trans:=[Plotterc5.trans.x,Plotterc5.trans.y+Rad,PlotterZ];
        IF PlotterTemp2.trans.y>0 THEN
            IF PlotterTemp2.trans.y<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(PlotterTemp2.trans.y/abs(tPlotter.tframe.trans.x));
                IF PlotterZOri>PlotA6Max THEN
                    PlotterZOri:=90;
                ENDIF
                PlotterTemp2.rot:=OrientZYX(-90+PlotterZOri,0,180);
                PlotterTemp2.trans.y:=PlotterTemp2.trans.y-((abs(tPlotter.tframe.trans.x)-(Ycord+Rad))*(9/((abs(tPlotter.tframe.trans.x)-540))));
            ELSEIF PlotterTemp2.trans.y<2500 THEN
                PlotterZori:=25;
                PlotterTemp2.rot:=OrientZYX(-90+PlotterZOri,0,180);
            ELSE
                PlotterZOri:=0;
                PlotterTemp2.rot:=OrientZYX(-90,0,180);
            ENDIF
        ELSE
            RAISE ERR_PLOT_POS;
        ENDIF
        IF PlotterTemp2.trans.y+Bed1.uframe.trans.y>2800 THEN
            PlotterTemp2.extax.eax_a:=(PlotterTemp2.trans.x+Bed1Wyong.uframe.trans.x);
        ELSE
            PlotterTemp2.extax.eax_a:=(PlotterTemp2.trans.x+Bed1Wyong.uframe.trans.x+1000+Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri)));
        ENDIF

        IF PlotterTemp2.extax.eax_a>10150 THEN
            PlotterTemp2.extax.eax_a:=10100;
        ELSEIF PlotterTemp2.extax.eax_a<0 THEN
            PlotterTemp2.extax.eax_a:=0;
        ENDIF

        PlotterTemp3.trans:=[Plotterc5.trans.x-Rad,Plotterc5.trans.y,PlotterZ];
        IF PlotterTemp3.trans.y>0 THEN
            IF PlotterTemp3.trans.y<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(PlotterTemp3.trans.y/abs(tPlotter.tframe.trans.x));
                IF PlotterZOri>PlotA6Max THEN
                    PlotterZOri:=90;
                ENDIF
                PlotterTemp3.rot:=OrientZYX(-90+PlotterZOri,0,180);
                PlotterTemp3.trans.y:=PlotterTemp3.trans.y-((abs(tPlotter.tframe.trans.x)-(Ycord-Rad))*(9/((abs(tPlotter.tframe.trans.x)-540))));

            ELSEIF PlotterTemp3.trans.y<2500 THEN
                PlotterZori:=25;
                PlotterTemp3.rot:=OrientZYX(-90+PlotterZOri,0,180);
            ELSE
                PlotterZOri:=0;
                PlotterTemp3.rot:=OrientZYX(-90,0,180);
            ENDIF
        ELSE
            RAISE ERR_PLOT_POS;
        ENDIF
        IF PlotterTemp3.trans.y+Bed1Wyong.uframe.trans.y>2800 THEN
            PlotterTemp3.extax:=[(PlotterTemp3.trans.x+Bed1Wyong.uframe.trans.x),9E+09,9E+09,9E+09,9E+09,9E+09];
        ELSE
            PlotterTemp3.extax:=[(PlotterTemp3.trans.x+Bed1Wyong.uframe.trans.x+1000+Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri))),9E+09,9E+09,9E+09,9E+09,9E+09];
        ENDIF

        IF PlotterTemp3.extax.eax_a>10150 THEN
            PlotterTemp3.extax.eax_a:=10100;
        ELSEIF PlotterTemp3.extax.eax_a<0 THEN
            PlotterTemp3.extax.eax_a:=0;
        ENDIF
        MoveC PlotterTemp2,PlotterTemp3,vPlotter,fine,tPlotter\WObj:=Bed1Wyong;

        PlotterTemp.trans:=[Plotterc5.trans.x,Plotterc5.trans.y-Rad,PlotterZ];
        IF PlotterTemp.trans.y>0 THEN
            IF PlotterTemp.trans.y<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(PlotterTemp.trans.y/abs(tPlotter.tframe.trans.x));
                IF PlotterZOri>PlotA6Max THEN
                    PlotterZOri:=90;
                ENDIF
                PlotterTemp.rot:=OrientZYX(-90+PlotterZOri,0,180);
                PlotterTemp.trans.y:=PlotterTemp.trans.y-((abs(tPlotter.tframe.trans.x)-(Ycord-Rad))*(9/((abs(tPlotter.tframe.trans.x)-540))));
            ELSE
                PlotterZOri:=0;
                PlotterTemp.rot:=OrientZYX(-90,0,180);
            ENDIF
        ELSE
            RAISE ERR_PLOT_POS;
        ENDIF

        IF PlotterTemp.trans.y+Bed1.uframe.trans.y>2800 THEN
            PlotterTemp.extax:=[(PlotterTemp.trans.x+Bed1Wyong.uframe.trans.x),9E+09,9E+09,9E+09,9E+09,9E+09];
        ELSE
            PlotterTemp.extax:=[(PlotterTemp.trans.x+Bed1Wyong.uframe.trans.x+1000+Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri))),9E+09,9E+09,9E+09,9E+09,9E+09];
        ENDIF

        IF PlotterTemp.extax.eax_a>10150 THEN
            PlotterTemp.extax.eax_a:=10100;
        ELSEIF PlotterTemp.extax.eax_a<0 THEN
            PlotterTemp.extax.eax_a:=0;
        ENDIF

        PlotterTemp2.trans:=[Plotterc5.trans.x+Rad,Plotterc5.trans.y,PlotterZ];
        IF PlotterTemp2.trans.y>0 THEN
            IF PlotterTemp2.trans.y<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(PlotterTemp2.trans.y/abs(tPlotter.tframe.trans.x));
                IF PlotterZOri>PlotA6Max THEN
                    PlotterZOri:=90;
                ENDIF
                PlotterTemp2.rot:=OrientZYX(-90+PlotterZOri,0,180);
                PlotterTemp2.trans.y:=PlotterTemp2.trans.y-((abs(tPlotter.tframe.trans.x)-(Ycord))*(9/((abs(tPlotter.tframe.trans.x)-540))));
            ELSE
                PlotterZOri:=0;
                PlotterTemp2.rot:=OrientZYX(-90,0,180);
            ENDIF
        ELSE
            RAISE ERR_PLOT_POS;
        ENDIF
        IF PlotterTemp2.trans.y+Bed1.uframe.trans.y>2800 THEN
            PlotterTemp2.extax.eax_a:=(PlotterTemp2.trans.x+Bed1Wyong.uframe.trans.x);
        ELSE
            PlotterTemp2.extax.eax_a:=(PlotterTemp2.trans.x+Bed1Wyong.uframe.trans.x+1000+Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri)));
        ENDIF

        IF PlotterTemp2.extax.eax_a>10150 THEN
            PlotterTemp2.extax.eax_a:=10100;
        ELSEIF PlotterTemp2.extax.eax_a<0 THEN
            PlotterTemp2.extax.eax_a:=0;
        ENDIF
        MoveC PlotterTemp,PlotterTemp2,vPlotter,fine,tPlotter\WObj:=Bed1Wyong;
        MoveL Offs(PlotterTemp2,0,0,50),v100,z5,tPlotter\WObj:=Bed1Wyong;
        MoveJ Offs(PlotterTemp2,0,0,200),v500,fine,tPlotter\WObj:=Bed1Wyong;
        ConfJ\On;
        ConfL\On;

    ERROR
        RAISE ;

    ENDPROC

    PROC PackAway()
        !VAR jointtarget jtTarget;
        Home;
        !jtTarget := [[138.31,-55.47,60.29,-0.02,84.30,-2.02], [9416.99,9E+09,9E+09,9E+09,9E+09,9E+09]];
        !MoveAbsJ jtTarget, v500, fine, tTCMaster;
        MoveJ pHomeLoadout,v500,z50,tTCMaster;
    ERROR
        RAISE ;
    ENDPROC


    PROC Home()
        !Move robot to safe position, drop off any tools, close tool boxes

        TEST ToolNum

        CASE 1:
            !TCmaster
            !Check for any tb lids open and robot in tool stations
            !Move to Home
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tTCMaster\WObj:=wobj0);

            IF (CurrentPos.trans.x)>8000 AND (CurrentPos.trans.z<265) THEN
                TPErase;
                TPWrite("Jog robot out of tool station AND HOME");
                Stop;
            ENDIF

        CASE 2:
            !Heli
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tHeli\WObj:=wobj0);

            IF (CurrentPos.trans.x)>8000 AND CurrentPos.trans.z<125 THEN
                TPWrite("Jog robot out of tool station AND HOME");
                Stop;
            ENDIF

            IF CurrentPos.trans.y>(Bed1.uframe.trans.y+3000) THEN
                MoveL Offs(CurrentPos,0,(3000-CurrentPos.trans.y),50),v10,z5,tHeli\WObj:=wobj0;
                MoveJ Offs(CurrentPos,0,(3000-CurrentPos.trans.y),300-CurrentPos.trans.z),v100,z5,tHeli\WObj:=wobj0;
            ENDIF
            Heli_Dropoff;

        CASE 3:
            !VS

            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tVS\WObj:=wobj0);


            IF (CurrentPos.trans.x)>8000 AND CurrentPos.trans.z<265 THEN
                TPErase;
                TPWrite("Jog robot out of tool station AND HOME");
                Stop;
            ELSEIF CurrentPos.trans.z<200 THEN
                MoveL Offs(CurrentPos,0,0,(200-CurrentPos.trans.z)),v500,z5,tVS;

            ENDIF


            VS_Dropoff;


        CASE 4:
            !Plotter

            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tPlotter\WObj:=wobj0);

            IF CurrentPos.trans.z<270 AND (CurrentPos.trans.x)<8000 THEN
                MoveL Offs(CurrentPos,0,0,(270-CurrentPos.trans.z)),v500,z5,tPlotter;
            ENDIF

            IF (CurrentPos.trans.x)>8000 AND CurrentPos.trans.z<265 THEN
                TPErase;
                TPWrite("Jog robot out of tool station AND HOME");
                Stop;
            ENDIF

            IF CurrentPos.trans.y>(Bed1.uframe.trans.y+3300) THEN
                MoveL Offs(CurrentPos,0,(3300-CurrentPos.trans.y),50),v10,z5,tPlotter\WObj:=wobj0;
                MoveJ Offs(CurrentPos,0,(3300-CurrentPos.trans.y),1000-CurrentPos.trans.z),v100,z5,tPlotter\WObj:=wobj0;
            ENDIF
            Plotter_Dropoff;

        CASE 5:
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tVac\WObj:=wobj0);

            IF (CurrentPos.trans.x)>8000 AND CurrentPos.trans.z<265 THEN
                TPErase;
                TPWrite("Jog robot out of tool station AND HOME");
                Stop;
            ENDIF
            IF CurrentPos.trans.z<200 AND (CurrentPos.trans.x)<8000 THEN
                MoveL Offs(CurrentPos,0,0,(200-CurrentPos.trans.z)),v500,fine,tVac;
            ENDIF
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tVac\WObj:=wobj0);
            IF CurrentPos.trans.y>(Bed1.uframe.trans.y+3000) THEN
                MoveL Offs(CurrentPos,0,(3000-CurrentPos.trans.y),50),v200,z5,tVac\WObj:=wobj0;
                MoveJ Offs(CurrentPos,0,(3000-CurrentPos.trans.y),700-CurrentPos.trans.z),v200,z5,tVac\WObj:=wobj0;
            ENDIF
            Vac_Dropoff;

        CASE 6:
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tPolish\WObj:=wobj0);


            IF (CurrentPos.trans.x)>8000 AND CurrentPos.trans.z<265 THEN
                TPErase;
                TPWrite("Jog robot out of tool station AND HOME");
                Stop;

            ENDIF
            Polish_Dropoff;

        DEFAULT:
            !Unknown
            RAISE ERR_TC_SELECTION;

        ENDTEST

        MoveJ pHome,v500,fine,tTCMaster;

    ERROR
        RAISE ;

    ENDPROC

    FUNC num PointToPointDist(num px,num py,num x1,num y1)
        !Used to check if point is within helicopter blades

        VAR num Dist;

        Dist:=Sqrt((x1-px)*(x1-px)+(y1-py)*(y1-py));
        RETURN Dist;
    ENDFUNC

    FUNC num HighestArray(num count)
        !Used to determine highest height offset
        VAR num j;
        VAR num HighestValue;
        HighestValue:=HeliZArray{1};
        FOR j FROM 1 TO count DO
            IF HeliZArray{j}>HighestValue THEN
                HighestValue:=HeliZArray{j};
            ENDIF
        ENDFOR
        IF PreviousHighest>HighestValue THEN
            PreviousHighest:=HighestValue;
            RETURN PreviousHighest;
        ELSEIF HighestValue<=-30 THEN
            PreviousHighest:=HighestValue;
            RETURN 0;
        ELSE
            PreviousHighest:=HighestValue;
            RETURN HighestValue;
        ENDIF

    ENDFUNC

    PROC HeliZ(num x1,num y1,bool ResetZArray)
        !Determines height offsets for helicopter movements
        VAR num CloseYPos;
        x1:=Abs(x1);
        IF ResetZArray=TRUE THEN
            HeliZArrayCounter:=1;
            FOR i FROM 1 TO DIM(HeliZArray,1) DO
                HeliZArray{i}:=-50;
            ENDFOR
        ENDIF

        FOR i FROM 1 TO 17 DO
            FOR j FROM 1 TO 4 DO
                IF PointToPointDist(x1,y1,BedZpos{j,i,1},BedZpos{j,i,2})<=HeliBladeWidth/2 THEN
                    HeliZArray{HeliZArrayCounter}:=BedZreads{j,i};
                    Incr HeliZArrayCounter;
                ENDIF
            ENDFOR
        ENDFOR

    ENDPROC

    PROC PlotBedGrid(num Xcord1,num Ycord1,num ZOffset)
        !Used by BedGridPlotter for Z datum
        Plotterp1.trans:=[Xcord1,Ycord1,200+ZOffset];
        !+46

        IF Plotterp1.trans.y>0 THEN
            IF Plotterp1.trans.y<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(Plotterp1.trans.y/abs(tPlotter.tframe.trans.x));
                IF PlotterZOri>PlotA6Max THEN
                    PlotterZOri:=90;
                ENDIF
                Plotterp1.rot:=OrientZYX(-90+PlotterZOri,0,180);
            ELSE
                PlotterZOri:=0;
                Plotterp1.rot:=OrientZYX(-90,0,180);
            ENDIF
        ELSE
            RAISE ERR_PLOT_POS;
        ENDIF

        IF PlotterP1.trans.y>(abs(tPlotter.tframe.trans.x)+250) THEN
            Plotterp1.extax:=[(Plotterp1.trans.x+Bed1.uframe.trans.x),9E+09,9E+09,9E+09,9E+09,9E+09];
        ELSE
            Plotterp1.extax:=[(Plotterp1.trans.x+Bed1.uframe.trans.x+1000+Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri))),9E+09,9E+09,9E+09,9E+09,9E+09];
        ENDIF

        IF Plotterp1.extax.eax_a>10150 THEN
            Plotterp1.extax.eax_a:=10100;
        ENDIF

        IF Plotterp1.extax.eax_a<0 THEN
            Plotterp1.extax.eax_a:=0;
        ENDIF

        vPlotter:=[100,15,2000,15];

        MoveL Plotterp1,v300,zPlotter,tTCMaster\WObj:=Bed1Wyong;

    ENDPROC

    PROC BedGridPlotter()
        !Get Z datum offset
        FOR k FROM 7 TO 19 DO
            !Move x
            FOR j FROM 4 TO 9 DO
                !Move y

                PlotBedGrid(k*XGridSpacing+100),(j*YGridSpacing+100),Bed1Zread{10-j,(k+1)};
                WaitTime\inpos,0.1;

            ENDFOR

        ENDFOR

    ENDPROC

    PROC MoveGridDatum()
        !Sweep across bed maintaining Z height through offsets
        FOR j FROM 9 TO 4 DO
            FOR k FROM 11 TO 1 DO
                !Move x
                PlotBedGrid(k*XGridSpacing+100),(j*YGridSpacing+100),Bed1Zread{10-j,(k+1)};
            ENDFOR
        ENDFOR
    ENDPROC


    PROC VacuumBed()

        VAR num VacOverlap:=-400;
        IF ToolNum<>5 THEN
            Home;
            Vac_Pickup;
        ELSE
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tVac\WObj:=Bed1Wyong);
            IF CurrentPos.trans.x<0 AND (CurrentPos.trans.z<150) THEN
                MoveL Offs(CurrentPos,0,0,(150-CurrentPos.trans.z)),v500,z5,tVac\WObj:=Bed1Wyong;
            ELSEIF (CurrentPos.trans.z<700) THEN
                MoveL Offs(CurrentPos,0,0,(700-CurrentPos.trans.z)),v500,z5,tVac\WObj:=Bed1Wyong;
            ENDIF
        ENDIF

        pTemp:=pVacStart;
        pTemp2:=pVacStart;
        pTemp2.trans.x:=pVacStart2.trans.x;
        pTemp2.extax.eax_a:=pVacStart2.extax.eax_a;

        Vac_on;
        FOR i FROM 0 TO (Round((pVacStart.trans.y-pVacStart2.trans.y)/(-1*VacOverlap))) DO
            IF pTemp.trans.y+i*VacOverlap>pVacStart2.trans.y THEN
                MoveJ Offs(pTemp,0,i*VacOverlap,150),v500,z5,tVac\WObj:=Bed1Wyong;
                MoveL Offs(pTemp,0,i*VacOverlap,0),v50,z5,tVac\WObj:=Bed1Wyong;
                MoveL Offs(pTemp2,0,i*VacOverlap,0),v100,z5,tVac\WObj:=Bed1Wyong;
                MoveL Offs(pTemp2,0,i*VacOverlap,150),v50,fine,tVac\WObj:=Bed1Wyong;
            ENDIF
        ENDFOR

        Vac_off;

        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tVac\WObj:=wobj0);
        MoveL Offs(CurrentPos,0,0,800-CurrentPos.trans.z),v100,z5,tVac\WObj:=wobj0;

    ENDPROC

    PROC JointPositions()

        VAR num PolishOverlap:=450;
        pPolTemp:=pPolStart1;
        pPolTemp2:=pPolStart1;
        pPolTemp2.extax.eax_a:=pPolStart1.extax.eax_a-7500;
        pPolTemp2.trans.x:=-7500;

        pPolTemp.rot:=pPolStart1.rot;
        pPolTemp2.rot:=pPolStart1.rot;

        pPolTemp2.rot:=pPolStart2.rot;
        pPolTemp2.extax.eax_a:=pPolStart1.extax.eax_a-8500;
        CurrentJoints5:=CJointT();
        CurrentJoints6:=CalcJointT(Offs(pPolTemp2,50,(1+1)*PolishOverlap,40),tPolish\WObj:=Bed1Wyong);

    ENDPROC


    PROC RobbiePlot()

        ! !Write R
        !PlotLine 6900,1000, 6900,2000;
        !PlotArc 6900,2000,6650,1750,6900,1500;
        !PlotLine 6900,1500,6650,1000;

        !!Write O
        !PlotArc 6300,2000, 6050,1500,6300,1000;
        !PlotArc 6300,1000, 6550,1500,6300,2000;

        !!Write B
        !PlotLine 5700,1000, 5700,2000;
        !PlotArc 5700,2000,5450,1750,5700,1500;
        !PlotArc 5700,1500,5450,1250,5700,1000;

        !!Write B
        !PlotLine 5100,1000, 5100,2000;
        !PlotArc 5100,2000,4850,1750,5100,1500;
        !PlotArc 5100,1500,4850,1250,5100,1000;

        !!Write I
        !PlotLine 4500,1000, 4500,2000;

        !!Write E
        !PlotLine 3900,1000, 3900,2000;
        !PlotLine 3900,2000, 3400,2000;
        !PlotLine 3900,1500, 3400,1500;
        !PlotLine 3900,1000, 3400,1000;

        !formbox
        PlotRect 2000,500,2000,3500,6000,3500,6000,500;
        !Ferrule
        WaitTime\inpos,0.1;
        PlotCirc 2250,750,(PlotCircleD/2);
        PlotLine(2250-PlotCircleD/2-CrossHairExt),750,(2250+PlotCircleD/2+CrossHairExt),750;
        PlotLine 2250,(750-PlotCircleD/2-CrossHairExt),2250,(750+PlotCircleD/2+CrossHairExt);
        !Ferrule
        WaitTime\inpos,0.1;
        PlotCirc 2250,3250,(PlotCircleD/2);
        PlotLine(2250-PlotCircleD/2-CrossHairExt),3250,(2250+PlotCircleD/2+CrossHairExt),3250;
        PlotLine 2250,(3250-PlotCircleD/2-CrossHairExt),2250,(3250+PlotCircleD/2+CrossHairExt);
        !Grout tube Casee 4
        WaitTime\inpos,0.1;
        iCoord1x:=6000;
        iCoord1y:=2000;
        iAngle:=0;
        PlotRect iCoord1x-GroutWidth/2*Sin(iAngle)-GroutHeight*Cos(iAngle),iCoord1y+GroutHeight*Sin(iAngle)-GroutWidth/2*Cos(iAngle),iCoord1x+GroutWidth/2*Sin(iAngle)-GroutHeight*Cos(iAngle),iCoord1y+GroutHeight*Sin(iAngle)+GroutWidth/2*Cos(iAngle),iCoord1x+GroutWidth/2*Sin(iAngle),iCoord1y+GroutWidth/2*Cos(iAngle),iCoord1x-GroutWidth/2*Sin(iAngle),iCoord1y-GroutWidth/2*Cos(iAngle);

        !Lifting points 180 angle
        WaitTime\inpos,0.1;
        TriangleAngle:=180;
        iCoord1x:=5000;
        iCoord1y:=3500;
        PlotLine iCoord1x-TriangleHeight*Sin(TriangleAngle),iCoord1y-TriangleHeight*Cos(TriangleAngle),iCoord1x-TriangleBase/2*Cos(TriangleAngle),iCoord1y+TriangleBase/2*Sin(TriangleAngle);
        PlotLine iCoord1x-TriangleBase/2*Cos(TriangleAngle),iCoord1y+TriangleBase/2*Sin(TriangleAngle),iCoord1x+TriangleBase/2*Cos(TriangleAngle),iCoord1y-TriangleBase/2*Sin(TriangleAngle);
        PlotLine iCoord1x+TriangleBase/2*Cos(TriangleAngle),iCoord1y-TriangleBase/2*Sin(TriangleAngle),iCoord1x-TriangleHeight*Sin(TriangleAngle),iCoord1y-TriangleHeight*Cos(TriangleAngle);
        !Lifting points 180 angle
        WaitTime\inpos,0.1;
        TriangleAngle:=180;
        iCoord1x:=3000;
        iCoord1y:=3500;
        PlotLine iCoord1x-TriangleHeight*Sin(TriangleAngle),iCoord1y-TriangleHeight*Cos(TriangleAngle),iCoord1x-TriangleBase/2*Cos(TriangleAngle),iCoord1y+TriangleBase/2*Sin(TriangleAngle);
        PlotLine iCoord1x-TriangleBase/2*Cos(TriangleAngle),iCoord1y+TriangleBase/2*Sin(TriangleAngle),iCoord1x+TriangleBase/2*Cos(TriangleAngle),iCoord1y-TriangleBase/2*Sin(TriangleAngle);
        PlotLine iCoord1x+TriangleBase/2*Cos(TriangleAngle),iCoord1y-TriangleBase/2*Sin(TriangleAngle),iCoord1x-TriangleHeight*Sin(TriangleAngle),iCoord1y-TriangleHeight*Cos(TriangleAngle);

        Plotter_Dropoff;

    ENDPROC

    PROC PolishDemo()
        IF ToolNum<>6 THEN
            Home;
            Polish_Pickup;
        ELSE
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tPolish\WObj:=wobj0);
            IF CurrentPos.trans.z<600 THEN
                MoveL Offs(CurrentPos,0,0,(600-CurrentPos.trans.z)),v500,z5,tPolish;
            ENDIF
        ENDIF
        MoveJ pPolHome,v500,z5,tPolish;
        pPolTemp:=pPolStart1;
        pPolTemp2:=pPolStart1;
        pPolTemp2.extax.eax_a:=pPolStart1.extax.eax_a-7500;
        pPolTemp2.trans.x:=-7500;
        pPolTemp.rot:=pPolStart1.rot;
        pPolTemp2.rot:=pPolStart1.rot;
        FCCalib PolishLoad;
        pPolTemp.extax.eax_a:=pPolStart1.extax.eax_a;
        MoveJ Offs(pPolTemp,0,0,100),v500,z5,tPolish\WObj:=Bed1Wyong;
        Pol_on;
        MoveL Offs(pPolTemp,0,0,50),v100,fine,tPolish\WObj:=Bed1Wyong;
        myForceVector:=FCGetForce(\Tool:=tPolish);
        FCPress1LStart Offs(pPolTemp,-25,0,55),v10,\Fz:=120,15,\ForceChange:=50\PosSupvDist:=125,z5,tPolish\WObj:=Bed1Wyong;
        pPolTemp2.extax.eax_a:=pPolStart2.extax.eax_a-300;
        FCPressL Offs(pPolTemp2,-300,0,-15),v100,130,fine,tPolish\WObj:=Bed1Wyong;
        FCPressEnd Offs(pPolTemp2,-300,0,75),v50,\DeactOnly,tPolish\WObj:=Bed1Wyong;
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tPolish\WObj:=Bed1Wyong);
        MoveJ Offs(Reltool(CurrentPos,0,0,-100),0,450,0),v100,fine,tPolish\WObj:=Bed1Wyong;
        Pol_off;
        Polish_Dropoff;
    ENDPROC



    PROC BedGrid()

        !        MoveJ Offs(p10Maps,500*(1-1)+2000*(1-1),650*(1-1),50),v500,z5,tTCMaster\WObj:=Bed1Wyong;
        !        MoveL Offs(p10Maps,500*(1-1)+2000*(1-1),650*(1-1),0),v500,fine,tTCMaster\WObj:=Bed1Wyong;
        !        Stop;
        !        MoveL Offs(p10Maps,500*(1-1)+2000*(1-1),650*(1-1),50),v500,z5,tTCMaster\WObj:=Bed1Wyong;
        !        Stop;

        FOR i FROM 1 TO 5 DO
            !Move EAX
            FOR k FROM 1 TO 4 DO
                !Move x
                FOR j FROM 1 TO 4 DO
                    !Move y
                    IF 500*(k-1)+2000*(i-1)<8001 THEN
                        p10maps.extax.eax_a:=Bed1Wyong.uframe.trans.x+p10Maps.trans.x-500*(k-1)-2000*(i-1);
                        IF p10maps.extax.eax_a>10150 THEN
                            p10maps.extax.eax_a:=10100;
                        ENDIF
                        IF p10maps.extax.eax_a<1000 THEN
                            p10maps.extax.eax_a:=1000;
                        ENDIF

                        !MoveJ Offs(p10Maps,-500*(k-1)-2000*(i-1),650*(j-1),50),v500,z5,tTCMaster\WObj:=Bed1Wyong;
                        !MoveL Offs(p10Maps,-500*(k-1)-2000*(i-1),650*(j-1),0),v500,fine,tTCMaster\WObj:=Bed1Wyong;
                        !TPReadNum BedZread,"Enter Z reading";
                        !BedZreads{5-j,((i-1)*4+k)}:=BedZread;
                        BedZpos{5-j,((i-1)*4+k),1}:=p10Maps.trans.x-500*(k-1)-2000*(i-1);
                        BedZpos{5-j,((i-1)*4+k),2}:=p10maps.trans.y+650*(j-1);
                        !MoveL Offs(p10Maps,-500*(k-1)-2000*(i-1),650*(j-1),50),v500,z5,tTCMaster\WObj:=Bed1Wyong;
                    ENDIF

                ENDFOR
            ENDFOR
        ENDFOR
        Stop;

    ENDPROC


    PROC ClearBedZ()

        FOR i FROM 1 TO 4 DO
            !Move EAX
            FOR k FROM 1 TO 24 DO
                !Move x
                BedZreads{i,k}:=0;
                BedZpos{i,k,1}:=0;
                BedZpos{i,k,2}:=0;
            ENDFOR
        ENDFOR

    ENDPROC




    PROC BHTestTask()
        TPErase;
        TPWrite "BH Test Task";
        TPWrite "Press Play to confirm and start task";
        Stop;
        
        TPErase;
        TPWrite "Starting BH Test Task...";
        
        Heli_Pickup;
        MoveJ Offs(ptHeli,0,0,1000),v500,fine,tHeli;
        TPWrite "Helicopter tool at 1000mm above pickup";
        WaitTime 2;
        
        Heli_Dropoff;
        TPWrite "Helicopter tool dropped off";
        
        Polish_Pickup;
        MoveJ Offs(ptPolish,0,0,1000),v500,fine,tPolish;
        TPWrite "Polisher tool at 1000mm above pickup";
        WaitTime 2;
        
        Polish_Dropoff;
        TPWrite "Polisher tool dropped off";
        
        Home;
        TPWrite "BH Test Task Complete";
        
    ERROR
        RAISE ;
    ENDPROC



    PROC Datum()
        ! Datum - draws small circle at Bed1Wyong origin (0,0)
        ! Generated by Onyx Toolpath Generator
        VAR robtarget pDatumCenter;
        VAR robtarget pDatumCircle;
        VAR num DatumZ:=300;
        VAR num DatumRadius:=100;
        VAR num SafeZ:=500;
        VAR num i;
        
        TPWrite "Datum: ToolNum=" \Num:=ToolNum;
        IF ToolNum<>4 THEN
            TPWrite "No plotter! Will pickup plotter.";
            Stop;
            Home;
            Plotter_Pickup;
        ELSE
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tPlotter\WObj:=wobj0);
            IF CurrentPos.trans.z<600 THEN
                MoveL Offs(CurrentPos,0,0,(600-CurrentPos.trans.z)),v500,z5,tPlotter;
            ENDIF
        ENDIF
        
        ConfL\Off;
        ConfJ\Off;
        
        pDatumCenter:=[[0,0,DatumZ],[0,0,1,0],[0,0,0,0],[0,9E+09,9E+09,9E+09,9E+09,9E+09]];
        pDatumCenter.rot:=OrientZYX(-90,0,180);
        pDatumCenter.extax.eax_a:=6500;
        
        TPWrite "Datum: Drawing circle at origin";
        TPWrite "Press Play to continue";
        Stop;
        
        pDatumCircle:=pDatumCenter;
        pDatumCircle.trans.z:=SafeZ;
        MoveJ pDatumCircle,v500,z5,tPlotter\WObj:=Bed1Wyong;
        
        pDatumCircle.trans.x:=DatumRadius;
        pDatumCircle.trans.z:=DatumZ;
        MoveJ pDatumCircle,v500,z5,tPlotter\WObj:=Bed1Wyong;
        
        FOR i FROM 1 TO 8 DO
            pDatumCircle.trans.x:=DatumRadius*Cos(i*45);
            pDatumCircle.trans.y:=DatumRadius*Sin(i*45);
            MoveJ pDatumCircle,v100,fine,tPlotter\WObj:=Bed1Wyong;
        ENDFOR
        
        pDatumCircle.trans.x:=0;
        pDatumCircle.trans.y:=0;
        pDatumCircle.trans.z:=DatumZ;
        MoveJ pDatumCircle,v100,fine,tPlotter\WObj:=Bed1Wyong;
        
        TPWrite "Plotter at datum center (0,0)";
        TPWrite "Press Play to return tool";
        Stop;
        
        pDatumCircle.trans.z:=SafeZ;
        MoveJ pDatumCircle,v500,z5,tPlotter\WObj:=Bed1Wyong;
        
        ConfL\On;
        ConfJ\On;
        
        Plotter_Dropoff;
        Home;
        
        TPWrite "Datum Complete";
    ERROR
        RAISE;
    ENDPROC


    PROC PyHeli()
        ! PyHeli - Helicopter serpentine pattern
        ! Workzone: panel
        ! Force Control DISABLED (dummy run)
        ! Generated by Onyx Toolpath Generator
        
        VAR robtarget pHeliPos;
        VAR robtarget pHeliEnd;
        VAR num HeliZ:=450;
        VAR num SafeZ:=500;
        
        ! Workspace bounds (with offsets applied)
        VAR num WorkMinX:=2200;
        VAR num WorkMaxX:=7850;
        VAR num WorkMinY:=200;
        VAR num WorkMaxY:=2200;
        
        ! Pattern parameters
        VAR num StepSize:=450;
        VAR num SweepDir:=1;
        VAR num StepDir:=-1;
        VAR num CurrentY:=2200;
        VAR num CurrentX:=2200;
        VAR num NextY;
        VAR num NextX;
        VAR num StartX;
        VAR num EndX;
        VAR num StartY;
        VAR num EndY;
        
        ! Speed and blade parameters
        VAR num HeliSpeed:=100;
        VAR num HeliAngle:=1;
        VAR speeddata vHeliTravel:=[500,15,2000,15];
        VAR num NumPasses;
        ! Force control disabled
        
        NumPasses:=Trunc(Abs(WorkMaxY-WorkMinY)/StepSize)+1;
        
        TPWrite "PyHeli: Serpentine Pattern";
        TPWrite "Work Area (7850,2200) to (2200,200)";
        TPWrite "Passes=" \Num:=NumPasses;
        TPWrite "Step=" \Num:=StepSize;
        TPWrite "Force=OFF (dummy)";
        
        IF ToolNum<>2 THEN
            TPWrite "PyHeli: ToolNum<>2, need pickup";
            Stop;
            Home;
            Heli_Pickup;
        ELSE
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tHeli\WObj:=Bed1Wyong);
            IF CurrentPos.trans.z<SafeZ THEN
                MoveL Offs(CurrentPos,0,0,(SafeZ-CurrentPos.trans.z)),v500,z5,tHeli\WObj:=Bed1Wyong;
            ENDIF
        ENDIF
        
        ! Set start/end based on sweep direction
        IF SweepDir=1 THEN
            StartX:=WorkMinX;
            EndX:=WorkMaxX;
        ELSE
            StartX:=WorkMaxX;
            EndX:=WorkMinX;
        ENDIF
        
        ! Set initial position with fixed orientation
        pHeliPos:=[[0,0,HeliZ],OrientZYX(0,0,180),[0,0,0,0],[0,9E+09,9E+09,9E+09,9E+09,9E+09]];
        
        ! Move to row start above surface (HOVER)
        pHeliPos.trans.x:=-StartX;
        pHeliPos.trans.y:=CurrentY;
        pHeliPos.trans.z:=SafeZ;
        pHeliPos.extax.eax_a:=Bed1Wyong.uframe.trans.x-StartX;
        MoveJ pHeliPos,v500,z5,tHeli\WObj:=Bed1Wyong;
        
        ! Disable configuration tracking for serpentine movements
        ConfL\Off;
        ConfJ\Off;
        
        ! Home stepper before setting blade angle (ensures StepperPos is valid)
        TPWrite "Homing blade stepper...";
        Heli_Stepper_Home;
        TPWrite "Stepper homed";
        
        ! Set blade angle while hovering
        TPWrite "Setting blade angle to " \Num:=HeliAngle;
        HeliBlade_Angle HeliAngle;
        WaitTime 2;
        TPWrite "Blade angle set";
        
        ! No force calibration needed
        
        TPWrite "Hovering over workspace - Press Play to start";
        Stop;
        
        ! Start blade rotation BEFORE lowering
        TPWrite "Starting blade rotation...";
        HeliBladeSpeed HeliSpeed,"FWD";
        WaitTime 1;
        
        ! Lower to working height
        TPWrite "Lowering to work surface...";
        pHeliPos.trans.z:=HeliZ;
        MoveL pHeliPos,v50,fine,tHeli\WObj:=Bed1Wyong;
        
        ! No force control - dummy run
        
        ! Set up end position for first sweep
        pHeliEnd:=pHeliPos;
        pHeliEnd.trans.x:=-EndX;
        pHeliEnd.extax.eax_a:=Bed1Wyong.uframe.trans.x-EndX;
        
        ! ========== PASS 1: X-direction sweeps (stepping in Y) ===========
        WHILE TRUE DO
            ! === SWEEP X (full length) ===
            MoveL pHeliEnd,vHeliTravel,fine,tHeli\WObj:=Bed1Wyong;
            
            ! No force ramping in dummy mode
            
            ! Calculate next row
            NextY:=CurrentY+(StepDir*StepSize);
            
            ! Check if pass complete
            IF (StepDir=1 AND NextY>WorkMaxY) OR (StepDir=-1 AND NextY<WorkMinY) THEN
                EXIT;
            ENDIF
            
            ! Clamp to bounds
            IF NextY>WorkMaxY THEN
                NextY:=WorkMaxY;
            ELSEIF NextY<WorkMinY THEN
                NextY:=WorkMinY;
            ENDIF
            
            ! Step to next Y row
            pHeliEnd.trans.y:=NextY;
            MoveL pHeliEnd,vHeliTravel,fine,tHeli\WObj:=Bed1Wyong;
            CurrentY:=NextY;
            
            ! Flip sweep direction
            SweepDir:=-SweepDir;
            IF SweepDir=1 THEN
                StartX:=WorkMinX;
                EndX:=WorkMaxX;
            ELSE
                StartX:=WorkMaxX;
                EndX:=WorkMinX;
            ENDIF
            
            ! Set up end position for next sweep
            pHeliEnd.trans.x:=-EndX;
            pHeliEnd.extax.eax_a:=Bed1Wyong.uframe.trans.x-EndX;
        ENDWHILE
        
        ! ========== PASS 2: Y-direction sweeps (stepping in X) ==========
        TPWrite "=== PASS 2 START ===";
        
        ! Reset for Y-direction passes - start from current position
        CurrentX:=Abs(pHeliEnd.trans.x);
        TPWrite "Pass2: CurrentX=" \Num:=CurrentX;
        TPWrite "Pass2: CurrentY=" \Num:=CurrentY;
        TPWrite "Pass2: WorkMinX=" \Num:=WorkMinX;
        TPWrite "Pass2: WorkMaxX=" \Num:=WorkMaxX;
        
        ! Determine step direction based on where Pass 1 ended
        ! At high X, step toward low X; at low X, step toward high X
        IF CurrentX>((WorkMinX+WorkMaxX)/2) THEN
            StepDir:=-1;
            TPWrite "Pass2: StepDir=-1 (toward MinX)";
        ELSE
            StepDir:=1;
            TPWrite "Pass2: StepDir=+1 (toward MaxX)";
        ENDIF
        
        ! Determine sweep direction based on where Pass 1 ended (which Y edge)
        IF CurrentY>((WorkMinY+WorkMaxY)/2) THEN
            SweepDir:=1;
            StartY:=WorkMaxY;
            EndY:=WorkMinY;
            TPWrite "Pass2: Sweep MinY first";
        ELSE
            SweepDir:=-1;
            StartY:=WorkMinY;
            EndY:=WorkMaxY;
            TPWrite "Pass2: Sweep MaxY first";
        ENDIF
        
        TPWrite "Pass2: EndY=" \Num:=EndY;
        
        ! First Y sweep from current position
        TPWrite "Pass2: First Y sweep...";
        pHeliEnd.trans.y:=EndY;
        MoveL pHeliEnd,vHeliTravel,fine,tHeli\WObj:=Bed1Wyong;
        TPWrite "Pass2: First Y sweep done";
        
        TPWrite "Pass2: Entering X-step loop";
        
        WHILE TRUE DO
            ! Calculate next column
            NextX:=CurrentX+(StepDir*StepSize);
            TPWrite "Pass2: NextX=" \Num:=NextX;
            
            ! Check if pass complete (no more columns to step to)
            IF (StepDir=1 AND NextX>WorkMaxX) OR (StepDir=-1 AND NextX<WorkMinX) THEN
                TPWrite "Pass2: EXIT - NextX out of bounds";
                ! No force control end needed
                EXIT;
            ENDIF
            
            ! Clamp to bounds
            IF NextX>WorkMaxX THEN
                NextX:=WorkMaxX;
            ELSEIF NextX<WorkMinX THEN
                NextX:=WorkMinX;
            ENDIF
            
            ! Step to next X column
            TPWrite "Pass2: Step to X=" \Num:=NextX;
            pHeliEnd.trans.x:=-NextX;
            pHeliEnd.extax.eax_a:=Bed1Wyong.uframe.trans.x-NextX;
            MoveL pHeliEnd,vHeliTravel,fine,tHeli\WObj:=Bed1Wyong;
            CurrentX:=NextX;
            
            ! Flip sweep direction for next Y sweep
            SweepDir:=-SweepDir;
            IF SweepDir=1 THEN
                EndY:=WorkMinY;
            ELSE
                EndY:=WorkMaxY;
            ENDIF
            
            ! Set up end position and sweep Y
            TPWrite "Pass2: Sweep Y to " \Num:=EndY;
            pHeliEnd.trans.y:=EndY;
            MoveL pHeliEnd,vHeliTravel,fine,tHeli\WObj:=Bed1Wyong;
        ENDWHILE
        TPWrite "=== PASS 2 COMPLETE ===";
        
        ! === LIFT OFF BED ===
        pHeliPos.trans.z:=SafeZ;
        MoveL pHeliPos,v100,z5,tHeli\WObj:=Bed1Wyong;
        
        ! === STOP BLADE ROTATION ===
        HeliBladeSpeed 0,"FWD";
        WaitTime\InPos,3;
        
        ConfL\On;
        ConfJ\On;
        
        ! === PACKAWAY ===
        Heli_Dropoff;
        Home;
        
        TPWrite "PyHeli Complete";
    ERROR
        HeliBladeSpeed 0,"FWD";
        RAISE;
    ENDPROC


    PROC PyVac()
        ! PyVac - Vacuum procedure with serpentine pattern
        ! Workzone: bed
        ! Generated by Onyx Toolpath Generator
        
        VAR robtarget pVacPos;
        VAR robtarget pVacEnd;
        VAR num VacZ:=280;
        VAR num SafeZ:=300;
        
        ! Force control parameters
        VAR num VacForce:=50;
        VAR num VacZMin:=-20;
        VAR num VacZMax:=50;
        VAR num VacZRange:=70;
        
        ! Workspace bounds (with offsets applied)
        VAR num WorkMinX:=0;
        VAR num WorkMaxX:=8500;
        VAR num WorkMinY:=0;
        VAR num WorkMaxY:=1650;
        
        ! Pattern parameters
        VAR num StepSize:=300;
        VAR num SweepDir:=-1;
        VAR num YStepDir:=-1;
        VAR num CurrentY:=1650;
        VAR num NextY;
        VAR num StartX;
        VAR num EndX;
        
        VAR speeddata vVac:=[200,30,2000,15];
        VAR num NumPasses;
        
        NumPasses:=Trunc(Abs(WorkMaxY-WorkMinY)/StepSize)+1;
        
        TPWrite "PyVac: Serpentine Pattern";
        TPWrite "Work Area (8500,1650) to (0,0)";
        TPWrite "Passes=" \Num:=NumPasses;
        TPWrite "Step=" \Num:=StepSize;
        TPWrite "Speed=" \Num:=200;
        
        IF ToolNum<>5 THEN
            TPWrite "PyVac: ToolNum<>5, need pickup";
            TPWrite "PyVac: ToolNum=" \Num:=ToolNum;
            TPWrite "PyVac: Calling Vac_Pickup...";
            Stop;
            Vac_Pickup;
            TPWrite "PyVac: Vac_Pickup complete";
        ELSE
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tVac\WObj:=Bed1Wyong);
            IF CurrentPos.trans.z<SafeZ THEN
                MoveL Offs(CurrentPos,0,0,(SafeZ-CurrentPos.trans.z)),v500,z5,tVac\WObj:=Bed1Wyong;
            ENDIF
        ENDIF
        
        ConfL\Off;
        ConfJ\Off;
        
        pVacPos:=[[0,0,VacZ],[0.00615322,-0.709926,0.704246,-0.00239206],[1,-1,0,0],[0,9E+09,9E+09,9E+09,9E+09,9E+09]];
        
        TPWrite "Press Play to start";
        Stop;
        
        Vac_on;
        
        ! Main vacuum loop - always sweep right to left, lift and return
        WHILE TRUE DO
            ! Move to row start above work surface (right side)
            pVacPos.trans.x:=-WorkMaxX;
            pVacPos.trans.y:=CurrentY;
            pVacPos.trans.z:=VacZMax;
            pVacPos.extax.eax_a:=Bed1Wyong.uframe.trans.x-WorkMaxX;
            MoveL pVacPos,vVac,fine,tVac\WObj:=Bed1Wyong;
            
            ! Set up end position
            pVacEnd:=pVacPos;
            pVacEnd.trans.x:=-WorkMinX;
            pVacEnd.trans.z:=VacZ;
            pVacEnd.extax.eax_a:=Bed1Wyong.uframe.trans.x-WorkMinX;
            
            ! Sweep right to left
            pVacPos.trans.z:=VacZ;
            MoveL pVacPos,vVac,fine,tVac\WObj:=Bed1Wyong;
            MoveL pVacEnd,vVac,z5,tVac\WObj:=Bed1Wyong;
            
            ! Calculate next row
            NextY:=CurrentY+(YStepDir*StepSize);
            
            ! Check if pattern complete
            IF (YStepDir=1 AND NextY>WorkMaxY) OR (YStepDir=-1 AND NextY<WorkMinY) THEN
                ! Pattern complete
                EXIT;
            ENDIF
            
            ! Clamp to bounds for partial last step
            IF NextY>WorkMaxY THEN
                NextY:=WorkMaxY;
            ELSEIF NextY<WorkMinY THEN
                NextY:=WorkMinY;
            ENDIF
            
            ! Lift off work surface (already lifted by FCPressEnd)
            pVacPos.trans.z:=SafeZ;
            pVacPos.trans.x:=-WorkMinX;
            pVacPos.extax.eax_a:=Bed1Wyong.uframe.trans.x-WorkMinX;
            MoveL pVacPos,v500,z5,tVac\WObj:=Bed1Wyong;
            
            ! Return to start X (right side) at safe height, step to next Y
            pVacPos.trans.x:=-WorkMaxX;
            pVacPos.trans.y:=NextY;
            pVacPos.extax.eax_a:=Bed1Wyong.uframe.trans.x-WorkMaxX;
            MoveL pVacPos,v500,z5,tVac\WObj:=Bed1Wyong;
            
            CurrentY:=NextY;
        ENDWHILE
        
        Vac_off;
        
        pVacPos.trans.z:=SafeZ;
        MoveL pVacPos,v100,z5,tVac\WObj:=Bed1Wyong;
        
        ConfL\On;
        ConfJ\On;
        
        Vac_Dropoff;
        Home;
        
        TPWrite "PyVac Complete";
    ERROR
        Vac_off;
        RAISE;
    ENDPROC


    PROC PyPolish()
        ! PyPolish - Polisher serpentine with force control
        ! Workzone: bed
        ! Generated by Onyx Toolpath Generator
        
        VAR robtarget pPolPos;
        VAR robtarget pPolEnd;
        VAR num PolZ:=300;
        VAR num SafeZ:=300;
        
        ! Force control parameters
        VAR num StartForce:=300;
        VAR num MotionForce:=300;
        VAR num ForceChange:=100;
        VAR num PosSupvDist:=100;
        
        ! Workspace bounds (with offsets applied)
        VAR num WorkMinX:=0;
        VAR num WorkMaxX:=8500;
        VAR num WorkMinY:=0;
        VAR num WorkMaxY:=1650;
        
        ! Pattern parameters
        VAR num StepSize:=300;
        VAR num SweepDir:=1;
        VAR num YStepDir:=-1;
        VAR num CurrentY:=1650;
        VAR num NextY;
        VAR num StartX;
        VAR num EndX;
        
        VAR speeddata vPolApproach:=[20,30,2000,15];
        VAR speeddata vPolRetract:=[50,30,2000,15];
        VAR speeddata vPolTravel:=[100,30,2000,15];
        VAR num NumPasses;
        
        NumPasses:=Trunc(Abs(WorkMaxY-WorkMinY)/StepSize)+1;
        
        TPWrite "PyPolish: Serpentine Pattern";
        TPWrite "Work Area (8500,1650) to (0,0)";
        TPWrite "Passes=" \Num:=NumPasses;
        TPWrite "Step=" \Num:=StepSize;
        TPWrite "Force=" \Num:=MotionForce;
        
        IF ToolNum<>6 THEN
            TPWrite "PyPolish: ToolNum<>6, need pickup";
            Stop;
            Home;
            Polish_Pickup;
        ELSE
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tPolish\WObj:=Bed1Wyong);
            IF CurrentPos.trans.z<SafeZ THEN
                MoveL Offs(CurrentPos,0,0,(SafeZ-CurrentPos.trans.z)),v500,z5,tPolish\WObj:=Bed1Wyong;
            ENDIF
        ENDIF
        
        ConfL\Off;
        ConfJ\Off;
        
        ! Set start/end based on sweep direction
        IF SweepDir=1 THEN
            StartX:=WorkMinX;
            EndX:=WorkMaxX;
        ELSE
            StartX:=WorkMaxX;
            EndX:=WorkMinX;
        ENDIF
        
        ! Set initial position with fixed orientation (facing +X direction)
        pPolPos:=[[0,0,PolZ],OrientZYX(0,0,180),[1,-1,-1,0],[0,9E+09,9E+09,9E+09,9E+09,9E+09]];
        
        ! Calibrate force control
        FCCalib PolishLoad;
        
        TPWrite "Press Play to start";
        Stop;
        
        ! Move to row start above surface
        pPolPos.trans.x:=-StartX;
        pPolPos.trans.y:=CurrentY;
        pPolPos.trans.z:=SafeZ;
        pPolPos.extax.eax_a:=Bed1Wyong.uframe.trans.x-StartX;
        MoveL pPolPos,vPolTravel,z5,tPolish\WObj:=Bed1Wyong;
        
        ! Lower to approach height
        pPolPos.trans.z:=PolZ+50;
        MoveL pPolPos,vPolApproach,fine,tPolish\WObj:=Bed1Wyong;
        
        ! Turn on polisher and wait for spin-up
        Pol_off;
        WaitTime 0.2;
        Pol_on;
        WaitTime 1.0;
        
        ! Set up end position for first sweep
        pPolEnd:=pPolPos;
        pPolEnd.trans.x:=-EndX;
        pPolEnd.trans.z:=PolZ;
        pPolEnd.extax.eax_a:=Bed1Wyong.uframe.trans.x-EndX;
        
        ! Start force control
        FCPress1LStart Offs(pPolPos,0,0,25),vPolApproach,\Fz:=StartForce,15,\ForceChange:=ForceChange\PosSupvDist:=PosSupvDist,z5,tPolish\WObj:=Bed1Wyong;
        
        ! Main polisher loop - stays in contact during serpentine
        WHILE TRUE DO
            ! === SWEEP X (full length) ===
            FCPressL pPolEnd,vPolTravel,MotionForce,fine,tPolish\WObj:=Bed1Wyong;
            
            ! Calculate next row
            NextY:=CurrentY+(YStepDir*StepSize);
            
            ! Check if pattern complete
            IF (YStepDir=1 AND NextY>WorkMaxY) OR (YStepDir=-1 AND NextY<WorkMinY) THEN
                FCPressEnd Offs(pPolEnd,0,0,50),vPolRetract,\DeactOnly,tPolish\WObj:=Bed1Wyong;
                Pol_off;
                EXIT;
            ENDIF
            
            ! Clamp to bounds
            IF NextY>WorkMaxY THEN
                NextY:=WorkMaxY;
            ELSEIF NextY<WorkMinY THEN
                NextY:=WorkMinY;
            ENDIF
            
            ! Step to next Y row (still in force control)
            pPolEnd.trans.y:=NextY;
            FCPressL pPolEnd,vPolTravel,MotionForce,fine,tPolish\WObj:=Bed1Wyong;
            CurrentY:=NextY;
            
            ! Flip sweep direction
            SweepDir:=-SweepDir;
            IF SweepDir=1 THEN
                StartX:=WorkMinX;
                EndX:=WorkMaxX;
            ELSE
                StartX:=WorkMaxX;
                EndX:=WorkMinX;
            ENDIF
            
            ! Set up end position for next sweep
            pPolEnd.trans.x:=-EndX;
            pPolEnd.extax.eax_a:=Bed1Wyong.uframe.trans.x-EndX;
        ENDWHILE
        
        ! Return to safe height
        pPolPos.trans.z:=SafeZ;
        MoveL pPolPos,vPolTravel,z5,tPolish\WObj:=Bed1Wyong;
        
        ConfL\On;
        ConfJ\On;
        
        Polish_Dropoff;
        Home;
        
        TPWrite "PyPolish Complete";
    ERROR
        Pol_off;
        RAISE;
    ENDPROC


    PROC PyVibScreed()
        ! PyVibScreed - Vibrating Screed with Panel workzone parameters
        ! Workzone: Panel
        ! Panel: X=2200 to 7850, Y=200, Z=150
        ! Panel Start/Finish Offset: 200 mm
        ! Actual travel: X=2000 to 8050
        ! Global Z Offset: 300 mm
        ! Screed Z Offset: 4 mm
        ! Working Z: 454 mm
        ! Speed: 50 mm/s
        ! Angle: 11°
        ! Generated by Onyx Toolpath Generator
        
        VAR robtarget pScreedPos;
        VAR robtarget pScreedEnd;
        VAR num ScrStartX:=2000;
        VAR num ScrEndX:=8050;
        VAR num ScrY:=200;
        VAR num WorkZ:=454;
        VAR num SafeZ:=500;
        VAR num ScrAoffset:=11;
        VAR speeddata vScreed:=[50,30,2000,15];
        
        TPWrite "PyVibScreed: Panel Workzone";
        TPWrite "Start X=" \Num:=ScrStartX;
        TPWrite "End X=" \Num:=ScrEndX;
        TPWrite "Y=" \Num:=ScrY;
        TPWrite "Work Z=" \Num:=WorkZ;
        TPWrite "Speed=" \Num:=50;
        TPWrite "Angle=" \Num:=ScrAoffset;
        
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tVS\WObj:=Bed1Wyong);
        
        IF ToolNum<>3 THEN
            TPWrite "PyVibScreed: ToolNum<>3, need pickup";
            Stop;
            Home;
            VS_Pickup;
        ELSEIF (CurrentPos.trans.z<SafeZ) THEN
            MoveL Offs(CurrentPos,0,0,(SafeZ-CurrentPos.trans.z)),v200,z5,tVS\WObj:=Bed1Wyong;
        ENDIF
        
        ! Set up start position - use pVSstart as template for rotation
        pScreedPos:=pVSstart;
        pScreedPos.trans.x:=-ScrStartX;
        pScreedPos.trans.y:=ScrY;
        pScreedPos.trans.z:=SafeZ;
        pScreedPos.extax.eax_a:=Bed1Wyong.uframe.trans.x-ScrStartX+700;
        
        ! Set up end position
        pScreedEnd:=pScreedPos;
        pScreedEnd.trans.x:=-ScrEndX;
        pScreedEnd.trans.z:=WorkZ;
        pScreedEnd.extax.eax_a:=Bed1Wyong.uframe.trans.x-ScrEndX+700;
        
        ! Move to start position at safe height (holding high)
        MoveL pScreedPos,v500,fine,tVS\WObj:=Bed1Wyong;
        
        ! Drop down to approach height (100mm above work)
        pScreedPos.trans.z:=WorkZ+100;
        MoveL RelTool(pScreedPos,0,0,0\Ry:=ScrAoffset),v200,fine,tVS\WObj:=Bed1Wyong;
        
        ! Start vibrator
        VS_on;
        
        ! Lower to working Z
        pScreedPos.trans.z:=WorkZ;
        MoveL RelTool(pScreedPos,0,0,0\Ry:=ScrAoffset),v50,z5,tVS\WObj:=Bed1Wyong;
        
        ! Screed across panel
        MoveL RelTool(pScreedEnd,0,0,0\Ry:=ScrAoffset),vScreed,z5,tVS\WObj:=Bed1Wyong;
        
        ! Lift off at end
        pScreedEnd.trans.z:=WorkZ+100;
        MoveL RelTool(pScreedEnd,0,0,0\Ry:=ScrAoffset),v100,z5,tVS\WObj:=Bed1Wyong;
        
        VS_off;
        
        ! Return to safe height
        pScreedEnd.trans.z:=SafeZ;
        MoveL pScreedEnd,v200,z5,tVS\WObj:=Bed1Wyong;
        
        VS_Dropoff;
        
        TPWrite "PyVibScreed Complete";
    ENDPROC


    PROC PyPan()
        ! Python-generated Pan procedure
        ! Serpentine pattern over Panel workzone
        
        VAR robtarget pPanPos;
        VAR robtarget pPanEnd;
        VAR robtarget CurrentPos;
        VAR jointtarget CurrentJoints;
        
        ! Workspace bounds (Panel)
        CONST num WorkMinX:=2200;
        CONST num WorkMaxX:=7850;
        CONST num WorkMinY:=200;
        CONST num WorkMaxY:=2200;
        CONST num PanZ:=451;
        CONST num SafeZ:=751;
        
        ! Pattern parameters
        VAR num StepSize:=500;
        VAR num SweepDir:=1;
        VAR num StepDir:=-1;
        VAR num CurrentY:=2200;
        VAR num CurrentX:=2200;
        VAR num NextY;
        VAR num NextX;
        VAR num StartX;
        VAR num EndX;
        VAR num StartY;
        VAR num EndY;
        
        ! Speed and blade parameters
        VAR num PanSpeed:=140;
        VAR num PanAngle:=0;  ! Pan always uses 0 blade angle
        VAR speeddata vPanTravel:=[500,30,2000,15];
        VAR num NumPasses;
        
        NumPasses:=Trunc(Abs(WorkMaxY-WorkMinY)/StepSize)+1;
        
        TPWrite "PyPan: Serpentine Pattern";
        TPWrite "Work Area (7850,2200) to (2200,200)";
        TPWrite "Passes=" \Num:=NumPasses;
        TPWrite "Step=" \Num:=StepSize;
        
        IF ToolNum<>2 THEN
            TPWrite "PyPan: ToolNum<>2, need pickup";
            Stop;
            Home;
            Heli_Pickup;
        ELSE
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tHeli\WObj:=Bed1Wyong);
            IF CurrentPos.trans.z<SafeZ THEN
                MoveL Offs(CurrentPos,0,0,(SafeZ-CurrentPos.trans.z)),v500,z5,tHeli\WObj:=Bed1Wyong;
            ENDIF
        ENDIF
        
        ! Set start/end based on sweep direction
        IF SweepDir=1 THEN
            StartX:=WorkMinX;
            EndX:=WorkMaxX;
        ELSE
            StartX:=WorkMaxX;
            EndX:=WorkMinX;
        ENDIF
        
        ! Set initial position with fixed orientation
        pPanPos:=[[0,0,PanZ],OrientZYX(0,0,180),[0,0,0,0],[0,9E+09,9E+09,9E+09,9E+09,9E+09]];
        
        ! Move to row start above surface
        pPanPos.trans.x:=-StartX;
        pPanPos.trans.y:=CurrentY;
        pPanPos.trans.z:=SafeZ;
        pPanPos.extax.eax_a:=Bed1Wyong.uframe.trans.x-StartX;
        MoveJ pPanPos,v500,z5,tHeli\WObj:=Bed1Wyong;
        
        TPWrite "Press Play to start";
        Stop;
        
        ! Disable configuration tracking for serpentine movements
        ConfL\Off;
        ConfJ\Off;
        
        ! Lower to working height
        pPanPos.trans.z:=PanZ;
        MoveL pPanPos,v50,fine,tHeli\WObj:=Bed1Wyong;
        
        ! Start blade rotation
        HeliBladeSpeed PanSpeed,"FWD";
        WaitTime\InPos,3;
        
        ! Set up end position for first sweep
        pPanEnd:=pPanPos;
        pPanEnd.trans.x:=-EndX;
        pPanEnd.extax.eax_a:=Bed1Wyong.uframe.trans.x-EndX;
        
        ! ========== PASS 1: X-direction sweeps (stepping in Y) ===========
        WHILE TRUE DO
            ! === SWEEP X (full length) ===
            MoveL pPanEnd,vPanTravel,z5,tHeli\WObj:=Bed1Wyong;
            
            ! Calculate next row
            NextY:=CurrentY+(StepDir*StepSize);
            
            ! Check if pass complete
            IF (StepDir=1 AND NextY>WorkMaxY) OR (StepDir=-1 AND NextY<WorkMinY) THEN
                EXIT;
            ENDIF
            
            ! Clamp to bounds
            IF NextY>WorkMaxY THEN
                NextY:=WorkMaxY;
            ELSEIF NextY<WorkMinY THEN
                NextY:=WorkMinY;
            ENDIF
            
            ! Step to next Y row
            pPanEnd.trans.y:=NextY;
            MoveL pPanEnd,vPanTravel,z5,tHeli\WObj:=Bed1Wyong;
            CurrentY:=NextY;
            
            ! Flip sweep direction
            SweepDir:=-SweepDir;
            IF SweepDir=1 THEN
                StartX:=WorkMinX;
                EndX:=WorkMaxX;
            ELSE
                StartX:=WorkMaxX;
                EndX:=WorkMinX;
            ENDIF
            
            ! Set up end position for next sweep
            pPanEnd.trans.x:=-EndX;
            pPanEnd.extax.eax_a:=Bed1Wyong.uframe.trans.x-EndX;
        ENDWHILE
        
        ! ========== PASS 2: Y-direction sweeps (stepping in X) ==========
        
        ! Reset for Y-direction passes - start from current position
        CurrentX:=Abs(pPanEnd.trans.x);
        
        ! Determine step direction based on where Pass 1 ended
        ! At high X, step toward low X; at low X, step toward high X
        IF CurrentX>((WorkMinX+WorkMaxX)/2) THEN
            StepDir:=-1;
        ELSE
            StepDir:=1;
        ENDIF
        
        SweepDir:=1;
        StartY:=WorkMaxY;
        EndY:=WorkMinY;
        
        ! Set up for Y sweep and move to start position
        pPanEnd.trans.y:=EndY;
        MoveL pPanEnd,vPanTravel,z5,tHeli\WObj:=Bed1Wyong;
        
        WHILE TRUE DO
            ! Calculate next column
            NextX:=CurrentX+(StepDir*StepSize);
            
            ! Check if pass complete
            IF (StepDir=1 AND NextX>WorkMaxX) OR (StepDir=-1 AND NextX<WorkMinX) THEN
                EXIT;
            ENDIF
            
            ! Clamp to bounds
            IF NextX>WorkMaxX THEN
                NextX:=WorkMaxX;
            ELSEIF NextX<WorkMinX THEN
                NextX:=WorkMinX;
            ENDIF
            
            ! Step to next X column
            pPanEnd.trans.x:=-NextX;
            pPanEnd.extax.eax_a:=Bed1Wyong.uframe.trans.x-NextX;
            MoveL pPanEnd,vPanTravel,z5,tHeli\WObj:=Bed1Wyong;
            CurrentX:=NextX;
            
            ! Flip sweep direction
            SweepDir:=-SweepDir;
            IF SweepDir=1 THEN
                StartY:=WorkMinY;
                EndY:=WorkMaxY;
            ELSE
                StartY:=WorkMaxY;
                EndY:=WorkMinY;
            ENDIF
            
            ! Set up end position for next sweep
            pPanEnd.trans.y:=EndY;
            
            ! === SWEEP Y (full length) ===
            MoveL pPanEnd,vPanTravel,z5,tHeli\WObj:=Bed1Wyong;
        ENDWHILE
        
        ! === LIFT OFF BED ===
        pPanPos.trans.z:=SafeZ;
        MoveL pPanPos,v100,z5,tHeli\WObj:=Bed1Wyong;
        
        ! === STOP BLADE ROTATION ===
        HeliBladeSpeed 0,"FWD";
        WaitTime\InPos,3;
        
        ConfL\On;
        ConfJ\On;
        
        ! === PACKAWAY ===
        Heli_Dropoff;
        Home;
        
        TPWrite "PyPan Complete";
    ENDPROC


    
    ! ========== PY2 GENERATED PROCEDURES ==========
    ! Generated: 05-feb_10:18
    ! Do not edit manually - regenerate via web interface
    

    PROC Py2Main()
        ! Py2Main - Python-generated tools menu
        ! Generated: 05-feb_10:18
        
        VAR num iChoice;
        
        TPErase;
        TPWrite "=== Py2 Tools (05-feb_10:18) ===";
        TPWrite "Panel X: " \Num:=5000;
        TPWrite "Panel Y: " \Num:=1600;
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



    PROC Py2Heli()
        ! Py2Heli - Cross-hatch pattern (Andrew's pattern base)
        ! Generated by Onyx Toolpath Generator v2
        ! Panel: (2350,200) to (7350,1800)
        ! Z = FormHeight(150) + z_offset(0) = 150mm
        ! Step: 350mm
        ! Pattern: X passes first, then Y passes
        
        VAR robtarget pStart;
        VAR robtarget pEnd;
        VAR robtarget pCurrent;
        VAR jointtarget CurrentJoints;
        VAR robtarget CurrentPos;
        VAR num WorkZ:=0;
        VAR num SafeZ:=0;
        VAR num CurrentY:=0;
        VAR num CurrentX:=0;
        VAR num MinY:=0;
        VAR num MaxY:=0;
        VAR num MinX:=0;
        VAR num MaxX:=0;
        VAR num StepSize:=350;
        VAR num SweepDir:=1;
        VAR num StepDir:=1;
        VAR num PassCount:=0;
        VAR num NextX:=0;
        VAR num StartY:=0;
        VAR num EndY:=0;
        VAR bool bDone:=FALSE;
        VAR speeddata vTravel:=[500,15,2000,15];
        VAR num TrackMin:=-300;
        VAR num TrackMax:=10050;
        VAR num CalcTrack:=0;
        
        ! Initialize runtime values
        WorkZ:=FormHeight+0;
        SafeZ:=WorkZ+200;
        MinY:=200+600/2;
        MaxY:=1800-600/2;
        MinX:=2350+600/2;
        MaxX:=7350-600/2;
        
        TPWrite "========================================";
        TPWrite "Py2Heli: Cross-hatch Starting";
        TPWrite "========================================";
        TPWrite "Panel X: " \Num:=2350;
        TPWrite " to X: " \Num:=7350;
        TPWrite "Panel Y: " \Num:=200;
        TPWrite " to Y: " \Num:=1800;
        TPWrite "WorkZ=" \Num:=WorkZ;
        TPWrite "SafeZ=" \Num:=SafeZ;
        TPWrite "MinX=" \Num:=MinX;
        TPWrite "MaxX=" \Num:=MaxX;
        TPWrite "MinY=" \Num:=MinY;
        TPWrite "MaxY=" \Num:=MaxY;
        TPWrite "StepSize=" \Num:=StepSize;
        
        ! Get helicopter if needed
        IF ToolNum<>2 THEN
            TPWrite "Py2Heli: Getting helicopter...";
            Home;
            Heli_Pickup;
        ENDIF
        
        ! ============================================
        ! PHASE 1: X PASSES (sweep X, step in Y)
        ! Start at far Y, work back toward track
        ! ============================================
        TPWrite "========================================";
        TPWrite "=== PHASE 1: X Passes ===";
        TPWrite "========================================";
        CurrentY:=MaxY;
        SweepDir:=1;
        PassCount:=0;
        TPWrite "P1: Starting at CurrentY=" \Num:=CurrentY;
        TPWrite "P1: Will step toward MinY=" \Num:=MinY;
        
        ! Initialize start position (X negated per Andrew's pattern)
        pStart.trans:=[-1*(MinX-100),CurrentY,WorkZ];
        pStart.rot:=OrientZYX(0,0,180);
        pStart.robconf:=[0,0,0,0];
        
        IF CurrentY<1800 THEN
            CalcTrack:=Bed1Wyong.uframe.trans.x+pStart.trans.x+1000+600/2;
        ELSE
            CalcTrack:=Bed1Wyong.uframe.trans.x+pStart.trans.x+600/2;
        ENDIF
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pStart.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        
        pEnd:=pStart;
        pEnd.trans.x:=-1*(MaxX+100);
        IF CurrentY<1800 THEN
            CalcTrack:=Bed1Wyong.uframe.trans.x+pEnd.trans.x+1000-600/2;
        ELSE
            CalcTrack:=Bed1Wyong.uframe.trans.x+pEnd.trans.x-600/2;
        ENDIF
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pEnd.extax.eax_a:=CalcTrack;
        
        ! Move to start position (safe height)
        pStart.trans.z:=SafeZ;
        MoveJ pStart,v500,z5,tHeli\WObj:=Bed1Wyong;
        
        ! Home stepper and set blade angle
        TPWrite "Py2Heli: Homing stepper...";
        Heli_Stepper_Home;
        HeliBlade_Angle 0;
        WaitTime 1;
        
        ! Disable configuration tracking for serpentine movements
        ConfL\Off;
        ConfJ\Off;
        
        ! Start blade rotation
        TPWrite "Py2Heli: Starting blade...";
        HeliBladeSpeed 70,"FWD";
        WaitTime 2;
        
        ! Lower to work height
        pStart.trans.z:=WorkZ;
        MoveJ Offs(pStart,0,0,50),v100,z5,tHeli\WObj:=Bed1Wyong;
        MoveL pStart,v50,fine,tHeli\WObj:=Bed1Wyong;
        
        TPWrite "P1: Entering X-pass loop...";
        bDone:=FALSE;
        
        ! X-pass serpentine loop (using flag instead of EXIT)
        WHILE CurrentY>=MinY AND bDone=FALSE DO
            Incr PassCount;
            TPWrite "----------------------------------------";
            TPWrite "P1: X Pass " \Num:=PassCount;
            TPWrite "P1: CurrentY=" \Num:=CurrentY;
            TPWrite "P1: SweepDir=" \Num:=SweepDir;
            
            pStart.trans.y:=CurrentY;
            pEnd.trans.y:=CurrentY;
            
            IF CurrentY<1800 THEN
                CalcTrack:=Bed1Wyong.uframe.trans.x+pStart.trans.x+1000+600/2;
            ELSE
                CalcTrack:=Bed1Wyong.uframe.trans.x+pStart.trans.x+600/2;
            ENDIF
            IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
            IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
            pStart.extax.eax_a:=CalcTrack;
            
            IF CurrentY<1800 THEN
                CalcTrack:=Bed1Wyong.uframe.trans.x+pEnd.trans.x+1000-600/2;
            ELSE
                CalcTrack:=Bed1Wyong.uframe.trans.x+pEnd.trans.x-600/2;
            ENDIF
            IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
            IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
            pEnd.extax.eax_a:=CalcTrack;
            
            IF SweepDir=1 THEN
                TPWrite "P1: Sweep to pEnd (far X)";
                MoveL pEnd,vTravel,fine,tHeli\WObj:=Bed1Wyong;
            ELSE
                TPWrite "P1: Sweep to pStart (near X)";
                MoveL pStart,vTravel,fine,tHeli\WObj:=Bed1Wyong;
            ENDIF
            TPWrite "P1: Sweep complete";
            
            IF (CurrentY-StepSize)<MinY THEN
                TPWrite "P1: Last pass - (CurrentY-StepSize) < MinY";
                TPWrite "P1: Setting bDone=TRUE to exit loop";
                bDone:=TRUE;
            ELSE
                ! Only step to next row if not done
                CurrentY:=CurrentY-StepSize;
                TPWrite "P1: Step to next Y row=" \Num:=CurrentY;
                
                IF SweepDir=1 THEN
                    pEnd.trans.y:=CurrentY;
                    IF CurrentY<1800 THEN
                        CalcTrack:=Bed1Wyong.uframe.trans.x+pEnd.trans.x+1000-600/2;
                    ELSE
                        CalcTrack:=Bed1Wyong.uframe.trans.x+pEnd.trans.x-600/2;
                    ENDIF
                    IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
                    IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
                    pEnd.extax.eax_a:=CalcTrack;
                    MoveL pEnd,vTravel,fine,tHeli\WObj:=Bed1Wyong;
                ELSE
                    pStart.trans.y:=CurrentY;
                    IF CurrentY<1800 THEN
                        CalcTrack:=Bed1Wyong.uframe.trans.x+pStart.trans.x+1000+600/2;
                    ELSE
                        CalcTrack:=Bed1Wyong.uframe.trans.x+pStart.trans.x+600/2;
                    ENDIF
                    IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
                    IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
                    pStart.extax.eax_a:=CalcTrack;
                    MoveL pStart,vTravel,fine,tHeli\WObj:=Bed1Wyong;
                ENDIF
                
                SweepDir:=-1*SweepDir;
            ENDIF
        ENDWHILE
        
        TPWrite "P1: X passes complete, total=" \Num:=PassCount;
        TPWrite "P1: Final position Y=" \Num:=CurrentY;
        TPWrite "P1: pEnd.trans.x=" \Num:=pEnd.trans.x;
        
        ! ============================================
        ! PHASE 2: Y PASSES (sweep Y, step in X)
        ! Continue from where Pass 1 ended (like baseline PyHeli)
        ! ============================================
        TPWrite "========================================";
        TPWrite "=== PHASE 2: Y Passes ===";
        TPWrite "========================================";
        
        ! Get current position from where X passes ended
        CurrentX:=Abs(pEnd.trans.x);
        TPWrite "Pass2: CurrentX=" \Num:=CurrentX;
        TPWrite "Pass2: CurrentY=" \Num:=CurrentY;
        
        ! Determine step direction based on where Pass 1 ended
        IF CurrentX>((MinX+MaxX)/2) THEN
            StepDir:=-1;
            TPWrite "Pass2: StepDir=-1";
        ELSE
            StepDir:=1;
            TPWrite "Pass2: StepDir=+1";
        ENDIF
        
        ! Determine sweep direction based on where Pass 1 ended
        IF CurrentY>((MinY+MaxY)/2) THEN
            SweepDir:=1;
            StartY:=MaxY;
            EndY:=MinY;
            TPWrite "P2: SweepDir=1 (toward MinY)";
        ELSE
            SweepDir:=-1;
            StartY:=MinY;
            EndY:=MaxY;
            TPWrite "P2: SweepDir=-1 (toward MaxY)";
        ENDIF
        TPWrite "P2: StartY=" \Num:=StartY;
        TPWrite "P2: EndY=" \Num:=EndY;
        
        PassCount:=0;
        
        ! First Y sweep from current position
        TPWrite "P2: First Y sweep to EndY=" \Num:=EndY;
        pEnd.trans.y:=EndY;
        TPWrite "P2: Moving...";
        MoveL pEnd,vTravel,fine,tHeli\WObj:=Bed1Wyong;
        TPWrite "P2: First Y sweep complete";
        
        TPWrite "P2: Entering Y-pass loop...";
        bDone:=FALSE;
        
        ! Y-pass loop - step in X, sweep in Y (using flag instead of EXIT)
        WHILE bDone=FALSE DO
            Incr PassCount;
            TPWrite "----------------------------------------";
            TPWrite "P2: Y Pass " \Num:=PassCount;
            
            ! Calculate next column
            NextX:=CurrentX+(StepDir*StepSize);
            TPWrite "P2: CurrentX=" \Num:=CurrentX;
            TPWrite "P2: NextX=" \Num:=NextX;
            
            ! Check if complete
            IF (StepDir=1 AND NextX>MaxX) OR (StepDir=-1 AND NextX<MinX) THEN
                TPWrite "P2: NextX out of bounds - setting bDone=TRUE";
                bDone:=TRUE;
            ELSE
                ! Clamp to bounds
                IF NextX>MaxX THEN
                    NextX:=MaxX;
                    TPWrite "P2: Clamped to MaxX";
                ELSEIF NextX<MinX THEN
                    NextX:=MinX;
                    TPWrite "P2: Clamped to MinX";
                ENDIF
                
                ! Step to next X column
                TPWrite "P2: Step to X=" \Num:=NextX;
                pEnd.trans.x:=-1*NextX;
                CalcTrack:=Bed1Wyong.uframe.trans.x-NextX;
                IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
                IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
                pEnd.extax.eax_a:=CalcTrack;
                TPWrite "P2: Moving to next X column...";
                MoveL pEnd,vTravel,fine,tHeli\WObj:=Bed1Wyong;
                TPWrite "P2: Step complete";
                CurrentX:=NextX;
                
                ! Flip sweep direction
                SweepDir:=-1*SweepDir;
                IF SweepDir=1 THEN
                    EndY:=MinY;
                    TPWrite "P2: Next sweep toward MinY=" \Num:=EndY;
                ELSE
                    EndY:=MaxY;
                    TPWrite "P2: Next sweep toward MaxY=" \Num:=EndY;
                ENDIF
                
                ! Sweep Y
                TPWrite "P2: Sweep to Y=" \Num:=EndY;
                pEnd.trans.y:=EndY;
                TPWrite "P2: Moving...";
                MoveL pEnd,vTravel,fine,tHeli\WObj:=Bed1Wyong;
                TPWrite "P2: Sweep complete";
            ENDIF
        ENDWHILE
        
        TPWrite "========================================";
        TPWrite "P2: Y passes complete, total=" \Num:=PassCount;
        TPWrite "Cross-hatch complete!";
        TPWrite "========================================";
        
        ! ============================================
        ! FINISH: Stop blade, lift tool, return
        ! ============================================
        TPWrite "========================================";
        TPWrite "=== FINISH ===";
        TPWrite "========================================";
        
        TPWrite "FINISH: Stopping blade...";
        HeliBladeSpeed 0,"FWD";
        WaitTime 1;
        TPWrite "FINISH: Blade stopped";
        
        ! Lift off the bed
        TPWrite "FINISH: Lifting off bed...";
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tHeli\WObj:=Bed1Wyong);
        MoveJ Offs(CurrentPos,0,0,200),v100,fine,tHeli\WObj:=Bed1Wyong;
        TPWrite "FINISH: Lifted 200mm";
        
        ! Re-enable configuration tracking
        TPWrite "FINISH: Re-enabling ConfL/ConfJ...";
        ConfL\On;
        ConfJ\On;
        TPWrite "FINISH: Configuration tracking enabled";
        
        ! Return tool
        TPWrite "FINISH: Dropping off helicopter...";
        Heli_Dropoff;
        TPWrite "FINISH: Helicopter dropped off";
        
        TPWrite "FINISH: Homing...";
        Home;
        
        TPWrite "========================================";
        TPWrite "Py2Heli: COMPLETE";
        TPWrite "========================================";
        
    ERROR
        HeliBladeSpeed 0,"FWD";
        RAISE;
    ENDPROC



    PROC Py2Polish()
        ! Py2Polish - Polisher serpentine with force control
        ! Generated by Onyx Toolpath Generator v2
        ! Workzone: bed
        ! Area: (150,150) to (8500,1650)
        ! Z = 50mm (FormHeight + offset)
        ! Step: 300mm
        ! Force: Start=150N, Motion=150N
        
        VAR robtarget pStart;
        VAR robtarget pEnd;
        VAR jointtarget CurrentJoints;
        VAR robtarget CurrentPos;
        VAR num WorkZ:=0;
        VAR num SafeZ:=0;
        VAR num CurrentY:=0;
        VAR num MinY:=0;
        VAR num MaxY:=0;
        VAR num MinX:=0;
        VAR num MaxX:=0;
        VAR num StepSize:=300;
        VAR num SweepDir:=1;
        VAR num PassCount:=0;
        VAR bool bDone:=FALSE;
        VAR speeddata vApproach:=[20,15,2000,15];
        VAR speeddata vRetract:=[50,15,2000,15];
        VAR speeddata vTravel:=[100,15,2000,15];
        VAR num TrackMin:=-300;
        VAR num TrackMax:=10050;
        VAR num CalcTrack:=0;
        
        ! Initialize runtime values
        WorkZ:=50;
        SafeZ:=WorkZ+200;
        MinY:=150;
        MaxY:=1650;
        MinX:=150;
        MaxX:=8500;
        
        TPWrite "========================================";
        TPWrite "Py2Polish: Starting";
        TPWrite "========================================";
        TPWrite "Workzone: bed";
        TPWrite "MinX=" \Num:=MinX;
        TPWrite "MaxX=" \Num:=MaxX;
        TPWrite "MinY=" \Num:=MinY;
        TPWrite "MaxY=" \Num:=MaxY;
        TPWrite "WorkZ=" \Num:=WorkZ;
        TPWrite "StepSize=" \Num:=StepSize;
        TPWrite "Force Control: ENABLED";
        
        ! Get polisher if needed
        IF ToolNum<>6 THEN
            TPWrite "Py2Polish: Getting polisher...";
            Home;
            Polish_Pickup;
        ELSE
            ! Already have polisher - ensure safe height
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tPolish\WObj:=wobj0);
            IF CurrentPos.trans.z<600 THEN
                MoveL Offs(CurrentPos,0,0,(600-CurrentPos.trans.z)),v500,z5,tPolish;
            ENDIF
        ENDIF
        
        ! ============================================
        ! SERPENTINE PASSES (sweep X, step in Y)
        ! Start at far Y, work back toward track
        ! ============================================
        CurrentY:=MaxY;
        SweepDir:=1;
        PassCount:=0;
        
        TPWrite "Starting serpentine at Y=" \Num:=CurrentY;
        
        ! Initialize start position (X negated per Andrew's pattern)
        pStart.trans:=[-1*MinX,CurrentY,SafeZ];
        pStart.rot:=OrientZYX(0,0,180);
        pStart.robconf:=[0,0,0,0];
        
        ! Clamp track position to limits - arm will extend to reach target
        CalcTrack:=Bed1Wyong.uframe.trans.x+pStart.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pStart.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        
        pEnd:=pStart;
        pEnd.trans.x:=-1*MaxX;
        CalcTrack:=Bed1Wyong.uframe.trans.x+pEnd.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pEnd.extax.eax_a:=CalcTrack;
        
        ! Move to start position (safe height)
        MoveJ pStart,v500,z5,tPolish\WObj:=Bed1Wyong;
        
        ! Disable configuration tracking
        ConfL\Off;
        ConfJ\Off;
        
        ! Turn on polisher (only if force control enabled)
        Pol_on;
        
        ! Lower to work height and START force control ONCE before serpentine
        pStart.trans.z:=WorkZ;
        pEnd.trans.z:=WorkZ;
        MoveJ Offs(pStart,0,0,50),v100,z5,tPolish\WObj:=Bed1Wyong;
        
        ! Start force control - stays active for entire serpentine
        WaitTime\inpos,0.1;
        FCCalib PolishLoad;
        FCPress1LStart pStart,vApproach,\Fz:=150,15,\ForceChange:=150\PosSupvDist:=100,z5,tPolish\WObj:=Bed1Wyong;
        
        TPWrite "On work surface, starting serpentine...";
        
        bDone:=FALSE;
        
        ! Serpentine loop - STAY ON SURFACE throughout
        WHILE CurrentY>=MinY AND bDone=FALSE DO
            Incr PassCount;
            TPWrite "----------------------------------------";
            TPWrite "Pass " \Num:=PassCount;
            TPWrite "CurrentY=" \Num:=CurrentY;
            TPWrite "SweepDir=" \Num:=SweepDir;
            
            ! Update Y position (Z stays at WorkZ)
            pStart.trans.y:=CurrentY;
            pEnd.trans.y:=CurrentY;
            
            IF SweepDir=1 THEN
                ! Forward pass (MinX to MaxX) - stay on surface with force control
                TPWrite "Forward pass to MaxX";
                FCPressL pEnd,vTravel,150,fine,tPolish\WObj:=Bed1Wyong;
            ELSE
                ! Reverse pass (MaxX to MinX) - stay on surface with force control
                TPWrite "Reverse pass to MinX";
                FCPressL pStart,vTravel,150,fine,tPolish\WObj:=Bed1Wyong;
            ENDIF
            
            TPWrite "Pass complete";
            
            ! Check if we should continue
            IF (CurrentY-StepSize)<MinY THEN
                TPWrite "Last pass reached - done";
                bDone:=TRUE;
            ELSE
                ! Step to next row - STAY ON SURFACE
                CurrentY:=CurrentY-StepSize;
                TPWrite "Step to Y=" \Num:=CurrentY;
                
                ! Update Y and step while staying on surface (clamp track to limits)
                IF SweepDir=1 THEN
                    pEnd.trans.y:=CurrentY;
                    CalcTrack:=Bed1Wyong.uframe.trans.x+pEnd.trans.x;
                    IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
                    IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
                    pEnd.extax.eax_a:=CalcTrack;
                    FCPressL pEnd,vTravel,150,fine,tPolish\WObj:=Bed1Wyong;
                ELSE
                    pStart.trans.y:=CurrentY;
                    CalcTrack:=Bed1Wyong.uframe.trans.x+pStart.trans.x;
                    IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
                    IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
                    pStart.extax.eax_a:=CalcTrack;
                    FCPressL pStart,vTravel,150,fine,tPolish\WObj:=Bed1Wyong;
                ENDIF
                
                ! Flip direction
                SweepDir:=-1*SweepDir;
            ENDIF
        ENDWHILE
        
        ! END force control ONCE after all passes complete
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tPolish\WObj:=Bed1Wyong);
        FCPressEnd Offs(CurrentPos,0,0,75),vRetract,\DeactOnly,tPolish\WObj:=Bed1Wyong;
        
        TPWrite "========================================";
        TPWrite "Py2Polish: Complete";
        TPWrite "Total passes=" \Num:=PassCount;
        TPWrite "========================================";
        
        ! Ensure polisher is off (only if it was turned on)
        Pol_off;
        
        ! Re-enable configuration tracking
        ConfL\On;
        ConfJ\On;
        
        ! Return to safe position (already lifted if force control was used)
        ! Already lifted by FCPressEnd
        ! Moving to safe height
        
        
        ! Return tool and go home
        TPWrite "Py2Polish: Dropping off polisher...";
        Polish_Dropoff;
        TPWrite "Py2Polish: Polisher dropped off";
        
        TPWrite "Py2Polish: Homing...";
        Home;
        
        TPWrite "========================================";
        TPWrite "Py2Polish: COMPLETE";
        TPWrite "========================================";
        
    ERROR
        Pol_off;
        TPWrite "Py2Polish ERROR: " \Num:=ERRNO;
        RAISE;
    ENDPROC



    PROC Py2Vacuum()
        ! Py2Vacuum - Cross-hatch pattern for vacuum
        ! Generated by Onyx Toolpath Generator v2
        ! Workzone: bed
        ! Area: (0,0) to (8500,1650)
        ! Z = -20mm
        ! Step: 300mm
        ! Pattern: X passes first, then Y passes
        
        VAR robtarget pStart;
        VAR robtarget pEnd;
        VAR jointtarget CurrentJoints;
        VAR robtarget CurrentPos;
        VAR num WorkZ:=0;
        VAR num SafeZ:=0;
        VAR num CurrentY:=0;
        VAR num CurrentX:=0;
        VAR num MinY:=0;
        VAR num MaxY:=0;
        VAR num MinX:=0;
        VAR num MaxX:=0;
        VAR num StepSize:=300;
        VAR num SweepDir:=1;
        VAR num StepDir:=1;
        VAR num PassCount:=0;
        VAR num NextX:=0;
        VAR num StartY:=0;
        VAR num EndY:=0;
        VAR bool bDone:=FALSE;
        VAR speeddata vTravel:=[200,15,2000,15];
        VAR num TrackMin:=-300;
        VAR num TrackMax:=10050;
        VAR num CalcTrack:=0;
        
        ! Initialize runtime values
        WorkZ:=-20;
        SafeZ:=WorkZ+200;
        MinY:=0+400/2;
        MaxY:=1650-400/2;
        MinX:=0+400/2;
        MaxX:=8500-400/2;
        
        TPWrite "========================================";
        TPWrite "Py2Vacuum: Cross-hatch Starting";
        TPWrite "========================================";
        TPWrite "Workzone: bed";
        TPWrite "MinX=" \Num:=MinX;
        TPWrite "MaxX=" \Num:=MaxX;
        TPWrite "MinY=" \Num:=MinY;
        TPWrite "MaxY=" \Num:=MaxY;
        TPWrite "WorkZ=" \Num:=WorkZ;
        TPWrite "StepSize=" \Num:=StepSize;
        
        ! Get vacuum if needed
        IF ToolNum<>5 THEN
            TPWrite "Py2Vacuum: Getting vacuum...";
            Home;
            Vac_Pickup;
        ELSE
            ! Already have vacuum - ensure safe height
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tVac\WObj:=Bed1Wyong);
            IF CurrentPos.trans.z<600 THEN
                MoveL Offs(CurrentPos,0,0,(600-CurrentPos.trans.z)),v500,z5,tVac\WObj:=Bed1Wyong;
            ENDIF
        ENDIF
        
        ! ============================================
        ! PHASE 1: X PASSES (sweep X, step in Y)
        ! Start at far Y (MaxY), work back toward track
        ! ============================================
        TPWrite "P1: Starting X passes...";
        CurrentY:=MaxY;
        SweepDir:=1;
        PassCount:=0;
        TPWrite "P1: Starting at CurrentY=" \Num:=CurrentY;
        
        ! Initialize start position (X negated per Bed1Wyong)
        pStart.trans:=[-1*(MinX-100),CurrentY,WorkZ];
        pStart.rot:=OrientZYX(0,0,180);
        pStart.robconf:=[0,0,0,0];
        
        ! Clamp track position
        CalcTrack:=Bed1Wyong.uframe.trans.x+pStart.trans.x+400/2;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pStart.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        
        pEnd:=pStart;
        pEnd.trans.x:=-1*(MaxX+100);
        CalcTrack:=Bed1Wyong.uframe.trans.x+pEnd.trans.x-400/2;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pEnd.extax.eax_a:=CalcTrack;
        
        ! Move to start position (safe height)
        pStart.trans.z:=SafeZ;
        MoveJ pStart,v500,z5,tVac\WObj:=Bed1Wyong;
        
        ! Disable configuration tracking
        ConfL\Off;
        ConfJ\Off;
        
        ! Turn on vacuum
        TPWrite "Py2Vacuum: Starting vacuum...";
        Vac_on;
        WaitTime 1;
        
        ! Lower to work height
        pStart.trans.z:=WorkZ;
        pEnd.trans.z:=WorkZ;
        MoveJ Offs(pStart,0,0,50),v100,z5,tVac\WObj:=Bed1Wyong;
        MoveL pStart,v50,fine,tVac\WObj:=Bed1Wyong;
        
        TPWrite "P1: Entering X-pass loop...";
        bDone:=FALSE;
        
        ! X-pass serpentine loop
        WHILE CurrentY>=MinY AND bDone=FALSE DO
            Incr PassCount;
            TPWrite "----------------------------------------";
            TPWrite "P1: X Pass " \Num:=PassCount;
            TPWrite "P1: CurrentY=" \Num:=CurrentY;
            
            pStart.trans.y:=CurrentY;
            pEnd.trans.y:=CurrentY;
            
            ! Update extax with clamping
            CalcTrack:=Bed1Wyong.uframe.trans.x+pStart.trans.x+400/2;
            IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
            IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
            pStart.extax.eax_a:=CalcTrack;
            
            CalcTrack:=Bed1Wyong.uframe.trans.x+pEnd.trans.x-400/2;
            IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
            IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
            pEnd.extax.eax_a:=CalcTrack;
            
            IF SweepDir=1 THEN
                TPWrite "P1: Sweep to pEnd (far X)";
                MoveL pEnd,vTravel,fine,tVac\WObj:=Bed1Wyong;
            ELSE
                TPWrite "P1: Sweep to pStart (near X)";
                MoveL pStart,vTravel,fine,tVac\WObj:=Bed1Wyong;
            ENDIF
            
            IF (CurrentY-StepSize)<MinY THEN
                TPWrite "P1: Last pass - setting bDone=TRUE";
                bDone:=TRUE;
            ELSE
                ! Step to next row
                CurrentY:=CurrentY-StepSize;
                TPWrite "P1: Step to next Y row=" \Num:=CurrentY;
                
                IF SweepDir=1 THEN
                    pEnd.trans.y:=CurrentY;
                    CalcTrack:=Bed1Wyong.uframe.trans.x+pEnd.trans.x-400/2;
                    IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
                    IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
                    pEnd.extax.eax_a:=CalcTrack;
                    MoveL pEnd,vTravel,fine,tVac\WObj:=Bed1Wyong;
                ELSE
                    pStart.trans.y:=CurrentY;
                    CalcTrack:=Bed1Wyong.uframe.trans.x+pStart.trans.x+400/2;
                    IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
                    IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
                    pStart.extax.eax_a:=CalcTrack;
                    MoveL pStart,vTravel,fine,tVac\WObj:=Bed1Wyong;
                ENDIF
                
                SweepDir:=-1*SweepDir;
            ENDIF
        ENDWHILE
        
        TPWrite "P1: X passes complete, total=" \Num:=PassCount;
        
        ! ============================================
        ! PHASE 2: Y PASSES (sweep Y, step in X)
        ! Start at current X position, sweep in Y
        ! ============================================
        TPWrite "P2: Starting Y passes...";
        
        ! Reset for Y passes - start from MinX
        CurrentX:=MinX;
        StepDir:=1;
        PassCount:=0;
        bDone:=FALSE;
        
        ! Determine sweep direction based on where we ended Phase 1
        IF SweepDir=1 THEN
            StartY:=MinY;
            EndY:=MaxY;
        ELSE
            StartY:=MaxY;
            EndY:=MinY;
        ENDIF
        
        ! Initialize position for Y sweeps
        pStart.trans:=[-1*CurrentX,StartY,WorkZ];
        pEnd.trans:=[-1*CurrentX,EndY,WorkZ];
        
        CalcTrack:=Bed1Wyong.uframe.trans.x-CurrentX;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pStart.extax.eax_a:=CalcTrack;
        pEnd.extax.eax_a:=CalcTrack;
        
        TPWrite "P2: Starting at X=" \Num:=CurrentX;
        TPWrite "P2: StartY=" \Num:=StartY;
        TPWrite "P2: EndY=" \Num:=EndY;
        
        ! Y-pass serpentine loop
        WHILE bDone=FALSE DO
            Incr PassCount;
            TPWrite "----------------------------------------";
            TPWrite "P2: Y Pass " \Num:=PassCount;
            TPWrite "P2: CurrentX=" \Num:=CurrentX;
            
            ! Sweep in Y direction
            IF SweepDir=1 THEN
                TPWrite "P2: Sweep toward MaxY";
                MoveL pEnd,vTravel,fine,tVac\WObj:=Bed1Wyong;
            ELSE
                TPWrite "P2: Sweep toward MinY";
                MoveL pStart,vTravel,fine,tVac\WObj:=Bed1Wyong;
            ENDIF
            
            ! Calculate next X position
            NextX:=CurrentX+(StepDir*StepSize);
            
            ! Check if complete
            IF (StepDir=1 AND NextX>MaxX) OR (StepDir=-1 AND NextX<MinX) THEN
                TPWrite "P2: NextX out of bounds - setting bDone=TRUE";
                bDone:=TRUE;
            ELSE
                ! Clamp to bounds
                IF NextX>MaxX THEN
                    NextX:=MaxX;
                ELSEIF NextX<MinX THEN
                    NextX:=MinX;
                ENDIF
                
                ! Step to next X column
                TPWrite "P2: Step to X=" \Num:=NextX;
                pEnd.trans.x:=-1*NextX;
                pStart.trans.x:=-1*NextX;
                CalcTrack:=Bed1Wyong.uframe.trans.x-NextX;
                IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
                IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
                pEnd.extax.eax_a:=CalcTrack;
                pStart.extax.eax_a:=CalcTrack;
                
                IF SweepDir=1 THEN
                    MoveL pEnd,vTravel,fine,tVac\WObj:=Bed1Wyong;
                ELSE
                    MoveL pStart,vTravel,fine,tVac\WObj:=Bed1Wyong;
                ENDIF
                
                CurrentX:=NextX;
                SweepDir:=-1*SweepDir;
            ENDIF
        ENDWHILE
        
        TPWrite "P2: Y passes complete, total=" \Num:=PassCount;
        
        ! ============================================
        ! FINISH: Turn off vacuum, raise, dropoff
        ! ============================================
        TPWrite "========================================";
        TPWrite "Py2Vacuum: Complete";
        TPWrite "========================================";
        
        ! Turn off vacuum
        Vac_off;
        
        ! Raise to safe height
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tVac\WObj:=Bed1Wyong);
        MoveL Offs(CurrentPos,0,0,200),v200,z5,tVac\WObj:=Bed1Wyong;
        
        ! Re-enable config tracking
        ConfL\On;
        ConfJ\On;
        
        ! Return tool and go home
        TPWrite "Py2Vacuum: Dropping off vacuum...";
        Vac_Dropoff;
        TPWrite "Py2Vacuum: Vacuum dropped off";
        
        TPWrite "Py2Vacuum: Homing...";
        Home;
        
        TPWrite "========================================";
        TPWrite "Py2Vacuum: COMPLETE";
        TPWrite "========================================";
        
    ERROR
        Vac_off;
        TPWrite "Py2Vacuum ERROR: " \Num:=ERRNO;
        RAISE;
    ENDPROC

    
    ! ========== END PY2 GENERATED PROCEDURES ==========

ENDMODULE