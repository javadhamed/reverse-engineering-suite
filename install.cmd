@echo off
setlocal EnableDelayedExpansion

echo ========================================================
echo       Reverse Engineering Suite Installer
echo ========================================================
echo.

where powershell >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [ERROR] PowerShell is required to run this installer.
    pause
    exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1" %*

echo.
pause
