# Quick Reference: Maintenance & Monitoring Tools

## One-Liners

```powershell
# Smoke test (validate monitor works)
PowerShell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Someone\AppData\Local\AnthropicClaude\Test-Monitor-Smoke.ps1"

# Full diagnostic (health check)
PowerShell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Someone\AppData\Local\AnthropicClaude\Diagnose-Monitor-Hydra.ps1"

# Clean old logs (keep 7 days)
PowerShell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Someone\AppData\Local\AnthropicClaude\Rotate-MonitorLogs.ps1"

# Reinstall scheduled task (admin)
PowerShell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Someone\AppData\Local\AnthropicClaude\Install-Scheduled-Task.ps1"

# View recent monitor logs
Get-Content "$env:TEMP\Claude-Monitor-*.log" -Tail 50 -Wait

# Check if monitor task is running
Get-ScheduledTask -TaskName "Claude Health Monitor" | Select-Object State, Enabled, NextRunTime
```

## Daily Workflow

1. **After code changes:** Run smoke test to validate

   ```powershell
   & "C:\Users\Someone\AppData\Local\AnthropicClaude\Test-Monitor-Smoke.ps1"
   ```

2. **Weekly health check:** Run diagnostic

   ```powershell
   & "C:\Users\Someone\AppData\Local\AnthropicClaude\Diagnose-Monitor-Hydra.ps1"
   ```

3. **When %TEMP% usage > 100 MB:** Clean old logs
   ```powershell
   & "C:\Users\Someone\AppData\Local\AnthropicClaude\Rotate-MonitorLogs.ps1" -RetentionDays 7
   ```

## Troubleshooting Matrix

| Symptom               | Command                                                            | Expected Result               |
| --------------------- | ------------------------------------------------------------------ | ----------------------------- |
| Monitor not running   | `Get-ScheduledTask -TaskName "Claude Health Monitor"`              | State = Ready, Enabled = True |
| Recent errors in logs | `Get-Content "$env:TEMP\Claude-Monitor-*.log" -Tail 30`            | No ERROR or CRITICAL entries  |
| High disk usage       | `dir $env:TEMP\Claude-Monitor-*.log \| Measure-Object -Sum Length` | < 100 MB                      |
| System health unknown | `& "Diagnose-Monitor-Hydra.ps1"`                                   | Failed < 2, Warnings < 3      |
| Monitor logic broken  | `& "Test-Monitor-Smoke.ps1"`                                       | All 5 tests pass              |

## File Locations

- **Monitor scripts:** `C:\Users\Someone\AppData\Local\AnthropicClaude\`
- **Monitor logs:** `%TEMP%\Claude-Monitor-*.log`
- **Rotation log:** `%TEMP%\Claude-Monitor-Rotation.log`
- **Install log:** `%TEMP%\Claude-Monitor-Install.log`
- **Documentation:** `.github/copilot-instructions.md`, `MAINTENANCE-TESTING-GUIDE.md`, `README-MONITOR.md`

## Exit Codes

| Code | Meaning                                     |
| ---- | ------------------------------------------- |
| 0    | Success / all tests passed / system healthy |
| 1    | Failure / tests failed / issues detected    |

## Key Metrics

- **Smoke test:** 5 tests, target 5/5 pass
- **Diagnostic:** 15+ checks, target 0 failures
- **Log retention:** Default 7 days in %TEMP%
- **Log size limit:** Alert when > 100 MB
- **CPU threshold (monitor):** 500% (configurable in Monitor-ClaudeHealth.ps1)
- **Service interval:** 5 minutes (scheduled task) or 300 seconds (resident service)

## Common Tasks

**View monitor status:**

```powershell
Get-ScheduledTask -TaskName "Claude Health Monitor"
```

**Disable monitor (temporary):**

```powershell
Disable-ScheduledTask -TaskName "Claude Health Monitor"
```

**Enable monitor:**

```powershell
Enable-ScheduledTask -TaskName "Claude Health Monitor"
```

**Remove monitor (clean uninstall):**

```powershell
schtasks /delete /tn "Claude Health Monitor" /f
```

**Watch monitor logs in real-time:**

```powershell
Get-Content "$env:TEMP\Claude-Monitor-Service.log" -Tail 100 -Wait
```

---

For full documentation, see:

- `MAINTENANCE-TESTING-GUIDE.md` — detailed usage and integration
- `IMPLEMENTATION-SUMMARY.md` — implementation status and test results
- `.github/copilot-instructions.md` — safe-edit rules and conventions
