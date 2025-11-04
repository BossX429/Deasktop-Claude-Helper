@echo off
REM Create a startup link for Claude Health Monitor
REM This ensures the monitor runs on every system startup

setlocal enabledelayedexpansion

set "StartupFolder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "ScriptPath=C:\Users\Someone\AppData\Local\AnthropicClaude\Monitor-Service.ps1"
set "ShortcutPath=%StartupFolder%\Claude-Monitor.lnk"

echo Creating startup shortcut...

REM Create VBScript to make the shortcut
> "%temp%\CreateShortcut.vbs" (
    echo Set oWS = WScript.CreateObject("WScript.Shell"^)
    echo sLinkFile = "%ShortcutPath%"
    echo Set oLink = oWS.CreateShortcut(sLinkFile^)
    echo oLink.TargetPath = "powershell.exe"
    echo oLink.Arguments = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File ""C:\Users\Someone\AppData\Local\AnthropicClaude\Monitor-Service.ps1"""
    echo oLink.WorkingDirectory = "C:\Users\Someone\AppData\Local\AnthropicClaude"
    echo oLink.Description = "Claude Health Monitor"
    echo oLink.Save
)

cscript "%temp%\CreateShortcut.vbs"
del "%temp%\CreateShortcut.vbs"

if exist "%ShortcutPath%" (
    echo.
    echo ✓ SUCCESS: Startup shortcut created
    echo   Location: %ShortcutPath%
    echo   The monitor will launch automatically on next system restart
    echo.
) else (
    echo ✗ FAILED: Could not create shortcut
    echo.
)

pause
