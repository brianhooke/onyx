MODULE ErrorHandling
    VAR errnum ERR_VS_DISCONNECT:=-1;
    !VS not connected to tool
    VAR errnum ERR_HELI_BLADE_ANGLE:=-1;
    !Heli blade angle
    VAR errnum ERR_HELI_BLADE_SPEED:=-1;
    !Heli blade angle
    VAR errnum ERR_HELI_DISCONNECT:=-1;
    !Heli not connected to tool
    VAR errnum ERR_TS_CONFLICT:=-1;
    !Robot is near tool station during lid opening
    VAR errnum ERR_TC_SELECTION:=-1;
    !Tool changer state has tried to be changed outside of normal operating
    VAR errnum ERR_HELI_BLADE_DIRECTION:=-1;
    !Incorrect input for Helicopter blade direction
    VAR errnum ERR_PLOT_POS:=-1;
    !Incorrect input for plotter position
    VAR errnum ERR_INVALID_INPUT:=-1;
    !Incorrect input into Flex Pendant
    VAR errnum ERR_POLISH_DISCONNECT:=-1;
    !Polish tool not connected
    VAR errnum ERR_AIR_PRESSURE:=-1;
    !Less than 5 bar of pressure from regulator
    VAR errnum ERR_TC_SLAVE_PROX:=-1;
    !Toolchanger slave proximity reading incorrect to expected value
    


    VAR intnum STPAlarm;
    VAR intnum toolnumUpdate;
    VAR intnum RequestAccess;

    PROC InitialiseERRORs()

        BookErrNo ERR_VS_DISCONNECT;
        BookErrNo ERR_HELI_BLADE_ANGLE;
        BookErrNo ERR_HELI_BLADE_SPEED;
        BookErrNo ERR_HELI_DISCONNECT;
        BookErrNo ERR_TS_CONFLICT;
        BookErrNo ERR_TC_SELECTION;
        BookErrNo ERR_HELI_BLADE_DIRECTION;
        BookErrNo ERR_PLOT_POS;
        BookErrNo ERR_INVALID_INPUT;
        BookErrNo ERR_POLISH_DISCONNECT;
        BookErrNo ERR_AIR_PRESSURE;
        BookErrNo ERR_TC_SLAVE_PROX;

    ENDPROC


    PROC Interrupts()
        UpdateToolNum; !Set toolnum on startup
        SetDO PN_DO_10,0;
        SetDO PN_DO_14, 0;
        SetDO PN_DO_15,0;
        SetDO PN_DO_17,0;
        SetDO PN_DO_18,0;
        SetDO PN_DO_19,0;
        SetDO PN_DO_23,0;
        WaitTime \inpos, 0.2;
        StartMove;
        IF STPAlarm=0 THEN
            CONNECT STPAlarm WITH iSTPAlarm;
            ISignalDI Local_IO_0_DI1,1,STPAlarm;
        ENDIF
        IF toolnumUpdate=0 THEN
            CONNECT toolnumUpdate WITH itoolnumUpdate;
            ISignalDI PN_dI_24,1,toolnumUpdate;
        ENDIF
        IF RequestAccess=0 THEN
            CONNECT RequestAccess WITH iRequestAccess;
            ISignalDI PN_DI_09,1,RequestAccess;
        ENDIF
        
        IEnable;
    ENDPROC

    TRAP iSTPAlarm
        TPWrite "Heli stepper motor has missed a step";
        PulseDO\PLength:=StepPulseLength,Local_IO_0_DO8;
        WaitTime(StepPulseLength*2);
    ENDTRAP

    TRAP itoolnumUpdate  !Updates toolnum based on PLC change
        Toolnum:=dnumtonum (GInputDnum (PN_GI_Toolnum));
        SetDO PN_DO_24,1;
        WaitDI PN_DI_24,0;
        SetDO PN_DO_24,0;
        RETURN;
    ENDTRAP    
    
    TRAP iRequestAccess
        StopMove;
        ClearPath;
        AllOutputOff;
        SetDO PN_DO_10,1;
        RETURN;
    ENDTRAP
    
ENDMODULE