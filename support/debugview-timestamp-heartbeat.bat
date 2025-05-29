@echo off
setlocal enabledelayedexpansion

set title="HEARTBEAT"
set message="Time Checkpoint"
set heartbeat_delay_seconds=0
IF "%~1" == "" (
	echo "Missing argument"
	GOTO :HELP
)
IF 1%1 EQU +1%1 (
	set heartbeat_delay_seconds=%1
) ELSE (
	echo "Argument %1 is not a number"
	GOTO :HELP
)	

call powershell %~dp0.\write-to-debugview.ps1 -RepeatFrequencySeconds '!heartbeat_delay_seconds!' -Title '%title%' -Message '%message%'
GOTO :EOF

:HELP
	echo "USAGE %0 <seconds-delay-between-heartbeats>"
	echo "Issues an OutputDebugString '%title:"=%> <timestamp> %message:"=%' every <seconds-delay-between-heartbeats>"
	GOTO :EOF

endlocal

