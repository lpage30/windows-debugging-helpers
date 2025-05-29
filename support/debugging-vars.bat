@echo off
IF NOT DEFINED SESSION_DATE_TIME_STRING (
set now_time=%time::=_%
set now_time=%now_time:.=_%
set now_time=%now_time: =0%

set SESSION_DATE_TIME_STRING=%date:~10,4%_%date:~4,2%_%date:~7,2%.%now_time%
)

set debug_log_dir=%LOCALAPPDATA%\logs\debug\session_%SESSION_DATE_TIME_STRING%
IF NOT EXIST "%debug_log_dir%" (
	mkdir %debug_log_dir%
)

set PROCESS_LOGGER_LOG=%LOCALAPPDATA%\logs\debug\session_%SESSION_DATE_TIME_STRING%\process_logger_log.txt
set DEBUG_VIEW_LOG=%LOCALAPPDATA%\logs\debug\session_%SESSION_DATE_TIME_STRING%\debugview_log.txt
set BUILD_TYPE=Debug