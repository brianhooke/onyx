MODULE ForceMonitor
    
    
    ! ************Declare tool and load (adjust based on your setup)
  !PERS tooldata myTool := [TRUE, [[0,0,0],[1,0,0,0]], [1,[0,0,0],[1,0,0,0],0,0,0]];
  !PERS loaddata myLoad := [0.001,[0,0,0.001],[1,0,0,0],0,0,0];

  VAR fcforcevector forces;
  
  PROC force_monitor()
    ! **********One-time setup: Calibrate if not done (run manually first if needed)
    !myLoad := FCLoadID();
    !FCCalib myLoad;

    ! ************Optional: Activate force mode for active sensing during motion
    ! FCAct myTool \Load:=myLoad;

    ! **************Continuous loop to read and output forces
    WHILE TRUE DO
      forces := FCGetForce();

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