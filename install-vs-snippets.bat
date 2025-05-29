@echo off
setlocal
set SCRIPT_DIR=%~dp0.
set vs_snippets_dir=%USERPROFILE%\Documents\Visual Studio 2022\Code Snippets

xcopy /Y %SCRIPT_DIR%\vs-c#-*.snippet "%vs_snippets_dir%\Visual C#\My Code Snippets\"
xcopy /Y %SCRIPT_DIR%\vs-c++-*.snippet "%vs_snippets_dir%\Visual C++\My Code Snippets\"
xcopy /Y %SCRIPT_DIR%\vs-python-*.snippet "%vs_snippets_dir%\Python\My Code Snippets\"
xcopy /Y %SCRIPT_DIR%\vs-javascript-*.snippet "%vs_snippets_dir%\JavaScript\My Code Snippets\"

endlocal