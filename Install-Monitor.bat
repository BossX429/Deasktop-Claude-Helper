@echo off
REM Claude Health Monitor Task Scheduler Installation
REM Run as Administrator

setlocal enabledelayedexpansion

echo.
echo ============================================
echo Claude Health Monitor - Task Installation
echo ============================================
echo.

REM Check if running as admin
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: This script must be run as Administrator
    echo Please right-click and select "Run as administrator"
    pause
    exit /b 1
)

echo Installing Task Scheduler job...
echo.

REM Remove existing task if present
tasklist /fi "IMAGENAME eq schtasks.exe" 2>NUL | find /I /N "schtasks.exe">NUL
if errorlevel 1 (
    schtasks /delete /tn "Claude-Health-Monitor" /f 2>nul
)

REM Create new scheduled task
schtasks /create ^
    /tn "Claude-Health-Monitor" ^
    /tr "powershell.exe -NoProfile -ExecutionPolicy Bypass -File \"C:\Users\Someone\AppData\Local\AnthropicClaude\Monitor-ClaudeHealth.ps1\"" ^
    /sc minute ^
    /mo 5 ^
    /ru SYSTEM ^
    /rl HIGHEST ^
    /f

if %errorLevel% equ 0 (
    echo.
    echo ✓ SUCCESS: Task installed
    echo   Name: Claude-Health-Monitor
    echo   Schedule: Every 5 minutes
    echo   Privilege: SYSTEM (Highest)
    echo   Status: ACTIVE
    echo.
    echo The monitor will automatically detect and fix:
    echo   • Squirrel updater deadlock
    echo   • Claude CPU spikes
    echo   • Runaway processes (Edge, Explorer, etc)
    echo.
) else (
    echo.
    echo ✗ FAILED: Could not create task
    echo Error code: %errorLevel%
    echo.
)

pause
