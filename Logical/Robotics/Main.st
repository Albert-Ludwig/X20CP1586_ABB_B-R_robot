PROGRAM _INIT
	fbMy6Axis.Enable := TRUE;
	fbMy6Axis.MpLink := ADR(g6AxRobA);
	fbMy6Axis.Override := 10;
	fbMy6Axis.Parameters := ADR(My6Axis_Par);
	My6Axis_Par.ProgramName := 'Robotic.st';
	PowerButton.Enable := TRUE;
	SingleStepButton.Enable := TRUE;
	LogInButton.Enable := TRUE;
	ManualButton.Enable := TRUE;
	ServiceButton.Enable := TRUE;
	SettingButton.Enable := TRUE;
	CurrentPage := 'Main Page(Monitor)';
	Message:='Hello, welcome to B&R robotics.';
	
END_PROGRAM

PROGRAM _CYCLIC
	
	fbMy6Axis();
	
	//About the enability
	 
	// highest priority
	IF fbMy6Axis.Power=FALSE THEN
		HomeButton.Enable:=FALSE;
		RunButton.Enable:=FALSE;
		InterruptButton.Enable:=FALSE;
		ContinueButton.Enable:=FALSE;
		SingleStepButton.Enable:=FALSE;
	END_IF 
	
	IF fbMy6Axis.Power=TRUE THEN
		HomeButton.Enable:=TRUE;
		RunButton.Enable:=TRUE;
		InterruptButton.Enable:=TRUE;
	END_IF
	
	// Only valid when power is on
	IF fbMy6Axis.Power=TRUE AND fbMy6Axis.MoveProgram=TRUE THEN
		PowerButton.Enable:=FALSE;
		HomeButton.Enable:=FALSE;
		RunButton.Enable:=FALSE;
		SingleStepButton.Enable:=FALSE;
		LogInButton.Enable:=FALSE;
		ManualButton.Enable:=FALSE;
		ServiceButton.Enable:=FALSE;
		SettingButton.Enable:=FALSE;
		InterruptButton.Enable:=TRUE;
		ContinueButton.Enable:=TRUE;
	END_IF
	
	IF fbMy6Axis.Power=TRUE AND fbMy6Axis.MoveProgram=FALSE THEN
		PowerButton.Enable:=TRUE;
		HomeButton.Enable:=TRUE;
		RunButton.Enable:=TRUE;
		SingleStepButton.Enable:=TRUE;
		LogInButton.Enable:=TRUE;
		ManualButton.Enable:=TRUE;
		ServiceButton.Enable:=TRUE;
		SettingButton.Enable:=TRUE;
		InterruptButton.Enable:=FALSE;
		ContinueButton.Enable:=FALSE;
	END_IF 
	
	// only valid when power is on and inmotion is false
	IF fbMy6Axis.IsHomed=FALSE AND fbMy6Axis.Power=TRUE AND fbMy6Axis.MoveProgram=FALSE THEN
		RunButton.Enable:=FALSE;
		SingleStepButton.Enable:=FALSE;
	END_IF
	
	IF fbMy6Axis.IsHomed=TRUE AND fbMy6Axis.Power=TRUE AND fbMy6Axis.MoveProgram=FALSE THEN
		RunButton.Enable:=TRUE;
		SingleStepButton.Enable:=TRUE;
	END_IF
	
	//Auto reset
	IF fbMy6Axis.MoveDone = TRUE THEN
		fbMy6Axis.MoveProgram := FALSE;
		fbMy6Axis.MoveDirect :=FALSE;
	END_IF
	
	IF fbMy6Axis.IsHomed = TRUE THEN
		fbMy6Axis.Home:=FALSE;
	END_IF
	
	IF fbMy6Axis.Error = FALSE THEN
		fbMy6Axis.ErrorReset:=FALSE;
	END_IF
	
	
	// the single step mode
	IF fbMy6Axis.Power=TRUE AND fbMy6Axis.SingleStep=TRUE THEN
		IF fbMy6Axis.Continue=TRUE AND fbMy6Axis.MoveInterrupted=TRUE THEN
			fbMy6Axis.Continue:=FALSE;
		END_IF
		IF fbMy6Axis.MoveInterrupted=FALSE THEN
			ContinueButton.Enable:=FALSE;
		END_IF
	END_IF
	
	// Message display
	IF fbMy6Axis.Power=TRUE AND fbMy6Axis.IsHomed=FALSE THEN
		Message:='The robotics has not homed yet.';
	END_IF
	
	IF fbMy6Axis.Error=TRUE THEN
		Message:='Error! Please check the SDM and reset the error.';
	END_IF
	
	IF fbMy6Axis.Power=TRUE AND fbMy6Axis.IsHomed=TRUE THEN
		Message:='The robotics is homed.';
	END_IF 
	
	IF fbMy6Axis.Power=TRUE AND fbMy6Axis.IsHomed=TRUE THEN
		IF fbMy6Axis.MoveProgram=TRUE THEN
			Message:='The robotics is moving and driven by program.';
			IF fbMy6Axis.Interrupt=TRUE THEN
				Message:='The program is interrupted.';
			ELSIF fbMy6Axis.Continue=TRUE THEN
				Message:='The robotics is moving and driven by program.';
			END_IF
		END_IF
	END_IF
	
	IF fbMy6Axis.Power=TRUE AND fbMy6Axis.MoveProgram=FALSE AND fbMy6Axis.IsHomed=TRUE THEN
		IF fbMy6Axis.InMotion=TRUE THEN
			Message:='The robotics is moving and driven by manual input.';
		END_IF
	END_IF
			
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

