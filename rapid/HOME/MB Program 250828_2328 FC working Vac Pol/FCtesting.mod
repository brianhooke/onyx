MODULE FCtesting
    PERS loaddata TestLoad:=[130.053,[103.062,-36.4441,383.799],[1,0,0,0],0,0,0];
    ![122.484,[-16.6893,-1.73461,392.389],[1,0,0,0],0,0,0];
    CONST loaddata PolishLoad:=[87.0357,[37.5519,8.24935,283.334],[1,0,0,0],0,0,0];
    CONST loaddata HeliLoad70rpm:=[122.72,[317.395,-30.8887,388.598],[1,0,0,0],0,0,0];
    CONST loaddata HeliLoad100rpm:=[127.767,[21.072,5.44091,390.299],[1,0,0,0],0,0,0]; !Lowest error score
    CONST loaddata HeliLoad140rpm:=[130.053,[103.062,-36.4441,383.799],[1,0,0,0],0,0,0];
    
    VAR fcforcevector myForceVector;
    VAR num loaderr;
    VAR robtarget pPolTemp;
    VAR robtarget pPolTemp2;

    CONST robtarget pPolish10:=[[599.99,749.95,18.22],[0.00292005,0.00951812,-0.999919,-0.00792942],[0,0,0,0],[1082.85,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pPolish20:=[[600.19,749.03,23.00],[0.012269,0.999868,0.009605,0.00451214],[0,-1,-2,0],[1082.85,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pPolishSide:=[[253.57,398.37,35.08],[0.00776253,0.713874,-0.700216,-0.00473084],[0,0,-1,0],[583.746,9E+09,9E+09,9E+09,9E+09,9E+09]];


    CONST robtarget pPolStart1:=[[600,250,25],[0.00292005,0.00951812,-0.999919,-0.00792942],[0,0,0,0],[1082.85,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pPolStart2:=[[8500,250,25],[0.012269,0.999868,0.009605,0.00451214],[0,-1,-2,0],[9582.85,9E+09,9E+09,9E+09,9E+09,9E+09]];


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
        !TPWrite "X-torque: "\Num:=myForceVector.xtorque;
        !TPWrite "Y-torque: "\Num:=myForceVector.ytorque;
        !TPWrite "Z-torque: "\Num:=myForceVector.ztorque;
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
        VAR num PolishOverlap:=450;
        IF ToolNum<>6 THEN
            Home;
            Polish_Pickup;
        ENDIF
        MoveJ Offs(pHeliStart,0,0,300),v500,z5,tPolish\WObj:=Bed1;
        pPolTemp:=pPolStart1;
        pPolTemp2:=pPolStart1;
        pPolTemp2.extax.eax_a:=pPolStart1.extax.eax_a+8500;
        pPolTemp2.trans.x:=8500;
        Pol_on;
        FOR i FROM 0 TO 6 DO
            IF (i MOD 2)=0 THEN

                IF (i*PolishOverlap) < 1750 THEN
                pPolTemp.rot:=pPolStart1.rot;
                pPolTemp2.rot:=pPolStart1.rot;
                FCCalib PolishLoad;
                pPolTemp.extax.eax_a:=pPolStart1.extax.eax_a;
                MoveJ Offs(pPolTemp,0,i*PolishOverlap,100),v500,z5,tPolish\WObj:=Bed1;
                MoveL Offs(pPolTemp,0,i*PolishOverlap,25),v100,z5,tPolish\WObj:=Bed1;
                FCPress1LStart Offs(pPolTemp,20,i*PolishOverlap,-10),v5,\Fz:=300,15,\ForceChange:=100\PosSupvDist:=100,z5,tPolish\WObj:=Bed1;
                FCPressL Offs(pPolTemp,50,i*PolishOverlap,-15),v50,300,fine,tPolish\WObj:=Bed1;
                pPolTemp2.extax.eax_a:=pPolStart1.extax.eax_a+8500+300;
                FCPressL Offs(pPolTemp2,300,i*PolishOverlap,-15),v50,300,fine,tPolish\WObj:=Bed1;
                FCPressEnd Offs(pPolTemp2,300,i*PolishOverlap,30),v30,\DeactOnly,tPolish\WObj:=Bed1;
                CurrentJoints:=CJointT();
                CurrentPos:=CalcRobT(CurrentJoints,tPolish\WObj:=Bed1);
                MoveJ Reltool(CurrentPos,0,0,-100\Rz:=-90),v100,fine,tPolish\WObj:=Bed1;
                ENDIF
                
                IF ((i+1)*PolishOverlap) < 1750 THEN 
                pPolTemp.rot:=pPolStart2.rot;
                pPolTemp2.rot:=pPolStart2.rot;
                
                FCCalib PolishLoad;
                pPolTemp2.extax.eax_a:=pPolStart1.extax.eax_a+8500;
                MoveL Offs(pPolTemp2,0,(i+1)*PolishOverlap,25),v100,z5,tPolish\WObj:=Bed1;
                FCPress1LStart Offs(pPolTemp2,-20,(i+1)*PolishOverlap,-10),v5,\Fz:=300,15,\ForceChange:=100\PosSupvDist:=100,z5,tPolish\WObj:=Bed1;
                FCPressL Offs(pPolTemp2,-50,(i+1)*PolishOverlap,-15),v50,300,fine,tPolish\WObj:=Bed1;
                pPolTemp.extax.eax_a:=pPolStart1.extax.eax_a-300;
                FCPressL Offs(pPolTemp,0,(i+1)*PolishOverlap,-15),v50,300,fine,tPolish\WObj:=Bed1;
                FCPressEnd Offs(pPolTemp,0,(i+1)*PolishOverlap,30),v30,\DeactOnly,tPolish\WObj:=Bed1;
                CurrentJoints:=CJointT();
                CurrentPos:=CalcRobT(CurrentJoints,tPolish\WObj:=Bed1);
                MoveJ Reltool(CurrentPos,0,0,-100\Rz:=90),v100,fine,tPolish\WObj:=Bed1;
                ENDIF
            
            ENDIF
        ENDFOR
        
        Pol_off;
        pPolTemp:=pPolishSide;
        pPolTemp2:=pPolishSide;
        pPolTemp2.extax.eax_a:=pPolishSide.trans.x+Bed1.uframe.trans.x;
        
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tPolish\WObj:=Bed1);
        IF CurrentPos.extax.eax_a < 4500 THEN
        
        MoveJ Offs(pPolTemp,0,0,100),v500,fine,tPolish\WObj:=Bed1;
        Pol_on;
        MoveL Offs(pPolTemp,0,0,25),v100,z5,tPolish\WObj:=Bed1;
        FCCalib PolishLoad;
        FCPress1LStart Offs(pPolTemp,0,20,-10),v5,\Fz:=300,15,\ForceChange:=100\PosSupvDist:=100,z5,tPolish\WObj:=Bed1;
        FCPressL Offs(pPolTemp,0,50,-15),v50,300,fine,tPolish\WObj:=Bed1;
        FCPressL Offs(pPolTemp2,0,1700,-15),v50,300,fine,tPolish\WObj:=Bed1;
        FCPressEnd Offs(pPolTemp2,0,1750,30),v30,\DeactOnly,tPolish\WObj:=Bed1;

        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tPolish\WObj:=Bed1);
        MoveJ Reltool(CurrentPos,0,0,-100),v100,z5,tPolish\WObj:=Bed1;
        MoveJ Offs(pHeliStart,0,0,300),v500,fine,tPolish\WObj:=Bed1;

        pPolTemp:=pPolishSide;
        pPolTemp2:=pPolishSide;
        pPolTemp.extax.eax_a:=pPolishSide.extax.eax_a+8560;
        pPolTemp.trans.x:=pPolishSide.trans.x+8560;
        pPolTemp2.trans.x:=pPolishSide.trans.x+8560;
        pPolTemp2.extax.eax_a:=pPolishSide.trans.x+Bed1.uframe.trans.x+8560;
        MoveJ Offs(pPolTemp,0,0,100),v500,z5,tPolish\WObj:=Bed1;
        MoveL Offs(pPolTemp,0,0,25),v100,z5,tPolish\WObj:=Bed1;
        FCCalib PolishLoad;
        FCPress1LStart Offs(pPolTemp,0,20,-10),v5,\Fz:=300,15,\ForceChange:=100\PosSupvDist:=100,z5,tPolish\WObj:=Bed1;
        FCPressL Offs(pPolTemp,0,50,-15),v50,300,fine,tPolish\WObj:=Bed1;
        FCPressL Offs(pPolTemp2,0,1700,-15),v50,300,fine,tPolish\WObj:=Bed1;
        FCPressEnd Offs(pPolTemp2,0,1750,30),v30,\DeactOnly,tPolish\WObj:=Bed1;
        ELSE
        pPolTemp:=pPolishSide;
        pPolTemp2:=pPolishSide;
        pPolTemp.extax.eax_a:=pPolishSide.extax.eax_a+8560;
        pPolTemp.trans.x:=pPolishSide.trans.x+8560;
        pPolTemp2.trans.x:=pPolishSide.trans.x+8560;
        pPolTemp2.extax.eax_a:=pPolishSide.trans.x+Bed1.uframe.trans.x+8560;
        MoveJ Offs(pPolTemp,0,0,100),v500,z5,tPolish\WObj:=Bed1;
        Pol_on;
        MoveL Offs(pPolTemp,0,0,25),v100,z5,tPolish\WObj:=Bed1;
        FCCalib PolishLoad;
        FCPress1LStart Offs(pPolTemp,0,20,-10),v5,\Fz:=300,15,\ForceChange:=100\PosSupvDist:=100,z5,tPolish\WObj:=Bed1;
        FCPressL Offs(pPolTemp,0,50,-15),v50,300,fine,tPolish\WObj:=Bed1;
        FCPressL Offs(pPolTemp2,0,1700,-15),v50,300,fine,tPolish\WObj:=Bed1;
        FCPressEnd Offs(pPolTemp2,0,1750,30),v30,\DeactOnly,tPolish\WObj:=Bed1;
        
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tPolish\WObj:=Bed1);
        MoveJ Reltool(CurrentPos,0,0,-100),v100,z5,tPolish\WObj:=Bed1;
        MoveJ Offs(pHeliStart,0,0,300),v500,fine,tPolish\WObj:=Bed1;
        
        pPolTemp:=pPolishSide;
        pPolTemp2:=pPolishSide;
        pPolTemp2.extax.eax_a:=pPolishSide.trans.x+Bed1.uframe.trans.x;
        MoveJ Offs(pPolTemp,0,0,100),v500,fine,tPolish\WObj:=Bed1;
        
        MoveL Offs(pPolTemp,0,0,25),v100,z5,tPolish\WObj:=Bed1;
        FCCalib PolishLoad;
        FCPress1LStart Offs(pPolTemp,0,20,-10),v5,\Fz:=300,15,\ForceChange:=100\PosSupvDist:=100,z5,tPolish\WObj:=Bed1;
        FCPressL Offs(pPolTemp,0,50,-15),v50,300,fine,tPolish\WObj:=Bed1;
        FCPressL Offs(pPolTemp2,0,1700,-15),v50,300,fine,tPolish\WObj:=Bed1;
        FCPressEnd Offs(pPolTemp2,0,1750,30),v30,\DeactOnly,tPolish\WObj:=Bed1;

        ENDIF

        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tPolish\WObj:=Bed1);
        MoveJ Reltool(CurrentPos,0,0,-100),v100,fine,tPolish\WObj:=Bed1;
        Pol_off;
        MoveJ Offs(pHeliStart,0,0,300),v500,z5,tPolish\WObj:=Bed1;
        
        
        pPolTemp:=pPolStart1;
        pPolTemp.rot:=pPolStart2.rot;
        pPolTemp.trans.x:=1000;
        pPolTemp.extax.eax_a:=pPolStart1.extax.eax_a+2200;
        pPolTemp2:=pPolStart2;
        pPolTemp2.trans.x:=150;
        pPolTemp2.extax.eax_a:=pPolStart1.extax.eax_a+1350;
        
        MoveJ Offs(pPolTemp,0,0,100),v500,z5,tPolish\WObj:=Bed1;
        Pol_on;
        MoveL Offs(pPolTemp,0,0,25),v100,z5,tPolish\WObj:=Bed1;
        FCCalib PolishLoad;
        FCPress1LStart Offs(pPolTemp,20,0,-10),v5,\Fz:=300,15,\ForceChange:=100\PosSupvDist:=100,z5,tPolish\WObj:=Bed1;
        FCPressL Offs(pPolTemp,-50,0,-15),v50,300,fine,tPolish\WObj:=Bed1;
        FCPressL Offs(pPolTemp2,0,0,-15),v50,300,fine,tPolish\WObj:=Bed1;
        FCPressEnd Offs(pPolTemp2,-50,0,30),v30,\DeactOnly,tPolish\WObj:=Bed1;
        
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tPolish\WObj:=Bed1);
        MoveJ Reltool(CurrentPos,0,0,-100),v100,z5,tPolish\WObj:=Bed1;
        MoveJ Offs(pHeliStart,0,0,300),v500,fine,tPolish\WObj:=Bed1;
        
        Pol_off;
    ENDPROC
ENDMODULE