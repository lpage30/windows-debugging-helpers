@echo off
call %~dp0debugging-vars.bat

REM Provide comma-separated list of titles for each log-file to be followed
set logtitle_list=
REM Provide comma-separated list of log-file-paths for each log-file to be followed
set logfile_list=

REM Optional batchfilepath that sets the above 2 variables
IF NOT "%1" == "" call %1

