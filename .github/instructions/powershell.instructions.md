---
applies_to: "**/*.ps1"
---

# PowerShell Instructions for Claude Health Monitor

## 🎯 Purpose

PowerShell scripts in this repository implement the **Claude Health Monitor** - an auto-repair system that detects and fixes common Claude desktop issues on Windows.

## 📂 Key Files

- `Monitor-ClaudeHealth.ps1` - Core detection & repair logic
- `Monitor-Service.ps1` - Resident service loop (300s interval)
- `Install-Scheduled-Task.ps1` - Task scheduler registration
- `Diagnose-Monitor-Hydra.ps1` - 11 diagnostic checks
- `Test-Monitor-Smoke.ps1` - 5 validation tests
- `hydra_head_health_monitor.ps1` - Hydra deployment monitoring

## 🔧 PowerShell Conventions (MUST FOLLOW)

### Error Handling
```powershell
# ALWAYS use -ErrorAction SilentlyContinue for external operations
Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
Get-Process -Name Claude -ErrorAction SilentlyContinue
```

### Process Enumeration
```powershell
# ALWAYS wrap Get-Process in @(...) to handle single vs multiple results
$processes = @(Get-Process -Name "Claude" -ErrorAction SilentlyContinue)
```

### Logging
```powershell
# ALWAYS use Log-Message for detectable actions
Log-Message "Detected stuck Squirrel lock files" "WARN"
Log-Message "Successfully repaired CPU spike" "INFO"

# Append to $env:TEMP logs with timestamps
Add-Content -Path "$env:TEMP\Claude-Monitor-Service.log" -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Message"
```

### Idempotence
- All repair functions MUST be safe to re-run
- Guard operations before executing
- Never destructive state changes outside `%TEMP%`
- Check conditions before applying fixes

## ⚙️ Critical Configuration

### DO NOT MODIFY Without Review
```powershell
$CPUThreshold = 500  # CRITICAL - do not change without approval
```

### Safe to Modify
```powershell
$MaxRetries = 3
$RetryDelaySeconds = 5
$MonitorInterval = 300
```

## 🚀 Common Patterns

### Safe Process Kill + Restart
```powershell
Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1
Start-Process explorer.exe
```

### Lock File Detection
```powershell
$lockFiles = Get-ChildItem -Path $env:TEMP -Filter "Squirrel-*.lock" -ErrorAction SilentlyContinue
if ($lockFiles) {
    Remove-Item -Path $lockFiles.FullName -Force -ErrorAction SilentlyContinue
    Log-Message "Removed stuck lock files" "INFO"
}
```

### Conditional Repair
```powershell
if ($cpuTime -gt $CPUThreshold) {
    Log-Message "CPU threshold exceeded: $cpuTime" "WARN"
    Repair-CPUSpike
}
```

## 🧪 Testing Requirements

### Before Committing
```powershell
# Run smoke tests
.\Test-Monitor-Smoke.ps1

# Validate syntax (manual check - no PSScriptAnalyzer in repo currently)
PowerShell -NoProfile -NoExecutionPolicy -Command "& { . .\YourScript.ps1 }"
```

### In PRs
- Include test results in PR description
- Document expected behavior changes
- Verify no breaking changes to:
  - `$CPUThreshold`
  - Scheduled task name (`Claude Health Monitor`)
  - Log paths (`%TEMP%\Claude-Monitor-*.log`)

## 📝 Code Style

### Naming
- Functions: `Verb-Noun` (e.g., `Repair-SquirrelDeadlock`)
- Variables: `$PascalCase` or `$camelCase`
- Constants: `$UPPER_CASE` (for critical configs)

### Comments
- Add comments for complex logic only
- Match existing comment style
- Don't over-comment obvious code
- Document WHY, not WHAT

### Script Headers
```powershell
# Monitor-ClaudeHealth.ps1
# Purpose: Auto-repair common Claude desktop issues
# Author: [Your Name]
# Last Modified: [Date]
```

## ⚠️ Critical DON'Ts

### Performance
- **Never** use `Start-Sleep` in repair functions
- Keep repair logic fast (<100ms per attempt)
- `$RetryDelaySeconds` is for retry delays only, not repair logic

### State Management
- **Never** write to Windows registry
- **Never** modify shared application state
- Use lock files in `%TEMP%` for coordination
- Keep all temp files in `%TEMP%`

### Hydra Integration
- **Don't** write to Hydra-managed files (read-only)
- **Don't** block or interfere with Hydra services
- Document cross-process coordination in comments

## 📚 Examples

### Adding New Detection
```powershell
function Detect-NewIssue {
    $issues = @(Get-Process -Name "ProblemProcess" -ErrorAction SilentlyContinue)
    if ($issues.Count -gt 0) {
        Log-Message "Detected new issue: $($issues.Count) instances" "WARN"
        return $true
    }
    return $false
}
```

### Adding New Repair
```powershell
function Repair-NewIssue {
    Log-Message "Attempting repair for new issue" "INFO"
    
    try {
        # Guard condition
        $issue = Get-Process -Name "ProblemProcess" -ErrorAction SilentlyContinue
        if (-not $issue) {
            Log-Message "Issue already resolved" "INFO"
            return
        }
        
        # Repair action
        Stop-Process -Name "ProblemProcess" -Force -ErrorAction SilentlyContinue
        
        # Verify
        $stillExists = Get-Process -Name "ProblemProcess" -ErrorAction SilentlyContinue
        if (-not $stillExists) {
            Log-Message "Successfully repaired new issue" "SUCCESS"
        } else {
            Log-Message "Repair failed - issue persists" "ERROR"
        }
    }
    catch {
        Log-Message "Repair error: $_" "ERROR"
    }
}
```

## 🔍 Debugging

### View Logs
```powershell
# Recent logs
Get-Content "$env:TEMP\Claude-Monitor-*.log" -Tail 50

# Live tail
Get-Content "$env:TEMP\Claude-Monitor-Service.log" -Wait -Tail 100

# Filter warnings/errors
Get-Content "$env:TEMP\Claude-Monitor-*.log" | Select-String -Pattern "WARN|ERROR"
```

### Manual Test Run
```powershell
# Single execution
PowerShell -NoProfile -ExecutionPolicy Bypass -File ".\Monitor-ClaudeHealth.ps1"

# With verbose output
$VerbosePreference = "Continue"
.\Monitor-ClaudeHealth.ps1
```

## 📦 Dependencies

- Windows 10/11
- PowerShell 5.1 or later
- Administrator privileges (for installation)
- No external modules required (keep it simple)

## 🤝 Getting Help

- Check [README-MONITOR.md](../../README-MONITOR.md) for user documentation
- Review [SYSTEM-DASHBOARD.md](../../SYSTEM-DASHBOARD.md) for architecture
- See [Test-Monitor-Smoke.ps1](../../Test-Monitor-Smoke.ps1) for test examples
- Reference `.github/agents/powershell-agent.md` for specialized PowerShell tasks
