MODULE Tools
    PERS tooldata tTCMaster:=[TRUE,[[0,0,207.5],[1,0,0,0]],[41.2,[-41.5,-0.1,44.7],[1,0,0,0],2.01,2.47,1.702]];
    !tool 1
    !PERS tooldata tHeli:=[TRUE,[[-1091.64,-2.18304,690.122],[1,0,0,0]],[143,[-188.6,-2.3,347.7],[1,0,0,0],15.384,75.35,71.092]];
    PERS tooldata tHeli:=[TRUE,[[-1091.64,-2.18304,690.122],[0.999984769,-0.005235956,-0.001745304,-0.000009138]],[143,[-188.6,-2.3,347.7],[1,0,0,0],15.384,75.35,71.092]];
    !tool 2
    !PERS tooldata tVS:=[TRUE,[[-160.393,-0.542707,442.126],[0.0115258,-0.00542575,0.705151,0.708943]],[63.3,[-68.9,-1.3,146],[1,0,0,0],21.289,6.038,20.201]];
    PERS tooldata tVS:=[TRUE,[[-160.393,-0.542707,442.126],[0.999896,0.0028071,-0.004385,-0.0134527]],[63.3,[-68.9,-1.3,146],[1,0,0,0],21.289,6.038,20.201]];
    !tool 3
    PERS tooldata tPlotter:=[TRUE,[[-1713.88,3.06465,517.985],[1,0,0,0]],[51.3,[-156.1,-2.6,95.3],[1,0,0,0],2.987,13.114,10.95]];
    !tool 4
    
    PERS num ToolNum:=1;
    VAR bool TCtimeout:=FALSE;
    VAR bool TStimeout:=FALSE;
    CONST num StepsPerRevolution:=32;
    PERS num StepperPos:=0;
    CONST num RevstoAngle:=0.81;
    CONST num RPMtoAVoltage:=13.26;
    VAR num StepPulseLength:=0.05;
    CONST robtarget ptVS:=[[102.47,2824.22,-315.50],[0.00538578,0.999881,0.0144017,-0.00114345],[0,-1,-2,0],[0.415062,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget ptVSLid:=[[-1258.81,1496.40,1264.32],[0.00538869,0.999881,0.014392,-0.00114313],[1,0,-1,0],[-300,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget ptPlotter:=[[549.37,2999.41,-403.17],[0.00331195,0.665709,-0.746202,0.00139987],[0,0,-1,0],[-230.005,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget ptPlotterHome:=[[-28.06,3222.40,1164.30],[0.0023643,0.676174,-0.736738,0.000527345],[0,0,0,0],[-230.006,9E+09,9E+09,9E+09,9E+09,9E+09]];
    TASK PERS tooldata tool1:=[TRUE,[[-1646.57,-19.6846,521.171],[1,0,0,0]],[28,[0,0,0],[1,0,0,0],0,0,0]];
    TASK PERS wobjdata wobj1:=[FALSE,TRUE,"",[[1190.38,930.569,185.66],[1,0.000655845,-0.000507562,-0.00020191]],[[0,0,0],[1,0,0,0]]];
    VAR robtarget p10maps:=[[350,150,275],[0.00321343,0.67631,-0.736609,0.000689698],[0,0,-1,0],[850,9E+09,9E+09,9E+09,9E+09,9E+09]];
    
    
    
    !CONST robtarget ptPlotter2:=[[2455.32,660.70,20.70],[0.00237199,0.67253,-0.740066,0.000521901],[0,-1,-1,0],[2038.29,9E+09,9E+09,9E+09,9E+09,9E+09]];
    !CONST robtarget ptPlotter3:=[[2025.17,1239.67,114.17],[4.7808E-05,-0.101386,0.994847,-0.000400051],[1,-1,0,0],[2467.74,9E+09,9E+09,9E+09,9E+09,9E+09]];
    !CONST robtarget ptPlotter4:=[[2025.19,1239.69,114.15],[0.000337803,0.93262,-0.36086,0.000225436],[0,-1,-2,0],[2467.74,9E+09,9E+09,9E+09,9E+09,9E+09]];
    
    
    PROC TC_release()
        StopMove;

        SetDO Local_IO_0_DO1,0;
        SetDO Local_IO_0_DO2,0;
        SetDO Local_IO_0_DO3,0;
        SetDO Local_IO_0_DO4,0;
        SetDO Local_IO_0_DO5,0;
        SetDO Local_IO_0_DO6,0;
        SetDO Local_IO_0_DO7,0;
        SetDO Local_IO_0_DO8,0;

        SETDO Local_IO_0_DO14,0;
        SETDO Local_IO_0_DO13,1;
        WaitDI Local_IO_0_DI13,1\Maxtime:=3;
        SetDO Local_IO_0_DO13,0;

        Toolnum:=1;
        StartMove;
        
        ERROR 
            RAISE;
    ENDPROC

    PROC TC_grip(num ToolNo)
        StopMove;
        !Turn off any electrical connections
        SetDO Local_IO_0_DO1,0;
        SetDO Local_IO_0_DO2,0;
        SetDO Local_IO_0_DO3,0;
        SetDO Local_IO_0_DO4,0;
        SetDO Local_IO_0_DO5,0;
        SetDO Local_IO_0_DO6,0;
        SetDO Local_IO_0_DO7,0;
        SetDO Local_IO_0_DO8,0;


        !Turn off open solenoid
        !Actuate and check for DI signal
        SETDO Local_IO_0_DO13,0;
        IF TestDI(Local_IO_0_DI13) THEN
            SETDO Local_IO_0_DO14,1;
            WaitDI Local_IO_0_DI14,1\Maxtime:=3;
            SetDO Local_IO_0_DO14,0;

            !Set current tool to specified
            IF ToolNo=2 THEN
                ToolNum:=2;
            ELSEIF ToolNo=3 THEN
                ToolNum:=3;
            ELSEIF ToolNo=4 THEN
                ToolNum:=4;
            ELSE
                RAISE ERR_TC_SELECTION;
                
            ENDIF
        ELSE
            RAISE ERR_TC_SELECTION;
        ENDIF

        StartMove;
        
        ERROR
        RAISE;
        
    ENDPROC


    PROC Heli_Stepper_Home()
        IF ToolNum=2 AND testDI (Local_IO_0_DI14) THEN
            IF TestDI(Local_IO_0_DI2) THEN
                SETDO Local_IO_0_DO7,0;
                Heli_Step 50;
            ENDIF

            WHILE TestDI(Local_IO_0_DI2)=FALSE DO
                SETDO Local_IO_0_DO7,1;
                Heli_Step 1;
            ENDWHILE
            StepperPos:=0;
        ELSE
            RAISE ERR_HELI_DISCONNECT;
        ENDIF
        
        ERROR
        RAISE;
        
    ENDPROC

    PROC Heli_Step(num PULSES)
        IF (TestDI(Local_IO_0_DI2) AND DOutput(Local_IO_0_DO7)=0) OR TestDI(Local_IO_0_DI2)=FALSE THEN
            FOR i FROM 1 TO PULSES DO
                PulseDO\PLength:=StepPulseLength,Local_IO_0_DO8;
                IF DOutput(Local_IO_0_DO7)=1 THEN
                    Decr StepperPos;
                ELSE
                    Incr StepperPos;
                ENDIF
                WaitTime(StepPulseLength*2);
            ENDFOR
        ENDIF
    ENDPROC

    PROC HeliBlade_Angle(num angle)
        VAR num pulses:=0;
        IF ToolNum=2 AND testDI (Local_IO_0_DI14) THEN
            IF angle<0 OR angle>12 THEN
                RAISE ERR_HELI_BLADE_ANGLE;
            ELSE
                IF StepperPos*StepsPerRevolution*RevstoAngle>angle THEN
                    SETDO Local_IO_0_DO7,1;
                ELSE
                    SETDO Local_IO_0_DO7,0;
                ENDIF
                pulses:=Abs(StepperPos-(angle*StepsPerRevolution*RevstoAngle));
                IF angle=0 THEN
                    WHILE TestDI(Local_IO_0_DI2)=FALSE DO
                        Heli_Step 1;
                    ENDWHILE
                ELSE
                    Heli_Step pulses;
                ENDIF

            ENDIF
            PitchZOffset:= 75*Sin(angle);
        ELSE
            RAISE ERR_HELI_DISCONNECT;
        ENDIF
        
        ERROR
        RAISE;

    ENDPROC


    PROC VS_on()
        IF Toolnum=3 AND testDI (Local_IO_0_DI14) THEN
            SetDO Local_IO_0_DO5,1;
        ELSE
            RAISE ERR_VS_DISCONNECT;
        ENDIF
        
        ERROR
        RAISE;
        
    ENDPROC

    PROC VS_off()
        SetDO Local_IO_0_DO5,0;
    ENDPROC

    PROC HeliBladeSpeed(num RPM,string DIRECTION)
        !RPM range from 0 to 140, DIRECTION is either "FWD" or "REV"

        VAR num Avoltage:=0;
        IF ToolNum=2 AND testDI (Local_IO_0_DI14) THEN
            Avoltage:=RPM/RPMtoAVoltage;
            IF (Avoltage>0) AND (Avoltage<1) THEN
                Avoltage:=1;
            ELSEIF Avoltage>10 THEN
                Avoltage:=10;
            ELSEIF Avoltage=0 THEN
                SetDO Local_IO_0_DO1,0;
                SetDO Local_IO_0_DO2,0;
                SetDO Local_IO_0_DO3,0;
                SetDO Local_IO_0_DO4,0;
                SetAO Local_IO_1_AO1,0.00;
            ELSEIF Avoltage<0 OR Avoltage>10 THEN
                RAISE ERR_HELI_BLADE_SPEED;
            ENDIF

            IF Avoltage>0 AND Avoltage<=10 THEN
                IF DIRECTION="FWD" THEN
                    SetDO Local_IO_0_DO3,0;
                    SetDO Local_IO_0_DO2,1;
                ELSEIF DIRECTION="REV" THEN
                    SetDO Local_IO_0_DO2,0;
                    SetDO Local_IO_0_DO3,1;
                ELSE
                    RAISE ERR_HELI_BLADE_DIRECTION;
                    
                ENDIF
                SetDO Local_IO_0_DO4,1;
                SetDO Local_IO_0_DO1,1;
                WaitTime 0.1;
                SETAO Local_IO_1_AO1,Avoltage;
            ENDIF
        ELSEIF RPM = 0 THEN
            SetDO Local_IO_0_DO1,0;
            SetDO Local_IO_0_DO2,0;
            SetDO Local_IO_0_DO3,0;
            SetDO Local_IO_0_DO4,0;
            SetAO Local_IO_1_AO1,0.00;
        ELSE
            SetDO Local_IO_0_DO1,0;
            SetDO Local_IO_0_DO2,0;
            SetDO Local_IO_0_DO3,0;
            SetDO Local_IO_0_DO4,0;
            SetAO Local_IO_1_AO1,0.00;
            RAISE ERR_HELI_DISCONNECT;

        ENDIF
        
        ERROR
        RAISE;
        
    ENDPROC


    PROC Heli_Pickup()
        !Check lids are closed
        !Check robot position
        !check not currently holding a tool
        !Got to Home position
        !Open lid
        !Move robot to pickup tool
        !Pickup
        !move out of lid way
        !close lid

        IF ToolNum=1 THEN

            IF TestDI (Local_IO_0_DI11) = FALSE THEN
                !VS lid open
                CurrentJoints:=CJointT();
                CurrentPos:=CalcRobT(CurrentJoints,tool0\WObj:=wobj0);
                IF ((CurrentPos.trans.x+CurrentPos.extax.eax_a)>1250 AND (CurrentPos.trans.z<1200)) THEN
                    MoveL Offs(CurrentPos,0,0,(1200-CurrentPos.trans.z)),v500,z5,tTCMaster;
                ENDIF
                
            ENDIF
            MoveJ pHTSHome,v1500,fine,tTCMaster;
            IF TestDI(Local_IO_0_DI13) <> TRUE THEN
                TC_release;
            ENDIF
            !home position
            HeliBladeSpeed 0,"FWD";
            HeliBox_Open;
            !Open lid

            MoveJ Offs(pHeli,0,0,100),v1000,z5,tTCMaster;
            MoveL pHeli,v30,fine,tTCMaster;
            TC_grip(2);
            IF TestDI(Local_IO_0_DI2)=FALSE OR StepperPos<>0 THEN
                Heli_Stepper_Home;
            ENDIF
            MoveL Offs(ptHeli,0,0,50),v50,z5,tHeli;
            MoveJ Offs(ptHeli,100,0,800),v500,z5,tHeli;
            pTemp:=ptHeli;
            pTemp.extax.eax_a:=1000;
            MoveJ Offs(pTemp,1400,0,1200),v500,fine,tHeli;
            HeliBox_Close;

        ELSE
            !Currently holding tool
            RAISE ERR_TC_SELECTION;
            
        ENDIF
        
    ERROR
        RAISE;

    ENDPROC

    PROC Heli_Dropoff()

        IF ToolNum=2 THEN
            IF TESTDI(Local_IO_0_DI11) THEN
                CurrentJoints:=CJointT();
                CurrentPos:=CalcRobT(CurrentJoints,tHeli\WObj:=wobj0);
                IF (CurrentPos.trans.z<1000) THEN
                    MoveL Offs(CurrentPos,0,0,(1000-CurrentPos.trans.z)),v500,z5,tHeli;
                ENDIF
                
                MoveJ ptHeliLid,v500,fine,tHeli;
                HeliBladeSpeed 0,"FWD";
                HeliBox_Open;
                !Open lid
                MoveJ Offs(ptHeli,100,0,800),v500,z5,tHeli;
                MoveJ Offs(ptHeli,0,0,100),v500,z5,tHeli;
                MoveL ptHeli,v30,fine,tHeli;
                Heli_Stepper_Home;
                TC_release;
                MoveL Offs(pHeli,0,0,50),v50,z5,tTCMaster;
                MoveJ pHTSHome,v1500,z50,tTCMaster;
                HeliBox_Close;
            ELSE
                RAISE ERR_TS_CONFLICT;
                
            ENDIF

        ELSE
            !Currently holding different tool
            RAISE ERR_TC_SELECTION;
            
        ENDIF
ERROR
        RAISE;


    ENDPROC

    PROC VS_Pickup()
        IF ToolNum=1 THEN
            MoveJ pHTSHome,v1500,fine,tTCMaster;
            IF TestDI(Local_IO_0_DI13) <> TRUE THEN
                TC_release;
            ENDIF 
            !home position
            VS_off;

            VSBox_Open;
            !Open lid

            MoveJ Offs(pVS,0,0,50),v500,z5,tTCMaster;
            MoveL pVS,v30,fine,tTCMaster;
            TC_grip(3);
            MoveL Offs(ptVS,0,0,50),v50,z5,tVS;
            MoveL Offs(ptVS,0,0,650),v1000,z5,tVS;
            MoveJ Offs(ptVS,-1000,0,1400),v1000,fine,tVS;
            MoveJ ptVSLid,v1000,fine,tVS;
            VSBox_Close;
            MoveJ Offs(ptVS,-1000,0,1400),v1000,fine,tVS;

        ELSE
            !Currently holding tool
            RAISE ERR_TC_SELECTION;
            
        ENDIF
    ERROR
        RAISE;

    ENDPROC

    PROC VS_Dropoff()

        IF ToolNum=3 THEN
            CurrentJoints:=CJointT();
                CurrentPos:=CalcRobT(CurrentJoints,tVS\WObj:=wobj0);
                IF (CurrentPos.trans.z<500) THEN
                    MoveL Offs(CurrentPos,0,(2825-CurrentPos.trans.y),(750-CurrentPos.trans.z)),v500,z5,tVS;
                ENDIF

            MoveJ Offs(ptVS,-1000,0,1400),v1000,fine,tVS;
            MoveJ ptVSLid,v1000,fine,tVS;
            VS_Off;
            VSBox_Open;
            !Open lid
            MoveJ Offs(ptVS,-1000,0,1400),v1000,z50,tVS;
            MoveJ Offs(ptVS,0,0,600),v1000,z5,tVS;
            MoveJ Offs(ptVS,0,0,50),v200,z5,tVS;
            MoveL ptVS,v30,fine,tVS;
            TC_release;
            MoveL Offs(pVS,0,0,100),v50,z5,tTCMaster;
            MoveJ pHTSHome,v1500,fine,tTCMaster;
            VSBox_Close;

        ELSE
            !Currently holding different tool
            RAISE ERR_TC_SELECTION;
            
        ENDIF
    ERROR
        RAISE;


    ENDPROC

    PROC Plotter_Pickup()
        !Check lids are closed
        !Check robot position
        !check not currently holding a tool
        !Got to Home position
        !Open lid
        !Move robot to pickup tool
        !Pickup
        !move out of lid way
        !close lid

        IF ToolNum=1 THEN

            MoveJ pHTSHome,v1500,z50,tTCMaster;
            !home position
            IF TestDI(Local_IO_0_DI13) <> TRUE THEN
                TC_release;
            ENDIF
            
            VSBox_Open;
            !Open lid

            MoveJ Offs(pPlotter,0,0,50),v500,z5,tTCMaster;
            MoveL pPlotter,v30,fine,tTCMaster;
            TC_grip(4);
            MoveL Offs(ptPlotter,0,0,50),v50,z5,tPlotter;
            MoveL Offs(ptPlotter,0,0,400),v500,z5,tPlotter;
            MoveJ Offs(ptPlotter,-300,500,1200),v500,z5,tPlotter;
            MoveJ ptPlotterHome,v1500,fine,tPlotter;
            VSBox_Close;

        ELSE
            !Currently holding tool
            RAISE ERR_TC_SELECTION;
            
        ENDIF
    ERROR
        RAISE;

    ENDPROC

    PROC Plotter_Dropoff()


        IF ToolNum=4 THEN
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tPlotter\WObj:=wobj0);
                IF (CurrentPos.trans.z<1000) THEN
                    MoveL Offs(CurrentPos,0,0,(1200-CurrentPos.trans.z)),v500,z5,tPlotter;
                ENDIF

            MoveJ ptPlotterHome,v1500,fine,tPlotter;
            VSBox_Open;
            !Open lid
            MoveJ Offs(ptPlotter,0,0,400),v500,z5,tPlotter;
            MoveJ Offs(ptPlotter,0,0,50),v50,z5,tPlotter;
            MoveL ptPlotter,v10,fine,tPlotter;
            TC_release;
            MoveL Offs(pPlotter,0,0,50),v50,z5,tTCMaster;
            MoveJ pHTSHome,v1500,fine,tTCMaster;
            !home position
            VSBox_Close;

        ELSE
            !Currently holding different tool
            RAISE ERR_TC_SELECTION;
            
            
        ENDIF
        
    ERROR
        RAISE;

    ENDPROC






ENDMODULE