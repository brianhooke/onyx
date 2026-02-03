MODULE ToolPaths


    TASK PERS wobjdata Bed1:=[FALSE,TRUE,"",[[1000.00,930.569,220.66],[1,0.000655845,-0.000507562,-0.00020191]],[[0,0,0],[1,0,0,0]]];
    !Z 185.66
    !Track -230.02 at measurement

    PERS robtarget pScreed1:=[[-1100,1500,1500],[0.00814298,0.999961,0.000966756,0.00335392],[0,-1,-2,0],[-300,9E+09,9E+09,9E+09,9E+09,9E+09]];
    PERS robtarget pScreed2:=[[-1100,1500,1500],[0.00814298,0.999961,0.000966756,0.00335392],[0,-1,-2,0],[-300,9E+09,9E+09,9E+09,9E+09,9E+09]];

    CONST num HeliOverlapMin:=400;
    CONST num HeliBladeWidth:=1150;
    VAR num HeliPasses;
    VAR num HeliPassWidth;
    CONST num ScreedYpos:=2955;
    CONST num wBedXmin:=1600;
    CONST num wBedXmax:=10200;
    CONST num wBedYmin:=955;
    CONST num wBedYmax:=4955;
    CONST num FormHeight:=150;
    PERS num PitchZOffset:=1.30893;

    VAR speeddata vVS:=[100,15,2000,15];
    ![mm/s TCP, degrees/s TCP, mm/s external axes, degrees/s external axes]
    VAR speeddata vHeli:=[40,10,2000,15];
    VAR speeddata vPlotter:=[1000,30,2000,15];
    VAR zonedata zVS:=z5;
    VAR zonedata zHeli:=z5;
    VAR zonedata zPlotter:=z0;


    VAR robtarget Plotterp1:=[[1000,1000,-10],[0.000337803,0.93262,-0.36086,0.000225436],[0,-1,-2,0],[3400,9E+09,9E+09,9E+09,9E+09,9E+09]];
    PERS robtarget Plotterp2:=[[1100,2710,-20],[4.32964E-17,0.707107,-0.707107,-4.32964E-17],[0,-1,-1,0],[2100,9E+09,9E+09,9E+09,9E+09,9E+09]];
    PERS robtarget Plotterp3:=[[4500,1800,-20],[4.32964E-17,0.707107,-0.707107,-4.32964E-17],[0,-1,-1,0],[5000,9E+09,9E+09,9E+09,9E+09,9E+09]];
    PERS robtarget Plotterp4:=[[6500,1900,-20],[4.32964E-17,0.707107,-0.707107,-4.32964E-17],[1,-1,0,0],[7000,9E+09,9E+09,9E+09,9E+09,9E+09]];
    PERS robtarget Plotterp5:=[[1000,1000,-20],[5.65694E-17,0.92388,-0.382683,-2.34318E-17],[1,-1,0,0],[390.38,9E+09,9E+09,9E+09,9E+09,9E+09]];
    PERS robtarget Plotterc5:=[[1100,2750,-20],[0.00237199,0.67253,-0.740066,0.000521901],[0,-1,-1,0],[0,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR num Plotterc5r:=500;
    VAR robtarget PlotterTemp:=[[1500,3000,-10],[0.00237199,0.67253,-0.740066,0.000521901],[0,-1,-1,0],[3400,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget PlotterTemp2:=[[1500,3000,-10],[0.00237199,0.67253,-0.740066,0.000521901],[0,-1,-1,0],[3400,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR num PlotterZ:=-20;
    VAR num PlotterZOri;

    VAR robtarget pHeliStart:=[[900,900,185],[0.00869284,-0.711152,0.702867,0.0128866],[1,-1,-1,0],[1400,9E+09,9E+09,9E+09,9E+09,9E+09]];
    ![0.00497429,-0.71119,0.702786,0.0165738],[0,0,-1,0]
    VAR robtarget pHeliEnd:=[[2590,2800,185],[0.00869284,-0.711152,0.702867,0.0128866],[1,-1,-1,0],[7400,9E+09,9E+09,9E+09,9E+09,9E+09]];

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

    CONST num BedXmin:=0;
    CONST num BedXmax:=9000;
    CONST num BedYmin:=0;
    CONST num BedYmax:=3800;

    CONST num PlotA6Max:=45;

    PERS num anglex:=179.861;
    PERS num angley:=-0.241379;
    PERS num anglez:=-95.4741;
    VAR pose Object;

    PERS num BedZread:=5.97;

    VAR num BedZreads{4,24}:=[
    [0.4,0.16,0.25,0.37,4.57,4.15,3.8,2.87,5.03,4.73,4.66,4.19,3.53,3.3,3.3,1.78,0.9,-0.6,0,0,0,0,0,0],
    [2.84,2.36,2.18,2.12,5.15,4.95,4.84,4.15,5.5,5.1,4.91,4.6,3.9,3.37,3.15,1.82,0.85,-0.6,0,0,0,0,0,0],
    [5.08,4.03,3.75,3.52,5.75,5.22,4.97,4.82,6.02,4.95,4.85,4.24,4.12,3.14,2.44,1.73,0.65,-0.6,0,0,0,0,0,0],
    [7.37,6.59,6.12,5.57,6.55,5.75,5.48,5.87,6.35,5.78,5.87,5.27,5.34,4.3,3.34,2.42,1.45,1.02,0,0,0,0,0,0]];

    VAR num BedZpos{4,24,2}:=[[
    [545,1950],[1045,1950],[1545,1950],[2045,1950],[2545,1950],[3045,1950],[3545,1950],[4045,1950],[4545,1950],[5045,1950],[5545,1950],[6045,1950],[6545,1950],[7045,1950],[7545,1950],[7850,1950],[8545,1950],[9045,1950],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]],

   [[545,1350],[1045,1350],[1545,1350],[2045,1350],[2545,1350],[3045,1350],[3545,1350],[4045,1350],[4545,1350],[5045,1350],[5545,1350],[6045,1350],[6545,1350],[7045,1350],[7545,1350],[7850,1350],[8545,1350],[9045,1350],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]],

   [[545,750],[1045,750],[1545,750],[2045,750],[2545,750],[3045,750],[3545,750],[4045,750],[4545,750],[5045,750],[5545,750],[6045,750],[6545,750],[7045,750],[7545,750],[8045,750],[8545,750],[9045,750],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]],

    [[545,150],[1045,150],[1545,150],[2045,150],[2545,150],[3045,150],[3545,150],[4045,150],[4545,150],[5045,150],[5545,150],[6045,150],[6545,150],[7045,150],[7545,150],[8045,150],[8545,150],[9045,150],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]]];


    VAR num Bed2Zread{10,20}:=[[3.45,1.26,0.9,2.63,5.77,8.43,9.67,8.85,9.43,9.69,10.2,10.45,10.32,9.44,8.44,7.81,7.78,7.11,6.45,5.97],
                                 [3.64,1.19,1.08,3.11,5.89,7.94,8.99,8.93,9.69,9.86,9.71,10.03,10.05,9.28,8.55,7.6,7.26,6.89,5.88,5.5],
                                 [3.85,2.02,2.09,3.94,6.47,8.4,8.45,8.95,9.85,9.74,9.53,9.81,9.83,9.32,8.49,7.52,7.17,6.79,5.91,5.27],
                                 [4.24,2.8,2.94,4.42,6.82,8.25,8.33,8.9,9.5,9.11,9.2,9.47,9.48,8.85,8.1,7.38,6.98,6.49,5.36,5.14],
                                 [4.82,3.52,3.75,5.18,7.19,8.41,8.26,8.75,9.15,8.86,8.84,9.2,9.14,8.27,7.56,7.47,7.04,6.32,5.35,4.76],
                                 [2.95,2.3,1.78,2.4,3.56,4.56,5.09,5.46,5.68,5.52,5.22,5.44,5.3,4.77,4.34,4.55,3.98,3.03,2.34,1.85],
                                 [0.75,0.87,1.02,0.55,0,-0.2,0.11,0,0,0,0,0,0,0,0,0,0,0,0,0],
                                 [2.43,2.3,2.23,2.08,1.44,0.96,1.17,0,0,0,0,0,0,0,0,0,0,0,0,0],
                                 [4.66,4.52,4.1,3.88,3.19,2.74,3.03,0,0,0,0,0,0,0,0,0,0,0,0,0],
                                 [7.3,7.22,6.95,6.58,5.93,5.07,4.97,0,0,0,0,0,0,0,0,0,0,0,0,0]];

    VAR num Bed2Zpos{10,20,2}:=[[[100,3700],[560,3700],[1020,3700],[1480,3700],[1940,3700],[2400,3700],[2860,3700],[3320,3700],[3780,3700],[4240,3700],[4700,3700],[5160,3700],[5620,3700],[6080,3700],[6540,3700],[7000,3700],[7460,3700],[7920,3700],[8380,3700],[8840,3700]],

                               [[100,3300],[560,3300],[1020,3300],[1480,3300],[1940,3300],[2400,3300],[2860,3300],[3320,3300],[3780,3300],[4240,3300],[4700,3300],[5160,3300],[5620,3300],[6080,3300],[6540,3300],[7000,3300],[7460,3300],[7920,3300],[8380,3300],[8840,3300]],

                               [[100,2900],[560,2900],[1020,2900],[1480,2900],[1940,2900],[2400,2900],[2860,2900],[3320,2900],[3780,2900],[4240,2900],[4700,2900],[5160,2900],[5620,2900],[6080,2900],[6540,2900],[7000,2900],[7460,2900],[7920,2900],[8380,2900],[8840,2900]],

                               [[100,2500],[560,2500],[1020,2500],[1480,2500],[1940,2500],[2400,2500],[2860,2500],[3320,2500],[3780,2500],[4240,2500],[4700,2500],[5160,2500],[5620,2500],[6080,2500],[6540,2500],[7000,2500],[7460,2500],[7920,2500],[8380,2500],[8840,2500]],

                               [[100,2100],[560,2100],[1020,2100],[1480,2100],[1940,2100],[2400,2100],[2860,2100],[3320,2100],[3780,2100],[4240,2100],[4700,2100],[5160,2100],[5620,2100],[6080,2100],[6540,2100],[7000,2100],[7460,2100],[7920,2100],[8380,2100],[8840,2100]],

                               [[100,1700],[560,1700],[1020,1700],[1480,1700],[1940,1700],[2400,1700],[2860,1700],[3320,1700],[3780,1700],[4240,1700],[4700,1700],[5160,1700],[5620,1700],[6080,1700],[6540,1700],[7000,1700],[7460,1700],[7920,1700],[8380,1700],[8840,1700]],

                               [[100,1300],[560,1300],[1020,1300],[1480,1300],[1940,1300],[2400,1300],[2860,1300],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]],

                               [[100,900],[560,900],[1020,900],[1480,900],[1940,900],[2400,900],[2860,900],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]],

                               [[100,500],[560,500],[1020,500],[1480,500],[1940,500],[2400,500],[2860,500],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]],

                               [[100,100],[560,100],[1020,100],[1480,100],[1940,100],[2400,100],[2860,100],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]]];

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

    PERS num HeliZOffs:=8.45;
    !Offset based on bed heights

    VAR num SEnddiv:=0;
    VAR num SStartdiv:=0;

    VAR num ScrBedZ;

    PERS num HeliZArray{30}:=[8.4,8.25,8.41,8.45,8.33,8.26,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    VAR bool WithinBlades:=FALSE;
    PERS num HeliZArrayCounter:=7;
    PERS num HeliDiv:=5;
    PERS num PreviousHighest:=8.45;
    CONST robtarget pVacStart:=[[36.5,3431.40,-60],[0.000577269,0.709967,-0.704224,0.00390557],[1,-1,0,0],[999.999,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVacStart2:=[[36.5,383.65,-60],[0.000543413,0.709954,-0.704238,0.00386517],[-1,-1,-2,0],[-231.437,9E+09,9E+09,9E+09,9E+09,9E+09]];

    PROC TaskToDo()
        TPErase;
        TPReadNum iTaskno,"Enter task number : 1: Home, 2: Plot, 3: Screed, 4: Heli, 5: Vac, 6: Polish";
        TEST iTaskno
        CASE 1:
            Home;
        CASE 2:
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
                IF iCoord1x<BedXmin OR iCoord1y<BedYmin OR iCoord2x<BedXmin OR iCoord2y<BedYmin OR iCoord3x<BedXmin OR iCoord3y<BedYmin OR iCoord4x<BedXmin OR iCoord4y<BedYmin OR iCoord1x>BedXmax OR iCoord1y>BedYmax OR iCoord2x>BedXmax OR iCoord2y>BedYmax OR iCoord3x>BedXmax OR iCoord3y>BedYmax OR iCoord4x>BedXmax OR iCoord4y>BedYmax THEN
                    RAISE ERR_INVALID_INPUT;
                ENDIF
                PlotRect iCoord1x,iCoord1y,iCoord2x,iCoord2y,iCoord3x,iCoord3y,iCoord4x,iCoord4y;

            ELSEIF iPlotType=2 THEN
                !ferrule - Circle with cross
                TPWrite "Enter the coordinates for the centre position of the ferrule.";
                TPReadNum iCoord1x,"Enter centre coordinate X value";
                TPReadNum iCoord1y,"Enter centre coordinate y value";

                IF (iCoord1x-PlotCircleD)<BedXmin OR (iCoord1y-PlotCircleD)<BedYmin OR (iCoord1x+PlotCircleD)>BedXmax OR (iCoord1y+PlotCircleD)>BedYmax THEN
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
                    IF iCoord1x-GroutWidth/2*Cos(iAngle)<BedXmin OR iCoord1y+GroutWidth/2*Sin(iAngle)<BedYmin OR iCoord1x-GroutWidth/2*Cos(iAngle)+GroutHeight*Sin(iAngle)<BedXmin OR iCoord1y+GroutHeight*Cos(iAngle)+GroutWidth/2*Sin(iAngle)<BedYmin OR iCoord1x+GroutWidth/2*Cos(iAngle)+GroutHeight*Sin(iAngle)<BedXmin OR iCoord1y+GroutHeight*Cos(iAngle)-GroutWidth/2*Sin(iAngle)<BedYmin OR iCoord1x+GroutWidth/2*Cos(iAngle)<BedXmin OR iCoord1y-GroutWidth/2*Sin(iAngle)<BedYmin THEN
                        RAISE ERR_INVALID_INPUT;
                    ENDIF

                    IF iCoord1x-GroutWidth/2*Cos(iAngle)>BedXmax OR iCoord1y+GroutWidth/2*Sin(iAngle)>BedYmax OR iCoord1x-GroutWidth/2*Cos(iAngle)+GroutHeight*Sin(iAngle)>BedXmax OR iCoord1y+GroutHeight*Cos(iAngle)+GroutWidth/2*Sin(iAngle)>BedYmax OR iCoord1x+GroutWidth/2*Cos(iAngle)+GroutHeight*Sin(iAngle)>BedXmax OR iCoord1y+GroutHeight*Cos(iAngle)-GroutWidth/2*Sin(iAngle)>BedYmax OR iCoord1x+GroutWidth/2*Cos(iAngle)>BedXmax OR iCoord1y-GroutWidth/2*Sin(iAngle)>BedYmax THEN
                        RAISE ERR_INVALID_INPUT;
                    ENDIF

                    PlotRect iCoord1x-GroutWidth/2*Cos(iAngle),iCoord1y+GroutWidth/2*Sin(iAngle),iCoord1x-GroutWidth/2*Cos(iAngle)+GroutHeight*Sin(iAngle),iCoord1y+GroutHeight*Cos(iAngle)+GroutWidth/2*Sin(iAngle),iCoord1x+GroutWidth/2*Cos(iAngle)+GroutHeight*Sin(iAngle),iCoord1y+GroutHeight*Cos(iAngle)-GroutWidth/2*Sin(iAngle),iCoord1x+GroutWidth/2*Cos(iAngle),iCoord1y-GroutWidth/2*Sin(iAngle);

                CASE 2:

                    IF iCoord1x-GroutWidth/2*Sin(iAngle)<BedXmin OR iCoord1y-GroutWidth/2*Cos(iAngle)<BedYmin OR iCoord1x+GroutWidth/2*Sin(iAngle)<BedXmin OR iCoord1y+GroutWidth/2*Cos(iAngle)<BedYmin OR iCoord1x+GroutWidth/2*Sin(iAngle)+GroutHeight*Cos(iAngle)<BedXmin OR iCoord1y-GroutHeight*Sin(iAngle)+GroutWidth/2*Cos(iAngle)<BedYmin OR iCoord1x-GroutWidth/2*Sin(iAngle)+GroutHeight*Cos(iAngle)<BedXmin OR iCoord1y-GroutHeight*Sin(iAngle)-GroutWidth/2*Cos(iAngle)<BedYmin THEN
                        RAISE ERR_INVALID_INPUT;
                    ENDIF

                    IF iCoord1x-GroutWidth/2*Sin(iAngle)>BedXmax OR iCoord1y-GroutWidth/2*Cos(iAngle)>BedYmax OR iCoord1x+GroutWidth/2*Sin(iAngle)>BedXmax OR iCoord1y+GroutWidth/2*Cos(iAngle)>BedYmax OR iCoord1x+GroutWidth/2*Sin(iAngle)+GroutHeight*Cos(iAngle)>BedXmax OR iCoord1y-GroutHeight*Sin(iAngle)+GroutWidth/2*Cos(iAngle)>BedYmax OR iCoord1x-GroutWidth/2*Sin(iAngle)+GroutHeight*Cos(iAngle)>BedXmax OR iCoord1y-GroutHeight*Sin(iAngle)-GroutWidth/2*Cos(iAngle)>BedYmax THEN
                        RAISE ERR_INVALID_INPUT;
                    ENDIF

                    PlotRect iCoord1x-GroutWidth/2*Sin(iAngle),iCoord1y-GroutWidth/2*Cos(iAngle),iCoord1x+GroutWidth/2*Sin(iAngle),iCoord1y+GroutWidth/2*Cos(iAngle),iCoord1x+GroutWidth/2*Sin(iAngle)+GroutHeight*Cos(iAngle),iCoord1y-GroutHeight*Sin(iAngle)+GroutWidth/2*Cos(iAngle),iCoord1x-GroutWidth/2*Sin(iAngle)+GroutHeight*Cos(iAngle),iCoord1y-GroutHeight*Sin(iAngle)-GroutWidth/2*Cos(iAngle);

                CASE 3:

                    IF iCoord1x-GroutWidth/2*Cos(iAngle)-GroutHeight*Sin(iAngle)<BedXmin OR iCoord1y-GroutHeight*Cos(iAngle)+GroutWidth/2*Sin(iAngle)<BedYmin OR iCoord1x-GroutWidth/2*Cos(iAngle)<BedXmin OR iCoord1y+GroutWidth/2*Sin(iAngle)<BedYmin OR iCoord1x+GroutWidth/2*Cos(iAngle)<BedXmin OR iCoord1y-GroutWidth/2*Sin(iAngle)<BedYmin OR iCoord1x+GroutWidth/2*Cos(iAngle)-GroutHeight*Sin(iAngle)<BedXmin OR iCoord1y-GroutHeight*Cos(iAngle)-GroutWidth/2*Sin(iAngle)<BedYmin THEN
                        RAISE ERR_INVALID_INPUT;
                    ENDIF

                    IF iCoord1x-GroutWidth/2*Cos(iAngle)-GroutHeight*Sin(iAngle)>BedXmax OR iCoord1y-GroutHeight*Cos(iAngle)+GroutWidth/2*Sin(iAngle)>BedYmax OR iCoord1x-GroutWidth/2*Cos(iAngle)>BedXmax OR iCoord1y+GroutWidth/2*Sin(iAngle)>BedYmax OR iCoord1x+GroutWidth/2*Cos(iAngle)>BedXmax OR iCoord1y-GroutWidth/2*Sin(iAngle)>BedYmax OR iCoord1x+GroutWidth/2*Cos(iAngle)-GroutHeight*Sin(iAngle)>BedXmax OR iCoord1y-GroutHeight*Cos(iAngle)-GroutWidth/2*Sin(iAngle)>BedYmax THEN
                        RAISE ERR_INVALID_INPUT;
                    ENDIF

                    PlotRect iCoord1x-GroutWidth/2*Cos(iAngle)-GroutHeight*Sin(iAngle),iCoord1y-GroutHeight*Cos(iAngle)+GroutWidth/2*Sin(iAngle),iCoord1x-GroutWidth/2*Cos(iAngle),iCoord1y+GroutWidth/2*Sin(iAngle),iCoord1x+GroutWidth*Cos(iAngle),iCoord1y-GroutWidth/2*Sin(iAngle),iCoord1x+GroutWidth/2*Cos(iAngle)-GroutHeight*Sin(iAngle),iCoord1y-GroutHeight*Cos(iAngle)-GroutWidth/2*Sin(iAngle);


                CASE 4:

                    IF iCoord1x-GroutWidth/2*Sin(iAngle)-GroutHeight*Cos(iAngle)<BedXmin OR iCoord1y+GroutHeight*Sin(iAngle)-GroutWidth/2*Cos(iAngle)<BedYmin OR iCoord1x+GroutWidth/2*Sin(iAngle)-GroutHeight*Cos(iAngle)<BedXmin OR iCoord1y+GroutHeight*Sin(iAngle)+GroutWidth/2*Cos(iAngle)<BedYmin OR iCoord1x+GroutWidth/2*Sin(iAngle)<BedXmin OR iCoord1y+GroutWidth/2*Cos(iAngle)<BedYmin OR iCoord1x-GroutWidth/2*Sin(iAngle)<BedXmin OR iCoord1y-GroutWidth/2*Cos(iAngle)<BedYmin THEN
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

                IF (iCoord1x-TieInWidth/2)<BedXmin OR (iCoord1y-TieInWidth/2)<BedYmin OR (iCoord1x+TieInWidth/2)>BedXmax OR (iCoord1y+TieInWidth/2)>BedYmax THEN
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
                    IF iCoord1x-TriangleBase/2*Cos(TriangleAngle)<BedXmin OR iCoord1y+TriangleBase/2*Sin(TriangleAngle)<BedYmin OR iCoord1x+TriangleHeight*Sin(TriangleAngle)<BedXmin OR iCoord1y+TriangleHeight*Cos(TriangleAngle)<BedYmin OR iCoord1x+TriangleBase/2*Cos(TriangleAngle)<BedXmin OR iCoord1y-TriangleBase/2*Sin(TriangleAngle)<BedYmin OR iCoord1x-TriangleBase/2*Cos(TriangleAngle)>BedXmax OR iCoord1y+TriangleBase/2*Sin(TriangleAngle)>BedYmax OR iCoord1x+TriangleHeight*Sin(TriangleAngle)>BedXmax OR iCoord1y+TriangleHeight*Cos(TriangleAngle)>BedYmax OR iCoord1x+TriangleBase/2*Cos(TriangleAngle)>BedXmax OR iCoord1y-TriangleBase/2*Sin(TriangleAngle)>BedYmax THEN
                        RAISE ERR_INVALID_INPUT;
                    ENDIF
                    PlotLine iCoord1x-TriangleBase/2*Cos(TriangleAngle),iCoord1y+TriangleBase/2*Sin(TriangleAngle),iCoord1x+TriangleHeight*Sin(TriangleAngle),iCoord1y+TriangleHeight*Cos(TriangleAngle);
                    PlotLine iCoord1x+TriangleHeight*Sin(TriangleAngle),iCoord1y+TriangleHeight*Cos(TriangleAngle),iCoord1x+TriangleBase/2*Cos(TriangleAngle),iCoord1y-TriangleBase/2*Sin(TriangleAngle);
                    PlotLine iCoord1x+TriangleBase/2*Cos(TriangleAngle),iCoord1y-TriangleBase/2*Sin(TriangleAngle),iCoord1x-TriangleBase/2*Cos(TriangleAngle),iCoord1y+TriangleBase/2*Sin(TriangleAngle);

                ELSEIF iAngle<=135 AND iAngle>45 THEN
                    TriangleAngle:=iAngle-90;
                    IF iCoord1x-TriangleBase/2*Sin(TriangleAngle)<BedXmin OR iCoord1y-TriangleBase/2*Cos(TriangleAngle)<BedYmin OR iCoord1x+TriangleBase/2*Sin(TriangleAngle)<BedXmin OR iCoord1y-TriangleBase/2*Sin(TriangleAngle)<BedYmin OR iCoord1x+TriangleHeight*Cos(TriangleAngle)<BedXmin OR iCoord1y-TriangleHeight*Sin(TriangleAngle)<BedYmin OR iCoord1x-TriangleBase/2*Sin(TriangleAngle)>BedXmax OR iCoord1y-TriangleBase/2*Cos(TriangleAngle)>BedYmax OR iCoord1x+TriangleBase/2*Sin(TriangleAngle)>BedXmax OR iCoord1y-TriangleBase/2*Sin(TriangleAngle)>BedYmax OR iCoord1x+TriangleHeight*Cos(TriangleAngle)>BedXmax OR iCoord1y-TriangleHeight*Sin(TriangleAngle)>BedYmax THEN

                        RAISE ERR_INVALID_INPUT;
                    ENDIF
                    PlotLine iCoord1x-TriangleBase/2*Sin(TriangleAngle),iCoord1y-TriangleBase/2*Cos(TriangleAngle),iCoord1x+TriangleBase/2*Sin(TriangleAngle),iCoord1y+TriangleBase/2*Cos(TriangleAngle);
                    PlotLine iCoord1x+TriangleBase/2*Sin(TriangleAngle),iCoord1y+TriangleBase/2*Cos(TriangleAngle),iCoord1x+TriangleHeight*Cos(TriangleAngle),iCoord1y-TriangleHeight*Sin(TriangleAngle);
                    PlotLine iCoord1x+TriangleHeight*Cos(TriangleAngle),iCoord1y-TriangleHeight*Sin(TriangleAngle),iCoord1x-TriangleBase/2*Sin(TriangleAngle),iCoord1y-TriangleBase/2*Cos(TriangleAngle);

                ELSEIF iAngle<=225 AND iAngle>135 THEN
                    TriangleAngle:=iAngle-180;
                    IF iCoord1x-TriangleHeight*Sin(TriangleAngle)<BedXmin OR iCoord1y-TriangleHeight*Sin(TriangleAngle)<BedYmin OR iCoord1x-TriangleBase/2*Cos(TriangleAngle)<BedXmin OR iCoord1y+TriangleBase/2*Sin(TriangleAngle)<BedYmin OR iCoord1x+TriangleBase/2*Cos(TriangleAngle)<BedXmin OR iCoord1y-TriangleBase/2*Sin(TriangleAngle)<BedYmin OR iCoord1x-TriangleHeight*Sin(TriangleAngle)>BedXmax OR iCoord1y-TriangleHeight*Sin(TriangleAngle)>BedYmax OR iCoord1x-TriangleBase/2*Cos(TriangleAngle)>BedXmax OR iCoord1y+TriangleBase/2*Sin(TriangleAngle)>BedYmax OR iCoord1x+TriangleBase/2*Cos(TriangleAngle)>BedXmax OR iCoord1y-TriangleBase/2*Sin(TriangleAngle)>BedYmax THEN

                        RAISE ERR_INVALID_INPUT;
                    ENDIF
                    PlotLine iCoord1x-TriangleHeight*Sin(TriangleAngle),iCoord1y-TriangleHeight*Cos(TriangleAngle),iCoord1x-TriangleBase/2*Cos(TriangleAngle),iCoord1y+TriangleBase/2*Sin(TriangleAngle);
                    PlotLine iCoord1x-TriangleBase/2*Cos(TriangleAngle),iCoord1y+TriangleBase/2*Sin(TriangleAngle),iCoord1x+TriangleBase/2*Cos(TriangleAngle),iCoord1y-TriangleBase/2*Sin(TriangleAngle);
                    PlotLine iCoord1x+TriangleBase/2*Cos(TriangleAngle),iCoord1y-TriangleBase/2*Sin(TriangleAngle),iCoord1x-TriangleHeight*Sin(TriangleAngle),iCoord1y-TriangleHeight*Cos(TriangleAngle);

                ELSEIF iAngle<=315 AND iAngle>225 THEN
                    TriangleAngle:=iAngle-270;
                    IF iCoord1x-TriangleBase/2*Sin(TriangleAngle)<BedXmin OR iCoord1y-TriangleBase/2*Cos(TriangleAngle)<BedYmin OR iCoord1x+TriangleHeight*Cos(TriangleAngle)<BedXmin OR iCoord1y-TriangleHeight*Sin(TriangleAngle)<BedYmin OR iCoord1x+TriangleBase/2*Sin(TriangleAngle)<BedXmin OR iCoord1y+TriangleBase/2*Cos(TriangleAngle)<BedYmin OR iCoord1x-TriangleBase/2*Sin(TriangleAngle)>BedXmax OR iCoord1y-TriangleBase/2*Cos(TriangleAngle)>BedYmax OR iCoord1x+TriangleHeight*Cos(TriangleAngle)>BedXmax OR iCoord1y-TriangleHeight*Sin(TriangleAngle)>BedYmax OR iCoord1x+TriangleBase/2*Sin(TriangleAngle)>BedXmax OR iCoord1y+TriangleBase/2*Cos(TriangleAngle)>BedYmax THEN
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

        CASE 3:
            TPWrite "Enter the x coordinates for the start and end positions of the formwork.";
            TPReadNum iCoord1x,"Enter first coordinate X value";
            TPReadNum iCoord2x,"Enter second coordinate x value";
            TPReadNum iZoffset,"Enter Z offset (-ve for lower, +ve for higher, 0 for no change:";
            IF iCoord1x<0 OR iCoord2x<0 OR iCoord1x>9000 OR iCoord2x>9000 THEN
                RAISE ERR_INVALID_INPUT;
            ENDIF

            IF iCoord1x>iCoord2x THEN
                iCoordTemp:=iCoord1x;
                iCoord1x:=iCoord2x;
                iCoord2x:=iCoordTemp;
            ENDIF

            Screed iCoord1x,iCoord2x,iZoffset;

        CASE 4:
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
            TPReadNum iLRUD,"Enter 1 for left/right movement or 2 for up/down movement:";

            IF iCoord1x<0 OR iCoord1y<0 OR iCoord2x<0 OR iCoord2y<0 OR iCoord1x>8800 OR iCoord1y>3800 OR iCoord2x>8800 OR iCoord2y>8800 OR iHeliBladeSpeed<0 OR iHeliBladeSpeed>140 OR iHeliBladeAngle<0 OR iHeliBladeAngle>12 OR iCoord2y<iCoord1y OR iCoord2x<iCoord1x OR iHeliPan<1 OR iHeliPan>2 THEN
                RAISE ERR_INVALID_INPUT;
            ENDIF
            IF iLRUD=1 THEN
                HeliTrowelLR iCoord1x,iCoord1y,iCoord2x,iCoord2y,iHeliBladeSpeed,iHeliBladeAngle,iZoffset,iHeliPan;
            ELSEIF iLRUD=2 THEN
                HeliTrowelUD iCoord1x,iCoord1y,iCoord2x,iCoord2y,iHeliBladeSpeed,iHeliBladeAngle,iZoffset,iHeliPan;
            ELSE
                RAISE ERR_INVALID_INPUT;
            ENDIF

        CASE 5:
            VacuumBed;

        CASE 6:
            Polish;
        DEFAULT:
            RAISE ERR_INVALID_INPUT;
        ENDTEST
    ERROR
        RAISE ;
    ENDPROC

    PROC HeliTrowelLR(num HeliStartX,num HeliStartY,num HeliEndX,num HeliEndY,num HeliSpeed,num HeliAngle,num HeliZoffset,num IsPan)

        pHeliStart.trans:=[HeliStartX,HeliStartY,(FormHeight+35+HeliZoffset)];
        pHeliEnd.trans:=[HeliEndX,HeliEndY,(FormHeight+35+HeliZoffset)];

        IF ToolNum<>2 THEN
            Home;
            Heli_Pickup;
        ENDIF

        IF pHeliStart.trans.y<1800 THEN
            pHeliStart.extax.eax_a:=pHeliStart.trans.x+Bed1.uframe.trans.x-1500+HeliBladeWidth/2;
            pHeliEnd.extax.eax_a:=pHeliEnd.trans.x+Bed1.uframe.trans.x-1500-HeliBladeWidth/2;
        ELSE
            pHeliStart.extax.eax_a:=pHeliStart.trans.x+Bed1.uframe.trans.x+HeliBladeWidth/2;
            pHeliEnd.extax.eax_a:=pHeliEnd.trans.x+Bed1.uframe.trans.x-HeliBladeWidth/2;
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
        pHeliTempS.trans.x:=pHeliStart.trans.x+(HeliBladeWidth/2)-300;
        pHeliTempS.trans.y:=pHeliStart.trans.y+(HeliBladeWidth/2);
        pHeliTempE.trans.x:=pHeliEnd.trans.x-(HeliBladeWidth/2)+300;
        pHeliTempE.trans.y:=pHeliEnd.trans.y-(HeliBladeWidth/2);
        pHeliTempS.trans.z:=FormHeight+30+HeliZoffset;
        pHeliTempE.trans.z:=FormHeight+30+HeliZoffset;

        MoveJ Offs(pHeliTempS,0,0,300),v500,z5,tHeli\WObj:=Bed1;

        IF IsPan=2 THEN
            HeliBlade_Angle HeliAngle;
            HeliBladeSpeed HeliSpeed,"FWD";
            WaitTime\inpos,4;
        ENDIF

        IF IsPan=1 THEN
            MoveJ Offs(pHeliTempS,0,0,75),v500,z5,tHeli\WObj:=Bed1;
            Stop;
        ENDIF
        HeliZ pHeliTempS.trans.x,pHeliTempS.trans.y,TRUE;
        HeliZOffs:=HighestArray(HeliZArrayCounter);

        MoveL Offs(pHeliTempS,0,0,PitchZOffset+HeliZOffs),v50,z5,tHeli\WObj:=Bed1;
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


                FOR M FROM 0 TO (HeliDiv-1) DO
                    HeliZ(pHeliTemp1.trans.x+M*XGridSpacing+XGridSpacing),(pHeliTemp1.trans.y+HeliPassWidth*i/2),TRUE;
                    HeliZOffs:=HighestArray(HeliZArrayCounter);
                    IF (HeliPassWidth*i/2+pHeliTemp1.trans.y)>1600 THEN
                        pHeliTemp1.extax.eax_a:=pHeliTemp1.trans.x+Bed1.uframe.trans.x+M*XGridSpacing;
                    ELSE
                        pHeliTemp1.extax.eax_a:=pHeliTemp1.trans.x+Bed1.uframe.trans.x-1500+M*XGridSpacing;
                    ENDIF
                    MoveL Offs(pHeliTemp1,M*XGridSpacing,HeliPassWidth*i/2,PitchZOffset+HeliZOffs),vHeli,z5,tHeli\WObj:=Bed1;
                    !Across Right
                ENDFOR

                IF (HeliPassWidth*i/2+pHeliTemp2.trans.y)>1600 THEN
                    pHeliTemp2.extax.eax_a:=pHeliTemp2.trans.x+Bed1.uframe.trans.x;
                ELSE
                    pHeliTemp2.extax.eax_a:=pHeliTemp2.trans.x+Bed1.uframe.trans.x-1500;
                ENDIF
                HeliZ(pHeliTemp2.trans.x),(pHeliTemp1.trans.y+HeliPassWidth*i/2),TRUE;
                HeliZOffs:=HighestArray(HeliZArrayCounter);
                MoveL Offs(pHeliTemp2,0,HeliPassWidth*i/2,PitchZOffset+HeliZOffs),vHeli,z5,tHeli\WObj:=Bed1;
                !Across Right

                IF i=(2*HeliPasses) THEN
                ELSE
                    HeliZ(pHeliTemp2.trans.x),(pHeliTemp1.trans.y+HeliPassWidth*(i+1)/2),TRUE;
                    HeliZOffs:=HighestArray(HeliZArrayCounter);
                    IF (HeliPassWidth*(i+1)/2+pHeliTemp2.trans.y)>1600 THEN
                        pHeliTemp2.extax.eax_a:=pHeliTemp2.trans.x+Bed1.uframe.trans.x;
                    ELSE
                        pHeliTemp2.extax.eax_a:=pHeliTemp2.trans.x+Bed1.uframe.trans.x-1500;
                    ENDIF
                    MoveL Offs(pHeliTemp2,0,HeliPassWidth*(i+1)/2,PitchZOffset+HeliZOffs),vHeli,z5,tHeli\WObj:=Bed1;
                    !Up

                    FOR M FROM (HeliDiv-1) TO 0 DO
                        HeliZ(pHeliTemp1.trans.x+M*XGridSpacing),(pHeliTemp1.trans.y+HeliPassWidth*(i+1)/2),TRUE;
                        HeliZOffs:=HighestArray(HeliZArrayCounter);
                        IF (HeliPassWidth*(i+1)/2+pHeliTemp1.trans.y)>1600 THEN
                            pHeliTemp1.extax.eax_a:=pHeliTemp1.trans.x+Bed1.uframe.trans.x+M*XGridSpacing;
                        ELSE
                            pHeliTemp1.extax.eax_a:=pHeliTemp1.trans.x+Bed1.uframe.trans.x-1500+M*XGridSpacing;
                        ENDIF
                        MoveL Offs(pHeliTemp1,M*XGridSpacing,HeliPassWidth*(i+1)/2,PitchZOffset+HeliZOffs),vHeli,z5,tHeli\WObj:=Bed1;
                        !Across Left
                    ENDFOR

                ENDIF

            ENDIF
        ENDFOR

        IF IsPan=1 THEN
            WaitTime\InPos,0.1;
            HeliBladeSpeed 0,"FWD";
            WaitTime\inpos,8;
            MoveL Offs(pHeliTemp2,0,HeliPassWidth*2*HeliPasses/2,18+PitchZOffset+HeliZOffs),v50,fine,tHeli\WObj:=Bed1;
            HeliBladeSpeed 20,"REV";
            WaitTime\inpos,0.6;
            HeliBladeSpeed 0,"FWD";
            Stop;
        ENDIF
        MoveL Offs(pHeliTemp2,0,HeliPassWidth*2*HeliPasses/2,50+PitchZOffset+HeliZOffs),v50,z5,tHeli\WObj:=Bed1;

        HeliBladeSpeed 0,"FWD";
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tHeli\WObj:=wobj0);
        MoveJ Offs(pHeliTemp2,0,HeliPassWidth*2*HeliPasses/2+3000-CurrentPos.trans.y,300),v500,z5,tHeli\WObj:=Bed1;
        MoveJ ptHeliLid,v500,fine,tHeli;

    ENDPROC

    PROC HeliTrowelUD(num HeliStartX,num HeliStartY,num HeliEndX,num HeliEndY,num HeliSpeed,num HeliAngle,num HeliZoffset,num IsPan)

        pHeliStart.trans:=[HeliStartX,HeliStartY,(FormHeight+35+HeliZoffset)];
        pHeliEnd.trans:=[HeliEndX,HeliEndY,(FormHeight+35+HeliZoffset)];

        IF ToolNum<>2 THEN
            Home;
            Heli_Pickup;
        ENDIF

        IF pHeliStart.trans.y<1800 THEN
            pHeliStart.extax.eax_a:=pHeliStart.trans.x+Bed1.uframe.trans.x-1500+HeliBladeWidth/2;
            pHeliEnd.extax.eax_a:=pHeliEnd.trans.x+Bed1.uframe.trans.x-1500-HeliBladeWidth/2;
        ELSE
            pHeliStart.extax.eax_a:=pHeliStart.trans.x+Bed1.uframe.trans.x+HeliBladeWidth/2;
            pHeliEnd.extax.eax_a:=pHeliEnd.trans.x+Bed1.uframe.trans.x-HeliBladeWidth/2;
        ENDIF

        IF (pHeliEnd.trans.x-pHeliStart.trans.x)<HeliBladeWidth THEN
            HeliPasses:=1;
            HeliPassWidth:=0;
        ELSE
            HeliPasses:=((pHeliEnd.trans.x-pHeliStart.trans.x-HeliBladeWidth) DIV HeliOverlapMin);
            IF HeliPasses MOD 2<>0 THEN
                Incr HeliPasses;
            ENDIF
            IF HeliPasses<1 THEN
                HeliPasses:=1;
            ENDIF
            HeliPassWidth:=(pHeliEnd.trans.x-(HeliBladeWidth/2)-(pHeliStart.trans.x+(HeliBladeWidth/2)))/HeliPasses;
        ENDIF

        pHeliTempS:=pHeliStart;
        pHeliTempE:=pHeliEnd;
        pHeliTempS.trans.x:=pHeliStart.trans.x+(HeliBladeWidth/2)-300;
        pHeliTempS.trans.y:=pHeliStart.trans.y+(HeliBladeWidth/2);
        pHeliTempE.trans.x:=pHeliEnd.trans.x-(HeliBladeWidth/2)+300;
        pHeliTempE.trans.y:=pHeliEnd.trans.y-(HeliBladeWidth/2);
        pHeliTempS.trans.z:=FormHeight+30+HeliZoffset;
        pHeliTempE.trans.z:=FormHeight+30+HeliZoffset;

        MoveJ Offs(pHeliTempS,0,0,300),v500,z5,tHeli\WObj:=Bed1;

        IF IsPan=2 THEN
            HeliBlade_Angle HeliAngle;
            HeliBladeSpeed HeliSpeed,"FWD";
            WaitTime\inpos,4;
        ENDIF

        IF IsPan=1 THEN
            MoveJ Offs(pHeliTempS,0,0,75),v500,z5,tHeli\WObj:=Bed1;
            Stop;
        ENDIF
        HeliZ pHeliTempS.trans.x,pHeliTempS.trans.y,TRUE;
        HeliZOffs:=HighestArray(HeliZArrayCounter);

        MoveL Offs(pHeliTempS,0,0,PitchZOffset+HeliZOffs),v50,z5,tHeli\WObj:=Bed1;
        pHeliTemp1:=pHeliTempS;
        pHeliTemp2:=pHeliTempS;
        pHeliTemp2.trans.y:=pHeliTempE.trans.y;
        pHeliTemp2.extax.eax_a:=pHeliTempE.extax.eax_a;

        IF IsPan=1 THEN
            Stop;
            HeliBlade_Angle HeliAngle;
            HeliBladeSpeed HeliSpeed,"FWD";
            WaitTime\inpos,5;
        ENDIF


        HeliDiv:=(pHeliTempE.trans.y-pHeliTempS.trans.y) DIV YGridSpacing;


        FOR i FROM 0 to (2*HeliPasses) DO
            IF (i MOD 2)=0 THEN

                FOR M FROM 0 TO (HeliDiv-1) DO
                    HeliZ(pHeliTemp1.trans.x+HeliPassWidth*i/2),(pHeliTemp1.trans.y+M*YGridSpacing+YGridSpacing),TRUE;
                    HeliZOffs:=HighestArray(HeliZArrayCounter);
                    IF (pHeliTemp1.trans.y+M*YGridSpacing+YGridSpacing)>1600 THEN
                        pHeliTemp1.extax.eax_a:=pHeliTemp1.trans.x+Bed1.uframe.trans.x+HeliPassWidth*i/2;
                    ELSE
                        pHeliTemp1.extax.eax_a:=pHeliTemp1.trans.x+Bed1.uframe.trans.x-1500+HeliPassWidth*i/2;
                    ENDIF
                    MoveL Offs(pHeliTemp1,HeliPassWidth*i/2,M*YGridSpacing,PitchZOffset+HeliZOffs),vHeli,z5,tHeli\WObj:=Bed1;
                    !Up
                ENDFOR

                IF (pHeliTemp2.trans.y)>1600 THEN
                    pHeliTemp2.extax.eax_a:=pHeliTemp2.trans.x+Bed1.uframe.trans.x+HeliPassWidth*i/2;
                ELSE
                    pHeliTemp2.extax.eax_a:=pHeliTemp2.trans.x+Bed1.uframe.trans.x+HeliPassWidth*i/2-1500;
                ENDIF
                HeliZ(pHeliTemp2.trans.x),(pHeliTemp1.trans.y+HeliPassWidth*i/2),TRUE;
                HeliZOffs:=HighestArray(HeliZArrayCounter);
                MoveL Offs(pHeliTemp2,HeliPassWidth*i/2,0,PitchZOffset+HeliZOffs),vHeli,z5,tHeli\WObj:=Bed1;
                !Up

                IF i=(2*HeliPasses) THEN
                ELSE
                    HeliZ(pHeliTemp2.trans.x+HeliPassWidth*(i+1)/2),(pHeliTemp1.trans.y),TRUE;
                    HeliZOffs:=HighestArray(HeliZArrayCounter);
                    IF (pHeliTemp2.trans.y)>1600 THEN
                        pHeliTemp2.extax.eax_a:=pHeliTemp2.trans.x+Bed1.uframe.trans.x+HeliPassWidth*(i+1)/2;
                    ELSE
                        pHeliTemp2.extax.eax_a:=pHeliTemp2.trans.x+Bed1.uframe.trans.x+HeliPassWidth*(i+1)/2-1500;
                    ENDIF
                    MoveL Offs(pHeliTemp2,HeliPassWidth*(i+1)/2,0,PitchZOffset+HeliZOffs),vHeli,z5,tHeli\WObj:=Bed1;
                    !Right

                    FOR M FROM (HeliDiv-1) TO 0 DO
                        HeliZ(pHeliTemp1.trans.x+HeliPassWidth*(i+1)/2),(pHeliTemp1.trans.y+M*YGridSpacing),TRUE;
                        HeliZOffs:=HighestArray(HeliZArrayCounter);
                        IF (pHeliTemp1.trans.y+M*YGridSpacing)>1600 THEN
                            pHeliTemp1.extax.eax_a:=pHeliTemp1.trans.x+Bed1.uframe.trans.x+HeliPassWidth*(i+1)/2;
                        ELSE
                            pHeliTemp1.extax.eax_a:=pHeliTemp1.trans.x+Bed1.uframe.trans.x-1500+HeliPassWidth*(i+1)/2;
                        ENDIF
                        MoveL Offs(pHeliTemp1,+HeliPassWidth*(i+1)/2,M*YGridSpacing,PitchZOffset+HeliZOffs),vHeli,z5,tHeli\WObj:=Bed1;
                        !Down
                    ENDFOR

                ENDIF

            ENDIF
        ENDFOR

        IF IsPan=1 THEN
            WaitTime\InPos,0.1;
            HeliBladeSpeed 0,"FWD";
            WaitTime\inpos,8;
            MoveL Offs(pHeliTemp2,HeliPassWidth*(2*HeliPasses)/2,0,18+PitchZOffset+HeliZOffs),v50,fine,tHeli\WObj:=Bed1;
            HeliBladeSpeed 20,"REV";
            WaitTime\inpos,0.6;
            HeliBladeSpeed 0,"FWD";
            Stop;
        ENDIF
        MoveL Offs(pHeliTemp2,HeliPassWidth*2*HeliPasses/2,0,50+PitchZOffset+HeliZOffs),v50,z5,tHeli\WObj:=Bed1;

        HeliBladeSpeed 0,"FWD";
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tHeli\WObj:=wobj0);
        MoveL Offs(pHeliTemp2,HeliPassWidth*(2*HeliPasses)/2,0+3000-CurrentPos.trans.y,300),v500,z5,tHeli\WObj:=Bed1;
        MoveJ ptHeliLid,v500,fine,tHeli;

    ENDPROC

    PROC Screed(num ScrStart,num ScrEnd,num ScrZoffset)

        IF ToolNum<>3 THEN
            Home;
            VS_Pickup;
        ENDIF

        pScreedStart.trans:=[ScrStart,1900,FormHeight+ScrZoffset-5.5];
        pScreedEnd.trans:=[ScrEnd,1900,FormHeight+ScrZoffset-5.5];

        pScreedStart.extax.eax_a:=pScreedStart.trans.x+Bed1.uframe.trans.x-500;
        pScreedEnd.extax.eax_a:=pScreedEnd.trans.x+Bed1.uframe.trans.x-500;

        ScrInitialD:=(pScreedStart.trans.x) MOD 1000;
        IF ScrInitialD>350 AND ScrInitialD<=850 THEN
            ScrInitialD:=850-ScrInitialD;
        ELSEIF ScrInitialD>850 THEN
            ScrInitialD:=1000-ScrInitialD+350;
        ELSE
            ScrInitialD:=350-ScrInitialD;
        ENDIF

        IF pScreedStart.trans.x<350 THEN
            SStartdiv:=1;
            ScrBedZ:=BedZreads{1,1};
            pScreedStart.trans.z:=pScreedStart.trans.z+ScrBedZ;
        ELSEIF pScreedStart.trans.x<BedZpos{1,18,1} THEN
            SStartdiv:=(pScreedStart.trans.x+ScrInitialD-BedZpos{1,1,1}) DIV 500;
            ScrBedZ:=BedZreads{1,SStartdiv}*(1-Abs(pScreedStart.trans.x-BedZpos{1,SStartdiv,1})/500)+BedZreads{1,SStartdiv+1}*(1-Abs(pScreedStart.trans.x-BedZpos{1,SStartdiv,1+1})/500);
            pScreedStart.trans.z:=pScreedStart.trans.z+ScrBedZ;
        ELSE
            SStartdiv:=18;
            ScrBedZ:=BedZreads{1,18};
            pScreedStart.trans.z:=pScreedStart.trans.z+ScrBedZ;
        ENDIF


        IF pScreedEnd.trans.x<350 THEN
            SEnddiv:=1;
            ScrBedZ:=BedZreads{1,1};
            pScreedEnd.trans.z:=pScreedEnd.trans.z+ScrBedZ;
        ELSEIF pScreedEnd.trans.x<BedZpos{1,18,1} THEN
            SEnddiv:=(pScreedEnd.trans.x-(pScreedStart.trans.x+ScrInitialD)) DIV 500;
            ScrBedZ:=BedZreads{1,SEnddiv+SStartdiv}*(1-Abs(pScreedEnd.trans.x-BedZpos{1,SEnddiv+SStartdiv,1})/500)+BedZreads{1,SEnddiv+SStartdiv-1}*(1-Abs(pScreedEnd.trans.x-BedZpos{1,SEnddiv+SStartdiv-1,1})/500);
            pScreedEnd.trans.z:=pScreedEnd.trans.z+ScrBedZ;
        ELSE
            ScrBedZ:=BedZreads{1,18};
            SEnddiv:=18;
            pScreedEnd.trans.z:=pScreedEnd.trans.z+ScrBedZ;
        ENDIF

        MoveJ Offs(pScreedStart,-20,0,100),v1000,z5,tVS\WObj:=Bed1;
        VS_on;
        MoveL Offs(pScreedStart,-20,0,0),v100,z5,tVS\WObj:=Bed1;

        pScreedStart.extax.eax_a:=pScreedStart.extax.eax_a+ScrInitialD;
        MoveL Offs(pScreedStart,(ScrInitialD),0,BedZreads{1,(SStartdiv)}),vVS,z5,tVS\WObj:=Bed1;

        FOR i FROM (SStartdiv+1) TO (SEnddiv+SStartdiv) DO
            pScreedStart.extax.eax_a:=pScreedStart.extax.eax_a+500;
            MoveL Offs(pScreedStart,((i+1-(SStartdiv+1))*500+ScrInitialD),0,BedZreads{1,(i+1)}),vVS,z5,tVS\WObj:=Bed1;
        ENDFOR
        MoveL Offs(pScreedEnd,140,0,0),vVS,z5,tVS\WObj:=Bed1;
        MoveL Offs(pScreedEnd,140,0,100),v100,z5,tVS\WObj:=Bed1;
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
            CurrentPos:=CalcRobT(CurrentJoints,tPlotter\WObj:=wobj0);

            IF (CurrentPos.trans.z<(Bed1.uframe.trans.z-20)) OR ((CurrentPos.trans.x+CurrentPos.extax.eax_a)<Bed1.uframe.trans.x) THEN
                !Robot in TS
                TPErase;
                TPWrite("Jog robot out of tool station AND HOME");
                Stop;
            ELSEIF (CurrentPos.trans.y>(Bed1.uframe.trans.y+3000) AND (CurrentPos.trans.x+CurrentPos.extax.eax_a)>Bed1.uframe.trans.x) THEN
                !MoveL Offs(CurrentPos,0,(3300-CurrentPos.trans.y),50),v10,z5,tPlotter\WObj:=wobj0;
                !MoveJ Offs(CurrentPos,0,(3300-CurrentPos.trans.y),300-CurrentPos.trans.z),v10,z5,tPlotter\WObj:=wobj0;
            ENDIF
        ENDIF


        Plotterp1.trans:=[Xcord1,Ycord1,PlotterZ];
        Plotterp2.trans:=[Xcord2,Ycord2,PlotterZ];
        Plotterp3.trans:=[Xcord3,Ycord3,PlotterZ];
        Plotterp4.trans:=[Xcord4,Ycord4,PlotterZ];

        IF Plotterp1.trans.y>0 THEN
            IF Plotterp1.trans.y<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(Plotterp1.trans.y/abs(tPlotter.tframe.trans.x));
                IF PlotterZOri>PlotA6Max THEN
                    PlotterZOri:=45;
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
            Plotterp1.extax:=[(Plotterp1.trans.x+Bed1.uframe.trans.x-500-Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri))),9E+09,9E+09,9E+09,9E+09,9E+09];
        ENDIF


        IF Plotterp2.trans.y>0 THEN
            IF Plotterp2.trans.y<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(Plotterp2.trans.y/abs(tPlotter.tframe.trans.x));

                IF PlotterZOri>PlotA6Max THEN
                    PlotterZOri:=45;
                ENDIF
                Plotterp2.rot:=OrientZYX(-90+PlotterZOri,0,180);

            ELSE
                PlotterZOri:=0;
                Plotterp2.rot:=OrientZYX(-90,0,180);
            ENDIF
        ELSE
            RAISE ERR_PLOT_POS;
        ENDIF
        IF PlotterP2.trans.y>(abs(tPlotter.tframe.trans.x)+250) THEN
            Plotterp2.extax:=[(Plotterp2.trans.x+Bed1.uframe.trans.x),9E+09,9E+09,9E+09,9E+09,9E+09];
        ELSE
            Plotterp2.extax:=[(Plotterp2.trans.x+Bed1.uframe.trans.x-500-Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri))),9E+09,9E+09,9E+09,9E+09,9E+09];
        ENDIF

        IF Plotterp3.trans.y>0 THEN
            IF Plotterp3.trans.y<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(Plotterp3.trans.y/abs(tPlotter.tframe.trans.x));

                IF PlotterZOri>PlotA6Max THEN
                    PlotterZOri:=45;
                ENDIF
                Plotterp3.rot:=OrientZYX(-90+PlotterZOri,0,180);

            ELSE
                PlotterZOri:=0;
                Plotterp3.rot:=OrientZYX(-90,0,180);
            ENDIF
        ELSE
            RAISE ERR_PLOT_POS;
        ENDIF
        IF PlotterP3.trans.y>(abs(tPlotter.tframe.trans.x)+250) THEN
            Plotterp3.extax:=[(Plotterp3.trans.x+Bed1.uframe.trans.x),9E+09,9E+09,9E+09,9E+09,9E+09];
        ELSE
            Plotterp3.extax:=[(Plotterp3.trans.x+Bed1.uframe.trans.x-500-Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri))),9E+09,9E+09,9E+09,9E+09,9E+09];
        ENDIF

        IF Plotterp4.trans.y>0 THEN
            IF Plotterp4.trans.y<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(Plotterp4.trans.y/abs(tPlotter.tframe.trans.x));
                IF PlotterZOri>PlotA6Max THEN
                    PlotterZOri:=45;
                ENDIF
                Plotterp4.rot:=OrientZYX(-90+PlotterZOri,0,180);
            ELSE
                PlotterZOri:=0;
                Plotterp4.rot:=OrientZYX(-90,0,180);
            ENDIF
        ELSE
            RAISE ERR_PLOT_POS;
        ENDIF

        IF PlotterP4.trans.y>(abs(tPlotter.tframe.trans.x)+250) THEN
            Plotterp4.extax:=[(Plotterp4.trans.x+Bed1.uframe.trans.x),9E+09,9E+09,9E+09,9E+09,9E+09];
        ELSE
            Plotterp4.extax:=[(Plotterp4.trans.x+Bed1.uframe.trans.x-500-Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri))),9E+09,9E+09,9E+09,9E+09,9E+09];
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

        MoveJ Offs(Plotterp1,0,0,50),v2000,z5,tPlotter\WObj:=Bed1;
        ConfL\off;
        ConfJ\off;
        MoveL Plotterp1,v10,fine,tPlotter\WObj:=Bed1;
        MoveL Plotterp2,vPlotter,zPlotter,tPlotter\WObj:=Bed1;
        MoveL Plotterp3,vPlotter,fine,tPlotter\WObj:=Bed1;
        WaitTime\inpos,1;
        MoveL Plotterp4,vPlotter,zPlotter,tPlotter\WObj:=Bed1;
        MoveL Plotterp1,vPlotter,zPlotter,tPlotter\WObj:=Bed1;
        MoveL Offs(Plotterp1,0,0,50),v100,z5,tPlotter\WObj:=Bed1;
        MoveJ Offs(Plotterp1,0,0,200),v500,fine,tPlotter\WObj:=Bed1;

        ConfL\on;
        ConfJ\on;

    ERROR
        RAISE ;


    ENDPROC

    PROC PlotLine(num Xcord1,num Ycord1,num Xcord2,num Ycord2)

        IF ToolNum<>4 THEN
            Home;
            Plotter_Pickup;
        ELSE
            !Check position and move to safe position if needed
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tPlotter\WObj:=wobj0);

            IF (CurrentPos.trans.z<(Bed1.uframe.trans.z-30)) OR ((CurrentPos.trans.x+CurrentPos.extax.eax_a)<Bed1.uframe.trans.x) THEN
                !Robot in TS
                TPWrite("Jog robot out of tool station AND HOME");
                Stop;
            ELSEIF (CurrentPos.trans.y>(Bed1.uframe.trans.y+500) AND (CurrentPos.trans.x+CurrentPos.extax.eax_a)>Bed1.uframe.trans.x) THEN
                !MoveL Offs(CurrentPos,0,100,50),v200,z5,tPlotter\WObj:=wobj0;
            ENDIF
        ENDIF


        IF Xcord1<Xcord2 THEN
            Plotterp1.trans:=[Xcord1,Ycord1,PlotterZ];
            Plotterp2.trans:=[Xcord2,Ycord2,PlotterZ];
        ELSE
            Plotterp1.trans:=[Xcord2,Ycord2,PlotterZ];
            Plotterp2.trans:=[Xcord1,Ycord1,PlotterZ];
        ENDIF


        IF Plotterp1.trans.y>0 THEN
            IF Plotterp1.trans.y<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(Plotterp1.trans.y/abs(tPlotter.tframe.trans.x));
                IF PlotterZOri>PlotA6Max THEN
                    PlotterZOri:=45;
                ENDIF
                Plotterp1.rot:=OrientZYX(-90+PlotterZOri,0,180);
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
            Plotterp1.extax:=[(Plotterp1.trans.x+Bed1.uframe.trans.x),9E+09,9E+09,9E+09,9E+09,9E+09];
        ELSE
            Plotterp1.extax:=[(Plotterp1.trans.x+Bed1.uframe.trans.x-100-Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri))),9E+09,9E+09,9E+09,9E+09,9E+09];
        ENDIF

        IF Plotterp2.trans.y>0 THEN
            IF Plotterp2.trans.y<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(Plotterp2.trans.y/abs(tPlotter.tframe.trans.x));

                IF PlotterZOri>PlotA6Max THEN
                    PlotterZOri:=45;
                ENDIF
                Plotterp2.rot:=OrientZYX(-90+PlotterZOri,0,180);
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
            Plotterp2.extax:=[(Plotterp2.trans.x+Bed1.uframe.trans.x),9E+09,9E+09,9E+09,9E+09,9E+09];
        ELSE
            Plotterp2.extax:=[(Plotterp2.trans.x+Bed1.uframe.trans.x-100-Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri))),9E+09,9E+09,9E+09,9E+09,9E+09];
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

        IF Sqrt(((Plotterp1.trans.x-Plotterp2.trans.x)*(Plotterp1.trans.x-Plotterp2.trans.x))+((Plotterp1.trans.y-Plotterp2.trans.y)*(Plotterp1.trans.y-Plotterp2.trans.y)))<100 THEN
            vPlotter:=[10,5,2000,15];
        ELSE
            vPlotter:=[100,15,2000,15];
        ENDIF

        MoveJ Offs(Plotterp1,0,0,50),v2000,z5,tPlotter\WObj:=Bed1;
        ConfL\off;
        ConfJ\off;
        MoveL Plotterp1,v30,zPlotter,tPlotter\WObj:=Bed1;
        MoveL Plotterp2,vPlotter,fine,tPlotter\WObj:=Bed1;
        MoveL Offs(Plotterp2,0,0,50),v100,z5,tPlotter\WObj:=Bed1;
        MoveJ Offs(Plotterp2,0,0,200),v500,fine,tPlotter\WObj:=Bed1;

        ConfL\on;
        ConfJ\on;

    ERROR
        RAISE ;

    ENDPROC


    PROC PlotCirc(num Xcord,num Ycord,num Rad)
        IF ToolNum<>4 THEN
            Home;
            Plotter_Pickup;
        ELSE
            !Check position and move to safe position if needed
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tPlotter\WObj:=wobj0);

            IF (CurrentPos.trans.z<(Bed1.uframe.trans.z-20)) OR ((CurrentPos.trans.x+CurrentPos.extax.eax_a)<Bed1.uframe.trans.x) THEN
                !Robot in TS
                TPWrite("Jog robot out of tool station AND HOME");
                Stop;
            ELSEIF (CurrentPos.trans.y>(Bed1.uframe.trans.y+3000) AND (CurrentPos.trans.x+CurrentPos.extax.eax_a)>Bed1.uframe.trans.x) THEN
                !MoveL Offs(CurrentPos,0,(3000-CurrentPos.trans.y),50),v10,z5,tPlotter\WObj:=wobj0;
                !MoveJ Offs(CurrentPos,0,(3000-CurrentPos.trans.y),300-CurrentPos.trans.z),v10,z5,tPlotter\WObj:=wobj0;
            ENDIF
        ENDIF


        IF Rad<100 THEN
            vPlotter:=[10,5,2000,15];
        ELSE
            vPlotter:=[50,15,2000,15];
        ENDIF


        !Plot Circle
        Plotterc5.trans:=[Xcord,Ycord,PlotterZ];
        PlotterTemp.trans:=[Plotterc5.trans.x-Rad,Plotterc5.trans.y,PlotterZ];

        IF PlotterTemp.trans.y>0 THEN
            IF PlotterTemp.trans.y<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(PlotterTemp.trans.y/abs(tPlotter.tframe.trans.x));
                IF PlotterZOri>PlotA6Max THEN
                    PlotterZOri:=45;
                ENDIF
                PlotterTemp.rot:=OrientZYX(-90+PlotterZOri,0,180);
            ELSE
                PlotterTemp.rot:=OrientZYX(-90,0,180);
            ENDIF
        ELSE
            RAISE ERR_PLOT_POS;
        ENDIF

        IF PlotterTemp.trans.y+Bed1.uframe.trans.y>2800 THEN
            PlotterTemp.extax:=[(PlotterTemp.trans.x+Bed1.uframe.trans.x),9E+09,9E+09,9E+09,9E+09,9E+09];
        ELSE
            PlotterTemp.extax:=[(PlotterTemp.trans.x+Bed1.uframe.trans.x-500-Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri))),9E+09,9E+09,9E+09,9E+09,9E+09];
        ENDIF

        IF PlotterTemp.extax.eax_a>10150 THEN
            PlotterTemp.extax.eax_a:=10100;
        ELSEIF PlotterTemp.extax.eax_a<0 THEN
            PlotterTemp.extax.eax_a:=0;
        ENDIF

        MoveJ Offs(PlotterTemp,0,0,50),v1500,z5,tPlotter\WObj:=Bed1;
        MoveL PlotterTemp,v10,fine,tPlotter\WObj:=Bed1;

        PlotterTemp.trans:=[Plotterc5.trans.x,Plotterc5.trans.y+Rad,PlotterZ];
        IF PlotterTemp.trans.y>0 THEN
            IF PlotterTemp.trans.y<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(PlotterTemp.trans.y/abs(tPlotter.tframe.trans.x));
                IF PlotterZOri>PlotA6Max THEN
                    PlotterZOri:=45;
                ENDIF
                PlotterTemp.rot:=OrientZYX(-90+PlotterZOri,0,180);
            ELSE
                PlotterZOri:=0;
                PlotterTemp.rot:=OrientZYX(-90,0,180);
            ENDIF
        ELSE
            RAISE ERR_PLOT_POS;
        ENDIF
        IF PlotterTemp.trans.y+Bed1.uframe.trans.y>2800 THEN
            PlotterTemp.extax:=[(PlotterTemp.trans.x+Bed1.uframe.trans.x),9E+09,9E+09,9E+09,9E+09,9E+09];
        ELSE
            PlotterTemp.extax:=[(PlotterTemp.trans.x+Bed1.uframe.trans.x-500-Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri))),9E+09,9E+09,9E+09,9E+09,9E+09];
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
                    PlotterZOri:=45;
                ENDIF
                PlotterTemp2.rot:=OrientZYX(-90+PlotterZOri,0,180);

            ELSE
                PlotterZOri:=0;
                PlotterTemp2.rot:=OrientZYX(-90,0,180);
            ENDIF
        ELSE
            RAISE ERR_PLOT_POS;
        ENDIF
        IF PlotterTemp2.trans.y+Bed1.uframe.trans.y>2800 THEN
            PlotterTemp2.extax:=[(PlotterTemp2.trans.x+Bed1.uframe.trans.x),9E+09,9E+09,9E+09,9E+09,9E+09];
        ELSE
            PlotterTemp2.extax:=[(PlotterTemp2.trans.x+Bed1.uframe.trans.x-500-Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri))),9E+09,9E+09,9E+09,9E+09,9E+09];
        ENDIF

        IF PlotterTemp2.extax.eax_a>10150 THEN
            PlotterTemp2.extax.eax_a:=10100;
        ELSEIF PlotterTemp2.extax.eax_a<0 THEN
            PlotterTemp2.extax.eax_a:=0;
        ENDIF

        MoveC PlotterTemp,PlotterTemp2,vPlotter,fine,tPlotter\WObj:=Bed1;

        PlotterTemp.trans:=[Plotterc5.trans.x,Plotterc5.trans.y-Rad,PlotterZ];
        IF PlotterTemp.trans.y>0 THEN
            IF PlotterTemp.trans.y<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(PlotterTemp.trans.y/abs(tPlotter.tframe.trans.x));
                IF PlotterZOri>PlotA6Max THEN
                    PlotterZOri:=45;
                ENDIF
                PlotterTemp.rot:=OrientZYX(-90+PlotterZOri,0,180);

            ELSE
                PlotterZOri:=0;
                PlotterTemp.rot:=OrientZYX(-90,0,180);
            ENDIF
        ELSE
            RAISE ERR_PLOT_POS;
        ENDIF
        IF PlotterTemp.trans.y+Bed1.uframe.trans.y>2800 THEN
            PlotterTemp.extax:=[(PlotterTemp.trans.x+Bed1.uframe.trans.x),9E+09,9E+09,9E+09,9E+09,9E+09];
        ELSE
            PlotterTemp.extax:=[(PlotterTemp.trans.x+Bed1.uframe.trans.x-500-Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri))),9E+09,9E+09,9E+09,9E+09,9E+09];
        ENDIF

        IF PlotterTemp.extax.eax_a>10150 THEN
            PlotterTemp.extax.eax_a:=10100;
        ELSEIF PlotterTemp.extax.eax_a<0 THEN
            PlotterTemp.extax.eax_a:=0;
        ENDIF

        PlotterTemp2.trans:=[Plotterc5.trans.x-Rad,Plotterc5.trans.y,PlotterZ];
        IF PlotterTemp2.trans.y>0 THEN
            IF PlotterTemp2.trans.y<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(PlotterTemp2.trans.y/abs(tPlotter.tframe.trans.x));
                IF PlotterZOri>PlotA6Max THEN
                    PlotterZOri:=45;
                ENDIF
                PlotterTemp2.rot:=OrientZYX(-90+PlotterZOri,0,180);
            ELSE
                PlotterZOri:=0;
                PlotterTemp2.rot:=OrientZYX(-90,0,180);
            ENDIF
        ELSE
            RAISE ERR_PLOT_POS;
        ENDIF

        IF PlotterTemp2.trans.y+Bed1.uframe.trans.y>2800 THEN
            PlotterTemp2.extax:=[(PlotterTemp2.trans.x+Bed1.uframe.trans.x),9E+09,9E+09,9E+09,9E+09,9E+09];
        ELSE
            PlotterTemp2.extax:=[(PlotterTemp2.trans.x+Bed1.uframe.trans.x-500-Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri))),9E+09,9E+09,9E+09,9E+09,9E+09];
        ENDIF

        IF PlotterTemp2.extax.eax_a>10150 THEN
            PlotterTemp2.extax.eax_a:=10100;
        ELSEIF PlotterTemp2.extax.eax_a<0 THEN
            PlotterTemp2.extax.eax_a:=0;
        ENDIF

        MoveC PlotterTemp,PlotterTemp2,vPlotter,fine,tPlotter\WObj:=Bed1;
        MoveL Offs(PlotterTemp2,0,0,50),v100,z5,tPlotter\WObj:=Bed1;
        MoveJ Offs(PlotterTemp2,0,0,200),v500,z5,tPlotter\WObj:=Bed1;


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

            IF TestDI(Local_IO_0_DI11) THEN
                IF ((CurrentPos.trans.x+CurrentPos.extax.eax_a)<1250 AND (CurrentPos.trans.x+CurrentPos.extax.eax_a)>-400) AND (CurrentPos.trans.z<640) THEN
                    TPErase;
                    TPWrite("Jog robot out of tool station AND HOME");
                    Stop;
                ELSE
                    VSBox_Close;
                ENDIF
            ENDIF
            IF CurrentPos.trans.z<300 THEN
                TPErase;
                TPWrite("Jog robot out of tool station AND HOME");
                Stop;
            ENDIF


        CASE 2:
            !Heli
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tHeli\WObj:=wobj0);

            IF TestDI(Local_IO_0_DI11) THEN
                IF ((CurrentPos.trans.x+CurrentPos.extax.eax_a)<1850 AND (CurrentPos.trans.x+CurrentPos.extax.eax_a)>-1000) AND (CurrentPos.trans.z<640) THEN
                    TPWrite("Jog robot out of tool station AND HOME");
                    Stop;
                ELSE
                    VSBox_Close;
                ENDIF
            ENDIF
            IF CurrentPos.trans.z<200 AND (CurrentPos.trans.x+CurrentPos.extax.eax_a)<1850 THEN
                TPErase;
                TPWrite("Jog robot out of tool station AND HOME");
                Stop;
            ENDIF


            IF CurrentPos.trans.y>(Bed1.uframe.trans.y+3000) THEN
                MoveL Offs(CurrentPos,0,(3000-CurrentPos.trans.y),50),v10,z5,tHeli\WObj:=wobj0;
                MoveJ Offs(CurrentPos,0,(3000-CurrentPos.trans.y),1200-CurrentPos.trans.z),v100,z5,tHeli\WObj:=wobj0;
            ENDIF
            Heli_Dropoff;



        CASE 3:
            !VS

            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tVS\WObj:=wobj0);

            IF TestDI(Local_IO_0_DI11) THEN
                IF ((CurrentPos.trans.x+CurrentPos.extax.eax_a)<1400 AND (CurrentPos.trans.x+CurrentPos.extax.eax_a)>-400) AND (CurrentPos.trans.z<640) THEN
                    TPErase;
                    TPWrite("Jog robot out of tool station AND HOME");
                    Stop;
                ELSE
                    VSBox_Close;
                ENDIF
            ENDIF
            IF CurrentPos.trans.z<200 AND (CurrentPos.trans.x+CurrentPos.extax.eax_a)<1400 THEN
                TPErase;
                TPWrite("Jog robot out of tool station AND HOME");
                Stop;
            ENDIF

            VS_Dropoff;


        CASE 4:
            !Plotter

            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tPlotter\WObj:=wobj0);

            IF TestDI(Local_IO_0_DI11) THEN
                IF ((CurrentPos.trans.x+CurrentPos.extax.eax_a)<1300 AND (CurrentPos.trans.x+CurrentPos.extax.eax_a)>-400) AND (CurrentPos.trans.z<590) THEN
                    TPErase;
                    TPWrite("Jog robot out of tool station AND HOME");
                    Stop;
                ELSE
                    VSBox_Close;
                ENDIF
            ENDIF
            IF CurrentPos.trans.z<200 AND (CurrentPos.trans.x+CurrentPos.extax.eax_a)<1300 THEN
                TPErase;
                TPWrite("Jog robot out of bed area AND HOME");
                Stop;
            ENDIF

            IF CurrentPos.trans.y>(Bed1.uframe.trans.y+3300) THEN
                MoveL Offs(CurrentPos,0,(3300-CurrentPos.trans.y),50),v10,z5,tPlotter\WObj:=wobj0;
                MoveJ Offs(CurrentPos,0,(3300-CurrentPos.trans.y),1200-CurrentPos.trans.z),v100,z5,tPlotter\WObj:=wobj0;
            ENDIF
            Plotter_Dropoff;

        CASE 5:
            Vac_Dropoff;

        CASE 6:
            Polish_Dropoff;

        DEFAULT:
            !Unknown
            RAISE ERR_TC_SELECTION;

        ENDTEST

        !Close any tool box lids
        MoveJ pHTSHome,v500,fine,tTCMaster;
        VSBox_Close;
        !HeliBox_Close;

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
        ELSEIF HighestValue<=0 THEN
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

        IF ResetZArray=TRUE THEN
            HeliZArrayCounter:=1;
            FOR i FROM 1 TO DIM(HeliZArray,1) DO
                HeliZArray{i}:=0;
            ENDFOR
        ENDIF

        FOR i FROM 1 TO 20 DO
            FOR j FROM 1 TO 10 DO
                IF PointToPointDist(x1,y1,Bed2Zpos{j,i,1},Bed2Zpos{j,i,2})<=HeliBladeWidth/2 THEN
                    HeliZArray{HeliZArrayCounter}:=Bed2Zread{j,i};
                    Incr HeliZArrayCounter;
                ENDIF
            ENDFOR
        ENDFOR

    ENDPROC

    PROC PlotBedGrid(num Xcord1,num Ycord1,num ZOffset)
        !Used by BedGridPlotter for Z datum
        Plotterp1.trans:=[Xcord1,Ycord1,PlotterZ+44+ZOffset];
        !+46

        IF Plotterp1.trans.y>0 THEN
            IF Plotterp1.trans.y<(abs(tPlotter.tframe.trans.x)-10) THEN
                PlotterZOri:=ACos(Plotterp1.trans.y/abs(tPlotter.tframe.trans.x));
                IF PlotterZOri>PlotA6Max THEN
                    PlotterZOri:=45;
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
            Plotterp1.extax:=[(Plotterp1.trans.x+Bed1.uframe.trans.x-100-Abs(tPlotter.tframe.trans.x*Sin(PlotterZOri))),9E+09,9E+09,9E+09,9E+09,9E+09];
        ENDIF

        IF Plotterp1.extax.eax_a>10150 THEN
            Plotterp1.extax.eax_a:=10100;
        ENDIF

        IF Plotterp1.extax.eax_a<0 THEN
            Plotterp1.extax.eax_a:=0;
        ENDIF

        vPlotter:=[100,15,2000,15];

        MoveL Plotterp1,v300,zPlotter,tPlotter\WObj:=Bed1;



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
        VAR robtarget pTemp2;
        VAR num VacOverlap:=-400;
        IF ToolNum<>5 THEN
            Home;
            Vac_Pickup;
        ELSE
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tVac\WObj:=Bed1);
            IF (CurrentPos.trans.z<150) THEN
                    MoveL Offs(CurrentPos,0,0,(150-CurrentPos.trans.z)),v500,z5,tVac\WObj:=Bed1;
            ENDIF
        ENDIF

        pTemp:=pVacStart;
        pTemp2:=pVacStart;
        pTemp2.trans.x:=pVacStart.trans.x+9000;
        pTemp2.extax.eax_a:=pVacStart.extax.eax_a+9000;

        Vac_on;
        FOR i FROM 0 TO (Round(3800/(-1*VacOverlap))) DO
            IF pTemp.trans.y+i*VacOverlap > pVacStart2.trans.y THEN
            pTemp.extax.eax_a:=pVacStart.extax.eax_a-((1-((pTemp.trans.y+i*VacOverlap)-pVacStart2.trans.y)/(pVacStart.trans.y-pVacStart2.trans.y))*(pVacStart.extax.eax_a-pVacStart2.extax.eax_a));
            pTemp2.extax.eax_a:=pVacStart.extax.eax_a+9000-((1-((pTemp.trans.y+i*VacOverlap)-pVacStart2.trans.y)/(pVacStart.trans.y-pVacStart2.trans.y))*(pVacStart.extax.eax_a-pVacStart2.extax.eax_a));
            MoveJ Offs(pTemp,0,i*VacOverlap,150),v500,z5,tVac\WObj:=Bed1;
            MoveL Offs(pTemp,0,i*VacOverlap,0),v50,z5,tVac\WObj:=Bed1;
            MoveL Offs(pTemp2,0,i*VacOverlap,0),v100,z5,tVac\WObj:=Bed1;
            MoveL Offs(pTemp2,0,i*VacOverlap,150),v50,fine,tVac\WObj:=Bed1;
            ENDIF
        ENDFOR

        pTemp:=pVacStart2;
        pTemp2:=pVacStart2;
        pTemp2.trans.x:=pVacStart2.trans.x+9000;
        pTemp2.extax.eax_a:=pVacStart2.extax.eax_a+9000;
        MoveJ Offs(pTemp,0,0,150),v500,z5,tVac\WObj:=Bed1;
        MoveL Offs(pTemp,0,0,0),v50,z5,tVac\WObj:=Bed1;
        MoveL Offs(pTemp2,0,0,0),v100,z5,tVac\WObj:=Bed1;
        MoveL Offs(pTemp2,0,0,150),v50,z5,tVac\WObj:=Bed1;


        MoveJ Offs(ptVac,1000,-500,1200),v500,z5,tVac;
        Vac_off;

    ENDPROC



ENDMODULE