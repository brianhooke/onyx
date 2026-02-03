MODULE FCtesting
    PERS loaddata TestLoad:=[130.053,[103.062,-36.4441,383.799],[1,0,0,0],0,0,0];
    ![122.484,[-16.6893,-1.73461,392.389],[1,0,0,0],0,0,0];
    CONST loaddata PolishLoad:=[87.0357,[37.5519,8.24935,283.334],[1,0,0,0],0,0,0];
    CONST loaddata HeliLoad70rpm:=[122.72,[317.395,-30.8887,388.598],[1,0,0,0],0,0,0];
    CONST loaddata HeliLoad100rpm:=[127.767,[21.072,5.44091,390.299],[1,0,0,0],0,0,0];
    !Lowest error score
    CONST loaddata HeliLoad140rpm:=[130.053,[103.062,-36.4441,383.799],[1,0,0,0],0,0,0];

    VAR fcforcevector myForceVector;
    VAR num loaderr;
    VAR robtarget pPolTemp;
    VAR robtarget pPolTemp2;

    CONST robtarget pPolish10:=[[599.99,749.95,18.22],[0.00292005,0.00951812,-0.999919,-0.00792942],[0,0,0,0],[1082.85,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pPolish20:=[[600.19,749.03,23.00],[0.012269,0.999868,0.009605,0.00451214],[0,-1,-2,0],[1082.85,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pPolishSide:=[[-253.57,398.37,75],[0.000625449,0.713919,-0.700225,0.00227362],[1,-1,0,0],[7736,9E+09,9E+09,9E+09,9E+09,9E+09]];


    CONST robtarget pPolStart1:=[[-600,250,75],[1.04259E-05,-0.999952,-0.00961003,-0.00172456],[1,-1,-1,0],[9582.85,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pPolStart2:=[[-7000,700,75],[0.00290121,-0.00953475,0.99995,-0.000307041],[1,-1,-3,0],[1082.85,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pPolHome:=[[8100.03,2300.00,699.99],[0.00170896,-0.707216,0.706994,0.00158688],[0,0,-1,0],[7969.05,9E+09,9E+09,9E+09,9E+09,9E+09]];

    VAR num PolishOverlap:=300;

    VAR num FCBladeAngle:=0;
    VAR num FCHeliBldSpd:=0;
    VAR num FCHeliOffs:=0;
    VAR speeddata FCHeliSpd:=[100,30,2000,15];
    VAR num FCHeliFrce:=0;
    VAR num FCHeliStartX:=0;
    VAR num FCHeliStartY:=0;
    VAR num FCHeliEndX:=0;
    VAR loaddata FCHeliLD;


    PROC FCtest()
        !CurrentJoints:=CJointT();
        !CurrentPos:=CalcRobT(CurrentJoints,tTCmaster\WObj:=wobj0);
        !MoveJ Offs(CurrentPos,0,0,25),v50,fine,tTCMaster\WObj:=wobj0;
        TestLoad:=FCLoadId(\MaxMoveAx5:=25\MaxMoveAx6:=60\PointsPerAxis:=10\loadiderr:=loaderr);
        FCCalib TestLoad;
        TPWrite "Load ID error is: "\num:=loaderr;
    ENDPROC

    PROC ReadForces()
        myForceVector:=FCGetForce(\Tool:=tPolish);
        !TPWrite "X-force: "\Num:=myForceVector.xforce;
        !TPWrite "Y-force: "\Num:=myForceVector.yforce;
        TPWrite "Z-force: "\Num:=myForceVector.zforce;
        TPWrite "X-torque: "\Num:=myForceVector.xtorque;
        TPWrite "Y-torque: "\Num:=myForceVector.ytorque;
        TPWrite "Z-torque: "\Num:=myForceVector.ztorque;
    ENDPROC

    !Heli_Pickup;
    !Stop;
    !HeliDropOffFC;
    PROC HeliDropOffFC()

        FCCalib TestLoad;
        MoveJ ptHeliLid,v500,fine,tHeli;
        HeliBladeSpeed 0,"FWD";
        !HeliBox_Open;
        !Open lid
        MoveJ Offs(ptHeli,100,0,800),v500,z5,tHeli;
        MoveJ Offs(ptHeli,0,0,100),v500,z5,tHeli;
        WaitTime\inpos,1;
        ReadForces;
        Stop;
        MoveJ Offs(ptHeli,0,0,80),v50,z5,tHeli;
        WaitTime\inpos,1;
        ReadForces;
        Stop;
        MoveJ Offs(ptHeli,0,0,60),v50,z5,tHeli;
        WaitTime\inpos,1;
        ReadForces;
        Stop;
        MoveJ Offs(ptHeli,0,0,40),v50,z5,tHeli;
        WaitTime\inpos,1;
        ReadForces;
        Stop;
        MoveJ Offs(ptHeli,0,0,20),v50,z5,tHeli;
        WaitTime\inpos,1;
        ReadForces;
        Stop;
        MoveJ Offs(ptHeli,0,0,10),v50,z5,tHeli;
        WaitTime\inpos,1;
        ReadForces;
        Stop;
        MoveL ptHeli,v30,fine,tHeli;
        WaitTime\inpos,1;
        ReadForces;
        Stop;
        Heli_Stepper_Home;
        TC_release;
        MoveL Offs(pHeli,0,0,50),v50,z5,tTCMaster;
        MoveJ pHTSHome,v1500,z50,tTCMaster;
    ENDPROC

    PROC TcMasterFCTest()
        VAR fcboxvol my_supv_box:=[-10000,10000,-10000,10000,-10000,10000];
        FCSupvPos\Box:=my_supv_box;
        FCSupvForce\Zmax:=1000;

        pHeliStart.trans.x:=500;
        pHeliStart.trans.y:=1000;
        pHeliStart.trans.z:=100;

        !Heli_Pickup;
        MoveJ Offs(pHeliStart,0,0,500),v500,z5,tTCMaster\WObj:=Bed1;
        Stop;
        FCTest;
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tTcMaster\WObj:=wobj0);
        !FCSupvPos \PosSupvFrame:= [CurrentPos.trans,CurrentPos.rot] \Box:= my_supv_box;
        !FCSupvForce \ZMax:=1000;
        !FCAct tTcMaster;! \WObj:=Bed1;
        !Stop;
        !FCSpdChgAct 400;
        !Stop;
        !MoveJ Offs(CurrentPos,100,0,0),v30,z30,tTCMaster\WObj:=wobj0;
        !Stop;
        !MoveJ Offs(CurrentPos,50,50,50),v30,z30,tTCMaster\WObj:=wobj0;
        !Stop;
        !FCSpdChgDeact;
        !Stop;

        TPWrite "Robot in force mode:"\bool:=FCIsForceMode();
        MoveJ Offs(pHeliStart,0,0,400),v100,z5,tTCMaster\WObj:=Bed1;
        !Stop;
        !FCAct tTcMaster;
        !TPWrite"Robot in force mode:"\bool:=FCIsForceMode();
        Stop;
        FCPress1LStart Offs(pHeliStart,50,0,350),v30,\Fz:=200,50,\PosSupvDist:=150,z30,tTCMaster\WObj:=Bed1;
        TPWrite "Robot in force mode:"\bool:=FCIsForceMode();
        FCPressL Offs(pHeliStart,100,0,320),v30,180,z30,tTCMaster\WObj:=Bed1;
        Stop;
        FCPressL Offs(pHeliStart,140,0,320),v30,180,z30,tTCMaster\WObj:=Bed1;
        FCPressEnd Offs(pHeliStart,140,0,500),v30,tTcMaSter\WObj:=Bed1;
        Stop;
        FCDeact;

    ENDPROC

    PROC PolFCTest()
        FCSupvForce\Zmax:=1000;



        MoveJ Offs(pHeliStart,0,0,300),v500,z5,tPolish\WObj:=Bed1;

        !Pol_on;
        !FCTest;
        !TPWrite"Test";
        !ReadForces;
        !Pol_off;
        FCCalib PolishLoad;

        pPolTemp:=pPolStart1;

        MoveJ Offs(pPolTemp,0,400,100),v500,z5,tPolish\WObj:=Bed1;
        MoveL Offs(pPolTemp,0,400,25),v100,z5,tPolish\WObj:=Bed1;
        WaitTime\inpos,1;
        TPWrite "Before";
        ReadForces;
        TPWrite "TestLoad: "\num:=(TestLoad.mass*9.81);
        Pol_on;
        WaitTime\inpos,3;
        FCPress1LStart Offs(pPolTemp,20,400,-5),v5,\Fz:=300,15,\ForceChange:=100\PosSupvDist:=100,z5,tPolish\WObj:=Bed1;
        TPWrite "Start";
        ReadForces;
        FCPressL Offs(pPolTemp,50,400,-10),v30,300,fine,tPolish\WObj:=Bed1;
        TPWrite "Mid";
        ReadForces;
        pPolTemp.extax.eax_a:=pPolStart1.extax.eax_a+1000;
        FCPressL Offs(pPolTemp,1000,400,-10),v30,300,fine,tPolish\WObj:=Bed1;
        TPWrite "Mid1";
        ReadForces;
        pPolTemp.extax.eax_a:=pPolStart1.extax.eax_a+2000;
        FCPressL Offs(pPolTemp,2000,400,-10),v30,300,fine,tPolish\WObj:=Bed1;
        TPWrite "Mid2";
        ReadForces;
        pPolTemp.extax.eax_a:=pPolStart1.extax.eax_a+3000;
        FCPressL Offs(pPolTemp,3000,400,-10),v30,300,fine,tPolish\WObj:=Bed1;
        TPWrite "Mid3";
        ReadForces;
        pPolTemp.extax.eax_a:=pPolStart1.extax.eax_a+4000;
        FCPressL Offs(pPolTemp,4000,400,-10),v30,300,fine,tPolish\WObj:=Bed1;
        TPWrite "Mid4";
        ReadForces;
        FCPressEnd Offs(pPolTemp,4000,400,25),v30,\DeactOnly,tPolish\WObj:=Bed1;
        TPWrite "Robot in force mode:"\bool:=FCIsForceMode();
        MoveJ Offs(pPolTemp,4050,400,100),v200,z5,tPolish\WObj:=Bed1;
        TPWrite "End";
        ReadForces;

        Pol_off;
        MoveJ Offs(pPolStart1,0,400,500),v500,z5,tPolish\WObj:=Bed1;

        Stop;
    ENDPROC

    PROC Polish()
        ! Confirm tool state before proceeding
        TPWrite "Polish: ToolNum=" \Num:=ToolNum;
        IF ToolNum<>6 THEN
            TPWrite "No polisher! Set ToolNum=6 or Play to pickup";
            Stop;
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

        FOR i FROM 0 TO 6 DO
            IF (i MOD 2)=0 THEN

                IF (i*PolishOverlap)<1750 THEN
                    pPolTemp.rot:=pPolStart1.rot;
                    pPolTemp2.rot:=pPolStart1.rot;
                    WaitTime\inpos,0.1;
                    FCCalib PolishLoad;
                    pPolTemp.extax.eax_a:=pPolStart1.extax.eax_a;
                    MoveJ Offs(pPolTemp,0,i*PolishOverlap,100),v500,z5,tPolish\WObj:=Bed1Wyong;
                    Pol_on;
                    MoveL Offs(pPolTemp,0,i*PolishOverlap,80),v100,fine,tPolish\WObj:=Bed1Wyong;
                    WaitTime\inpos,0.1;
                    FCPress1LStart Offs(pPolTemp,-25,i*PolishOverlap,50),v20,\Fz:=140,15,\ForceChange:=75\PosSupvDist:=100,z5,tPolish\WObj:=Bed1Wyong;
                    pPolTemp2.extax.eax_a:=pPolStart2.extax.eax_a-300;
                    FCPressL Offs(pPolTemp2,-300,i*PolishOverlap,-40),v80,130,fine,tPolish\WObj:=Bed1Wyong;
                    FCPressEnd Offs(pPolTemp2,-300,i*PolishOverlap,75),v50,\DeactOnly,tPolish\WObj:=Bed1Wyong;
                    CurrentJoints:=CJointT();
                    CurrentPos:=CalcRobT(CurrentJoints,tPolish\WObj:=Bed1Wyong);
                    MoveJ Offs(Reltool(CurrentPos,0,0,-100\Rz:=-90),0,450,0),v100,fine,tPolish\WObj:=Bed1Wyong;
                    Pol_off;
                ENDIF

                IF ((i+1)*PolishOverlap)<1750 THEN
                    pPolTemp.rot:=pPolStart2.rot;
                    pPolTemp2.rot:=pPolStart2.rot;
                    WaitTime\inpos,0.1;
                    FCCalib PolishLoad;
                    pPolTemp2.extax.eax_a:=pPolStart1.extax.eax_a-8500;
                    WaitTime\inpos,0.1;
                    Pol_on;
                    ConfL\Off;
                    MoveL Offs(pPolTemp2,0,(i+1)*PolishOverlap,70),v100,fine,tPolish\WObj:=Bed1Wyong;
                    WaitTime\inpos,0.1;
                    FCPress1LStart Offs(pPolTemp2,25,(i+1)*PolishOverlap,45),v20,\Fz:=140,15,\ForceChange:=75\PosSupvDist:=100,z5,tPolish\WObj:=Bed1Wyong;
                    FCPressL Offs(pPolTemp2,300,(i+1)*PolishOverlap,-40),v100,130,fine,tPolish\WObj:=Bed1Wyong;
                    pPolTemp.extax.eax_a:=pPolStart1.extax.eax_a-600;
                    FCPressL Offs(pPolTemp,0,(i+1)*PolishOverlap,-25),v100,130,fine,tPolish\WObj:=Bed1Wyong;
                    FCPressEnd Offs(pPolTemp,0,(i+1)*PolishOverlap,75),v50,\DeactOnly,tPolish\WObj:=Bed1Wyong;
                    CurrentJoints:=CJointT();
                    CurrentPos:=CalcRobT(CurrentJoints,tPolish\WObj:=Bed1Wyong);
                    MoveJ Reltool(CurrentPos,0,0,-100\Rz:=90),v100,fine,tPolish\WObj:=Bed1Wyong;
                    Pol_off;
                    ConfL\On;
                ENDIF

            ENDIF
        ENDFOR

        Pol_off;

        pPolTemp:=pPolishSide;
        pPolTemp.extax.eax_a:=pPolishSide.trans.x+Bed1Wyong.uframe.trans.x;
        pPolTemp2:=pPolishSide;
        pPolTemp2.extax.eax_a:=pPolishSide.trans.x+Bed1Wyong.uframe.trans.x;

        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tPolish\WObj:=Bed1Wyong);
        IF CurrentPos.extax.eax_a>4000 THEN

            MoveJ Offs(pPolTemp,0,0,100),v500,fine,tPolish\WObj:=Bed1Wyong;
            WaitTime\inpos,0.1;
            FCCalib PolishLoad;
            MoveL Offs(pPolTemp,0,0,40),v100,z5,tPolish\WObj:=Bed1Wyong;
            WaitTime\inpos,0.1;
            Pol_on;
            FCPress1LStart Offs(pPolTemp,0,50,-10),v10,\Fz:=140,15,\ForceChange:=75\PosSupvDist:=100,z5,tPolish\WObj:=Bed1Wyong;
            FCPressL Offs(pPolTemp2,0,1700,-25),v100,130,fine,tPolish\WObj:=Bed1Wyong;
            FCPressEnd Offs(pPolTemp2,0,1750,30),v50,\DeactOnly,tPolish\WObj:=Bed1Wyong;

            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tPolish\WObj:=Bed1Wyong);
            MoveJ Reltool(CurrentPos,0,0,-100),v100,z5,tPolish\WObj:=Bed1Wyong;
            Pol_off;
            MoveJ Offs(pHeliStart,0,0,300),v500,fine,tPolish\WObj:=Bed1Wyong;

            pPolTemp:=pPolishSide;
            pPolTemp2:=pPolishSide;
            pPolTemp.extax.eax_a:=pPolishSide.extax.eax_a-6500;
            pPolTemp.trans.x:=pPolishSide.trans.x-6500;
            pPolTemp2.trans.x:=pPolishSide.trans.x-6500;
            pPolTemp2.extax.eax_a:=pPolishSide.trans.x+Bed1Wyong.uframe.trans.x-6500;
            MoveJ Offs(pPolTemp,0,0,100),v500,z5,tPolish\WObj:=Bed1Wyong;
            WaitTime\inpos,0.1;
            FCCalib PolishLoad;
            MoveL Offs(pPolTemp,0,0,25),v100,z5,tPolish\WObj:=Bed1Wyong;
            WaitTime\inpos,0.1;
            Pol_on;
            FCPress1LStart Offs(pPolTemp,0,50,-40),v5,\Fz:=140,15,\ForceChange:=75\PosSupvDist:=100,z5,tPolish\WObj:=Bed1Wyong;
            FCPressL Offs(pPolTemp2,0,1700,-50),v100,130,fine,tPolish\WObj:=Bed1Wyong;
            FCPressEnd Offs(pPolTemp2,0,1750,30),v30,\DeactOnly,tPolish\WObj:=Bed1wyong;
        ELSE
            pPolTemp:=pPolishSide;
            pPolTemp2:=pPolishSide;
            pPolTemp.extax.eax_a:=pPolishSide.extax.eax_a-6500;
            pPolTemp.trans.x:=pPolishSide.trans.x-6500;
            pPolTemp2.trans.x:=pPolishSide.trans.x-6500;
            pPolTemp2.extax.eax_a:=pPolishSide.trans.x+Bed1Wyong.uframe.trans.x-6500;
            MoveJ Offs(pPolTemp,0,0,100),v500,z5,tPolish\WObj:=Bed1Wyong;
            FCCalib PolishLoad;
            WaitTime\inpos,0.1;
            MoveL Offs(pPolTemp,0,0,40),v100,z5,tPolish\WObj:=Bed1Wyong;
            WaitTime\inpos,0.1;
            Pol_on;
            FCPress1LStart Offs(pPolTemp,0,50,-40),v10,\Fz:=140,15,\ForceChange:=75\PosSupvDist:=100,z5,tPolish\WObj:=Bed1Wyong;
            FCPressL Offs(pPolTemp2,0,1700,-50),v100,130,fine,tPolish\WObj:=Bed1Wyong;
            FCPressEnd Offs(pPolTemp2,0,1750,30),v50,\DeactOnly,tPolish\WObj:=Bed1Wyong;

            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tPolish\WObj:=Bed1Wyong);
            MoveJ Reltool(CurrentPos,0,0,-100),v100,z5,tPolish\WObj:=Bed1Wyong;
            Pol_off;
            MoveJ Offs(pHeliStart,0,0,300),v500,fine,tPolish\WObj:=Bed1Wyong;

            pPolTemp:=pPolishSide;
            pPolTemp2:=pPolishSide;
            pPolTemp2.extax.eax_a:=pPolishSide.trans.x+Bed1Wyong.uframe.trans.x;
            MoveJ Offs(pPolTemp,0,0,100),v500,fine,tPolish\WObj:=Bed1Wyong;
            WaitTime\inpos,0.1;
            FCCalib PolishLoad;
            MoveL Offs(pPolTemp,0,0,25),v100,z5,tPolish\WObj:=Bed1Wyong;
            WaitTime\inpos,0.1;
            Pol_on;
            FCPress1LStart Offs(pPolTemp,0,50,-10),v10,\Fz:=140,15,\ForceChange:=75\PosSupvDist:=100,z5,tPolish\WObj:=Bed1Wyong;
            FCPressL Offs(pPolTemp2,0,1700,-25),v100,130,fine,tPolish\WObj:=Bed1Wyong;
            FCPressEnd Offs(pPolTemp2,0,1750,30),v30,\DeactOnly,tPolish\WObj:=Bed1Wyong;

        ENDIF

        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tPolish\WObj:=Bed1Wyong);
        MoveJ Reltool(CurrentPos,0,0,-100),v100,fine,tPolish\WObj:=Bed1Wyong;
        Pol_off;
        MoveJ ptPolishHome,v1000,z5,tPolish\WObj:=wobj0;

    ENDPROC

    PROC HeliFC(num HeliStartX,num HeliStartY,num HeliEndX,speeddata HeliTrvSpd,num HeliBldSpeed,num HeliAngle,num HeliForce,loaddata HeliLD)

        IF ToolNum<>2 THEN
            Home;
            Heli_Pickup;
        ENDIF

        pHeliStart.trans:=[-1*(HeliStartX-HeliBladeWidth/2+100),(HeliStartY+HeliBladeWidth/2),(FormHeight+14)];
        pHeliEnd.trans:=[-1*(HeliEndX+HeliBladeWidth/2-100),(HeliStartY+HeliBladeWidth/2),(FormHeight+14)];

        IF pHeliStart.trans.y<1800 THEN
            pHeliStart.extax.eax_a:=Bed1Wyong.uframe.trans.x+pHeliStart.trans.x+1000+HeliBladeWidth/2;
            pHeliEnd.extax.eax_a:=Bed1Wyong.uframe.trans.x+pHeliEnd.trans.x+1000-HeliBladeWidth/2;
        ELSE
            pHeliStart.extax.eax_a:=Bed1Wyong.uframe.trans.x+pHeliStart.trans.x+HeliBladeWidth/2;
            pHeliEnd.extax.eax_a:=Bed1Wyong.uframe.trans.x+pHeliEnd.trans.x-HeliBladeWidth/2;
        ENDIF

        pHeliTempS:=pHeliStart;
        pHeliTempE:=pHeliEnd;

        MoveJ Offs(pHeliTempS,0,0,200),v500,z5,tHeli\WObj:=Bed1Wyong;
        TPWrite "Setting blade angle.";
        HeliBlade_Angle HeliAngle;
        FCCalib HeliLD;
        MoveJ Offs(pHeliTempS,0,0,100),v100,z5,tHeli\WObj:=Bed1Wyong;
        WaitTime\inpos,0.5;
        TPErase;
        TPWrite "Robot should be 100mm off concrete and above concrete.";
        TPWrite "Only press play if this is the case!!!";
        TPWrite "Otherwise PP to main and call Andrew.";
        Stop;
        HeliBladeSpeed HeliBldSpeed,"FWD";
        WaitTime\inpos,4;
        MoveJ Offs(pHeliTempS,0,0,50),v50,z5,tHeli\WObj:=Bed1Wyong;
        !myForceVector:=FCGetForce(\Tool:=tHeli);
        FCPress1LStart Offs(pHeliTempS,-25,0,-5),v10,\Fz:=HeliForce,15,\ForceChange:=100\PosSupvDist:=125,z5,tHeli\WObj:=Bed1Wyong;
        FCPressL Offs(pHeliTempE,0,0,-25),HeliTrvSpd,HeliForce,fine,tHeli\WObj:=Bed1Wyong;
        FCPressEnd Offs(pHeliTempE,50,0,50),v50,\DeactOnly,tHeli\WObj:=Bed1Wyong;
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tHeli\WObj:=Bed1Wyong);
        MoveJ Offs(CurrentPos,0,0,150),v100,fine,tHeli\WObj:=Bed1Wyong;
        HeliBladeSpeed 0,"FWD";
        WaitTime\InPos,2;
        MoveJ Offs(ptHeli,0,0,600),v500,fine,tHeli;

    ENDPROC

    PROC HeliFCDummy(num HeliStartX,num HeliStartY,num HeliEndX,speeddata HeliTrvSpd)
        VAR num DummyZ:=200;
        !Vertical height offset
        IF ToolNum<>2 THEN
            Home;
            Heli_Pickup;
        ENDIF

        pHeliStart.trans:=[-1*(HeliStartX-HeliBladeWidth/2+100),(HeliStartY+HeliBladeWidth/2),(FormHeight+14+DummyZ)];
        pHeliEnd.trans:=[-1*(HeliEndX+HeliBladeWidth/2-100),(HeliStartY+HeliBladeWidth/2),(FormHeight+14+DummyZ)];

        IF pHeliStart.trans.y<1800 THEN
            pHeliStart.extax.eax_a:=Bed1Wyong.uframe.trans.x+pHeliStart.trans.x+1000+HeliBladeWidth/2;
            pHeliEnd.extax.eax_a:=Bed1Wyong.uframe.trans.x+pHeliEnd.trans.x+1000-HeliBladeWidth/2;
        ELSE
            pHeliStart.extax.eax_a:=Bed1Wyong.uframe.trans.x+pHeliStart.trans.x+HeliBladeWidth/2;
            pHeliEnd.extax.eax_a:=Bed1Wyong.uframe.trans.x+pHeliEnd.trans.x-HeliBladeWidth/2;
        ENDIF

        pHeliTempS:=pHeliStart;
        pHeliTempE:=pHeliEnd;

        MoveJ Offs(pHeliTempS,0,0,200),v500,z5,tHeli\WObj:=Bed1Wyong;
        MoveJ Offs(pHeliTempS,0,0,100),v100,z5,tHeli\WObj:=Bed1Wyong;
        WaitTime\inpos,1;
        MoveJ Offs(pHeliTempS,0,0,50),v50,z5,tHeli\WObj:=Bed1Wyong;
        MoveL Offs(pHeliTempS,-25,0,-5),v10,z5,tHeli\WObj:=Bed1Wyong;
        MoveL Offs(pHeliTempE,0,0,-25),HeliTrvSpd,fine,tHeli\WObj:=Bed1Wyong;
        MoveL Offs(pHeliTempE,50,0,50),v50,fine,tHeli\WObj:=Bed1Wyong;
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tHeli\WObj:=Bed1Wyong);
        MoveJ Offs(CurrentPos,0,0,150),v100,fine,tHeli\WObj:=Bed1Wyong;
        HeliBladeSpeed 0,"FWD";
        WaitTime\InPos,1;
        MoveJ Offs(ptHeli,0,0,500),v500,fine,tHeli;

    ENDPROC


    PROC PolishTest()
        ! PolishTest - runs polisher path at Z=75+z_offset with motor
        ! Y offset -150mm (closer to track) to dodge precast panel
        ! Uses LIFT-TRAVEL-LOWER pattern to avoid axis 3 limits
        ! Generated by rapid_generator.py
        VAR robtarget pPolTestTemp;
        VAR robtarget pPolTestTemp2;
        VAR num PolTestZ:=75;
        VAR num YPanelDodge:=-150;
        VAR num SafeZ:=500;
        
        ! Confirm tool state before proceeding
        TPWrite "PolishTest: ToolNum=" \Num:=ToolNum;
        IF ToolNum<>6 THEN
            TPWrite "No polisher! Set ToolNum=6 or Play to pickup";
            Stop;
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
        
        ! Disable configuration monitoring for joint flexibility
        ConfL\Off;
        ConfJ\Off;
        
        ! Setup start positions - near and far track ends
        pPolTestTemp:=pPolStart1;
        pPolTestTemp.trans.z:=PolTestZ;
        pPolTestTemp2:=pPolStart1;
        pPolTestTemp2.trans.z:=PolTestZ;
        pPolTestTemp2.extax.eax_a:=pPolStart2.extax.eax_a;
        pPolTestTemp2.trans.x:=pPolStart2.trans.x;
        
        TPWrite "PolishTest: Running at Z=" \Num:=PolTestZ;
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
                    MoveJ Offs(pPolTestTemp,0,0,SafeZ-PolTestZ),v500,z5,tPolish\WObj:=Bed1Wyong;
                    MoveL pPolTestTemp,v100,fine,tPolish\WObj:=Bed1Wyong;
                    
                    Pol_on;
                    WaitTime 0.3;
                    
                    ! Lift, travel to far end, lower
                    MoveL Offs(pPolTestTemp,0,0,SafeZ-PolTestZ),v500,z5,tPolish\WObj:=Bed1Wyong;
                    MoveJ Offs(pPolTestTemp2,0,0,SafeZ-PolTestZ),v500,z5,tPolish\WObj:=Bed1Wyong;
                    MoveL pPolTestTemp2,v100,fine,tPolish\WObj:=Bed1Wyong;
                    
                    WaitTime 0.3;
                    Pol_off;
                    
                ELSE
                    ! Odd pass: far -> near (back up the track)
                    ! Start at far position  
                    pPolTestTemp.trans.y:=pPolStart1.trans.y+i*PolishOverlap+YPanelDodge;
                    pPolTestTemp2.trans.y:=pPolStart1.trans.y+i*PolishOverlap+YPanelDodge;
                    
                    ! Approach at safe height, lower to work
                    MoveJ Offs(pPolTestTemp2,0,0,SafeZ-PolTestZ),v500,z5,tPolish\WObj:=Bed1Wyong;
                    MoveL pPolTestTemp2,v100,fine,tPolish\WObj:=Bed1Wyong;
                    
                    Pol_on;
                    WaitTime 0.3;
                    
                    ! Lift, travel to near end, lower
                    MoveL Offs(pPolTestTemp2,0,0,SafeZ-PolTestZ),v500,z5,tPolish\WObj:=Bed1Wyong;
                    MoveJ Offs(pPolTestTemp,0,0,SafeZ-PolTestZ),v500,z5,tPolish\WObj:=Bed1Wyong;
                    MoveL pPolTestTemp,v100,fine,tPolish\WObj:=Bed1Wyong;
                    
                    WaitTime 0.3;
                    Pol_off;
                ENDIF
            ENDIF
        ENDFOR
        
        ! Lift before returning home
        MoveJ Offs(pPolTestTemp,0,0,SafeZ-PolTestZ),v500,z5,tPolish\WObj:=Bed1Wyong;
        
        ! Restore configuration monitoring
        ConfL\On;
        ConfJ\On;
        
        MoveJ pPolHome,v500,z5,tPolish;
        Polish_Dropoff;
        Home;
        
        TPWrite "PolishTest Complete";
    ERROR
        RAISE;
    ENDPROC


    PROC PolishTest()
        ! PolishTest - runs polisher path at Z=75+z_offset with motor
        ! Generated by Onyx Toolpath Generator
        VAR robtarget pPolTestTemp;
        VAR robtarget pPolTestTemp2;
        VAR num PolTestZ:=75;
        VAR num YPanelDodge:=-150;
        VAR num SafeZ:=500;
        
        TPWrite "PolishTest: ToolNum=" \Num:=ToolNum;
        IF ToolNum<>6 THEN
            TPWrite "No polisher! Set ToolNum=6 or Play to pickup";
            Stop;
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
        
        ConfL\Off;
        ConfJ\Off;
        
        pPolTestTemp:=pPolStart1;
        pPolTestTemp.trans.z:=PolTestZ;
        pPolTestTemp2:=pPolStart1;
        pPolTestTemp2.trans.z:=PolTestZ;
        pPolTestTemp2.extax.eax_a:=pPolStart2.extax.eax_a;
        pPolTestTemp2.trans.x:=pPolStart2.trans.x;
        
        TPWrite "PolishTest: Running at Z=" \Num:=PolTestZ;
        TPWrite "Press Play to start test path";
        Stop;
        
        FOR i FROM 0 TO 3 DO
            IF (i*PolishOverlap)<1750 THEN
                IF (i MOD 2)=0 THEN
                    pPolTestTemp.trans.y:=pPolStart1.trans.y+i*PolishOverlap+YPanelDodge;
                    pPolTestTemp2.trans.y:=pPolStart1.trans.y+i*PolishOverlap+YPanelDodge;
                    
                    MoveJ Offs(pPolTestTemp,0,0,SafeZ-PolTestZ),v500,z5,tPolish\WObj:=Bed1Wyong;
                    MoveL pPolTestTemp,v100,fine,tPolish\WObj:=Bed1Wyong;
                    
                    Pol_on;
                    WaitTime 0.3;
                    
                    MoveL Offs(pPolTestTemp,0,0,SafeZ-PolTestZ),v500,z5,tPolish\WObj:=Bed1Wyong;
                    MoveJ Offs(pPolTestTemp2,0,0,SafeZ-PolTestZ),v500,z5,tPolish\WObj:=Bed1Wyong;
                    MoveL pPolTestTemp2,v100,fine,tPolish\WObj:=Bed1Wyong;
                    
                    WaitTime 0.3;
                    Pol_off;
                ELSE
                    pPolTestTemp.trans.y:=pPolStart1.trans.y+i*PolishOverlap+YPanelDodge;
                    pPolTestTemp2.trans.y:=pPolStart1.trans.y+i*PolishOverlap+YPanelDodge;
                    
                    MoveJ Offs(pPolTestTemp2,0,0,SafeZ-PolTestZ),v500,z5,tPolish\WObj:=Bed1Wyong;
                    MoveL pPolTestTemp2,v100,fine,tPolish\WObj:=Bed1Wyong;
                    
                    Pol_on;
                    WaitTime 0.3;
                    
                    MoveL Offs(pPolTestTemp2,0,0,SafeZ-PolTestZ),v500,z5,tPolish\WObj:=Bed1Wyong;
                    MoveJ Offs(pPolTestTemp,0,0,SafeZ-PolTestZ),v500,z5,tPolish\WObj:=Bed1Wyong;
                    MoveL pPolTestTemp,v100,fine,tPolish\WObj:=Bed1Wyong;
                    
                    WaitTime 0.3;
                    Pol_off;
                ENDIF
            ENDIF
        ENDFOR
        
        MoveJ Offs(pPolTestTemp,0,0,SafeZ-PolTestZ),v500,z5,tPolish\WObj:=Bed1Wyong;
        
        ConfL\On;
        ConfJ\On;
        
        MoveJ pPolHome,v500,z5,tPolish;
        Polish_Dropoff;
        Home;
        
        TPWrite "PolishTest Complete";
    ERROR
        RAISE;
    ENDPROC

ENDMODULE