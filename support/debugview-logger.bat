@echo off
setlocal
call %~dp0.\debugging-vars.bat
echo. > %DEBUG_VIEW_LOG%
title DebugView Logging to %DEBUG_VIEW_LOG%
call %DEBUG_VIEW_PP_HOME%\DebugViewConsole.exe  -a -c -v -p -n -f | tee -a %DEBUG_VIEW_LOG%
title %CD%
endlocal