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
    
    VAR errnum ERR_PLOT_POS:=-1;
    
    VAR errnum ERR_INVALID_INPUT:=-1;


    VAR intnum STPAlarm;
    
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
        
    ENDPROC
        

    PROC Interrupts()
        IF STPAlarm=0 THEN
            CONNECT STPAlarm WITH iSTPAlarm;
            ISignalDI Local_IO_0_DI1,1,STPAlarm;
        ENDIF

    ENDPROC

    TRAP iSTPAlarm
        TPWrite "Heli stepper motor has missed a step";
    ENDTRAP


ENDMODULE