MODULE FCtesting
PERS loaddata TestLoad:=[122.484,[-16.6893,-1.73461,392.389],[1,0,0,0],0,0,0];   
VAR fcforcevector myForceVector;
            
    PROC FCtest()
        !CurrentJoints:=CJointT();
        !CurrentPos:=CalcRobT(CurrentJoints,tTCmaster\WObj:=wobj0);
        !MoveJ Offs(CurrentPos,0,0,25),v50,fine,tTCMaster\WObj:=wobj0;
        TestLoad:=FCLoadId(\MaxMoveAx5:=25\MaxMoveAx6:=60\PointsPerAxis:=10);
        FCCalib TestLoad;
    ENDPROC
    
    PROC ReadForces()
        myForceVector:=FCGetForce(\Tool:=tHeli);
        TPWrite "X-force: "\Num:=myForceVector.xforce;
        TPWrite "Y-force: "\Num:=myForceVector.yforce;
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
            WaitTime \inpos,1;
            ReadForces;
            Stop;
            MoveJ Offs(ptHeli,0,0,80),v50,z5,tHeli;
            WaitTime \inpos,1;
            ReadForces;
            Stop;
            MoveJ Offs(ptHeli,0,0,60),v50,z5,tHeli;
            WaitTime \inpos,1;
            ReadForces;
            Stop;
            MoveJ Offs(ptHeli,0,0,40),v50,z5,tHeli;
            WaitTime \inpos,1;
            ReadForces;
            Stop;
            MoveJ Offs(ptHeli,0,0,20),v50,z5,tHeli;
            WaitTime \inpos,1;
            ReadForces;
            Stop;
            MoveJ Offs(ptHeli,0,0,10),v50,z5,tHeli;
            WaitTime \inpos,1;
            ReadForces;
            Stop;
            MoveL ptHeli,v30,fine,tHeli;
            WaitTime \inpos,1;
            ReadForces;
            Stop;
            Heli_Stepper_Home;
            TC_release;
            MoveL Offs(pHeli,0,0,50),v50,z5,tTCMaster;
            MoveJ pHTSHome,v1500,z50,tTCMaster;
    ENDPROC
    
ENDMODULE