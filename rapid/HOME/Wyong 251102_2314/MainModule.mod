MODULE MainModule
    PROC main()
        HeliBladeSpeed 0,"FWD";
        Pol_off;
        Vac_off;
        VS_off;
        !Turn off Helicopter
        InitialiseERRORs;
        !Turn on custom errors
        Interrupts;
        !Turn on any interrupts
            
        WHILE TRUE DO
            
            Polish;
            
            
            
            Stop;
            
        ENDWHILE
        
        
        
        WHILE TRUE DO
            TaskToDo;
        ENDWHILE


        !Error Handling
    ERROR
        TEST ERRNO

        CASE ERR_WAIT_MAXTIME:
            ErrWrite "ERR_WAIT_MAXTIME","Robot has not recieved signal, check air compressor pressure.";
            SetDO Local_IO_0_DO9,0;
            SetDO Local_IO_0_DO10,0;
            SetDO Local_IO_0_DO11,0;
            SetDO Local_IO_0_DO12,0;
            IF ToolNum=1 THEN
                SETDO Local_IO_0_DO13,0;
                SETDO Local_IO_0_DO14,0;
            ENDIF
            EXIT;

        CASE ERR_HELI_DISCONNECT:
            ErrWrite "ERR_HELI_DISCONNECT","Helicopter Tool is not coupled but power is trying to be supplied.";
            EXIT;

        CASE ERR_VS_DISCONNECT:
            ErrWrite "ERR_VS_DISCONNECT","Vibrating Screed Tool is not coupled but power is trying to be supplied.";
            EXIT;

        CASE ERR_HELI_BLADE_ANGLE:
            ErrWrite "ERR_HELI_BLADE_ANGLE","Helicopter Tool blade angle is outside the expected 0 to 12 degrees.";
            EXIT;

        CASE ERR_HELI_BLADE_SPEED:
            ErrWrite "ERR_HELI_BLADE_SPEED","Blade speed is outside the expected 0 to 140 degrees.";
            EXIT;

        CASE ERR_HELI_BLADE_DIRECTION:
            ErrWrite "ERR_HELI_BLADE_DIRECTION","The Helicopter Tool blade direction has not been specified as FWD or REV.";
            EXIT;

        CASE ERR_TS_CONFLICT:
            ErrWrite "ERR_TS_CONFLICT","Robot is too close to a toolbox while the lid is trying to be closed or opened.";
            EXIT;

        CASE ERR_TC_SELECTION:
            ErrWrite "ERR_TC_SELECTION","Tool changer state has tried to be changed outside of normal operating";
            EXIT;

        CASE ERR_PLOT_POS:
            ErrWrite "ERR_PLOT_POS","Plotting position outside the expected";
            EXIT;

        CASE ERR_INVALID_INPUT:
            ErrWrite "ERR_INVALID_INPUT","Input on teach pendant outside of expected bounds";
            EXIT;

        ENDTEST
        EXIT;

    ENDPROC
ENDMODULE