@echo off
setlocal enabledelayedexpansion

REM Check for admin rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo ============================================
    echo Claude Health Monitor - Task Installation
    echo ============================================
    echo.
    echo ERROR: This script must be run as Administrator
    echo Please right-click and select "Run as administrator"
    echo.
    pause
    exit /b 1
)

echo.
echo ============================================
echo Claude Health Monitor - Installing...
echo ============================================
echo.

REM Create the scheduled task
schtasks /create /tn "Claude Health Monitor" /tr "powershell -NoProfile -ExecutionPolicy Bypass -File \"C:\Users\Someone\AppData\Local\AnthropicClaude\Monitor-Service.ps1\"" /sc minute /mo 5 /f /ru SYSTEM

if %errorLevel% equ 0 (
    echo.
    echo [SUCCESS] Task created!
    echo.
    echo Starting monitor...
    schtasks /run /tn "Claude Health Monitor"
    
    if %errorLevel% equ 0 (
        echo [SUCCESS] Monitor started!
        echo.
        echo Installation complete. The monitor will run every 5 minutes.
    ) else (
        echo [WARNING] Could not start task manually, but it's scheduled.
    )
) else (
    echo [ERROR] Failed to create task
    pause
    exit /b 1
)

echo.
pause
