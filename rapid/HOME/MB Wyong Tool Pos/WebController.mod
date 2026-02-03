MODULE WebController
!    VAR string command := "";
!    VAR bool new_command := FALSE;

!    PROC WebControlMain()
!        WHILE TRUE DO
!            IF new_command THEN
!                ProcessCommand command;
!                new_command := FALSE;
!            ENDIF
!            WaitTime 0.1;
!        ENDWHILE
!    ENDPROC

!    PROC ProcessCommand(string cmd)
!        IF cmd = "MOVE_FORWARD" THEN
!            MoveJ [[500,0,500],[0,0,1,0],0,0,0], v1000, fine, tool0;
!        ELSEIF cmd = "MOVE_HOME" THEN
!            MoveJ [[0,0,500],[0,0,1,0],0,0,0], v1000, fine, tool0;
!        ELSE
!            TPWrite "Unknown command: " + cmd;
!        ENDIF
!    ENDPROC
ENDMODULE
