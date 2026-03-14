MODULE Tools
    PERS tooldata tTCMaster:=[TRUE,[[0,0,207.5],[1,0,0,0]],[35.1,[-43.8,-5.8,88.2],[1,0,0,0],1.89,2.404,2.185]];
    !tool 1
    !PERS tooldata tHeli:=[TRUE,[[-1091.64,-2.18304,690.122],[0.999984769,-0.005235956,-0.001745304,-0.000009138]],[143,[-188.6,-2.3,347.7],[1,0,0,0],15.384,75.35,71.092]];
    PERS tooldata tHeli:= [TRUE,[[3.62043,-1.97066,832.975],[1,0,0,0]],[126.195,[57.114,-1.07346,391.24],[1,0,0,0],7.566,7.566,1.232]];![TRUE,[[3.62043,-1.97066,832.975],[1,0,0,0]],[123.2,[0,0,358.8],[1,0,0,0],7.566,7.566,1.232]];
    !tool 2
    PERS tooldata tVS:=[TRUE,[[-119.236,1.39032,565.83],[0.999896,0.0028071,-0.004385,-0.0134527]],[71,[-53.1,1.5,220.3],[1,0,0,0],22.767,7.043,16.96]];
    !tool 3
    PERS tooldata tPlotter:=[TRUE,[[-1713.88,3.06465,517.985],[1,0,0,0]],[51.3,[-156.1,-2.6,95.3],[1,0,0,0],2.987,13.114,10.95]];
    !tool 4
    PERS tooldata tVac:=[TRUE,[[-138.372,-208.094,748.57],[1,0,0,0]],[57.9,[-21.4,-4,179.8],[1,0,0,0],3.394,3.58,2.723]];
    !tool 5
    PERS tooldata tPolish:=[TRUE,[[-73.9437,0.320318,577.592],[1,0,0,0]],[98.6,[46.8,-4.7,321.4],[1,0,0,0],8.622,12.165,6.339]];
    !tool 6

    PERS num ToolNum:=2;
    CONST num StepsPerRevolution:=200;
    PERS num StepperPos:=0;
    CONST num RevstoAngle:=0.81;
    CONST num RPMtoAVoltage:=13.26;
    VAR num StepPulseLength:=0.05;
    VAR num pulses:=0;
    CONST num HeliBladeHeight:=150; 

    CONST robtarget ptVS:=[[11044.04,2735.51,-321.13],[0.0112875,-0.0246166,0.999633,-0.00046329],[0,-1,0,0],[9402.52,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget ptVSLid:=[[-1258.81,1496.40,1264.32],[0.00538869,0.999881,0.014392,-0.00114313],[1,0,-1,0],[-300,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget ptPlotter:=[[10425.84,1482.31,-402.44],[7.96616E-05,0.000723746,0.999997,0.00233849],[0,0,0,0],[7000,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget ptPlotterHome:=[[-28.06,3222.40,1164.30],[0.0023643,0.676174,-0.736738,0.000527345],[0,0,0,0],[-230.006,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pheliFlat:=[[1539.97,3060.81,188.30],[0.00869284,-0.711152,0.702867,0.0128866],[1,-1,-1,0],[2550.86,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pauto1:=[[-778.40,2128.06,1481.94],[0.022656,0.969999,-0.241976,-0.00596024],[1,0,-1,0],[882.621,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pauto11:=[[3681.78,3060.67,2088.41],[0.374917,-0.637445,0.551185,0.386389],[0,0,-1,0],[3637.95,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pauto21:=[[10834.94,586.90,1323.18],[0.0589615,0.154699,-0.985821,0.0273665],[0,-1,0,0],[9151.19,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVac:=[[9128.09,2033.98,112.72],[0.00154174,-0.707209,0.706975,0.00636242],[1,0,0,0],[9669.05,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pPolish:=[[10178.12,2902.68,132.37],[0.21997,-0.478405,0.841218,0.12286],[0,-1,0,0],[9669.05,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget ptVac:=[[9332.47,2178.46,-428.18],[0.00154068,-0.707204,0.706979,0.00635994],[1,0,0,0],[9669.05,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget ptPolish:=[[10304.25,3112.75,-154.67],[0.21997,-0.478405,0.841218,0.12286],[0,-1,0,0],[9669.05,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pHome:=[[9788.10,1111.58,1428.55],[0.00172327,-0.707218,0.706991,0.0015985],[0,0,-1,0],[9669.05,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pHomeLoadout:=[[10727.04,861.31,1157.29],[0.00106715,-0.495112,0.868828,0.000646025],[0,0,-1,0],[10083.3,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget psafetysync:=[[1398.85,1929.78,822.76],[0.00987552,-0.710785,0.703215,0.013256],[0,0,-1,0],[1388.92,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVSHome:=[[9585.25,2694.24,650],[7.1103E-05,0.00253236,0.999994,0.00232889],[0,0,0,0],[8700,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget ptPolishHome:=[[9800,2600,700],[0.00170969,-0.70722,0.706989,0.00159033],[0,0,-1,0],[9669.05,9E+09,9E+09,9E+09,9E+09,9E+09]];
   
    VAR robtarget safetypos;
    VAR jointtarget SafetyJoints:= [[86.92,9.65,27.89,0.50,50.60,-4.00],[1388.98,0,0,0,0,0]];
    TASK PERS tooldata toolscribe:=[TRUE,[[-1649.26,45.4029,529.7],[1,0,0,0]],[35,[0,0,0],[1,0,0,0],0,0,0]];
    TASK PERS wobjdata Bed1Wyong:=[FALSE,TRUE,"",[[8054.45,655.281,-259.936],[1,0.000749019,0.000172907,3.16291E-05]],[[0,0,0],[1,0,0,0]]];!y=1005.26 before 150mm guide put in
    CONST robtarget p30:=[[-8200.33,3455.89,-25.52],[0.00615322,-0.709926,0.704246,-0.00239206],[1,-1,0,0],[700.017,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVS2:=[[10884.11,2694.01,-84.00],[0.000422431,0.00399926,-0.999989,-0.00231643],[0,0,-4,0],[9400.01,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget ptVS2:=[[11044.30,2695.84,-318.76],[0.00400447,-0.0174424,0.99984,-0.00046851],[0,0,-4,0],[9400.01,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVSHome2:=[[8270.42,2695.81,568.34],[0.00400107,-0.0174495,0.99984,-0.00047725],[1,-1,-3,0],[9348.32,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVS3:=[[10919.98,2729.70,35.52],[0.00684157,-0.011203,0.999911,0.00238795],[0,-1,0,0],[9402.52,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget ptVS3:=[[11083.53,2733.90,-196.88],[0.011289,-0.0246227,0.999633,-0.000462066],[0,-1,0,0],[9402.52,9E+09,9E+09,9E+09,9E+09,9E+09]];
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
    TASK PERS tooldata tool1:=[TRUE,[[-138.372,-208.094,748.57],[1,0,0,0]],[40,[0,0,0],[1,0,0,0],0,0,0]];
    TASK PERS tooldata tool2:=[TRUE,[[10.4741,45.9214,435.129],[1,0,0,0]],[40,[0,0,0],[1,0,0,0],0,0,0]];
    CONST robtarget pVSautoTest:=[[1039.10,4562.98,597.52],[0.00170689,-0.706592,0.707617,0.00159207],[1,-1,0,0],[1849.25,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVSautoTest2:=[[7142.34,4562.98,597.53],[0.00170875,-0.706594,0.707615,0.00159224],[0,0,-1,0],[6421.13,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVSautoTest3:=[[2519.26,1845.27,1231.38],[0.00565408,-0.932444,0.361249,0.00387472],[1,-1,-1,0],[3215.19,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pVSautoTest4:=[[6263.30,1664.20,1335.95],[0.00567298,-0.932446,0.361243,0.0038847],[1,-1,-1,0],[6692.31,9E+09,9E+09,9E+09,9E+09,9E+09]];
    
    
    PROC Safetypose()
        !safetypos:=CalcRobT (safetyJoints, tTCMaster);
        MoveAbsJ SafetyJoints, v100,fine, tool0;
        Stop;
    ENDPROC
        
    PROC AllOutputOff()
        VS_off;
        Pol_off;
        HeliBladeSpeed 0,"FWD";
        SetDO PN_DO_08,0;
        SetDO PN_DO_09,0;
        SetDO PN_DO_23,0;
        SetDO PN_DO_14,0;
        SetDO PN_DO_15,0;
    ENDPROC
    
    PROC ResetAllIO()
        !Reset all I/Os to default Home state (master tool, no tools active)
        !Call this when at Home position to clear any stuck states
        
        TPWrite "Resetting all I/Os to Home state...";
        
        !VS/Polish motor off
        SetDO PN_DO_18,0;
        
        !Heli blades off
        SetDO PN_DO_19,0;
        SetDO PN_DO_21,0;
        SetAO Local_IO_1_AO1,0;
        
        !Heli stepper off
        SetDO Local_IO_0_DO7,0;
        
        TPWrite "I/O reset complete.";
        
    ENDPROC
        
    
    PROC TC_release()

        AllOutputOff;
        
        SetDO PN_DO_15,1;
        WaitDI PN_DI_15,1 \MaxTime:=5;
        SetDO PN_DO_15,0;
        

    ERROR
        RAISE ;
    ENDPROC

    
    PROC TC_grip()
        !Turn off any electrical connections
        AllOutputOff;

        !Turn off open solenoid
        !Actuate and check for DI signal

        SETDO PN_DO_14,1;
        WaitDI PN_DI_14,1;
        SETDO PN_DO_14,0;


    ERROR
        RAISE ;

    ENDPROC

    PROC HeliBlade_Angle(num angle)
        !Change angle of Helicopter blades
        pulses:=angle*10;
        UpdateToolNum;
        IF ToolNum=2 THEN
            IF angle<0 OR angle>12 THEN
                RAISE ERR_HELI_BLADE_ANGLE;
            ELSE
                
            IF pulses <> GInput(PN_GI_HeliBladeAngle) THEN
    SetDO PN_DO_33,  pulses MOD 2;             ! Bit 0 (LSB)
    SetDO PN_DO_34, (pulses DIV 2)   MOD 2;    ! Bit 1
    SetDO PN_DO_35, (pulses DIV 4)   MOD 2;    ! Bit 2
    SetDO PN_DO_36, (pulses DIV 8)   MOD 2;    ! Bit 3
    SetDO PN_DO_37, (pulses DIV 16)  MOD 2;    ! Bit 4
    SetDO PN_DO_38, (pulses DIV 32)  MOD 2;    ! Bit 5
    SetDO PN_DO_39, (pulses DIV 64)  MOD 2;    ! Bit 6
    SetDO PN_DO_40, (pulses DIV 128) MOD 2;    ! Bit 7 (MSB)
                SetDO PN_DO_23,1;
                WaitDI PN_DI_23,1;
                SetDO PN_DO_23,0;
            ENDIF
            ENDIF
            PitchZOffset:=HeliBladeHeight/2*Sin(angle);
        ELSE
            RAISE ERR_HELI_DISCONNECT;
        ENDIF

    ERROR
        RAISE ;

    ENDPROC


    PROC VS_on()
            SetDO PN_DO_18,1;
            WaitDI PN_DI_18,1;
    ERROR
        RAISE ;

    ENDPROC

    PROC VS_off()
        SetDO PN_DO_18,0;
        WaitDI PN_DI_18,0;
    ENDPROC

    PROC HeliBladeSpeed(num RPM,string DIRECTION)
        !RPM range from 0 to 140, DIRECTION is either "FWD" or "REV"

        VAR num Avoltage:=0;
        UpdateToolNum;
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
                TPWrite "Starting Heli Tool blades.";
                WaitDI PN_DI_19,1;
                WaitTime 0.1;
                SETAO Local_IO_1_AO1,Avoltage;
            ENDIF
        ELSEIF RPM=0 THEN
            SetDO PN_DO_19,0;
            TPWrite "Stopping Heli Tool blades.";
            WaitDI PN_DI_19,0;
        ELSE
            SetDO PN_DO_19,0;
            WaitDI PN_DI_19,0;
            RAISE ERR_HELI_DISCONNECT;

        ENDIF

    ERROR
        RAISE ;

    ENDPROC
    
    PROC Heli_Off()
        SetDO PN_DO_19,0;
        TPWrite "Waiting for Heli Tool blades to stop";
        WaitDI PN_DI_19,0;
    ENDPROC
    


    PROC Heli_Pickup()
        UpdateToolNum;
        IF ToolNum=1 THEN

                WaiTtime\inpos,0.05;
                CurrentJoints:=CJointT();
                CurrentPos:=CalcRobT(CurrentJoints,tTCmaster\WObj:=wobj0);
                IF CurrentPos.trans.z<300 THEN
                    MoveL Offs(CurrentPos,0,0,(500-CurrentPos.trans.z)),v500,z5,tTCMaster;
                ENDIF

            MoveJ pHome,v1500,fine,tTCMaster;
            GripCheck;

            MoveJ Offs(pHeli,0,0,100),v1000,z5,tTCMaster;
            MoveL pHeli,v30,fine,tTCMaster;
            TC_grip;
            MoveL Offs(ptHeli,0,0,50),v50,fine,tHeli;
            TCSlavePresent TRUE;
            HeliBlade_Angle 0;
            MoveJ Offs(ptHeli,0,0,700),v500,z5,tHeli;
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
        UpdateToolNum;
        IF ToolNum=2 THEN
                WaiTtime\inpos,0.05;
                CurrentJoints:=CJointT();
                CurrentPos:=CalcRobT(CurrentJoints,tHeli\WObj:=wobj0);
                IF (CurrentPos.trans.z<250) THEN
                    MoveL Offs(CurrentPos,0,0,(250-CurrentPos.trans.z)),v500,z5,tHeli;
                ENDIF

                Heli_Off;
                ReleaseCheck;

                MoveJ Offs(ptHeli,0,0,700),v500,z5,tHeli;
                MoveJ Offs(ptHeli,0,0,100),v500,z5,tHeli;
                MoveL Offs(ptHeli,0,0,30),v30,fine,tHeli;
                HeliBlade_Angle 0;
                MoveL ptHeli,v30,fine,tHeli;
                TC_release;
                MoveL Offs(pHeli,0,0,50),v50,z5,tTCMaster;
                TCSlavePresent FALSE;
                MoveJ pHome,v1500,z50,tTCMaster;


        ELSE
            !Currently holding different tool
            RAISE ERR_TC_SELECTION;

        ENDIF
    ERROR
        RAISE ;
    ENDPROC
    
    PROC VS_Pickup()
        UpdateToolNum;
        IF ToolNum=1 THEN
            WaiTtime\inpos,0.05;
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tTCmaster\WObj:=wobj0);
            IF CurrentPos.trans.z<500 THEN
                MoveL Offs(CurrentPos,0,0,(500-CurrentPos.trans.z)),v500,z5,tTCMaster;
            ENDIF
            MoveJ pHome,vmax,fine,tTCMaster;
            !home position
            VS_off;
            MoveJ Offs(pVS,-300,0,400 ),vMax,z5,tTCMaster;
            GripCheck;
            MoveJ Offs(pVS,0,0,50),vMax,z5,tTCMaster;
            MoveL pVS3,v30,fine,tTCMaster;
            TC_grip;
            MoveL Offs(ptVS,0,0,80),v50,z5,tVS;
            TCSlavePresent TRUE;
            MoveL Offs(ptVS,0,0,300),v200,z5,tVS;
            MoveL Offs(ptVS,-100,0,450),v200,z5,tVS;
            MoveJ Offs(ptVS,-450,-50,650),v800,z5,tVS;
            MoveL pVSHome3,v800,z5,tVS;

        ELSE
            !Currently holding tool
            RAISE ERR_TC_SELECTION;

        ENDIF
    ERROR
        RAISE ;

    ENDPROC

    PROC VS_Dropoff() 
        UpdateToolNum;
        IF ToolNum=3 THEN
            WaiTtime\inpos,0.05;
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tVS\WObj:=wobj0);
            IF (CurrentPos.trans.z<400) THEN
                MoveL Offs(CurrentPos,0,(2600-CurrentPos.trans.y),(400-CurrentPos.trans.z)),v500,z5,tVS;
            ENDIF

            MoveL pVSHome3,v800,z5,tVS;
            pTemp:=pVSHome3;
            pTemp.trans.x:=pVSHome3.trans.x+1500;
            pTemp.extax.eax_a:=pVSHome3.extax.eax_a+1000;
            VS_Off;
            MoveL Offs(ptVS,-450,0,650),v800,z5,tVS;
            MoveJ Offs(ptVS,-100,0,450),v1000,z5,tVS;
            MoveJ Offs(ptVS,0,0,300),v500,z5,tVS;
            ReleaseCheck;
            MoveL Offs(ptVS,0,0,80),v200,z5,tVS;
            MoveL ptVS,v30,fine,tVS;
            TC_release;
            MoveL Offs(pVS,0,0,50),v50,z5,tTCMaster;
            TCSlavePresent FALSE;
            MoveJ pHome,vMax,z5,tTCMaster;

        ELSE
            !Currently holding different tool
            RAISE ERR_TC_SELECTION;

        ENDIF
    ERROR
        RAISE ;
    ENDPROC

    PROC Plotter_Pickup()
        UpdateToolNum;
        IF ToolNum=1 THEN
            WaiTtime\inpos,0.05;
            MoveJ pHome,v1500,z50,tTCMaster;
            !home position
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tTCmaster\WObj:=wobj0);
            IF CurrentPos.trans.z<500 THEN
                MoveL Offs(CurrentPos,0,0,(500-CurrentPos.trans.z)),v500,z5,tTCMaster;
            ENDIF
            GripCheck;
            MoveJ Offs(pPlotter,0,0,50),v500,z5,tTCMaster;
            MoveL pPlotter,v30,fine,tTCMaster;
            TC_grip;
            MoveL Offs(ptPlotter,0,0,50),v50,z5,tPlotter;
            TCSlavePresent TRUE;
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
        UpdateToolNum;
        IF ToolNum=4 THEN
            WaiTtime\inpos,0.05;
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tPlotter\WObj:=wobj0);
            IF (CurrentPos.trans.z<700) OR (CurrentPos.trans.y<1600) THEN  
                MoveL Offs(CurrentPos,0,1700-CurrentPos.trans.y,(700-CurrentPos.trans.z)),v500,z5,tPlotter;
            ENDIF

            
            MoveL Offs(Reltool(ptPlotter,0,0,0\Rz:=-90),-1500,1600,1000),v500,z5,tPlotter;
            MoveJ Offs(ptPlotter,0,0,600),v500,z5,tPlotter;
            ReleaseCheck;
            MoveJ Offs(ptPlotter,0,0,50),v500,z5,tPlotter;
            MoveL ptPlotter,v20,fine,tPlotter;
            TC_release;
            MoveL Offs(pPlotter,0,0,50),v50,z5,tTCMaster;
            TCSlavePresent FALSE;
            MoveJ pHome,vMax,fine,tTCMaster;
            
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

            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tTCmaster\WObj:=wobj0);
            IF CurrentPos.trans.z<500 THEN
                MoveL Offs(CurrentPos,0,0,(500-CurrentPos.trans.z)),v500,z5,tTCMaster;
            ENDIF
            
            MoveJ RelTool(pVac,0,0,-100),v1000,z5,tTCMaster;
            GripCheck;
            MoveL pVac,v30,fine,tTCMaster;
            TC_grip;
            MoveL Offs(ptVac,0,-5,50),v50,z5,tVac;
            TCSlavePresent TRUE;
            MoveJ Offs(ptVac,0,80,800),v500,z5,tVac;
            pTemp:=ptVac;
            pTemp.extax.eax_a:=ptVac.extax.eax_a-1000;
            pTemp.trans.x:=ptVac.trans.x-1000;
            pTemp.trans.z:=ptVac.trans.z+800;
            MoveJ pTemp,v500,fine,tVac;

        ELSE
            !Currently holding tool
            RAISE ERR_TC_SELECTION;

        ENDIF

    ERROR
        RAISE ;

    ENDPROC
    
    PROC Vac_Dropoff()
        UpdateToolNum;
        IF ToolNum=5 THEN
            WaiTtime\inpos,0.05;
                CurrentJoints:=CJointT();
                CurrentPos:=CalcRobT(CurrentJoints,tVac\WObj:=Bed1Wyong);
                IF (CurrentPos.trans.z<800) THEN
                    MoveL Offs(CurrentPos,0,0,(800-CurrentPos.trans.z)),v500,z5,tVac\WObj:=Bed1Wyong;
                ENDIF

                MoveJ Offs(ptVac,0,150,800),v500,z5,tVac;
                MoveJ Offs(ptVac,0,10,100),v500,z5,tVac;
                ReleaseCheck;
                MoveL ptVac,v30,fine,tVac;
                TC_release;
                MoveL Offs(pVac,0,0,50),v50,z5,tTCMaster;
                TCSlavePresent FALSE;
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
            IF CurrentPos.trans.z<500 THEN
                MoveL Offs(CurrentPos,0,0,(500-CurrentPos.trans.z)),v500,z5,tTCMaster;
            ENDIF
            
            MoveJ pHome,v1500,fine,tTCMaster;

            MoveJ RelTool(pPolish,0,0,-100),vMax,z5,tTCMaster;
            GripCheck;
            MoveJ RelTool(pPolish,0,0,-80),v1000,z5,tTCMaster;
            MoveL pPolish,v30,fine,tTCMaster;
            TC_grip;
            MoveL Offs(ptPolish,0,0,50),v50,z5,tPolish;
            TCSlavePresent TRUE;
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
        UpdateToolNum;
        IF ToolNum=6 THEN
                WaitTime \inpos, 0.05;
                CurrentJoints:=CJointT();
                CurrentPos:=CalcRobT(CurrentJoints,tPolish\WObj:=wobj0);
                IF (CurrentPos.trans.z<700) THEN
                    MoveL Offs(CurrentPos,0,0,(700-CurrentPos.trans.z)),v500,z5,tPolish;
                ENDIF
                pTemp:=ptPolishHome;
                pTemp.extax.eax_a:=ptPolishHome.extax.eax_a-1700;
                pTemp.trans.x:=ptPolishHome.trans.x-1700;
                pTemp.trans.y:=ptPolishHome.trans.y-300;
                MoveJ pTemp,v500,z5,tPolish;
                
                MoveJ ptPolishHome,v500,z5,tPolish;

                MoveJ Offs(ptPolish,0,0,500),v500,z5,tPolish;
                ReleaseCheck;
                MoveJ Offs(ptPolish,0,0,100),v500,z5,tPolish;
                MoveL ptPolish,v30,fine,tPolish;
                TC_release;
                MoveL RelTool(pPolish,0,0,-50),v50,z5,tTCMaster;
                TCSlavePresent FALSE;
                MoveJ RelTool(pPolish,0,0,-100),v50,z5,tTCMaster;
                MoveJ pHome,vMax,z50,tTCMaster;

 

        ELSE
            !Currently holding different tool
            RAISE ERR_TC_SELECTION;

        ENDIF
    ERROR
        RAISE ;
    ENDPROC
    
    PROC Pol_on()
            SetDO PN_DO_17,1;
            WaitDI PN_DI_17,1;
    ERROR
        RAISE ;

    ENDPROC
    
    PROC Pol_off()
        SetDO PN_DO_17,0;
        WaitDI PN_DI_17,0;
    ENDPROC
    
    PROC Vac_on()
    ENDPROC
    
    PROC Vac_off()
    ENDPROC
    
    PROC UpdateToolNum()
        Toolnum:=dnumtonum (GInputDnum (PN_GI_Toolnum));
    ENDPROC
    
    PROC GripCheck()
        ToolheldCheck;
        AirPressureCheck;
    ERROR
        RAISE ;
    ENDPROC
        
    PROC ReleaseCheck()
        AirPressureCheck;
    ERROR
        RAISE ;
    ENDPROC
    
    PROC ToolheldCheck()
        IF TESTDI (PN_DI_16) THEN
            RAISE ERR_TC_SELECTION;
        ENDIF
    ERROR
        RAISE ;
    ENDPROC
    
    PROC TCSlavePresent (bool Expected)
        WaitTime \inpos,0.05;
        IF Expected AND (TestDI(PN_DI_10) = FALSE) THEN
            RAISE ERR_TC_SLAVE_PROX;
        ELSEIF Expected=FALSE AND (TestDI (PN_DI_10) = TRUE) THEN
            RAISE ERR_TC_SLAVE_PROX;
        ENDIF
    ERROR
        RAISE ;
    ENDPROC
    
    PROC AirPressureCheck()
        IF TESTDI (PN_DI_11) = FALSE THEN
            RAISE ERR_AIR_PRESSURE;
        ENDIF
    ERROR
        RAISE ;
    ENDPROC

ENDMODULE