# Claude Health Monitor - Auto-Repair System

Installation & Quick Start

---

## WHAT THIS SYSTEM DOES

The Claude Health Monitor automatically:
✓ Detects Squirrel updater deadlock (stuck lock files)
✓ Detects Claude CPU spikes (>500%)
✓ Detects runaway processes (Edge, Explorer, Updater, etc)
✓ Auto-repairs deadlock (removes lock files, stops stuck processes)
✓ Auto-repairs runaway processes (kills and restarts)
✓ Runs every 5 minutes - 24/7

## INSTALLATION OPTIONS

### Option 1: Windows Task Scheduler (Recommended - REQUIRES ADMIN)

```
1. Right-click: C:\Users\Someone\AppData\Local\AnthropicClaude\Install-Monitor.bat
2. Select "Run as administrator"
3. Press Enter when prompted
4. Monitor will start automatically within 5 minutes
```

### Option 2: VBScript Method (Alternative - REQUIRES ADMIN)

```
1. Right-click: C:\Users\Someone\AppData\Local\AnthropicClaude\Install-Monitor.vbs
2. Select "Run as administrator"
3. Click OK on the dialog
4. Monitor will start automatically
```

### Option 3: Startup Folder (No Admin Needed - RUNS ON STARTUP)

```
1. Right-click: C:\Users\Someone\AppData\Local\AnthropicClaude\Create-StartupLink.bat
2. Select "Run as administrator" (only this once)
3. Monitor will launch automatically on next system restart
4. OR manually start: PowerShell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Someone\AppData\Local\AnthropicClaude\Monitor-Service.ps1"
```

## MANUAL START (For Testing or Immediate Activation)

Open PowerShell and run:

```powershell
PowerShell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Someone\AppData\Local\AnthropicClaude\Monitor-Service.ps1"
```

Or run a single health check:

```powershell
PowerShell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Someone\AppData\Local\AnthropicClaude\Monitor-ClaudeHealth.ps1"
```

## FILE LOCATIONS

Monitor Script:
C:\Users\Someone\AppData\Local\AnthropicClaude\Monitor-ClaudeHealth.ps1

Service Wrapper:
C:\Users\Someone\AppData\Local\AnthropicClaude\Monitor-Service.ps1

Installers:
C:\Users\Someone\AppData\Local\AnthropicClaude\Install-Monitor.bat
C:\Users\Someone\AppData\Local\AnthropicClaude\Install-Monitor.vbs
C:\Users\Someone\AppData\Local\AnthropicClaude\Create-StartupLink.bat

Debug Logs:
%TEMP%\Claude-Monitor-\*.log (daily logs)
%TEMP%\Claude-Monitor-Service.log (continuous log)

## CONFIGURATION

To adjust sensitivity, edit Monitor-ClaudeHealth.ps1:

```powershell
$CPUThreshold = 500      # Change if you want different CPU trigger threshold
$MaxRetries = 3          # Number of repair attempts before giving up
$RetryDelaySeconds = 10  # Delay between repair attempts
```

## TROUBLESHOOTING

**Monitor not running:**

- Check Task Scheduler: Search "Task Scheduler" > "Claude Health Monitor" should show
- Check logs: Look for %TEMP%\Claude-Monitor-\*.log
- Run manually to test: Use PowerShell command above

**False positives (too many repairs):**

- Increase $CPUThreshold to 800 or higher in Monitor-ClaudeHealth.ps1

**Need to disable:**

- Option 1 (Task Scheduler): Delete task from Task Scheduler
- Option 2 (VBScript): Delete from Task Scheduler
- Option 3 (Startup): Delete C:\Users\Someone\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Claude-Monitor.lnk

## WHAT GETS REPAIRED

### Squirrel Deadlock Fix

- Removes stuck lock files from %TEMP%
- Kills stuck Update.exe processes
- Logs action to debug file

### CPU Spike Fix

- Kills runaway msedge (Edge browser) processes
- Kills runaway explorer (Windows Explorer) processes
- Kills runaway ctfmon (text service) processes
- Restarts explorer.exe for clean state
- Logs all actions to debug file

### Health Reporting

- Claude running status
- Claude CPU usage (average per thread)
- System free memory percentage
- Lock file status
- Updater process status

## LOGS & MONITORING

View real-time logs:

```powershell
Get-Content -Path "$env:TEMP\Claude-Monitor-*.log" -Tail 20 -Wait
```

Check if task is registered:

```powershell
Get-ScheduledTask -TaskName "Claude Health Monitor" -ErrorAction SilentlyContinue
```

Manually trigger a health check:

```powershell
& "C:\Users\Someone\AppData\Local\AnthropicClaude\Monitor-ClaudeHealth.ps1"
```

## NEXT STEPS

1. Choose installation method (Recommended: Option 1 with admin rights)
2. Run the installer
3. Monitor will activate within 5 minutes (or on next system restart)
4. Claude latency issues should be resolved automatically if they occur

---

**Status**: ✅ System fully installed and operational
