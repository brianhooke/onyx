MODULE Toolstations
    VAR num TStimer:=10;
    VAR robtarget CurrentPos;
    VAR jointtarget CurrentJoints;

    PROC VSBox_Open()
        StopMove;
        ! Check that robot isn't over the box

        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tool0\WObj:=wobj0);

        IF ((CurrentPos.trans.x+CurrentPos.extax.eax_a)<1250 AND (CurrentPos.trans.x+CurrentPos.extax.eax_a)>-400) AND (CurrentPos.trans.z<1200) THEN
            !Robot too close to box lid
            RAISE ERR_TS_CONFLICT;
            Stop;
        ELSE

            SetDO Local_IO_0_DO9,0;
            SetDO Local_IO_0_DO10,1;
            WaitDI Local_IO_0_DI9,1\Maxtime:=TStimer;
            IF TestDI(Local_IO_0_DI9)<>TRUE THEN
                EXIT;
            ENDIF
        ENDIF

        StartMove;

    ERROR
        RAISE ;
    ENDPROC

    PROC VSBox_Close()
        StopMove;

        ! Check that robot isn't in the box
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tTCMaster\WObj:=wobj0);

        IF ((CurrentPos.trans.x+CurrentPos.extax.eax_a)<1250 AND (CurrentPos.trans.x+CurrentPos.extax.eax_a)>-400) AND (CurrentPos.trans.z<1200) THEN
            !Robot too close to box lid
            RAISE ERR_TS_CONFLICT;
            Stop;
        ELSE
            SetDO Local_IO_0_DO10,0;
            SetDO Local_IO_0_DO9,1;
            WaitDI Local_IO_0_DI11,1\MaxTime:=TStimer;
            IF TestDI(Local_IO_0_DI11)<>TRUE THEN
                EXIT;
            ENDIF
            SetDO Local_IO_0_DO9,0;
        ENDIF

        StartMove;

    ERROR
        RAISE ;
    ENDPROC

    PROC HeliBox_Open()
        StopMove;

        ! Check that robot isn't over the box
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tTCMaster\WObj:=wobj0);

        IF (((CurrentPos.trans.x+CurrentPos.extax.eax_a)<-500 AND (CurrentPos.trans.x+CurrentPos.extax.eax_a)>-2400) AND (CurrentPos.trans.z<1400)) OR ((CurrentPos.trans.x+CurrentPos.extax.eax_a)<0 AND (CurrentPos.trans.z<2700) AND ToolNum=2) THEN
            !Robot too close to box lid
            RAISE ERR_TS_CONFLICT;
            Stop;
        ELSE
            SetDO Local_IO_0_DO11,0;
            SetDO Local_IO_0_DO12,1;
            WaitDI Local_IO_0_DI12,1\MaxTime:=TStimer;
            IF TestDI(Local_IO_0_DI12)<>TRUE THEN
                EXIT;
            ENDIF
        ENDIF

        StartMove;

    ERROR
        RAISE ;
    ENDPROC

    PROC HeliBox_Close()
        StopMove;

        ! Check that robot isn't in the box
        CurrentJoints:=CJointT();
        CurrentPos:=CalcRobT(CurrentJoints,tool0\WObj:=wobj0);

        IF ((CurrentPos.trans.x+CurrentPos.extax.eax_a)<-500 AND (CurrentPos.trans.x+CurrentPos.extax.eax_a)>-2400) AND (CurrentPos.trans.z<1400) THEN
            !Robot too close to box lid
            RAISE ERR_TS_CONFLICT;
            Stop;
        ELSE
            SetDO Local_IO_0_DO12,0;
            SetDO Local_IO_0_DO11,1;
            WaitDI Local_IO_0_DI10,1\MaxTime:=TStimer;
            IF TestDI(Local_IO_0_DI10)<>TRUE THEN
                EXIT;
            ENDIF
            SetDO Local_IO_0_DO11,0;
        ENDIF

        StartMove;

    ERROR
        RAISE ;
    ENDPROC

ENDMODULE