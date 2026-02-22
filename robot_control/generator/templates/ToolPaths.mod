MODULE ToolPaths
    !*******************************************************************
    ! CLEANED MODULE - Legacy code removed
    ! Only contains: PackAway, Home procedures
    ! PERS wobjdata moved to FixedParameters.mod
    ! Python generators inject Py2* procedures at runtime
    !*******************************************************************


    PROC PackAway()
        !VAR jointtarget jtTarget;
        Home;
        !jtTarget := [[138.31,-55.47,60.29,-0.02,84.30,-2.02], [9416.99,9E+09,9E+09,9E+09,9E+09,9E+09]];
        !MoveAbsJ jtTarget, v500, fine, tTCMaster;
        MoveJ pHomeLoadout,v500,z50,tTCMaster;
    ERROR
        RAISE ;
    ENDPROC


    PROC Home()
        !Move robot to safe position, drop off any tools, close tool boxes

        TEST ToolNum

        CASE 1:
            !TCmaster
            !Check for any tb lids open and robot in tool stations
            !Move to Home
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tTCMaster\WObj:=wobj0);

            IF (CurrentPos.trans.x)>8000 AND (CurrentPos.trans.z<265) THEN
                TPErase;
                TPWrite("Jog robot out of tool station AND HOME");
                Stop;
            ENDIF

        CASE 2:
            !Heli
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tHeli\WObj:=wobj0);

            IF (CurrentPos.trans.x)>8000 AND CurrentPos.trans.z<125 THEN
                TPWrite("Jog robot out of tool station AND HOME");
                Stop;
            ENDIF

            IF CurrentPos.trans.y>(Bed1.uframe.trans.y+3000) THEN
                MoveL Offs(CurrentPos,0,(3000-CurrentPos.trans.y),50),v10,z5,tHeli\WObj:=wobj0;
                MoveJ Offs(CurrentPos,0,(3000-CurrentPos.trans.y),300-CurrentPos.trans.z),v100,z5,tHeli\WObj:=wobj0;
            ENDIF
            Heli_Dropoff;

        CASE 3:
            !VS

            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tVS\WObj:=wobj0);


            IF (CurrentPos.trans.x)>8000 AND CurrentPos.trans.z<265 THEN
                TPErase;
                TPWrite("Jog robot out of tool station AND HOME");
                Stop;
            ELSEIF CurrentPos.trans.z<200 THEN
                MoveL Offs(CurrentPos,0,0,(200-CurrentPos.trans.z)),v500,z5,tVS;

            ENDIF


            VS_Dropoff;


        CASE 4:
            !Plotter

            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tPlotter\WObj:=wobj0);

            IF CurrentPos.trans.z<270 AND (CurrentPos.trans.x)<8000 THEN
                MoveL Offs(CurrentPos,0,0,(270-CurrentPos.trans.z)),v500,z5,tPlotter;
            ENDIF

            IF (CurrentPos.trans.x)>8000 AND CurrentPos.trans.z<265 THEN
                TPErase;
                TPWrite("Jog robot out of tool station AND HOME");
                Stop;
            ENDIF

            IF CurrentPos.trans.y>(Bed1.uframe.trans.y+3300) THEN
                MoveL Offs(CurrentPos,0,(3300-CurrentPos.trans.y),50),v10,z5,tPlotter\WObj:=wobj0;
                MoveJ Offs(CurrentPos,0,(3300-CurrentPos.trans.y),1000-CurrentPos.trans.z),v100,z5,tPlotter\WObj:=wobj0;
            ENDIF
            Plotter_Dropoff;

        CASE 5:
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tVac\WObj:=wobj0);

            IF (CurrentPos.trans.x)>8000 AND CurrentPos.trans.z<265 THEN
                TPErase;
                TPWrite("Jog robot out of tool station AND HOME");
                Stop;
            ENDIF
            IF CurrentPos.trans.z<200 AND (CurrentPos.trans.x)<8000 THEN
                MoveL Offs(CurrentPos,0,0,(200-CurrentPos.trans.z)),v500,fine,tVac;
            ENDIF
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tVac\WObj:=wobj0);
            IF CurrentPos.trans.y>(Bed1.uframe.trans.y+3000) THEN
                MoveL Offs(CurrentPos,0,(3000-CurrentPos.trans.y),50),v200,z5,tVac\WObj:=wobj0;
                MoveJ Offs(CurrentPos,0,(3000-CurrentPos.trans.y),700-CurrentPos.trans.z),v200,z5,tVac\WObj:=wobj0;
            ENDIF
            Vac_Dropoff;

        CASE 6:
            CurrentJoints:=CJointT();
            CurrentPos:=CalcRobT(CurrentJoints,tPolish\WObj:=wobj0);


            IF (CurrentPos.trans.x)>8000 AND CurrentPos.trans.z<265 THEN
                TPErase;
                TPWrite("Jog robot out of tool station AND HOME");
                Stop;

            ENDIF
            Polish_Dropoff;

        DEFAULT:
            !Unknown
            RAISE ERR_TC_SELECTION;

        ENDTEST

        MoveJ pHome,v500,fine,tTCMaster;

    ERROR
        RAISE ;

    ENDPROC

ENDMODULE
