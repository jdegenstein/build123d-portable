@echo off
setlocal

REM Get the directory where this script is located (The Bundle Root)
set "BUNDLE_ROOT=%~dp0"

REM Define the path to the portable Python executable
REM We use the explicit path from your file tree
set "PORTABLE_PYTHON_BIN=%BUNDLE_ROOT%pyinst\cpython-3.12.12-windows-x86_64-none\python.exe"

REM Launch VS Code using the binary in your tree
REM We use "start" so the command prompt window closes immediately
start "" "%BUNDLE_ROOT%vscode\Code.exe"
