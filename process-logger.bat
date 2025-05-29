@echo off
setlocal
IF "%1" == "" GOTO :HELP
IF "%2" == "" GOTO :HELP

IF NOT EXIST %1 (
    echo "%1 does not exist"
    GOTO :HELP
)
IF NOT EXIST %2 (
    echo "%2 does not exist"
    GOTO :HELP
)
IF "%ON_MONITORED_PROCESSES_CALL_BATCHFILE_BAT%" == "" (
    echo "%0 requires use of on-monitored-processes-call-batchfile.bat script; path held in global variable: ON_MONITORED_PROCESSES_CALL_BATCHFILE_BAT"
    echo "This variable is missing."
    GOTO :HELP
)
IF NOT EXIST %ON_MONITORED_PROCESSES_CALL_BATCHFILE_BAT% (
    echo "%0 requires use of on-monitored-processes-call-batchfile.bat script; path held in global variable: ON_MONITORED_PROCESSES_CALL_BATCHFILE_BAT"
    echo "This script is missing."
    GOTO :HELP
)
GOTO :START
:HELP
echo "USAGE: %0 <logtitle-logfile-list-batchfile> <code-source-root-directory>"
echo "sets up logfile following to debugview and process monitoring"
echo "%0 requires use of on-monitored-processes-call-batchfile.bat script; path held in global variable: ON_MONITORED_PROCESSES_CALL_BATCHFILE_BAT"
echo "This variable or script is missing."
GOTO :EOF

:START
call %~dp0.\support\logging-vars.bat %1
title Process Logger: %SESSION_DATE_TIME_STRING%
echo "START(%time%) session %SESSION_DATE_TIME_STRING%" > %PROCESS_LOGGER_LOG%
call %ON_MONITORED_PROCESSES_CALL_BATCHFILE_BAT% "%~2" "%~dp0.\support\log-debugview.bat" "%~dp0.\support\start-debugview-logger.bat" "%~dp0.\support\stop-debugview-logger.bat" "%SESSION_DATE_TIME_STRING%" | tee -a %PROCESS_LOGGER_LOG%
title %CD%

endlocal