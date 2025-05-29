# Windows Debugging Helpers
Set of scripts and files to help in debugging code.

## scripts
- `vs-<language>-debug-[functions|msgbox|output].snippet`  
Visual Studio code snippet files to assist in adding stock code for different debug activities:
	- `functions` - these normally are added to top of a file to define functions needed by other snippets. Depending on `language` different functions may be needed to provide consistent behavior.
	- `msgbox` - used to add a message box 'popup' where you apply the snippet. This is helpful to trigger debugger or pause to attach.
	- `output` - used to add `OutputDebugstring()` which calls underlying windows output debug string that is viewed in debugview or other tools independent of your program.
- `install-vs-snippets.bat`  
applies all `vs-*.snippet` files to Visual Studio for immediate use in that IDE.

- `chk-match-pdbs.bat`
```
USAGE: %0 <path-to-top-of-code-directory>
chkmatch all found pdbs with their corresponding (copied) exe or dll
Used when you want to align your built PDBs to executables of a release build of the same code
Useful when analyzing crash dumps
```
- `follow-logs-to-debugview.bat`  
Basically tails all persisted logs, captures outputdebug string messages, and provides 'heartbeat' timestamps to help correlate behaviors with logoutput.  
The purpose here is to run your system locally, and observe, via debugview, log output correlated to your interactions with local services.
- `process-logger.bat`  
Similar to `follow-logs-to-debugview.bat` this tails all persisted logs, and spawns a new output debug string capture for each program when it starts and then closes it when it ends.  
This allows the user to have a log isolated to each spawned program as well as a single unified debug-view log. All logs would have heartbeats in them to help correlate behaviors with log output.

## details
### Visual Studio 20XX code snippets for easier debugging
- `install-vs-snippets.bat` -- copies `vs-<lang>-*.snippet` files to the location used by Visual Studio for that `<lang>` my code snippets.
- `vs-<lang>-*.snippet` -- files to be imported into visual studio as code snippets
	- `vs-c#-debug-msgbox.snippet` or `vs-c++-debug-msgbox.snippet` or `vs-python-debug-msgbox.snippet` or `vs-javascript-debug-msgbox.snippet` calls `ImosMessageBox()` or `MessageBox()` with context information. C++ only: Yes will cause `ImosLaunchDebugger()` No will continue.
	- `vs-c#-debug-output.snippet` or `vs-c++-debug-output.snippet` or `vs-python-debug-output.snippet` or `vs-javascript-debug-output.snippet`  calls `OutputDebugString()` so you can use [DebugView](https://learn.microsoft.com/en-us/sysinternals/downloads/debugview)
	- `vs-c++-get-callstack-function.snippet` - C++ specific code definining getCallstack code for I386 and C++ 98. Must be placed in global scope, if used all other debug C++ scripts will call the getCallstack and output the call stack.
	- `vs-c#-debug-functions.snippet` - C# specific functions wrapped in namespace to be inserted at top level of file so others in file can use them (other snippets).


### follow all logs to debugview 
- call `follow-logs-to-debugview.bat`
- open debugview locally to observe results

### follow all ogs and processes for logging
- call `process-logger.bat`
- run your processes/activities
- find logs in a few places: 
   - `%LOCALAPPDATA%\logs\debugview_log.txt`  contains all debugview captured output from all processes
   - `%LOCALAPPDATA%\logs\process_logger_log.txt`  contains the history of processes that started and stopped during your process-logger session
   - `%LOCALAPPDATA%\logs\debug\session_<date>.<session-time>` folder associated with your process-logger session
      - `%LOCALAPPDATA%\logs\debug\session_<date>.<session-time>\debugview-<program-name>.<date>.<program-start-time>.txt` a file for every process start detected.

### Write Message with Title to DebugView
- call `write-to-debugview.bat` used as convenience to 'inject' outputdebugview messages into logs while running.
```
"USAGE: write-to-debugview {message-title} {message}"
"Writes '{message-title}> <timestamp> {message}' to OutputDebugString(); shows up in DebugView"
```


Logging Tools to either:
- follow all locally started services and logs and see output in debugview with timestamps
- follow all locally started services and logs and capture output to a single logfile for later analysis
- `%ON_MONITORED_PROCESSES_CALL_BATCHFILE_BAT%`  
env variable to batch file used to monitor and call stated batchfile when process is created.
   ```
   "USAGE: on-monitored-processes-call-batchfile.bat <process-condition> <batch-file-to-call> [<startup-batch-file-to-call> [<shutdown-batch-file-to-call>]]"
   "Whenever a program meeting <program-condition> starts, call <batch-file-to-call> with following information:"
   "       `CALL <batch-file-to-call> <SessionDateTimeString> <process-PID> <process-name>`  "
   "`<SessionDateTimeString>` - formatted date and time: `YYYY_MM_DD.HH_MM_SS` of start of overall session  "
   "`<process-PID>` - process Identifier of process that started  "
   "`<process-name>` - Win32-Process.Name of process that started  "
   "`<process-condition> - can be:  "
   "  `directory-path` - whenever an executable file under this directory starts call `<batch-file-to-call>` with its information  "
   "  `process-command-line-substring` - whenever a process containing this substring starts call `<batch-file-to-call>` with its information  "
   "`<batch-file-to-call>` - a batch file that will be called in its own process whenever a process starts and killed when that process ends.  "
   "`<startup-batch-file-to-call>` - a batch file that will be called once before monitoring processes.  "
   "`<shutdown-batch-file-to-call>` - a batch file that will be called once when process monitoring ends."
   ```
## Dependencies
- Install [Cygwin tools](https://www.cygwin.com/) so scripts can use `tee` `tail` `sed` and `grep`
	- make sure Cygwin install path is in your `PATH`
- Install {DebugViewPP](https://github.com/CobaltFusion/DebugViewPP/releases)  so debugviewconsole scripts can trap outputdebugstring without elevated rights
	- set the DebugViewPP `bin` directory path to the global variable `DEBUG_VIEW_PP_HOME`
