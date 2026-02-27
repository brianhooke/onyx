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

    
    ! ========== PY2 GENERATED PROCEDURES ==========
    ! Generated: 27-feb_16:09
    ! Do not edit manually - regenerate via web interface
    

    PROC MainMenu()
        VAR num iTask;
        TPErase;
        TPReadNum iTask,"1:Home,2:Py2_27-feb_16:09";
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


    PROC Py2Main()
        ! Py2Main - Python-generated tools menu
        ! Generated: 27-feb_16:09
        
        VAR num iChoice;
        
        TPErase;
        TPWrite "=== Py2 Tools (27-feb_16:09) ===";
        TPWrite "Panel X: " \Num:=5530;
        TPWrite "Panel Y: " \Num:=2000;
        TPReadNum iChoice,"1:Heli,2:Polish,3:Vac,4:Pan,5:Screed,6:BedClean";
        
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
            SeqBedClean;
        DEFAULT:
            TPWrite "Invalid choice";
        ENDTEST
    ENDPROC


    PROC Py2Heli()
        ! Py2Heli - Generated by Onyx Tool Class
        ! Workzone: panel
        ! Area: (450,450) to (5380,1700)
        ! Z = 650mm
        ! Step: 200mm

        VAR robtarget pCurrent;
        VAR jointtarget CurrentJoints;
        VAR robtarget CurrentPos;
        VAR num WorkZ:=650;
        VAR num SafeZ:=850;
        VAR num CurrentX:=0;
        VAR num CurrentY:=0;
        VAR speeddata vTravel:=[100,15,2000,15];
        VAR num TrackMin:=-300;
        VAR num TrackMax:=10050;
        VAR num CalcTrack:=0;
        VAR num HeliForce:=0;
        VAR bool bFCActive:=FALSE;
        VAR fcforcevector myForceVector;

        TPWrite "========================================";
        TPWrite "Py2Heli: Starting";
        TPWrite "========================================";
        TPWrite "Workzone: panel";
        TPWrite "WorkZ=" \Num:=WorkZ;

        ! Get tool if needed
        IF ToolNum<>2 THEN
            TPWrite "Py2Heli: Getting tool...";
            Home;
            Heli_Pickup;
        ENDIF

        ! Disable configuration tracking
        ConfL\Off;
        ConfJ\Off;

        ! Home stepper and set blade angle
        TPWrite "Py2Heli: Homing stepper...";
        Heli_Stepper_Home;
        ! Blade angle set via params

        ! ========================================
        ! Pattern Execution: 3 points
        ! ========================================

        ! Point 1: (1000, 1150) [rapid]
        CurrentX:=1000;
        CurrentY:=1150;
        pCurrent.trans:=[-1*CurrentX,CurrentY,SafeZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveJ pCurrent,v500,z5,tHeli\WObj:=Bed1Wyong;

        ! Point 2: (4830, 1150) [work]
        CurrentX:=4830;
        CurrentY:=1150;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 3: (4830, 1000) [work]
        CurrentX:=4830;
        CurrentY:=1000;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Stop blade rotation
        HeliBladeSpeed 0,"FWD";
        WaitTime 1;

        ! Lift to safe height
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tHeli\WObj:=Bed1Wyong);
        MoveL Offs(CurrentPos,0,0,200),v200,z5,tHeli\WObj:=Bed1Wyong;

        ! Re-enable configuration tracking
        ConfL\On;
        ConfJ\On;

        ! Return tool and go home
        TPWrite "Py2Heli: Dropping off tool...";
        Heli_Dropoff;
        Home;

        TPWrite "========================================";
        TPWrite "Py2Heli: COMPLETE";
        TPWrite "========================================";

    ERROR
        HeliBladeSpeed 0,"FWD";
        IF bFCActive THEN
            FCPressEnd Offs(CurrentPos,0,0,100),v50,\DeactOnly,tHeli\WObj:=Bed1Wyong;
        ENDIF
        RAISE;
    ENDPROC

    PROC Py2Polish()
        ! Py2Polish - Generated by Onyx Tool Class
        ! Workzone: panel
        ! Area: (250,250) to (5580,1900)
        ! Z = 650mm
        ! Step: 200mm

        VAR robtarget pCurrent;
        VAR jointtarget CurrentJoints;
        VAR robtarget CurrentPos;
        VAR num WorkZ:=650;
        VAR num SafeZ:=850;
        VAR num CurrentX:=0;
        VAR num CurrentY:=0;
        VAR speeddata vTravel:=[100,15,2000,15];
        VAR num TrackMin:=-300;
        VAR num TrackMax:=10050;
        VAR num CalcTrack:=0;
        VAR bool bFCActive:=FALSE;

        TPWrite "========================================";
        TPWrite "Py2Polish: Starting";
        TPWrite "========================================";
        TPWrite "Workzone: panel";
        TPWrite "WorkZ=" \Num:=WorkZ;

        ! Get tool if needed
        IF ToolNum<>6 THEN
            TPWrite "Py2Polish: Getting tool...";
            Home;
            Polish_Pickup;
        ENDIF

        ! Disable configuration tracking
        ConfL\Off;
        ConfJ\Off;

        ! ========================================
        ! Pattern Execution: 76 points
        ! ========================================

        ! Turn on polisher motor
        Pol_on;

        ! Force control calibration
        WaitTime\inpos,0.1;
        FCCalib PolishLoad;

        ! Start force control
        FCPress1LStart pCurrent,v20,\Fz:=200,15,\ForceChange:=150\PosSupvDist:=50,z5,tPolish\WObj:=Bed1Wyong;
        bFCActive:=TRUE;

        ! Point 1: (250, 1900) [rapid]
        CurrentX:=250;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,SafeZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveJ pCurrent,v500,z5,tPolish\WObj:=Bed1Wyong;

        ! Point 2: (5580, 1900) [work]
        CurrentX:=5580;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 3: (5580, 1700) [work]
        CurrentX:=5580;
        CurrentY:=1700;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 4: (250, 1700) [work]
        CurrentX:=250;
        CurrentY:=1700;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 5: (250, 1500) [work]
        CurrentX:=250;
        CurrentY:=1500;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 6: (5580, 1500) [work]
        CurrentX:=5580;
        CurrentY:=1500;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 7: (5580, 1300) [work]
        CurrentX:=5580;
        CurrentY:=1300;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 8: (250, 1300) [work]
        CurrentX:=250;
        CurrentY:=1300;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 9: (250, 1100) [work]
        CurrentX:=250;
        CurrentY:=1100;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 10: (5580, 1100) [work]
        CurrentX:=5580;
        CurrentY:=1100;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 11: (5580, 900) [work]
        CurrentX:=5580;
        CurrentY:=900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 12: (250, 900) [work]
        CurrentX:=250;
        CurrentY:=900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 13: (250, 700) [work]
        CurrentX:=250;
        CurrentY:=700;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 14: (5580, 700) [work]
        CurrentX:=5580;
        CurrentY:=700;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 15: (5580, 500) [work]
        CurrentX:=5580;
        CurrentY:=500;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 16: (250, 500) [work]
        CurrentX:=250;
        CurrentY:=500;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 17: (250, 300) [work]
        CurrentX:=250;
        CurrentY:=300;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 18: (5580, 300) [work]
        CurrentX:=5580;
        CurrentY:=300;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 19: (5580, 250) [work]
        CurrentX:=5580;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 20: (250, 250) [work]
        CurrentX:=250;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 21: (250, 250) [work]
        CurrentX:=250;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 22: (250, 1900) [work]
        CurrentX:=250;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 23: (450, 1900) [work]
        CurrentX:=450;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 24: (450, 250) [work]
        CurrentX:=450;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 25: (650, 250) [work]
        CurrentX:=650;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 26: (650, 1900) [work]
        CurrentX:=650;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 27: (850, 1900) [work]
        CurrentX:=850;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 28: (850, 250) [work]
        CurrentX:=850;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 29: (1050, 250) [work]
        CurrentX:=1050;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 30: (1050, 1900) [work]
        CurrentX:=1050;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 31: (1250, 1900) [work]
        CurrentX:=1250;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 32: (1250, 250) [work]
        CurrentX:=1250;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 33: (1450, 250) [work]
        CurrentX:=1450;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 34: (1450, 1900) [work]
        CurrentX:=1450;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 35: (1650, 1900) [work]
        CurrentX:=1650;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 36: (1650, 250) [work]
        CurrentX:=1650;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 37: (1850, 250) [work]
        CurrentX:=1850;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 38: (1850, 1900) [work]
        CurrentX:=1850;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 39: (2050, 1900) [work]
        CurrentX:=2050;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 40: (2050, 250) [work]
        CurrentX:=2050;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 41: (2250, 250) [work]
        CurrentX:=2250;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 42: (2250, 1900) [work]
        CurrentX:=2250;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 43: (2450, 1900) [work]
        CurrentX:=2450;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 44: (2450, 250) [work]
        CurrentX:=2450;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 45: (2650, 250) [work]
        CurrentX:=2650;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 46: (2650, 1900) [work]
        CurrentX:=2650;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 47: (2850, 1900) [work]
        CurrentX:=2850;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 48: (2850, 250) [work]
        CurrentX:=2850;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 49: (3050, 250) [work]
        CurrentX:=3050;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 50: (3050, 1900) [work]
        CurrentX:=3050;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 51: (3250, 1900) [work]
        CurrentX:=3250;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 52: (3250, 250) [work]
        CurrentX:=3250;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 53: (3450, 250) [work]
        CurrentX:=3450;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 54: (3450, 1900) [work]
        CurrentX:=3450;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 55: (3650, 1900) [work]
        CurrentX:=3650;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 56: (3650, 250) [work]
        CurrentX:=3650;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 57: (3850, 250) [work]
        CurrentX:=3850;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 58: (3850, 1900) [work]
        CurrentX:=3850;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 59: (4050, 1900) [work]
        CurrentX:=4050;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 60: (4050, 250) [work]
        CurrentX:=4050;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 61: (4250, 250) [work]
        CurrentX:=4250;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 62: (4250, 1900) [work]
        CurrentX:=4250;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 63: (4450, 1900) [work]
        CurrentX:=4450;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 64: (4450, 250) [work]
        CurrentX:=4450;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 65: (4650, 250) [work]
        CurrentX:=4650;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 66: (4650, 1900) [work]
        CurrentX:=4650;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 67: (4850, 1900) [work]
        CurrentX:=4850;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 68: (4850, 250) [work]
        CurrentX:=4850;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 69: (5050, 250) [work]
        CurrentX:=5050;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 70: (5050, 1900) [work]
        CurrentX:=5050;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 71: (5250, 1900) [work]
        CurrentX:=5250;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 72: (5250, 250) [work]
        CurrentX:=5250;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 73: (5450, 250) [work]
        CurrentX:=5450;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 74: (5450, 1900) [work]
        CurrentX:=5450;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 75: (5580, 1900) [work]
        CurrentX:=5580;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;

        ! Point 76: (5580, 250) [work]
        CurrentX:=5580;
        CurrentY:=250;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        FCPressL pCurrent,vTravel,100,fine,tPolish\WObj:=Bed1Wyong;


        ! End force control
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tPolish\WObj:=Bed1Wyong);
        FCPressEnd Offs(CurrentPos,0,0,75),v50,\DeactOnly,tPolish\WObj:=Bed1Wyong;
        bFCActive:=FALSE;

        Pol_off;

        ! Lift to safe height
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tPolish\WObj:=Bed1Wyong);
        MoveL Offs(CurrentPos,0,0,200),v200,z5,tPolish\WObj:=Bed1Wyong;

        ! Re-enable configuration tracking
        ConfL\On;
        ConfJ\On;

        ! Return tool and go home
        TPWrite "Py2Polish: Dropping off tool...";
        Polish_Dropoff;
        Home;

        TPWrite "========================================";
        TPWrite "Py2Polish: COMPLETE";
        TPWrite "========================================";

    ERROR
        Pol_off;
        TPWrite "Py2Polish ERROR: " \Num:=ERRNO;
        RAISE;
    ENDPROC

    PROC Py2Vac()
        ! Py2Vac - Generated by Onyx Tool Class
        ! Workzone: panel
        ! Area: (350,350) to (5480,1800)
        ! Z = 650mm
        ! Step: 200mm

        VAR robtarget pCurrent;
        VAR jointtarget CurrentJoints;
        VAR robtarget CurrentPos;
        VAR num WorkZ:=650;
        VAR num SafeZ:=850;
        VAR num CurrentX:=0;
        VAR num CurrentY:=0;
        VAR speeddata vTravel:=[100,15,2000,15];
        VAR num TrackMin:=-300;
        VAR num TrackMax:=10050;
        VAR num CalcTrack:=0;

        TPWrite "========================================";
        TPWrite "Py2Vac: Starting";
        TPWrite "========================================";
        TPWrite "Workzone: panel";
        TPWrite "WorkZ=" \Num:=WorkZ;

        ! Get tool if needed
        IF ToolNum<>5 THEN
            TPWrite "Py2Vac: Getting tool...";
            Home;
            Vac_Pickup;
        ENDIF

        ! Disable configuration tracking
        ConfL\Off;
        ConfJ\Off;

        ! Turn on vacuum
        TPWrite "Py2Vac: Starting vacuum...";
        Vac_on;
        WaitTime 1;

        ! ========================================
        ! Pattern Execution: 72 points
        ! ========================================

        ! Point 1: (350, 1800) [rapid]
        CurrentX:=350;
        CurrentY:=1800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,SafeZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveJ pCurrent,v500,z5,tVac\WObj:=Bed1Wyong;

        ! Point 2: (5480, 1800) [work]
        CurrentX:=5480;
        CurrentY:=1800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 3: (5480, 1600) [work]
        CurrentX:=5480;
        CurrentY:=1600;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 4: (350, 1600) [work]
        CurrentX:=350;
        CurrentY:=1600;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 5: (350, 1400) [work]
        CurrentX:=350;
        CurrentY:=1400;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 6: (5480, 1400) [work]
        CurrentX:=5480;
        CurrentY:=1400;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 7: (5480, 1200) [work]
        CurrentX:=5480;
        CurrentY:=1200;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 8: (350, 1200) [work]
        CurrentX:=350;
        CurrentY:=1200;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 9: (350, 1000) [work]
        CurrentX:=350;
        CurrentY:=1000;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 10: (5480, 1000) [work]
        CurrentX:=5480;
        CurrentY:=1000;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 11: (5480, 800) [work]
        CurrentX:=5480;
        CurrentY:=800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 12: (350, 800) [work]
        CurrentX:=350;
        CurrentY:=800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 13: (350, 600) [work]
        CurrentX:=350;
        CurrentY:=600;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 14: (5480, 600) [work]
        CurrentX:=5480;
        CurrentY:=600;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 15: (5480, 400) [work]
        CurrentX:=5480;
        CurrentY:=400;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 16: (350, 400) [work]
        CurrentX:=350;
        CurrentY:=400;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 17: (350, 350) [work]
        CurrentX:=350;
        CurrentY:=350;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 18: (5480, 350) [work]
        CurrentX:=5480;
        CurrentY:=350;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 19: (350, 350) [work]
        CurrentX:=350;
        CurrentY:=350;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 20: (350, 1800) [work]
        CurrentX:=350;
        CurrentY:=1800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 21: (550, 1800) [work]
        CurrentX:=550;
        CurrentY:=1800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 22: (550, 350) [work]
        CurrentX:=550;
        CurrentY:=350;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 23: (750, 350) [work]
        CurrentX:=750;
        CurrentY:=350;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 24: (750, 1800) [work]
        CurrentX:=750;
        CurrentY:=1800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 25: (950, 1800) [work]
        CurrentX:=950;
        CurrentY:=1800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 26: (950, 350) [work]
        CurrentX:=950;
        CurrentY:=350;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 27: (1150, 350) [work]
        CurrentX:=1150;
        CurrentY:=350;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 28: (1150, 1800) [work]
        CurrentX:=1150;
        CurrentY:=1800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 29: (1350, 1800) [work]
        CurrentX:=1350;
        CurrentY:=1800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 30: (1350, 350) [work]
        CurrentX:=1350;
        CurrentY:=350;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 31: (1550, 350) [work]
        CurrentX:=1550;
        CurrentY:=350;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 32: (1550, 1800) [work]
        CurrentX:=1550;
        CurrentY:=1800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 33: (1750, 1800) [work]
        CurrentX:=1750;
        CurrentY:=1800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 34: (1750, 350) [work]
        CurrentX:=1750;
        CurrentY:=350;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 35: (1950, 350) [work]
        CurrentX:=1950;
        CurrentY:=350;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 36: (1950, 1800) [work]
        CurrentX:=1950;
        CurrentY:=1800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 37: (2150, 1800) [work]
        CurrentX:=2150;
        CurrentY:=1800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 38: (2150, 350) [work]
        CurrentX:=2150;
        CurrentY:=350;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 39: (2350, 350) [work]
        CurrentX:=2350;
        CurrentY:=350;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 40: (2350, 1800) [work]
        CurrentX:=2350;
        CurrentY:=1800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 41: (2550, 1800) [work]
        CurrentX:=2550;
        CurrentY:=1800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 42: (2550, 350) [work]
        CurrentX:=2550;
        CurrentY:=350;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 43: (2750, 350) [work]
        CurrentX:=2750;
        CurrentY:=350;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 44: (2750, 1800) [work]
        CurrentX:=2750;
        CurrentY:=1800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 45: (2950, 1800) [work]
        CurrentX:=2950;
        CurrentY:=1800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 46: (2950, 350) [work]
        CurrentX:=2950;
        CurrentY:=350;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 47: (3150, 350) [work]
        CurrentX:=3150;
        CurrentY:=350;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 48: (3150, 1800) [work]
        CurrentX:=3150;
        CurrentY:=1800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 49: (3350, 1800) [work]
        CurrentX:=3350;
        CurrentY:=1800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 50: (3350, 350) [work]
        CurrentX:=3350;
        CurrentY:=350;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 51: (3550, 350) [work]
        CurrentX:=3550;
        CurrentY:=350;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 52: (3550, 1800) [work]
        CurrentX:=3550;
        CurrentY:=1800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 53: (3750, 1800) [work]
        CurrentX:=3750;
        CurrentY:=1800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 54: (3750, 350) [work]
        CurrentX:=3750;
        CurrentY:=350;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 55: (3950, 350) [work]
        CurrentX:=3950;
        CurrentY:=350;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 56: (3950, 1800) [work]
        CurrentX:=3950;
        CurrentY:=1800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 57: (4150, 1800) [work]
        CurrentX:=4150;
        CurrentY:=1800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 58: (4150, 350) [work]
        CurrentX:=4150;
        CurrentY:=350;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 59: (4350, 350) [work]
        CurrentX:=4350;
        CurrentY:=350;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 60: (4350, 1800) [work]
        CurrentX:=4350;
        CurrentY:=1800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 61: (4550, 1800) [work]
        CurrentX:=4550;
        CurrentY:=1800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 62: (4550, 350) [work]
        CurrentX:=4550;
        CurrentY:=350;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 63: (4750, 350) [work]
        CurrentX:=4750;
        CurrentY:=350;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 64: (4750, 1800) [work]
        CurrentX:=4750;
        CurrentY:=1800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 65: (4950, 1800) [work]
        CurrentX:=4950;
        CurrentY:=1800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 66: (4950, 350) [work]
        CurrentX:=4950;
        CurrentY:=350;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 67: (5150, 350) [work]
        CurrentX:=5150;
        CurrentY:=350;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 68: (5150, 1800) [work]
        CurrentX:=5150;
        CurrentY:=1800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 69: (5350, 1800) [work]
        CurrentX:=5350;
        CurrentY:=1800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 70: (5350, 350) [work]
        CurrentX:=5350;
        CurrentY:=350;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 71: (5480, 350) [work]
        CurrentX:=5480;
        CurrentY:=350;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        ! Point 72: (5480, 1800) [work]
        CurrentX:=5480;
        CurrentY:=1800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVac\WObj:=Bed1Wyong;

        Vac_off;

        ! Lift to safe height
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tVac\WObj:=Bed1Wyong);
        MoveL Offs(CurrentPos,0,0,200),v200,z5,tVac\WObj:=Bed1Wyong;

        ! Re-enable configuration tracking
        ConfL\On;
        ConfJ\On;

        ! Return tool and go home
        TPWrite "Py2Vac: Dropping off tool...";
        Vac_Dropoff;
        Home;

        TPWrite "========================================";
        TPWrite "Py2Vac: COMPLETE";
        TPWrite "========================================";

    ERROR
        Vac_off;
        TPWrite "Py2Vac ERROR: " \Num:=ERRNO;
        RAISE;
    ENDPROC

    PROC Py2Pan()
        ! Py2Pan - Generated by Onyx Tool Class
        ! Workzone: panel
        ! Area: (450,450) to (5380,1700)
        ! Z = 651mm
        ! Step: 300mm

        VAR robtarget pCurrent;
        VAR jointtarget CurrentJoints;
        VAR robtarget CurrentPos;
        VAR num WorkZ:=651;
        VAR num SafeZ:=851;
        VAR num CurrentX:=0;
        VAR num CurrentY:=0;
        VAR speeddata vTravel:=[100,15,2000,15];
        VAR num TrackMin:=-300;
        VAR num TrackMax:=10050;
        VAR num CalcTrack:=0;
        VAR num PanForce:=0;
        VAR bool bFCActive:=FALSE;

        TPWrite "========================================";
        TPWrite "Py2Pan: Starting";
        TPWrite "========================================";
        TPWrite "Workzone: panel";
        TPWrite "WorkZ=" \Num:=WorkZ;

        ! Get helicopter tool (Pan attaches to it)
        IF ToolNum<>2 THEN
            TPWrite "Py2Pan: Getting helicopter...";
            Home;
            Heli_Pickup;
        ENDIF

        ! Home stepper (blade angle = 0 for pan)
        TPWrite "Py2Pan: Homing stepper...";
        Heli_Stepper_Home;
        HeliBlade_Angle 0;

        ! Disable configuration tracking
        ConfL\Off;
        ConfJ\Off;

        ! ========================================
        ! Pattern Execution: 48 points
        ! ========================================

        ! Point 1: (450, 1700) [rapid]
        CurrentX:=450;
        CurrentY:=1700;
        pCurrent.trans:=[-1*CurrentX,CurrentY,SafeZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveJ pCurrent,v500,z5,tHeli\WObj:=Bed1Wyong;

        ! Point 2: (5380, 1700) [work]
        CurrentX:=5380;
        CurrentY:=1700;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 3: (5380, 1400) [work]
        CurrentX:=5380;
        CurrentY:=1400;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 4: (450, 1400) [work]
        CurrentX:=450;
        CurrentY:=1400;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 5: (450, 1100) [work]
        CurrentX:=450;
        CurrentY:=1100;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 6: (5380, 1100) [work]
        CurrentX:=5380;
        CurrentY:=1100;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 7: (5380, 800) [work]
        CurrentX:=5380;
        CurrentY:=800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 8: (450, 800) [work]
        CurrentX:=450;
        CurrentY:=800;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 9: (450, 500) [work]
        CurrentX:=450;
        CurrentY:=500;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 10: (5380, 500) [work]
        CurrentX:=5380;
        CurrentY:=500;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 11: (5380, 450) [work]
        CurrentX:=5380;
        CurrentY:=450;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 12: (450, 450) [work]
        CurrentX:=450;
        CurrentY:=450;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 13: (450, 450) [work]
        CurrentX:=450;
        CurrentY:=450;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 14: (450, 1700) [work]
        CurrentX:=450;
        CurrentY:=1700;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 15: (750, 1700) [work]
        CurrentX:=750;
        CurrentY:=1700;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 16: (750, 450) [work]
        CurrentX:=750;
        CurrentY:=450;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 17: (1050, 450) [work]
        CurrentX:=1050;
        CurrentY:=450;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 18: (1050, 1700) [work]
        CurrentX:=1050;
        CurrentY:=1700;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 19: (1350, 1700) [work]
        CurrentX:=1350;
        CurrentY:=1700;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 20: (1350, 450) [work]
        CurrentX:=1350;
        CurrentY:=450;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 21: (1650, 450) [work]
        CurrentX:=1650;
        CurrentY:=450;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 22: (1650, 1700) [work]
        CurrentX:=1650;
        CurrentY:=1700;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 23: (1950, 1700) [work]
        CurrentX:=1950;
        CurrentY:=1700;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 24: (1950, 450) [work]
        CurrentX:=1950;
        CurrentY:=450;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 25: (2250, 450) [work]
        CurrentX:=2250;
        CurrentY:=450;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 26: (2250, 1700) [work]
        CurrentX:=2250;
        CurrentY:=1700;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 27: (2550, 1700) [work]
        CurrentX:=2550;
        CurrentY:=1700;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 28: (2550, 450) [work]
        CurrentX:=2550;
        CurrentY:=450;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 29: (2850, 450) [work]
        CurrentX:=2850;
        CurrentY:=450;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 30: (2850, 1700) [work]
        CurrentX:=2850;
        CurrentY:=1700;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 31: (3150, 1700) [work]
        CurrentX:=3150;
        CurrentY:=1700;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 32: (3150, 450) [work]
        CurrentX:=3150;
        CurrentY:=450;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 33: (3450, 450) [work]
        CurrentX:=3450;
        CurrentY:=450;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 34: (3450, 1700) [work]
        CurrentX:=3450;
        CurrentY:=1700;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 35: (3750, 1700) [work]
        CurrentX:=3750;
        CurrentY:=1700;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 36: (3750, 450) [work]
        CurrentX:=3750;
        CurrentY:=450;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 37: (4050, 450) [work]
        CurrentX:=4050;
        CurrentY:=450;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 38: (4050, 1700) [work]
        CurrentX:=4050;
        CurrentY:=1700;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 39: (4350, 1700) [work]
        CurrentX:=4350;
        CurrentY:=1700;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 40: (4350, 450) [work]
        CurrentX:=4350;
        CurrentY:=450;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 41: (4650, 450) [work]
        CurrentX:=4650;
        CurrentY:=450;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 42: (4650, 1700) [work]
        CurrentX:=4650;
        CurrentY:=1700;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 43: (4950, 1700) [work]
        CurrentX:=4950;
        CurrentY:=1700;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 44: (4950, 450) [work]
        CurrentX:=4950;
        CurrentY:=450;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 45: (5250, 450) [work]
        CurrentX:=5250;
        CurrentY:=450;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 46: (5250, 1700) [work]
        CurrentX:=5250;
        CurrentY:=1700;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 47: (5380, 1700) [work]
        CurrentX:=5380;
        CurrentY:=1700;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Point 48: (5380, 450) [work]
        CurrentX:=5380;
        CurrentY:=450;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.rot:=OrientZYX(0,0,180);
        pCurrent.robconf:=[0,0,0,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tHeli\WObj:=Bed1Wyong;

        ! Stop blade rotation
        HeliBladeSpeed 0,"FWD";
        WaitTime 1;

        ! Lift to safe height
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tHeli\WObj:=Bed1Wyong);
        MoveL Offs(CurrentPos,0,0,200),v200,z5,tHeli\WObj:=Bed1Wyong;

        ! Re-enable configuration tracking
        ConfL\On;
        ConfJ\On;

        ! Return tool and go home
        TPWrite "Py2Pan: Dropping off helicopter...";
        Heli_Dropoff;
        Home;

        TPWrite "========================================";
        TPWrite "Py2Pan: COMPLETE";
        TPWrite "========================================";

    ERROR
        HeliBladeSpeed 0,"FWD";
        IF bFCActive THEN
            FCPressEnd Offs(CurrentPos,0,0,100),v50,\DeactOnly,tHeli\WObj:=Bed1Wyong;
        ENDIF
        RAISE;
    ENDPROC

    PROC Py2VS()
        ! Py2VS - Generated by Onyx Tool Class
        ! Workzone: panel
        ! Area: (500,500) to (5330,1650)
        ! Z = 650mm
        ! Step: 200mm

        VAR robtarget pCurrent;
        VAR jointtarget CurrentJoints;
        VAR robtarget CurrentPos;
        VAR num WorkZ:=650;
        VAR num SafeZ:=850;
        VAR num CurrentX:=0;
        VAR num CurrentY:=0;
        VAR speeddata vTravel:=[100,15,2000,15];
        VAR num TrackMin:=-300;
        VAR num TrackMax:=10050;
        VAR num CalcTrack:=0;

        TPWrite "========================================";
        TPWrite "Py2VS: Starting";
        TPWrite "========================================";
        TPWrite "Workzone: panel";
        TPWrite "WorkZ=" \Num:=WorkZ;

        ! Get tool if needed
        IF ToolNum<>3 THEN
            TPWrite "Py2VS: Getting tool...";
            Home;
            VS_Pickup;
        ENDIF

        ! Disable configuration tracking
        ConfL\Off;
        ConfJ\Off;

        ! ========================================
        ! Pattern Execution: 4 points
        ! Force Monitoring: DISABLED
        ! ========================================

        ! Use VS tool's orientation from pickup end position (pVSHome3)
        ! This prevents 180 degree rotation when moving to work surface
        pCurrent.rot:=pVSHome3.rot;

        ! Point 1: (-100, 1900) [rapid]
        CurrentX:=-100;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,SafeZ];
        pCurrent.robconf:=[1,0,1,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveJ pCurrent,v500,z5,tVS\WObj:=Bed1Wyong;

        ! Turn on vibrating screed after positioning
        TPWrite "Py2VS: Starting screed...";
        VS_on;

        ! Point 2: (-50, 1900) [work]
        CurrentX:=-50;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.robconf:=[1,0,1,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVS\WObj:=Bed1Wyong;

        ! Point 3: (5880, 1900) [work]
        CurrentX:=5880;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,WorkZ];
        pCurrent.robconf:=[1,0,1,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveL pCurrent,vTravel,fine,tVS\WObj:=Bed1Wyong;

        ! Point 4: (5930, 1900) [rapid]
        CurrentX:=5930;
        CurrentY:=1900;
        pCurrent.trans:=[-1*CurrentX,CurrentY,SafeZ];
        pCurrent.robconf:=[1,0,1,0];
        CalcTrack:=Bed1Wyong.uframe.trans.x+pCurrent.trans.x;
        IF CalcTrack<TrackMin THEN CalcTrack:=TrackMin; ENDIF
        IF CalcTrack>TrackMax THEN CalcTrack:=TrackMax; ENDIF
        pCurrent.extax:=[CalcTrack,9E+09,9E+09,9E+09,9E+09,9E+09];
        MoveJ pCurrent,v500,z5,tVS\WObj:=Bed1Wyong;

        VS_off;

        ! Lift to safe height
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tVS\WObj:=Bed1Wyong);
        MoveL Offs(CurrentPos,0,0,200),v200,z5,tVS\WObj:=Bed1Wyong;

        ! Re-enable configuration tracking
        ConfL\On;
        ConfJ\On;

        ! Return tool and go home
        TPWrite "Py2VS: Dropping off tool...";
        VS_Dropoff;
        Home;

        TPWrite "========================================";
        TPWrite "Py2VS: COMPLETE";
        TPWrite "========================================";

    ERROR
        VS_off;
        TPWrite "Py2VS ERROR: " \Num:=ERRNO;
        RAISE;
    ENDPROC


    PROC SeqBedClean()
        ! SeqBedClean - Bed Cleaning Sequence
        ! Runs: Vacuum -> Polish
        ! Generated by Onyx Toolpath Generator v2
        
        TPWrite "========================================";
        TPWrite "SeqBedClean: Starting Bed Clean Sequence";
        TPWrite "========================================";
        TPWrite "Step 1: Vacuum";
        TPWrite "Step 2: Polish";
        TPWrite "========================================";
        
        ! Step 1: Vacuum the bed
        TPWrite "SeqBedClean: Starting vacuum...";
        Py2Vac;
        TPWrite "SeqBedClean: Vacuum complete";
        
        ! Step 2: Polish the bed
        TPWrite "SeqBedClean: Starting polish...";
        Py2Polish;
        TPWrite "SeqBedClean: Polish complete";
        
        TPWrite "========================================";
        TPWrite "SeqBedClean: SEQUENCE COMPLETE";
        TPWrite "========================================";
        
    ERROR
        TPWrite "SeqBedClean ERROR: " \Num:=ERRNO;
        RAISE;
    ENDPROC

    
    ! ========== END PY2 GENERATED PROCEDURES ==========

ENDMODULE