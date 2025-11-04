@echo off
REM Claude Health Monitor - Comprehensive Setup Script
REM Right-click and select "Run as administrator"

setlocal enabledelayedexpansion

cls
echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║  Claude Health Monitor - Complete Installation Setup      ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

REM Check for admin rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] This script requires Administrator privileges
    echo.
    echo Please:
    echo   1. Right-click on this file
    echo   2. Select "Run as administrator"
    echo.
    pause
    exit /b 1
)

echo [INFO] Running with administrator privileges...
echo.

REM Set paths
set MONITOR_DIR=C:\Users\Someone\AppData\Local\AnthropicClaude
set MONITOR_SCRIPT=%MONITOR_DIR%\Monitor-Service.ps1
set LOG_FILE=%TEMP%\Claude-Monitor-Install.log

echo [INFO] Installation Directory: %MONITOR_DIR%
echo [INFO] Log File: %LOG_FILE%
echo.

REM Step 1: Create scheduled task
echo [STEP 1/3] Creating Scheduled Task...
schtasks /create /tn "Claude Health Monitor" ^
    /tr "powershell -NoProfile -ExecutionPolicy Bypass -File \"%MONITOR_SCRIPT%\"" ^
    /sc minute /mo 5 /ru SYSTEM /f >> %LOG_FILE% 2>&1

if %errorLevel% equ 0 (
    echo [SUCCESS] Scheduled task created
) else (
    echo [ERROR] Failed to create scheduled task
    type %LOG_FILE%
    pause
    exit /b 1
)

REM Step 2: Start the task
echo [STEP 2/3] Starting Monitor Service...
schtasks /run /tn "Claude Health Monitor" >> %LOG_FILE% 2>&1

if %errorLevel% equ 0 (
    echo [SUCCESS] Monitor service started
) else (
    echo [WARNING] Task created but could not start immediately
    echo          It will run at the next scheduled interval
)

REM Step 3: Verify installation
echo [STEP 3/3] Verifying Installation...
timeout /t 2 /nobreak
schtasks /query /tn "Claude Health Monitor" > nul 2>&1

if %errorLevel% equ 0 (
    echo [SUCCESS] Task verified in Task Scheduler
) else (
    echo [ERROR] Task not found - installation may have failed
    type %LOG_FILE%
    pause
    exit /b 1
)

echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║  ✓ Installation Complete                                  ║
echo ╚════════════════════════════════════════════════════════════╝
echo.
echo The Claude Health Monitor is now installed and running!
echo.
echo What it does:
echo   • Monitors Claude Desktop process health
echo   • Detects Squirrel updater deadlocks
echo   • Kills runaway processes (Edge, Explorer, etc.)
echo   • Runs automatically every 5 minutes
echo   • Logs all actions to: %TEMP%\Claude-Monitor-*.log
echo.
echo You can:
echo   • View logs: type %TEMP%\Claude-Monitor-*.log
echo   • Check status: schtasks /query /tn "Claude Health Monitor"
echo   • Uninstall: schtasks /delete /tn "Claude Health Monitor" /f
echo.
pause
