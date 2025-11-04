# Maintenance & Testing Guide

This document describes the three maintenance and testing tools added to the Claude Health Monitor system.

## 1. Log Rotation (`Rotate-MonitorLogs.ps1`)

**Purpose:** Prevent long-term log bloat in `%TEMP%` by automatically removing logs older than a configurable retention period.

**Usage:**

```powershell
# Run manually (default: keep logs 7 days old)
PowerShell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Someone\AppData\Local\AnthropicClaude\Rotate-MonitorLogs.ps1"

# Keep logs for 14 days
PowerShell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Someone\AppData\Local\AnthropicClaude\Rotate-MonitorLogs.ps1" -RetentionDays 14

# Use custom log directory
PowerShell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Someone\AppData\Local\AnthropicClaude\Rotate-MonitorLogs.ps1" -LogDir "C:\Logs"
```

**Schedule as a Task (optional):**

```powershell
# Create a weekly rotation task (admin required)
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File 'C:\Users\Someone\AppData\Local\AnthropicClaude\Rotate-MonitorLogs.ps1'"
$trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Sunday -At 02:00AM
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Claude Monitor Log Rotation" -RunLevel Highest
```

**Log Output:**

- Written to `%TEMP%\Claude-Monitor-Rotation.log`
- Timestamped entries show removed logs and summary

---

## 2. Smoke Test Harness (`Test-Monitor-Smoke.ps1`)

**Purpose:** Lightweight test suite that validates monitor script functionality without requiring external dependencies or complex setup.

**Tests Performed:**

1. **Script Exists** — Verify monitor script is present
2. **Lockfile Simulation** — Create and detect fake Squirrel lockfile
3. **Log Creation** — Verify timestamped logging works
4. **Process Detection** — Confirm `Get-Process` wrapper handles 0/1/many results
5. **Monitor Execution** — Run monitor script and verify no blocking errors

**Usage:**

```powershell
# Run all tests
PowerShell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Someone\AppData\Local\AnthropicClaude\Test-Monitor-Smoke.ps1"

# Specify custom monitor script path
PowerShell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Someone\AppData\Local\AnthropicClaude\Test-Monitor-Smoke.ps1" -MonitorScript "D:\MyMonitor\Monitor-ClaudeHealth.ps1"
```

**Sample Output:**

```
========================================
  Test 1: Monitor Script Exists
========================================
✓ PASS: Monitor script found at C:\Users\Someone\AppData\Local\AnthropicClaude\Monitor-ClaudeHealth.ps1

========================================
  Test 2: Simulate Squirrel Lockfile
========================================
✓ PASS: Created test lockfile: C:\Users\Temp\.squirrel-lock-test-12345
✓ PASS: Lockfile exists and is detectable
✓ PASS: Cleanup: removed test lockfile

...

========================================
Test Summary
========================================
Passed: 5 / 5
✓ All smoke tests passed!
```

**Exit Codes:**

- `0` = All tests passed
- `1` = One or more tests failed

---

## 3. Hydra Integration Diagnostic (`Diagnose-Monitor-Hydra.ps1`)

**Purpose:** Comprehensive diagnostic that validates the monitor system and its parallel operation with Hydra services.

**Checks Performed:**

1. **Scheduled Task Status** — Verify "Claude Health Monitor" is registered and enabled
2. **Monitor Script Files** — Confirm all required scripts exist
3. **Log Files** — Check log existence, size, and age
4. **Process Conflicts** — Monitor CPU usage of explorer, Update.exe, msedge
5. **Hydra Integration** — Check for Hydra directory and audit report
6. **Temp Directory Health** — Verify `%TEMP%` accessibility and size
7. **Parallel Execution** — Simulate concurrent monitor + Hydra load

**Usage:**

```powershell
# Full diagnostic (default paths)
PowerShell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Someone\AppData\Local\AnthropicClaude\Diagnose-Monitor-Hydra.ps1"

# Custom paths
PowerShell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Someone\AppData\Local\AnthropicClaude\Diagnose-Monitor-Hydra.ps1" `
  -MonitorScriptDir "D:\Claude" `
  -HydraDir "D:\Hydra" `
  -TempDir "E:\Temp"
```

**Sample Output:**

```
╔═══════════════════════════════════════════════╗
║ Scheduled Task Status                         ║
╚═══════════════════════════════════════════════╝
✓ Scheduled task 'Claude Health Monitor' exists
  State: Ready
  Enabled: True
✓ Task is enabled and scheduled

╔═══════════════════════════════════════════════╗
║ Monitor Log Files                             ║
╚═══════════════════════════════════════════════╝
✓ Found 3 log file(s)
  Total size: 15.42 MB
  • Claude-Monitor-Service.log (8.5 KB)
  • Claude-Monitor-20251103.log (5.2 KB)
  • Claude-Monitor-20251102.log (2.1 KB)
✓ Log size is healthy

╔═══════════════════════════════════════════════╗
║ Diagnostic Summary                            ║
╚═══════════════════════════════════════════════╝
Passed:  6
Failed:  0
Warnings: 0
✓ Diagnostic complete — system healthy
```

**Exit Codes:**

- `0` = All checks passed, system is healthy
- `1` = One or more failures detected

---

## Integration with Workflows

### Daily Operations

```powershell
# 1. Run smoke test after any script changes
Test-Monitor-Smoke.ps1

# 2. Run diagnostic weekly to check system health
Diagnose-Monitor-Hydra.ps1

# 3. Clean up old logs monthly
Rotate-MonitorLogs.ps1 -RetentionDays 7
```

### Troubleshooting

| Symptom                     | Diagnostic                                        | Fix                                                              |
| --------------------------- | ------------------------------------------------- | ---------------------------------------------------------------- |
| `%TEMP%` disk usage growing | `Diagnose-Monitor-Hydra.ps1` shows large log size | Run `Rotate-MonitorLogs.ps1 -RetentionDays 3`                    |
| Monitor not running         | Scheduled task status shows "Disabled"            | Run `Install-Scheduled-Task.ps1` elevated                        |
| Lockfile not detected       | `Test-Monitor-Smoke.ps1` Test 2 fails             | Review `Monitor-ClaudeHealth.ps1` Test-SquirrelDeadlock function |
| Explorer hung after repair  | `Diagnose-Monitor-Hydra.ps1` Process Health fails | Check `Monitor-ClaudeHealth.ps1` Repair-RunawayProcess           |

---

## CI/CD Integration

Add to your build pipeline:

```yaml
# Example: GitHub Actions or Azure Pipelines
- name: Run Monitor Smoke Tests
  run: |
    powershell -NoProfile -ExecutionPolicy Bypass -File "Test-Monitor-Smoke.ps1"

- name: Run Full Diagnostic
  run: |
    powershell -NoProfile -ExecutionPolicy Bypass -File "Diagnose-Monitor-Hydra.ps1"
```

---

## Maintenance Schedule (Recommended)

| Task             | Frequency                          | Command                      |
| ---------------- | ---------------------------------- | ---------------------------- |
| Smoke Test       | After any code change              | `Test-Monitor-Smoke.ps1`     |
| Diagnostic Check | Weekly                             | `Diagnose-Monitor-Hydra.ps1` |
| Log Rotation     | Monthly (or when `%TEMP%` > 100MB) | `Rotate-MonitorLogs.ps1`     |

---

## Notes

- All scripts use `-ErrorAction SilentlyContinue` internally to avoid blocking other processes
- Diagnostic parallel execution test spawns a background PowerShell job; no external tools required
- Log rotation preserves the most recent N days of logs for forensics
- Smoke test cleans up temporary files automatically after each test

For issues or questions, refer to `.github/copilot-instructions.md` for safe-edit guidelines and integration rules.
