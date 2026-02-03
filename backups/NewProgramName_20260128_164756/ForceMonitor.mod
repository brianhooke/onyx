MODULE ForceMonitor
    !*******************************************************************
    ! ForceMonitor - Background force/torque sensor monitoring
    ! 
    ! Exposes force sensor values as PERS variables for external access
    ! via Robot Web Services (RWS). Run ForceMonitorStart to begin
    ! continuous monitoring at 2Hz.
    !
    ! Variables exposed:
    !   fm_fx, fm_fy, fm_fz - Forces in Newtons
    !   fm_tx, fm_ty, fm_tz - Torques in Nm
    !   fm_status - 1=running, 0=stopped
    !*******************************************************************
    
    ! Force values (Newtons)
    PERS num fm_fx:=0;
    PERS num fm_fy:=0;
    PERS num fm_fz:=0;
    
    ! Torque values (Nm)
    PERS num fm_tx:=0;
    PERS num fm_ty:=0;
    PERS num fm_tz:=0;
    
    ! Status: 1=running, 0=stopped
    PERS num fm_status:=0;
    
    ! Control flag for loop
    VAR bool fm_running:=FALSE;
    
    ! Force vector for reading
    VAR forcevector fm_forces;
    
    
    PROC ForceMonitorStart()
        !***************************************************************
        ! Start continuous force monitoring at 2Hz
        ! Call this procedure to begin updating force values
        ! The loop will run until ForceMonitorStop is called
        !***************************************************************
        
        fm_running:=TRUE;
        fm_status:=1;
        TPWrite "ForceMonitor: Started (2Hz)";
        
        WHILE fm_running DO
            ! Read current force/torque values
            fm_forces:=FCGetForce(\Tool:=tHeli);
            
            ! Update exposed variables
            fm_fx:=fm_forces.xforce;
            fm_fy:=fm_forces.yforce;
            fm_fz:=fm_forces.zforce;
            fm_tx:=fm_forces.xtorque;
            fm_ty:=fm_forces.ytorque;
            fm_tz:=fm_forces.ztorque;
            
            ! Wait 0.5 seconds (2Hz polling rate)
            WaitTime 0.5;
        ENDWHILE
        
        fm_status:=0;
        TPWrite "ForceMonitor: Stopped";
        
    ERROR
        fm_status:=0;
        fm_running:=FALSE;
        TPWrite "ForceMonitor: Error - " \Num:=ERRNO;
        RAISE;
    ENDPROC
    
    
    PROC ForceMonitorStop()
        !***************************************************************
        ! Stop the force monitoring loop
        !***************************************************************
        fm_running:=FALSE;
        TPWrite "ForceMonitor: Stop requested";
    ENDPROC
    
    
    PROC ForceMonitorOnce()
        !***************************************************************
        ! Read force values once (no loop)
        ! Useful for single readings without continuous monitoring
        !***************************************************************
        fm_forces:=FCGetForce(\Tool:=tHeli);
        
        fm_fx:=fm_forces.xforce;
        fm_fy:=fm_forces.yforce;
        fm_fz:=fm_forces.zforce;
        fm_tx:=fm_forces.xtorque;
        fm_ty:=fm_forces.ytorque;
        fm_tz:=fm_forces.ztorque;
        
        TPWrite "Fx=" \Num:=fm_fx \NoNewLine;
        TPWrite " Fy=" \Num:=fm_fy \NoNewLine;
        TPWrite " Fz=" \Num:=fm_fz;
        TPWrite "Tx=" \Num:=fm_tx \NoNewLine;
        TPWrite " Ty=" \Num:=fm_ty \NoNewLine;
        TPWrite " Tz=" \Num:=fm_tz;
        
    ERROR
        TPWrite "ForceMonitorOnce: Error - " \Num:=ERRNO;
        RAISE;
    ENDPROC
    
ENDMODULE
