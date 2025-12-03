MODULE ForceMonitor
    !*********************************************************
    ! ForceMonitor - Reads ATI Force/Torque sensor data
    ! and exposes values for external monitoring via RWS
    !
    ! Usage: Load this module and call ForceMonitorLoop()
    ! from a background task, or call ForceReadOnce() 
    ! periodically from your main program.
    !
    ! The PERS variables can be read via Robot Web Services:
    ! /rw/rapid/symbol/data/RAPID/T_ROB1/ForceMonitor/fm_fx
    !*********************************************************
    
    ! Persistent variables for force values (Newtons)
    PERS num fm_fx := 0;
    PERS num fm_fy := 0;
    PERS num fm_fz := 0;
    
    ! Persistent variables for torque values (Newton-meters)
    PERS num fm_tx := 0;
    PERS num fm_ty := 0;
    PERS num fm_tz := 0;
    
    ! Timestamp of last reading (for staleness detection)
    PERS num fm_timestamp := 0;
    
    ! Status flag (0=stopped, 1=running, -1=error)
    PERS num fm_status := 0;
    
    ! Update rate in seconds (0.05 = 20Hz, 0.25 = 4Hz)
    CONST num UPDATE_INTERVAL := 0.05;
    
    ! Force vector for FCGetForce
    VAR fcforcevector forceVec;
    
    !*********************************************************
    ! ForceReadOnce - Single force reading
    ! Call this from your program to update force values once
    !*********************************************************
    PROC ForceReadOnce()
        VAR bool ok;
        
        ! Read force/torque from sensor
        ! FCGetForce returns forces in tool frame by default
        ok := FCGetForce(forceVec);
        
        IF ok THEN
            ! Extract individual components
            fm_fx := forceVec.fx;
            fm_fy := forceVec.fy;
            fm_fz := forceVec.fz;
            fm_tx := forceVec.tx;
            fm_ty := forceVec.ty;
            fm_tz := forceVec.tz;
            fm_timestamp := GetTime(\Numeric);
            fm_status := 1;
        ELSE
            fm_status := -1;
        ENDIF
    ENDPROC
    
    !*********************************************************
    ! ForceMonitorLoop - Continuous monitoring loop
    ! Run this in a background task for continuous updates
    !*********************************************************
    PROC ForceMonitorLoop()
        fm_status := 1;
        
        WHILE TRUE DO
            ForceReadOnce;
            WaitTime UPDATE_INTERVAL;
        ENDWHILE
    ERROR
        fm_status := -1;
        TRYNEXT;
    ENDPROC
    
    !*********************************************************
    ! ForceMonitorStart - Start monitoring (alias)
    !*********************************************************
    PROC ForceMonitorStart()
        ForceMonitorLoop;
    ENDPROC
    
    !*********************************************************
    ! ForceMonitorStop - Stop monitoring
    ! Note: This only works if called from another task
    !*********************************************************
    PROC ForceMonitorStop()
        fm_status := 0;
    ENDPROC
    
ENDMODULE
