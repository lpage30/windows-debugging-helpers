@echo off
setlocal
IF "%1" == "" GOTO :HELP
IF NOT EXIST %1 (
	echo "%1 does not exist"
	GOTO :HELP
)
GOTO :START
:HELP
echo "USAGE: %0 <path-to-top-of-code-directory>"
echo "chkmatch all found pdbs with their corresponding (copied) exe or dll"
echo "Used when you want to align your built PDBs to executables of a release build of the same code"
echo "Useful when analyzing crash dumps"
GOTO :EOF

:START
set chkmatch_home=%~dp0chkMatch
IF NOT EXIST %chkmatch_home%\chkmatch.exe (
    echo "chkmatch.exe not found. http://www.debuginfo.com/tools/chkmatch.html"
    GOTO :EOF
)
where grep >nul 2>&1
IF NOT "%ERRORLEVEL%" == "0" (
    echo "cygwin tools not installed. grep is used with dir to find all pdbs"
    GOTO :EOF
)
pushd %1
for /F %%f in ('dir /s /b ^| grep -E ".*pdb"') do (
    IF EXIST %%~dpnf.exe (
        echo "  chkmatch -m %%~dpnf.exe %%~dpnf.pdb"
        call %chkmatch_home%\chkmatch.exe -m %%~dpnf.exe %%~dpnf.pdb
    ) ELSE (
        IF EXIST %%~dpnf.dll (
            echo "  chkmatch -m %%~dpnf.dll %%~dpnf.pdb"
            call %chkmatch_home%\chkmatch.exe -m %%~dpnf.dll %%~dpnf.pdb
        )
    )
)

endlocal