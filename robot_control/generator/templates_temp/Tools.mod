MODULE Tools
    !*******************************************************************
    ! Tool procedures and runtime variables
    ! CONST/PERS declarations moved to FixedParameters.mod
    !*******************************************************************

    ! Runtime variables
    PERS num ToolNum:=1;
    PERS num StepperPos:=0;
    VAR num StepPulseLength:=0.05;
    VAR robtarget safetypos;
    VAR jointtarget SafetyJoints:= [[86.92,9.65,27.89,0.50,50.60,-4.00],[1388.98,0,0,0,0,0]];
    
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
        RAISE ;

    ENDPROC

    PROC Heli_Step(num PULSES)
        !Move stepper number of PULSES
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

            MoveJ pVSint1,v500,z5,tTCMaster;
            MoveJ Offs(pVS2,0,0,50),v500,z5,tTCMaster;
            MoveL pVS2,v30,fine,tTCMaster;
            TC_grip(3);
            MoveL Offs(ptVS2,0,0,100),v50,z5,tVS;
            MoveL Offs(ptVS2,0,0,600),v500,z5,tVS;
            MoveL Offs(Reltool(ptVS2,0,0,0\Rz:=-90),-1500,1600,1000),v500,z5,tVS;
            
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

            MoveJ pVSHome2,v1000,z5,tVS;
            pTemp:=pVSHome2;
            pTemp.trans.x:=pVSHome2.trans.x+1500;
            pTemp.extax.eax_a:=pVSHome2.extax.eax_a+1000;
            VS_Off;
            MoveJ Offs(ptVS2,-300,0,650),v1000,z5,tVS;
            MoveJ Offs(ptVS2,-100,0,250),v200,z5,tVS;
            MoveJ Offs(ptVS2,0,0,100),v200,z5,tVS;
            MoveL ptVS2,v30,fine,tVS;
            TC_release;
            MoveL Offs(pVS2,0,0,50),v50,z5,tTCMaster;
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
            IF TestDI(Local_IO_0_DI13)<>TRUE THEN
                TC_release;
            ENDIF

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
    
    
    

ENDMODULE