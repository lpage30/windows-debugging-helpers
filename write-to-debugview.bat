@echo off
IF "%~2" == "" (
	echo "USAGE: %0 {message-title} {message}"
	echo "Writes '{message-title}> <timestamp> {message}' to OutputDebugString(); shows up in DebugView"
	GOTO :EOF
)
call powershell %~dp0.\support\write-to-debugview.ps1 -Title %1 -Message %2
