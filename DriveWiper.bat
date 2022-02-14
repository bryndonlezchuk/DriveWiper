@echo off
setlocal EnableDelayedExpansion

:: GOALS:
:: Using diskpart, detect all additional drives attached to system and wipe them

:: TODO:
:: MAIN
:: HELP

:: Variables

:: Arguments? Maybe later... but have some GetOps just in case
:GETOPTS
	if /I "%1" == "-x" @echo on & REM Debug mode
	if /I "%1" == "-?" goto :HELP
	
	if not %ERRORLEVEL%==0 goto :CLEANUP
	shift
	if not "%1" == "" goto :GETOPTS
goto :MAIN

:: Describe script usage
:HELP
	echo This feature is not yet available
goto :CLEANUP

:: Main body of script goes here <=========================================================================================
:Main
	echo Starting script...
	call :ADMINCHECK
	echo;
	echo Current devices found by diskpart:
	echo;
	(echo Rescan & echo List Disk) | diskpart | find "Disk "
	echo;
	echo Warning: This script will wipe all but drive 0, do you wish to proceed? (Press enter or exit now)
	echo;
	pause > nul
	
	REM start cmd /c "commands"
	
	set /A COUNT=0
	for /f "tokens=* USEBACKQ" %%F in (`^(echo Rescan ^& echo List Disk^) ^| diskpart ^| find /I "online"`) do (
		set VAR=%%F
		
		REM echo !COUNT!
		
		if !COUNT! EQU 0 (
			REM echo Skipping Disk 0
			echo !VAR! Skipping
		) else (
			REM Comment the count increment down bellow to not proceed with this path
			echo !VAR! Starting "diskpart clean all" in new window...
			start cmd /C "(echo Rescan & echo List disk & echo Select Disk !COUNT! & echo Detail Disk & echo Clean All) | diskpart"
		)
		
		REM Comment line bellow to engage safety
		set /A COUNT+=1
	)
	
	echo;
	echo;
	echo Diskpart "Clean All" running in new windows. Please leave them open to finish process.
	echo End of script. Press ENTER to exit.
	pause > nul

	
:CLEANUP
	:: I don't think there will be any cleanup needed
goto :EOF

:: Start of functions

:: Checks for administrative permissions
::		No inputs
:ADMINCHECK
	net session >nul 2>&1
	if not %ERRORLEVEL%==0 echo WARNING: ADMINISTRAIVE PERMISSIONS MAY BE REQUIRED
exit /b 0