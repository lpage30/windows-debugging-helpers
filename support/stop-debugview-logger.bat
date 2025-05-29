@echo off
setlocal
set tempfile1=%TEMP%\debugview_pids_%RANDOM%.txt
set tempfile2=%TEMP%\debugview_pids_%RANDOM%.txt
set tempfile3=%TEMP%\debugview_pids_%RANDOM%.txt

wmic process where "name='powershell.exe' and commandline like '%%write-to-debugview.ps1%%'" get processId /value 2>nul | grep "ProcessId=" | tr -d "ProcessId=" > %tempfile1%
wmic process where "name='powershell.exe' and commandline like '%%follow-to-debugview.ps1%%'" get processId /value 2>nul | grep "ProcessId=" | tr -d "ProcessId=" > %tempfile2%
wmic process where "name='DebugViewConsole.exe'" get processId /value 2>nul  | grep "ProcessId=" | tr -d "ProcessId=" > %tempfile3%

call :KILL_PID %tempfile1% "Debugview Heartbeater"
call :KILL_PID %tempfile2% "log follower to Debugview"
call :KILL_PID %tempfile3% "Debugview console"

del /Q %tempfile1%
del /Q %tempfile2%
del /Q %tempfile3%
GOTO :EOF
:KILL_PID
for /f "tokens=*" %%d in (%1) do (
	echo "Killing %~2..."
	call taskkill /F /pid %%d
)
GOTO :EOF
endlocal