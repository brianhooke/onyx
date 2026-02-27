MODULE ForceMonitor
    
    ! ************Declare tool and load (adjust based on your setup)
  !PERS tooldata myTool := [TRUE, [[0,0,0],[1,0,0,0]], [1,[0,0,0],[1,0,0,0],0,0,0]];
  !PERS loaddata myLoad := [0.001,[0,0,0.001],[1,0,0,0],0,0,0];

  ! Persistent force values - readable via RWS API
    PERS num fm_fx := 0;
    PERS num fm_fy := 0;
    PERS num fm_fz := 0;
    PERS num fm_tx := 0;
    PERS num fm_ty := 0;
    PERS num fm_tz := 0;
    PERS num fm_status := 0;  ! 1 = active, 0 = inactive
    
  VAR fcforcevector forces;
  
  PROC force_monitor()
    ! **********One-time setup: Calibrate if not done (run manually first if needed)
    !myLoad := FCLoadID();
    !FCCalib myLoad;

    ! ************Optional: Activate force mode for active sensing during motion
    ! FCAct myTool \Load:=myLoad;

    ! Mark as active
    fm_status := 1;
    
    ! **************Continuous loop to read and output forces
    WHILE TRUE DO
      forces := FCGetForce();

      ! Update PERS variables (readable via RWS API)
      fm_fx := forces.xforce;
      fm_fy := forces.yforce;
      fm_fz := forces.zforce;
      fm_tx := forces.xtorque;
      fm_ty := forces.ytorque;
      fm_tz := forces.ztorque;

      ! Set analog outputs (scale if values exceed AO limits, e.g., /10)
      SetAO AO_Force_X, forces.xforce;  
      SetAO AO_Force_Y, forces.yforce;
      SetAO AO_Force_Z, forces.zforce;
      SetAO AO_Force_TX, forces.xtorque;
      SetAO AO_Force_TY, forces.ytorque;
      SetAO AO_Force_TZ, forces.ztorque;

      ! Small delay to avoid CPU overload (adjust for sample rate, e.g., 10-100 ms)
      WaitTime 0.01;
    ENDWHILE
    
  ENDPROC
  
ENDMODULE