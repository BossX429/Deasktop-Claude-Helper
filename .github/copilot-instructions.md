# Copilot Instructions for AnthropicClaude Repository

## Goal

Provide concise, actionable guidance so an AI coding agent can safely edit, test, and extend the Claude Health Monitor and related Hydra integration.

## Big picture (read first)

- The repo contains a multi-release Electron Claude app (`app-*`) and a small PowerShell-based auto-repair system that defends against Squirrel updater deadlocks and runaway processes.
- The monitor runs in two modes: Task Scheduler (recommended, scheduled every 5 minutes) and a Startup resident loop (`Monitor-Service.ps1`).
- Hydra-related tooling and audits live in the repo root (`hydra_*`, `HYDRA-AUDIT-REPORT.json`) — monitor must be non-blocking relative to Hydra services.

## Key files (open these first)

- `Monitor-ClaudeHealth.ps1` — core detection & repair. Config: `$CPUThreshold = 500`, `$MaxRetries`, `$RetryDelaySeconds`.
- `Monitor-Service.ps1` — resident loop; interval default 300s; logs to `$env:TEMP\Claude-Monitor-Service.log`.
- `Install-Scheduled-Task.ps1`, `Install-Monitor.bat`, `Setup-Monitor.bat` — installers that register `"Claude Health Monitor"` scheduled task (RunLevel: Highest/SYSTEM).
- `ColorScheme.ps1`, PowerShell profile — terminal helpers for colorized output during development.
- `HYDRA-*` files and `HYDRA-AUDIT-REPORT.json` — system audits, orchestration helpers; treat Hydra files as authoritative for distributed behavior.

## Developer workflows & commands (copy/paste)

- Run a single check:

```powershell
PowerShell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Someone\AppData\Local\AnthropicClaude\Monitor-ClaudeHealth.ps1"
```

- Run resident service (debug):

```powershell
PowerShell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Someone\AppData\Local\AnthropicClaude\Monitor-Service.ps1"
```

- Install as scheduled task (admin): run `Install-Scheduled-Task.ps1` elevated. Task name: `Claude Health Monitor`.
- Tail logs:

```powershell
Get-Content "$env:TEMP\Claude-Monitor-Service.log" -Tail 100 -Wait
Get-Content "$env:TEMP\Claude-Monitor-*.log" -Tail 50 -Wait
```

- Remove scheduled task:

```powershell
schtasks /delete /tn "Claude Health Monitor" /f
```

## Project-specific conventions (must follow)

- Error handling: use `-ErrorAction SilentlyContinue` and log errors with `Log-Message` instead of throwing.
- Process enumeration: always wrap `Get-Process` in `@(...)` to handle single vs multiple results.
- Logging: append timestamped bracketed lines to `$env:TEMP` logs via `Add-Content` to remain machine-parseable.
- Idempotence: repair functions must be safe to re-run; guard operations and avoid destructive state outside `%TEMP%`.

## Hydra integration rules (critical)

- Do not write to Hydra-managed files; read-only is allowed.
- Monitor must not block or sleep in a way that affects Hydra; keep repairs fast and idempotent.
- If you need cross-process coordination, prefer lock files in `%TEMP%` and document the behavior in comments.

## Safe-edit checklist (for PRs)

- Preserve `$CPUThreshold = 500` unless the change is reviewed.
- Preserve scheduled task name and log paths (`%TEMP\Claude-Monitor-*.log`).
- Add `Log-Message` calls for any new repair or detection action.
- Maintain `-ErrorAction SilentlyContinue` on external operations.

## Small examples (copy patterns)

- Detect loggable condition:

```powershell
Log-Message "Detected stuck Squirrel lock files" "WARN"
```

- Safe kill + restart explorer:

```powershell
Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
Start-Process explorer.exe
```

## When to ask maintainers

- Changes to install/uninstall flows, default thresholds, or file paths.
- Adding persistent state (outside `%TEMP%`) or external dependencies.
- Any change that affects Hydra orchestration or shared resources.

## Repository structure

This repository contains:
- **PowerShell monitoring scripts** (`.ps1` files) - Core health monitoring and auto-repair system
- **Python Hydra tooling** (`hydra_*.py` files) - Multi-head profiling, adaptive weighting, and orchestration
- **Installation scripts** (`.bat`, `.vbs` files) - Windows Task Scheduler integration
- **Documentation** (`.md` files) - Comprehensive guides for setup, maintenance, and troubleshooting
- **CI/CD workflows** (`.github/workflows/`) - Automated testing and deployment

## Testing and validation

### Running tests

All tests run on Windows runners and use PowerShell:

```powershell
# Run smoke tests (validates monitor script functionality)
PowerShell -NoProfile -ExecutionPolicy Bypass -File "Test-Monitor-Smoke.ps1"

# Run diagnostics (checks monitor and Hydra health)
PowerShell -NoProfile -ExecutionPolicy Bypass -File "Diagnose-Monitor-Hydra.ps1"

# Run Hydra rebalancing tests
PowerShell -NoProfile -ExecutionPolicy Bypass -File "test_rebalancing.ps1"
```

### CI/CD workflows

- **tests.yml**: Runs smoke tests and diagnostics on push/PR to main/develop
- **hydra-deploy.yml**: Manual deployment workflow for Hydra system (staging/production)

### Before committing changes

1. Run relevant tests locally if possible (Windows environment required)
2. Ensure PowerShell scripts maintain `-NoProfile -ExecutionPolicy Bypass` compatibility
3. Verify log file paths still use `%TEMP%` directory
4. Check that Task Scheduler task name remains "Claude Health Monitor"

## Language and ecosystem specifics

### PowerShell (.ps1 files)

- **No linter required** - scripts use basic PowerShell syntax
- **No build step** - scripts run directly via PowerShell interpreter
- **Dependencies**: None - uses built-in Windows cmdlets only
- **Style**: Follow existing comment style, use `Log-Message` for output

### Python (.py files)

- **Version**: Python 3.9+ (specified in hydra-deploy.yml)
- **No package manager** - scripts use Python standard library only
- **No linter configured** - follow existing code style
- **Dependencies**: `json`, `sys`, `statistics`, `pathlib`, `datetime` (all stdlib)

### Batch/VBScript files

- **Purpose**: Windows installer wrappers only
- **Do not modify** unless changing installation flow
- **No linting or testing** - simple wrappers for PowerShell scripts

## Code quality and review guidelines

### Security considerations

- Never hardcode credentials or API keys
- Avoid modifying system files outside `%TEMP%` and user's AppData
- Be cautious with `Stop-Process -Force` - only kill processes explicitly listed in documentation
- Validate all file paths before deletion operations

### Performance expectations

- Monitor script should complete in < 10 seconds
- Hydra profiling should complete in < 30 seconds
- No blocking operations that affect Hydra orchestration

### Common pitfalls to avoid

- Do not wrap `Get-Process` without `@(...)` - causes errors with single results
- Do not remove `-ErrorAction SilentlyContinue` - essential for production reliability
- Do not change CPU threshold without understanding impact on users
- Do not introduce new dependencies without approval

## Contribution workflow

1. Make minimal, surgical changes to address the specific issue
2. Test changes locally if possible (Windows environment ideal)
3. Update relevant documentation if behavior changes
4. Run smoke tests and diagnostics before creating PR
5. Include log output or test results in PR description

## Additional resources

- **Main documentation**: `README-MONITOR.md` - Installation and usage guide
- **Implementation status**: `IMPLEMENTATION-SUMMARY.md` - Project completion status
- **Hydra guides**: `HYDRA-*.md` files - Hydra system architecture and setup
- **Quick reference**: `QUICK-REFERENCE.md` - Common commands and workflows
