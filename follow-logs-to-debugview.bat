@echo off
setlocal
call %~dp0.\support\logging-vars.bat %1
start "30s Heartbeat to DebugView %SESSION_DATE_TIME_STRING%" /MIN /D %~dp0. %comspec% /C debugview-timestamp-heartbeat.bat 30
title Follow logs to DebugView %SESSION_DATE_TIME_STRING%
call powershell %~dp0.\support\follow-to-debugview.ps1 -Titles %logtitle_list% -Filenames %logfile_list%
title %CD%
endlocal