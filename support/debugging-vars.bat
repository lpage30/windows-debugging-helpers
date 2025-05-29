@echo off
IF NOT "%1" == "" (
set SESSION_DATE_TIME_STRING=%~1
)
IF NOT DEFINED SESSION_DATE_TIME_STRING (
call %DATE_TIME_SUFFIX_VARS_BAT%
set SESSION_DATE_TIME_STRING=%date_time_suffix%
)

set debug_log_dir=%LOCALAPPDATA%\logs\debug\session_%SESSION_DATE_TIME_STRING%
IF NOT EXIST "%debug_log_dir%" (
	mkdir %debug_log_dir%
)

set PROCESS_LOGGER_LOG=%LOCALAPPDATA%\logs\debug\session_%SESSION_DATE_TIME_STRING%\process_logger_log.txt
set DEBUG_VIEW_LOG=%LOCALAPPDATA%\logs\debug\session_%SESSION_DATE_TIME_STRING%\debugview_log.txt
set BUILD_TYPE=Debug