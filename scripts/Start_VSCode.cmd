@echo off
setlocal enabledelayedexpansion

REM ----------------------------------------------------------------------
REM 1. CALCULATE PATHS
REM ----------------------------------------------------------------------

set "BUNDLE_ROOT=%~dp0"

REM Define Portable Python paths
set "PORTABLE_PYTHON_BIN=%BUNDLE_ROOT%pyinst\cpython-3.12.12-windows-x86_64-none\python.exe"
set "PORTABLE_PYTHON_DIR=%BUNDLE_ROOT%pyinst\cpython-3.12.12-windows-x86_64-none"
set "PORTABLE_SCRIPTS_DIR=%BUNDLE_ROOT%pyinst\cpython-3.12.12-windows-x86_64-none\Scripts"

REM Define VS Code Data paths
set "VSCODE_EXE=%BUNDLE_ROOT%vscode\Code.exe"
set "VSCODE_DATA=%BUNDLE_ROOT%vscode\data"
set "USER_DATA_DIR=%VSCODE_DATA%\user-data"
set "EXT_DIR=%VSCODE_DATA%\extensions"
set "SETTINGS_FILE=%USER_DATA_DIR%\User\settings.json"

REM ----------------------------------------------------------------------
REM 2. PREPARE ENVIRONMENT
REM ----------------------------------------------------------------------

REM Escape backslashes for JSON (C:\Path -> C:\\Path)
set "ESCAPED_PYTHON_BIN=%PORTABLE_PYTHON_BIN:\=\\%"

REM Prepend to PATH so terminal sessions find this python first
set "PATH=%PORTABLE_PYTHON_DIR%;%PORTABLE_SCRIPTS_DIR%;%PATH%"

REM ----------------------------------------------------------------------
REM 3. INJECT SETTINGS
REM ----------------------------------------------------------------------

REM Replace the existing path with our calculated absolute path
powershell -NoProfile -Command "(Get-Content -LiteralPath '%SETTINGS_FILE%') -replace '\"python.defaultInterpreterPath\": \".*?\"', '\"python.defaultInterpreterPath\": \"%ESCAPED_PYTHON_BIN%\"' | Set-Content -LiteralPath '%SETTINGS_FILE%'"

REM ----------------------------------------------------------------------
REM 4. LAUNCH VS CODE (Forced Mode)
REM ----------------------------------------------------------------------

REM We explicitly pass --user-data-dir and --extensions-dir to force it to use
REM our portable files, preventing any fallback to %APPDATA%.
start "" "%VSCODE_EXE%" --user-data-dir "%USER_DATA_DIR%" --extensions-dir "%EXT_DIR%"
