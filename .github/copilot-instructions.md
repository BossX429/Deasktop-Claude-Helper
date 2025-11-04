# Goal

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

If you want, I can expand this to include: exact sample log lines, a small smoke-test harness, or a checklist to gate PRs. Reply with which to add.
