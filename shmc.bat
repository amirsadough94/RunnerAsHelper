
@echo off
if "%~1"=="" (
    echo Please drag a shortcut onto this file.
    pause
    exit /b 1
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0shmc.ps1" "%~1"

if errorlevel 1 pause
