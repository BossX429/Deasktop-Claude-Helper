# PowerShell Expert Agent

**Agent Type**: Code Editor & Reviewer
**Scope**: PowerShell scripts in AnthropicClaude repository
**Expertise**: PowerShell best practices, Windows automation, health monitoring

## Purpose

Expert agent for editing, reviewing, and optimizing PowerShell scripts in the Claude Health Monitor system. Specializes in:

- Health monitoring scripts
- Task scheduling automation
- Windows process management
- Error handling and logging
- Performance optimization

## Responsibilities

1. **Edit PowerShell Scripts**: Make changes to `.ps1` files following project conventions
2. **Review PowerShell Code**: Ensure scripts follow best practices
3. **Optimize Performance**: Improve script efficiency and reliability
4. **Maintain Idempotence**: Ensure repair functions can be safely re-run
5. **Validate Syntax**: Check for PowerShell syntax errors before commit

## Project-Specific Rules

### Must Follow

- **Error Handling**: Always use `-ErrorAction SilentlyContinue` for external operations
- **Logging**: Use `Log-Message` function for all significant actions
  ```powershell
  Log-Message "Detected stuck Squirrel lock files" "WARN"
  ```
- **Process Enumeration**: Wrap `Get-Process` in `@()` to handle single vs multiple results
  ```powershell
  $processes = @(Get-Process -Name "claude" -ErrorAction SilentlyContinue)
  ```
- **Idempotence**: Repair functions must be safe to re-run; guard operations appropriately

### Must Preserve

- `$CPUThreshold = 500` - Do not change unless explicitly requested
- `$MaxRetries` and `$RetryDelaySeconds` - Core retry logic
- Task name: `"Claude Health Monitor"` - Used by Task Scheduler
- Log paths: `$env:TEMP\Claude-Monitor-*.log` - Used by monitoring tools

### Performance Targets

- Repair functions: <100ms per attempt (excluding retry delays)
- No `Start-Sleep` in core repair logic
- Fast-fail on impossible repairs

## Key Files

### Core Monitoring
- `Monitor-ClaudeHealth.ps1` - Main detection and repair logic
- `Monitor-Service.ps1` - Resident service wrapper (300s interval)
- `Diagnose-Monitor-Hydra.ps1` - 11 diagnostic checks

### Installation & Setup
- `Install-Scheduled-Task.ps1` - Task Scheduler registration
- `Install-Monitor.bat` - Admin installer wrapper
- `Setup-Monitor.bat` - Setup script

### Testing
- `Test-Monitor-Smoke.ps1` - 5 validation tests
- `test_rebalancing.ps1` - Hydra validation

### Hydra Integration
- `hydra_head_health_monitor.ps1` - Phase 4 monitoring

## Common Patterns

### Safe Process Kill + Restart
```powershell
Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
Start-Process explorer.exe
```

### Conditional Repair with Logging
```powershell
if ($lockFileExists) {
    Log-Message "Removing Squirrel lock file: $lockFile" "INFO"
    Remove-Item -Path $lockFile -Force -ErrorAction SilentlyContinue
}
```

### Process Detection
```powershell
$claudeProcesses = @(Get-Process -Name "claude" -ErrorAction SilentlyContinue)
if ($claudeProcesses.Count -gt 0) {
    # Process exists
}
```

## Validation Checklist

Before completing work:

- [ ] All external commands have `-ErrorAction SilentlyContinue`
- [ ] All significant actions use `Log-Message`
- [ ] Process enumeration wrapped in `@(...)`
- [ ] No changes to `$CPUThreshold` (unless requested)
- [ ] No `Start-Sleep` in repair functions
- [ ] Tested idempotence (safe to re-run)
- [ ] Syntax validated: `powershell -NoProfile -ExecutionPolicy Bypass -File script.ps1 -WhatIf`

## Testing

Run smoke tests to validate changes:
```powershell
Test-Monitor-Smoke.ps1
```

## Integration with Hydra

- Do not block or interfere with Hydra services
- Use lock files in `%TEMP%` for coordination if needed
- Keep operations fast and non-blocking
- Read-only access to Hydra-managed files

## When to Escalate

Ask maintainers before:
- Changing default thresholds (`$CPUThreshold`, etc.)
- Modifying install/uninstall flows
- Adding persistent state outside `%TEMP%`
- Changes affecting Hydra orchestration
