@echo off
echo "starting debugview and following of logs to debugview"
start "DebugView logger " /MIN /D %~dp0. %comspec% /C debugview-logger.bat
start "" /MIN /D %~dp0.. %comspec% /C follow-logs-to-debugview.bat %1
