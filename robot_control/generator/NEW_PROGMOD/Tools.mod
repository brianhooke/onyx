MODULE Tools
    PERS tooldata tTCMaster:=[TRUE,[[0,0,207.5],[1,0,0,0]],[35.1,[-43.8,-5.8,88.2],[1,0,0,0],1.89,2.404,2.185]];
    !tool 1
    !PERS tooldata tHeli:=[TRUE,[[-1091.64,-2.18304,690.122],[0.999984769,-0.005235956,-0.001745304,-0.000009138]],[143,[-188.6,-2.3,347.7],[1,0,0,0],15.384,75.35,71.092]];
    PERS tooldata tHeli:= [TRUE,[[3.62043,-1.97066,832.975],[1,0,0,0]],[126.195,[57.114,-1.07346,391.24],[1,0,0,0],7.566,7.566,1.232]];![TRUE,[[3.62043,-1.97066,832.975],[1,0,0,0]],[123.2,[0,0,358.8],[1,0,0,0],7.566,7.566,1.232]];
    !tool 2
    PERS tooldata tVS:=[TRUE,[[-160.393,-0.542707,442.126],[0.999896,0.0028071,-0.004385,-0.0134527]],[63.3,[-68.9,-1.3,146],[1,0,0,0],21.289,6.038,20.201]];
    !tool 3
    PERS tooldata tPlotter:=[TRUE,[[-1713.88,3.06465,517.985],[1,0,0,0]],[51.3,[-156.1,-2.6,95.3],[1,0,0,0],2.987,13.114,10.95]];
    !tool 4
    PERS tooldata tVac:=[TRUE,[[-1506.14,-102.387,605.248],[1,0,0,0]],[55,[-309.6,-23.7,189.4],[1,0,0,0],0,25.787,22.646]];
    !tool 5
    PERS tooldata tPolish:=[TRUE,[[-73.9437,0.320318,577.592],[1,0,0,0]],[98.6,[46.8,-4.7,321.4],[1,0,0,0],8.622,12.165,6.339]];
    !tool 6

    PERS num ToolNum:=1;
    CONST num StepsPerRevolution:=32;
    PERS num StepperPos:=0;
    CONST num RevstoAngle:=0.81;
    CONST num RPMtoAVoltage:=13.26;
    VAR num StepPulseLength:=0.05;

    CONST robtarget ptVS:=[[11045.67,2693.97,-320.50],[0.00448015,-0.0109106,0.99993,-0.000490788],[0,0,0,0],[9400,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget ptVSLid:=[[-1258.81,1496.40,1264.32],[0.00538869,0.999881,0.014392,-0.00114313],[1,0,-1,0],[-300,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget ptPlotter:=[[10425.84,1482.31,-402.44],[7.96616E-05,0.000723746,0.999997,0.00233849],[0,0,0,0],[7000,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget ptPlotterHome:=[[-28.06,3222.40,1164.30],[0.0023643,0.676174,-0.736738,0.000527345],[0,0,0,0],[-230.006,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pheliFlat:=[[1539.97,3060.81,188.30],[0.00869284,-0.711152,0.702867,0.0128866],[1,-1,-1,0],[2550.86,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pauto1:=[[-778.40,2128.06,1481.94],[0.022656,0.969999,-0.241976,-0.00596024],[1,0,-1,0],[882.621,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pauto11:=[[3681.78,3060.67,2088.41],[0.374917,-0.637445,0.551185,0.386389],[0,0,-1,0],[3637.95,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pauto21:=[[10834.94,586.90,1323.18],[0.0589615,0.154699,-0.985821,0.0273665],[0,-1,0,0],[9151.19,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVac:=[[8710.42,2016.87,-57.34],[8.16993E-05,-3.02533E-05,0.999997,0.00233675],[0,0,0,0],[8008.49,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pPolish:=[[10187.84,2909.45,124.99],[0.210696,-0.480812,0.841761,0.12596],[0,-1,0,0],[9669.05,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget ptVac:=[[10216.63,1916.43,-455.32],[8.13591E-05,-3.02535E-05,0.999997,0.00233577],[0,0,0,0],[8008.49,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget ptPolish:=[[10307.20,3119.00,-165.31],[0.210696,-0.480814,0.84176,0.12596],[0,-1,0,0],[9669.05,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pHome:=[[9788.10,1111.58,1428.55],[0.00172327,-0.707218,0.706991,0.0015985],[0,0,-1,0],[9669.05,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pHomeLoadout:=[[10727.04,861.31,1157.29],[0.00106715,-0.495112,0.868828,0.000646025],[0,0,-1,0],[10083.3,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget psafetysync:=[[1398.85,1929.78,822.76],[0.00987552,-0.710785,0.703215,0.013256],[0,0,-1,0],[1388.92,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVSHome:=[[9585.25,2694.24,650],[7.1103E-05,0.00253236,0.999994,0.00232889],[0,0,0,0],[8700,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget ptPolishHome:=[[9800,2600,700],[0.00170969,-0.70722,0.706989,0.00159033],[0,0,-1,0],[9669.05,9E+09,9E+09,9E+09,9E+09,9E+09]];
   
    VAR robtarget safetypos;
    VAR jointtarget SafetyJoints:= [[86.92,9.65,27.89,0.50,50.60,-4.00],[1388.98,0,0,0,0,0]];
    TASK PERS tooldata toolscribe:=[TRUE,[[-1649.26,45.4029,529.7],[1,0,0,0]],[35,[0,0,0],[1,0,0,0],0,0,0]];
    TASK PERS wobjdata Bed1Wyong:=[FALSE,TRUE,"",[[7989.63,1005.26,-267.803],[0.999997,0.00206543,0.00107668,-0.000243432]],[[0,0,0],[1,0,0,0]]];
    CONST robtarget p30:=[[-8200.33,3455.89,-25.52],[0.00615322,-0.709926,0.704246,-0.00239206],[1,-1,0,0],[700.017,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVS2:=[[10884.11,2694.01,-84.00],[0.000422431,0.00399926,-0.999989,-0.00231643],[0,0,-4,0],[9400.01,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget ptVS2:=[[11044.30,2695.84,-318.76],[0.00400447,-0.0174424,0.99984,-0.00046851],[0,0,-4,0],[9400.01,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVSHome2:=[[8270.42,2695.81,568.34],[0.00400107,-0.0174495,0.99984,-0.00047725],[1,-1,-3,0],[9348.32,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVS3:=[[10884.11,2694.01,-84.00],[0.000422431,0.00399926,-0.999989,-0.00231643],[0,0,0,0],[9400.01,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget ptVS3:=[[11044.30,2695.84,-318.76],[0.00400447,-0.0174424,0.99984,-0.00046851],[0,0,0,0],[9400.01,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVSHome3:=[[8270.42,2495.81,568.34],[0.00400107,-0.0174495,0.99984,-0.00047725],[1,0,1,0],[9348.32,9E+09,9E+09,9E+09,9E+09,9E+09]];
    
    CONST robtarget pVSstart:=[[0,1910,152.62],[0.00447556,-0.0129767,0.999906,0.000222253],[1,0,-3,0],[8013.81,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVSend:=[[-7901.85,1910,136.34],[0.00447498,-0.0129641,0.999906,0.000216841],[1,-1,-3,0],[1001.47,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pPolori:=[[-7500.00,699.99,61.10],[0.00290121,-0.00953475,0.99995,-0.000307041],[1,-1,-3,0],[1082.85,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pWyongheli:=[[-1079.05,1074.88,154.71],[0.000446787,0.711247,-0.702933,-0.00362622],[1,0,0,0],[8410.48,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pWyongpolside:=[[-315.45,397.96,85.25],[0.000625449,0.713919,-0.700225,0.00227362],[1,-1,0,0],[7736.06,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVSint1:=[[9801.17,1585.88,785.87],[0.000745595,-0.16668,-0.986008,-0.00229112],[0,0,-3,0],[9489.51,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVSint11:=[[10878.13,2675.70,-4.86],[0.000487439,-0.00236958,-0.999995,-0.00225572],[0,0,0,0],[9392.97,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVSint21:=[[8895.30,2753.13,512.58],[0.004325,0.0253885,0.999646,-0.00668668],[1,0,1,0],[9358.69,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVSint31:=[[11044.32,2695.82,-318.76],[0.0040055,-0.0174317,0.99984,-0.000470895],[0,0,0,0],[9400.01,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVSint41:=[[-250.26,1159.79,740.05],[0.00465391,-0.0435285,0.999041,0.000350233],[1,-1,1,0],[8339.63,9E+09,9E+09,9E+09,9E+09,9E+09]];
    
    
    PROC Safetypose()
        !safetypos:=CalcRobT (safetyJoints, tTCMaster);
        MoveAbsJ SafetyJoints, v100,fine, tool0;
        Stop;
    ENDPROC
        
    PROC AllOutputOff()
        VS_off;
        Pol_off;
        HeliBladeSpeed 0,"FWD";
        
    ENDPROC
        
    
    PROC TC_release()
        StopMove;
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tTCMaster\WObj:=wobj0);
        IF CurrentPos.trans.z>300 THEN
            TPWrite "Release of tool outside of expected bounds!";
            RAISE ERR_TC_SELECTION;
        ENDIF

        AllOutputOff;
        
        SetDO PN_DO_15,1;
        WaitDI PN_DI_15,1;
        Toolnum:=1;
        SetDO PN_DO_15,0;
        
        
        SetDO PN_DO_25,1;
        SetDO PN_DO_26,0;
        SetDO PN_DO_27,0;
        SetDO PN_DO_28,0;
        SetDO PN_DO_29,0;
        SetDO PN_DO_30,0;
        SetDO PN_DO_31,0;
        SetDO PN_DO_32,0;
        SetDO PN_DO_24,1;
        WaitDI PN_DI_24,1;
        SetDO PN_DO_24,0;
        
        StartMove;

    ERROR
        RAISE ;
    ENDPROC

    
    PROC TC_grip(num ToolNo)
        StopMove;
        !Turn off any electrical connections
        AllOutputOff;

        !Turn off open solenoid
        !Actuate and check for DI signal

        SETDO PN_DO_14,1;
        WaitDI PN_DI_14,1;
        SETDO PN_DO_14,0;
        
        TEST ToolNo
        CASE 1:
        SetDO PN_DO_25,1;
        SetDO PN_DO_26,0;
        SetDO PN_DO_27,0;
        SetDO PN_DO_28,0;
        SetDO PN_DO_29,0;
        SetDO PN_DO_30,0;
        SetDO PN_DO_31,0;
        SetDO PN_DO_32,0;
        CASE 2:
        SetDO PN_DO_25,0;
        SetDO PN_DO_26,1;
        SetDO PN_DO_27,0;
        SetDO PN_DO_28,0;
        SetDO PN_DO_29,0;
        SetDO PN_DO_30,0;
        SetDO PN_DO_31,0;
        SetDO PN_DO_32,0;
        CASE 3:
        SetDO PN_DO_25,1;
        SetDO PN_DO_26,1;
        SetDO PN_DO_27,0;
        SetDO PN_DO_28,0;
        SetDO PN_DO_29,0;
        SetDO PN_DO_30,0;
        SetDO PN_DO_31,0;
        SetDO PN_DO_32,0;
        CASE 4:
        SetDO PN_DO_25,0;
        SetDO PN_DO_26,0;
        SetDO PN_DO_27,1;
        SetDO PN_DO_28,0;
        SetDO PN_DO_29,0;
        SetDO PN_DO_30,0;
        SetDO PN_DO_31,0;
        SetDO PN_DO_32,0;
        CASE 5:
        SetDO PN_DO_25,1;
        SetDO PN_DO_26,0;
        SetDO PN_DO_27,1;
        SetDO PN_DO_28,0;
        SetDO PN_DO_29,0;
        SetDO PN_DO_30,0;
        SetDO PN_DO_31,0;
        SetDO PN_DO_32,0;
        CASE 6:
        SetDO PN_DO_25,0;
        SetDO PN_DO_26,1;
        SetDO PN_DO_27,1;
        SetDO PN_DO_28,0;
        SetDO PN_DO_29,0;
        SetDO PN_DO_30,0;
        SetDO PN_DO_31,0;
        SetDO PN_DO_32,0;
        CASE 7:
        SetDO PN_DO_25,1;
        SetDO PN_DO_26,1;
        SetDO PN_DO_27,1;
        SetDO PN_DO_28,0;
        SetDO PN_DO_29,0;
        SetDO PN_DO_30,0;
        SetDO PN_DO_31,0;
        SetDO PN_DO_32,0;
        
        
        ENDTEST
        
        SetDO PN_DO_24, 1;
        WaitDI PN_DI_24, 0;
        SetDO PN_DO_24, 0;
        
            !Set current tool to specified
            IF ToolNo>=2 AND ToolNo<=6 THEN
                ToolNum:=ToolNo;
            ELSE
                RAISE ERR_TC_SELECTION;
            ENDIF

        StartMove;

    ERROR
        RAISE ;

    ENDPROC


    PROC Heli_Stepper_Home()
        !Home the ballscrew of helicopter blade angling mechanism
        IF ToolNum=2 AND testDI(Local_IO_0_DI14) THEN
            IF TestDI(Local_IO_0_DI2) THEN
                SETDO Local_IO_0_DO7,0;
                !Heli_Step 50; 
            ENDIF

            WHILE TestDI(Local_IO_0_DI2)=FALSE DO
                SETDO Local_IO_0_DO7,1;
                !Heli_Step 1;
            ENDWHILE
            StepperPos:=0;
        ELSE
            RAISE ERR_HELI_DISCONNECT;
        ENDIF

    ERROR
        RAISE ;

    ENDPROC

    PROC HeliBlade_Angle(num angle)
        !Change angle of Helicopter blades
        VAR num pulses:=0;
        IF ToolNum=2 AND testDI(Local_IO_0_DI14) THEN
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
                        !Heli_Step 1;
                    ENDWHILE
                ELSE
                    !Heli_Step pulses;
                ENDIF

            ENDIF
            PitchZOffset:=75*Sin(angle);
        ELSE
            RAISE ERR_HELI_DISCONNECT;
        ENDIF

    ERROR
        RAISE ;

    ENDPROC


    PROC VS_on()
        IF Toolnum=3 THEN
            SetDO PN_DO_18,1;
            WaitDI PN_DI_18,1 \MaxTime:=5;
        ELSE
            RAISE ERR_VS_DISCONNECT;
        ENDIF

    ERROR
        RAISE ;

    ENDPROC

    PROC VS_off()
        SetDO PN_DO_18,0;
        WaitDI PN_DI_18,0 \MaxTime:=5;
    ENDPROC

    PROC HeliBladeSpeed(num RPM,string DIRECTION)
        !RPM range from 0 to 140, DIRECTION is either "FWD" or "REV"

        VAR num Avoltage:=0;
        IF ToolNum=2 THEN
            Avoltage:=RPM/RPMtoAVoltage;
            IF (Avoltage>0) AND (Avoltage<1) THEN
                Avoltage:=1;
            ELSEIF Avoltage>10 THEN
                Avoltage:=10;
            ELSEIF Avoltage=0 THEN
                SetAO Local_IO_1_AO1,0.00;
            ELSEIF Avoltage<0 OR Avoltage>10 THEN
                RAISE ERR_HELI_BLADE_SPEED;
            ENDIF

            IF Avoltage>0 AND Avoltage<=10 THEN
                IF DIRECTION="FWD" THEN
                    SetDO PN_DO_21,0;
                ELSEIF DIRECTION="REV" THEN
                    SetDO PN_DO_21,1;
                ELSE
                    RAISE ERR_HELI_BLADE_DIRECTION;

                ENDIF
                SetDO PN_DO_19,1;
                WaitDI PN_DI_19,1 \MaxTime:=15;
                WaitTime 0.1;
                SETAO Local_IO_1_AO1,Avoltage;
            ENDIF
        ELSEIF RPM=0 THEN
            SetDO PN_DO_19,0;
            WaitDI PN_DI_19,0 \MaxTime:=5;
        ELSE
            SetDO PN_DO_19,0;
            WaitDI PN_DI_19,1 \MaxTime:=5;
            RAISE ERR_HELI_DISCONNECT;

        ENDIF

    ERROR
        RAISE ;

    ENDPROC
    
    PROC Heli_Off()
        SetDO PN_DO_19,0;
        WaitDI PN_DI_19,0 \MaxTime:=15;
    ENDPROC
    


    PROC Heli_Pickup()

        IF ToolNum=1 THEN

                WaiTtime\inpos,0.05;
                CurrentJoints:=CJointT();
                CurrentPos:=CalcRobT(CurrentJoints,tTCmaster\WObj:=wobj0);
                IF CurrentPos.trans.z<300 THEN
                    MoveL Offs(CurrentPos,0,0,(500-CurrentPos.trans.z)),v500,z5,tTCMaster;
                ENDIF

            MoveJ pHome,v1500,fine,tTCMaster;

            MoveJ Offs(pHeli,0,0,100),v1000,z5,tTCMaster;
            MoveL pHeli,v30,fine,tTCMaster;
            TC_grip(2);
!            IF TestDI(Local_IO_0_DI2)=FALSE OR StepperPos<>0 THEN
!                Heli_Stepper_Home;
!            ENDIF
            MoveL Offs(ptHeli,0,0,50),v50,fine,tHeli;
            MoveJ Offs(ptHeli,0,0,500),v500,z5,tHeli;
            pTemp:=ptHeli;
            pTemp.extax.eax_a:=ptHeli.extax.eax_a-2000;
            pTemp.trans.z:=ptHeli.trans.z+800;
            MoveJ Offs(pTemp,-2000,0,0),v500,fine,tHeli;

        ELSE
            !Currently holding tool
            RAISE ERR_TC_SELECTION;

        ENDIF

    ERROR
        RAISE ;

    ENDPROC

    PROC Heli_Dropoff()

        IF ToolNum=2 THEN
                WaiTtime\inpos,0.05;
                CurrentJoints:=CJointT();
                CurrentPos:=CalcRobT(CurrentJoints,tHeli\WObj:=wobj0);
                IF (CurrentPos.trans.z<250) THEN
                    MoveL Offs(CurrentPos,0,0,(250-CurrentPos.trans.z)),v500,z5,tHeli;
                ENDIF

                Heli_Off;

                MoveJ Offs(ptHeli,0,0,500),v500,z5,tHeli;
                MoveJ Offs(ptHeli,0,0,100),v500,z5,tHeli;
                MoveL Offs(ptHeli,0,0,20),v30,fine,tHeli;
                !ADD HELI STEPPER HOMING BACK IN HERE
                MoveL ptHeli,v30,fine,tHeli;
                TC_release;
                MoveL Offs(pHeli,0,0,50),v50,z5,tTCMaster;
                MoveJ pHome,v1500,z50,tTCMaster;


        ELSE
            !Currently holding different tool
            RAISE ERR_TC_SELECTION;

        ENDIF
    ERROR
        RAISE ;
    ENDPROC
    
    PROC VS_Pickup()
        IF ToolNum=1 THEN
            WaiTtime\inpos,0.05;
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tTCmaster\WObj:=wobj0);
            IF CurrentPos.trans.z<300 THEN
                MoveL Offs(CurrentPos,0,0,(500-CurrentPos.trans.z)),v500,z5,tTCMaster;
            ENDIF
            MoveJ pHome,v1500,fine,tTCMaster;
            !home position
            VS_off;
            
            MoveJ Offs(pVS3,0,0,50),v500,z5,tTCMaster;
            MoveL pVS3,v30,fine,tTCMaster;
            TC_grip(3);
            MoveL Offs(ptVS3,0,0,150),v50,z5,tVS;
            MoveL Offs(ptVS3,-100,0,250),v50,z5,tVS;
            MoveJ Offs(ptVS3,-300,0,700),v1000,z5,tVS;
            MoveL pVSHome3,v500,z5,tVS;

        ELSE
            !Currently holding tool
            RAISE ERR_TC_SELECTION;

        ENDIF
    ERROR
        RAISE ;

    ENDPROC

    PROC VS_Dropoff()

        IF ToolNum=3 THEN
            WaiTtime\inpos,0.05;
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tVS\WObj:=wobj0);
            IF (CurrentPos.trans.z<400) THEN
                MoveL Offs(CurrentPos,0,(2825-CurrentPos.trans.y),(400-CurrentPos.trans.z)),v500,z5,tVS;
            ENDIF

            MoveJ pVSHome3,v1000,z5,tVS;
            pTemp:=pVSHome3;
            pTemp.trans.x:=pVSHome3.trans.x+1500;
            pTemp.extax.eax_a:=pVSHome3.extax.eax_a+1000;
            VS_Off;
            MoveL Offs(ptVS3,-300,0,650),v1000,z5,tVS;
            MoveJ Offs(ptVS3,-100,0,250),v200,z5,tVS;
            MoveJ Offs(ptVS3,0,0,150),v200,z5,tVS;
            MoveL ptVS3,v30,fine,tVS;
            TC_release;
            MoveL Offs(pVS3,0,0,50),v50,z5,tTCMaster;
            MoveJ pHome,v500,z5,tTCMaster;

        ELSE
            !Currently holding different tool
            RAISE ERR_TC_SELECTION;

        ENDIF
    ERROR
        RAISE ;


    ENDPROC

    PROC Plotter_Pickup()

        IF ToolNum=1 THEN
            WaiTtime\inpos,0.05;
            MoveJ pHome,v1500,z50,tTCMaster;
            !home position
            IF TestDI(Local_IO_0_DI13)<>TRUE THEN
                TC_release;
            ENDIF
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tTCmaster\WObj:=wobj0);
            IF CurrentPos.trans.z<300 THEN
                MoveL Offs(CurrentPos,0,0,(500-CurrentPos.trans.z)),v500,z5,tTCMaster;
            ENDIF
            
            MoveJ Offs(pPlotter,0,0,50),v500,z5,tTCMaster;
            MoveL pPlotter,v30,fine,tTCMaster;
            TC_grip(4);
            MoveL Offs(ptPlotter,0,0,50),v50,z5,tPlotter;
            MoveL Offs(ptPlotter,0,0,600),v500,z5,tPlotter;
            MoveL Offs(Reltool(ptPlotter,0,0,0\Rz:=-90),-1500,1600,1000),v500,z5,tPlotter;
            
        ELSE
            !Currently holding tool
            RAISE ERR_TC_SELECTION;

        ENDIF
    ERROR
        RAISE ;

    ENDPROC

    PROC Plotter_Dropoff()


        IF ToolNum=4 THEN
            WaiTtime\inpos,0.05;
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tPlotter\WObj:=wobj0);
            IF (CurrentPos.trans.z<700) OR (CurrentPos.trans.y<1600) THEN  
                MoveL Offs(CurrentPos,0,1700-CurrentPos.trans.y,(700-CurrentPos.trans.z)),v500,z5,tPlotter;
            ENDIF


            MoveL Offs(Reltool(ptPlotter,0,0,0\Rz:=-90),-1500,1600,1000),v500,z5,tPlotter;
            MoveJ Offs(ptPlotter,0,0,600),v500,z5,tPlotter;
            MoveJ Offs(ptPlotter,0,0,50),v50,z5,tPlotter;
            MoveL ptPlotter,v10,fine,tPlotter;
            TC_release;
            MoveL Offs(pPlotter,0,0,50),v50,z5,tTCMaster;
            MoveJ pHome,v1500,fine,tTCMaster;
            
        ELSE
            !Currently holding different tool
            RAISE ERR_TC_SELECTION;


        ENDIF

    ERROR
        RAISE ;

    ENDPROC
    
  PROC Vac_Pickup()

        IF ToolNum=1 THEN
            WaiTtime\inpos,0.05;
            MoveJ pHome,v1500,fine,tTCMaster;
            IF TestDI(Local_IO_0_DI13)<>TRUE THEN
                TC_release;
            ENDIF
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tTCmaster\WObj:=wobj0);
            IF CurrentPos.trans.z<300 THEN
                MoveL Offs(CurrentPos,0,0,(500-CurrentPos.trans.z)),v500,z5,tTCMaster;
            ENDIF
            
            MoveJ RelTool(pVac,0,0,-100),v1000,z5,tTCMaster;
            MoveL pVac,v30,fine,tTCMaster;
            TC_grip(5);
            MoveL Offs(ptVac,0,-5,50),v50,z5,tVac;
            MoveJ Offs(ptVac,0,80,800),v500,z5,tVac;
            pTemp:=ptVac;
            pTemp.extax.eax_a:=ptVac.extax.eax_a-1000;
            pTemp.trans.x:=ptVac.trans.x-1000;
            pTemp.trans.z:=ptVac.trans.z+800;
            MoveJ Reltool(pTemp,0,0,0,\Rz:=-90),v500,fine,tVac;

        ELSE
            !Currently holding tool
            RAISE ERR_TC_SELECTION;

        ENDIF

    ERROR
        RAISE ;

    ENDPROC
    
    PROC Vac_Dropoff()
        
        IF ToolNum=5 THEN
            WaiTtime\inpos,0.05;
                CurrentJoints:=CJointT();
                CurrentPos:=CalcRobT(CurrentJoints,tVac\WObj:=Bed1Wyong);
                IF (CurrentPos.trans.z<800) THEN
                    MoveL Offs(CurrentPos,0,0,(800-CurrentPos.trans.z)),v500,z5,tVac\WObj:=Bed1Wyong;
                ENDIF

                MoveJ Offs(ptVac,0,80,800),v500,z5,tVac;
                MoveJ Offs(ptVac,0,10,100),v500,z5,tVac;
                MoveL ptVac,v30,fine,tVac;
                TC_release;
                MoveL Offs(pVac,0,0,50),v50,z5,tTCMaster;
                MoveJ pHome,v1500,z50,tTCMaster;

        ELSE
            !Currently holding different tool
            RAISE ERR_TC_SELECTION;

        ENDIF
    ERROR
        RAISE ;
    ENDPROC
    
    
      PROC Polish_Pickup()

        IF ToolNum=1 THEN
            WaiTtime\inpos,0.05;
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tTCmaster\WObj:=wobj0);
            IF CurrentPos.trans.z<300 THEN
                MoveL Offs(CurrentPos,0,0,(500-CurrentPos.trans.z)),v500,z5,tTCMaster;
            ENDIF
            
            MoveJ pHome,v1500,fine,tTCMaster;

            MoveJ RelTool(pPolish,0,0,-100),v1000,z5,tTCMaster;
            MoveJ RelTool(pPolish,0,0,-80),v1000,z5,tTCMaster;
            MoveL pPolish,v30,fine,tTCMaster;
            TC_grip(6);
            MoveL Offs(ptPolish,0,0,50),v50,z5,tPolish;
            MoveJ Offs(ptPolish,0,0,500),v500,z5,tPolish;
            MoveJ ptPolishHome,v500,fine,tPolish;
            pTemp:=ptPolishHome;
            pTemp.extax.eax_a:=ptPolishHome.extax.eax_a-1700;
            pTemp.trans.x:=ptPolishHome.trans.x-1700;
            pTemp.trans.y:=ptPolishHome.trans.y-300;
            MoveJ pTemp,v500,fine,tPolish;
            
        ELSE
            !Currently holding tool
            RAISE ERR_TC_SELECTION;

        ENDIF

    ERROR
        RAISE ;

    ENDPROC
    
    PROC Polish_Dropoff()
        Pol_off;
        IF ToolNum=6 THEN
                CurrentJoints:=CJointT();
                CurrentPos:=CalcRobT(CurrentJoints,tPolish\WObj:=wobj0);
                IF (CurrentPos.trans.z<700) THEN
                    IF CurrentJoints.robax.rax_6<-80 THEN
                    TPErase;
                    TPWrite("Jog robot axis 6 AND HOME");
                    Stop;
                    ELSE
                    MoveL Offs(CurrentPos,0,0,(700-CurrentPos.trans.z)),v500,z5,tPolish;
                    ENDIF
                ENDIF
                pTemp:=ptPolishHome;
                pTemp.extax.eax_a:=ptPolishHome.extax.eax_a-1700;
                pTemp.trans.x:=ptPolishHome.trans.x-1700;
                pTemp.trans.y:=ptPolishHome.trans.y-300;
                MoveJ pTemp,v500,z5,tPolish;
                
                MoveJ ptPolishHome,v500,z5,tPolish;

                MoveJ Offs(ptPolish,0,0,500),v500,z5,tPolish;
                MoveJ Offs(ptPolish,0,0,100),v500,z5,tPolish;
                MoveL ptPolish,v30,fine,tPolish;
                TC_release;
                MoveL RelTool(pPolish,0,0,-50),v50,z5,tTCMaster;
                MoveJ RelTool(pPolish,0,0,-100),v50,z5,tTCMaster;
                MoveJ pHome,v1500,z50,tTCMaster;

 

        ELSE
            !Currently holding different tool
            RAISE ERR_TC_SELECTION;

        ENDIF
    ERROR
        RAISE ;
    ENDPROC
    
    PROC Pol_on()
        IF Toolnum=6 THEN
            SetDO PN_DO_18,1;
            WaitDI PN_DI_18,1 \MaxTime:=5;
        ELSE
            RAISE ERR_POLISH_DISCONNECT;
        ENDIF

    ERROR
        RAISE ;

    ENDPROC
    
    PROC Pol_off()
        SetDO PN_DO_18,0;
        WaitDI PN_DI_18,0 \MaxTime:=5;
    ENDPROC
    
    PROC Vac_on()
    ENDPROC
    
    PROC Vac_off()
    ENDPROC
    
    PROC Toolnum1()
        SetDO PN_DO_25,1;
        SetDO PN_DO_26,0;
        SetDO PN_DO_27,0;
        SetDO PN_DO_28,0;
        SetDO PN_DO_29,0;
        SetDO PN_DO_30,0;
        SetDO PN_DO_31,0;
        SetDO PN_DO_32,0;

        SetDO PN_DO_24,1;
        WaitDI PN_DI_24,1;
        SetDO PN_DO_24,0;
        ToolNum:=1;
        TC_release;
    EnDPROC
    

ENDMODULE