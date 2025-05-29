@echo off
setlocal enabledelayedexpansion
set SCRIPT_DIR=%~dp0.

IF "%3" == "" (
	echo "Missing arguments"
	GOTO :HELP
)
set PID=%~2
set name=%~3

call %SCRIPT_DIR%\debugging-vars.bat %1

set logfile_suffix=%date_time_suffix%.txt

set cmdline=""
for /F "tokens=*" %%d in ('wmic process where "processid=%PID%" get commandline /Value 2^>nul ^| grep CommandLine ^| sed "s/CommandLine=\(.*\)/\1/g"') DO (
	set cmdline=%%d
)
set debug_log_filepath=%debug_log_dir%\debugview-%name%.%logfile_suffix%
title %name% (%PID%) %~1: tailing %DEBUG_VIEW_LOG%
echo "START(%time%) tailing %DEBUG_VIEW_LOG% for %name% (%PID%) - %cmdline%" | tee -a %debug_log_filepath%
tail -f %DEBUG_VIEW_LOG% | grep -E --line-buffered "(%PID%|%name%|HEARTBEAT)" | tee -a %debug_log_filepath%
echo "STOP (%time%) tailing %DEBUG_VIEW_LOG% for %name% (%PID%) - %cmdline%" | tee -a %debug_log_filepath%
GOTO :EOF

:HELP
echo "Usage log-debug-output-for-process <SessionDateTimeString> <PID> <name>"
echo "%DEBUG_VIEW_CONSOLE_LOG_CMDLINE% | grep [<PID>] to %LOCALAPPDATA%\logs\debug\session_<SessionDateTimeString>\debugview-<name>.*.txt" 
echo "SessionDateTimeString used for folder names for logs. expected format: 'YYYY_MM_DD.HH_MM_SS'"
echo "PID  					process Identifier"
echo "name  				ProgramMapFilepath entry name"
GOTO :EOF

endlocal