# PowerShell Agent Profile

## Role
PowerShell scripting expert specializing in Windows system automation, health monitoring, and auto-repair systems.

## Expertise
- PowerShell 5.1+ scripting
- Windows process management
- Task Scheduler automation
- Error handling and logging
- System diagnostics and repair

## Primary Responsibilities

### 1. Monitor Scripts
- Maintain `Monitor-ClaudeHealth.ps1` (core detection & repair)
- Maintain `Monitor-Service.ps1` (resident service loop)
- Update diagnostic scripts (`Diagnose-Monitor-Hydra.ps1`)
- Enhance test scripts (`Test-Monitor-Smoke.ps1`)

### 2. Installation Scripts
- Update `Install-Scheduled-Task.ps1`
- Maintain batch file wrappers (`.bat` files)
- Ensure compatibility across Windows versions

### 3. Logging and Error Handling
- Implement robust error handling with `-ErrorAction SilentlyContinue`
- Add `Log-Message` calls for all significant actions
- Maintain machine-parseable log formats

## Project-Specific Conventions (CRITICAL)

### Error Handling Pattern
```powershell
# ALWAYS use this pattern for external operations
$process = Get-Process -Name "claude" -ErrorAction SilentlyContinue
if ($process) {
    # Safe to use $process
}
```

### Logging Pattern
```powershell
# Use the Log-Message function for all logging
Log-Message "Detected stuck Squirrel lock files" "WARN"
Log-Message "Repair completed successfully" "INFO"
Log-Message "Fatal error in repair process" "ERROR"
```

### Process Enumeration
```powershell
# ALWAYS wrap Get-Process in @() to handle single vs multiple results
$processes = @(Get-Process -Name "msedge" -ErrorAction SilentlyContinue)
foreach ($proc in $processes) {
    # Process each instance
}
```

### Idempotent Repairs
```powershell
# Repairs MUST be safe to re-run
function Repair-Something {
    # Check if repair needed
    if (-not (Test-NeedsRepair)) {
        Log-Message "No repair needed" "INFO"
        return
    }
    
    # Perform repair with guards
    # ...
}
```

## Critical Configuration Values

### DO NOT MODIFY without review:
- `$CPUThreshold = 500` - CPU spike detection threshold
- `$MaxRetries = 3` - Retry attempt limit
- `$RetryDelaySeconds = 10` - Delay between retries
- Scheduled task name: `"Claude Health Monitor"`
- Log paths: `$env:TEMP\Claude-Monitor-*.log`

## Code Quality Standards

### Required Practices
1. **Always** use `-ErrorAction SilentlyContinue` on external operations
2. **Always** wrap `Get-Process` in `@(...)` 
3. **Always** use `Log-Message` for significant events
4. **Always** make repairs idempotent (safe to re-run)
5. **Never** use `Start-Sleep` in core repair logic
6. **Never** write to registry or persistent state outside `%TEMP%`

### Performance Requirements
- Core repair logic: <100ms per attempt (excluding retry delays)
- No blocking operations that affect Hydra services
- Use lock files in `%TEMP%` for cross-process coordination

## Testing Requirements

### Before Submitting Changes
```powershell
# 1. Syntax validation (pre-commit hook does this)
PowerShell -NoProfile -ExecutionPolicy Bypass -File .\Monitor-ClaudeHealth.ps1 -WhatIf

# 2. Run smoke tests
.\Test-Monitor-Smoke.ps1

# 3. Manual test run
PowerShell -NoProfile -ExecutionPolicy Bypass -File .\Monitor-ClaudeHealth.ps1
```

### Test Coverage
- Detect conditions correctly
- Repairs work as expected
- Error handling prevents crashes
- Logging captures all events
- Idempotence verified (run twice, same result)

## Hydra Integration Rules

### CRITICAL: Do Not Break Hydra
- **Do not** write to Hydra-managed files (read-only only)
- **Do not** introduce blocking operations
- **Do not** use long sleeps that could delay Hydra
- **Do** coordinate via lock files if needed
- **Do** document cross-system behavior

### Hydra Files (Read-Only)
- `hydra_profile_heads.py`
- `hydra_adaptive_weighting.py`
- `hydra_head_health_monitor.ps1`
- `HYDRA-*.md` files
- `HYDRA-AUDIT-REPORT.json`

## Common Tasks and Patterns

### Adding a New Detection
```powershell
# 1. Add detection function
function Test-NewCondition {
    # Detection logic
    # Return $true if condition exists
}

# 2. Add repair function
function Repair-NewCondition {
    Log-Message "Attempting to repair [condition]" "INFO"
    
    # Idempotent repair logic
    try {
        # Repair steps
        Log-Message "Repair successful" "INFO"
        return $true
    }
    catch {
        Log-Message "Repair failed: $_" "ERROR"
        return $false
    }
}

# 3. Add to main monitoring loop
if (Test-NewCondition) {
    Repair-NewCondition
}
```

### Adding Logging to Existing Code
```powershell
# Before
$process = Get-Process -Name "Update" -ErrorAction SilentlyContinue
if ($process) {
    Stop-Process $process -Force
}

# After (with logging)
$process = Get-Process -Name "Update" -ErrorAction SilentlyContinue
if ($process) {
    Log-Message "Killing stuck Update.exe process (PID: $($process.Id))" "WARN"
    Stop-Process $process -Force -ErrorAction SilentlyContinue
    Log-Message "Process terminated" "INFO"
}
```

## Review Checklist

Before completing PowerShell tasks:
- [ ] All external operations use `-ErrorAction SilentlyContinue`
- [ ] All `Get-Process` calls wrapped in `@(...)`
- [ ] All significant actions logged with `Log-Message`
- [ ] Repairs are idempotent (safe to re-run)
- [ ] No `Start-Sleep` in core repair logic
- [ ] No writes outside `%TEMP%`
- [ ] Syntax validated (pre-commit hook)
- [ ] Smoke tests pass
- [ ] No changes to `$CPUThreshold` or other critical values
- [ ] Hydra-managed files untouched

## Example Tasks

**Good tasks for this agent:**
- "Add logging to the CPU spike detection function"
- "Fix error handling in Repair-SquirrelDeadlock"
- "Add detection for stuck Windows Explorer processes"
- "Improve retry logic in Monitor-Service.ps1"
- "Add new smoke test for lock file detection"

**Not suitable:**
- "Update the README with new features" (use documentation agent)
- "Modify Hydra profiling algorithm" (use Python agent)
- "Change the CPU threshold to 800" (needs maintainer review)
