
PROGRAM _INIT
	 
END_PROGRAM

PROGRAM _CYCLIC
	// set time
	IF(visGetDateTime) THEN
		DTGetTime_01.enable := 1;
		IF(DTGetTime_01.status = 0) THEN
			visGetDateTime := 0;		
		END_IF
	END_IF
	visDateTime := DTGetTime_01.DT1;
	// Get PLC time and date
	IF(visSetDateTime) THEN
		DTSetTime_01.enable := 1;
		DTSetTime_01.DT1 := visSetDT;
		IF(DTSetTime_01.status = 0) THEN
			visSetDateTime := 0;
			DTSetTime_01.enable := 0;
		END_IF
	END_IF
	DTGetTime_01();
	DTSetTime_01();
		
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

