# Goal

Provide concise, actionable guidance so an AI coding agent can safely edit, test, and extend the Claude Health Monitor and integrated Hydra decision system.

## Task suitability for AI agents

### ✅ Good tasks for Copilot (assign with confidence)

- **Bug fixes** with clear reproduction steps and expected behavior
- **Test additions** for existing functionality (unit tests, integration tests)
- **Documentation updates** to match code changes or improve clarity
- **Code refactoring** following established project conventions
- **Technical debt** with well-defined scope and acceptance criteria
- **Logging improvements** - adding `Log-Message` calls to existing functions
- **Error handling** - adding `-ErrorAction SilentlyContinue` patterns
- **Accessibility improvements** with clear guidelines

### ⚠️ Review carefully (suitable but needs human oversight)

- **Performance optimizations** - verify benchmarks and test thoroughly
- **Configuration changes** to non-critical values (not `$CPUThreshold`)
- **New features** with clear requirements and test cases
- **Dependency updates** - check compatibility and run full test suite
- **Workflow modifications** - ensure CI/CD pipeline remains functional

### ❌ Not suitable for Copilot (assign to humans)

- **Security-critical fixes** - requires deep security expertise and review
- **Breaking changes** - needs careful migration planning and communication
- **Architecture changes** - requires system-wide understanding and design
- **Critical threshold adjustments** - e.g., changing `$CPUThreshold = 500`
- **Production deployment decisions** - requires business judgment
- **Hydra algorithm redesign** - needs mathematical and domain expertise
- **Branch protection changes** - repository governance decisions

### 📋 Custom agent profiles available

For specialized tasks, reference these agent profiles in your issue/PR:

- `.github/agents/documentation-agent.md` - README, guides, markdown files
- `.github/agents/powershell-agent.md` - Monitor scripts, error handling
- `.github/agents/python-agent.md` - Hydra profiling, weighting algorithms

Example: `[Agent: PowerShell] Add logging to CPU spike detection function`

## Big picture (read first)

- **Five-layer architecture**: Application (multi-release Electron Claude `app-*`), Health Monitoring, Hydra Decision System, VS Code Optimization, GitHub Actions CI/CD.
- **Health Monitor**: PowerShell auto-repair system defending against Squirrel updater deadlocks, runaway processes, and CPU spikes (`$CPUThreshold = 500`).
- **Dual execution modes**: Task Scheduler (recommended, 5-min interval) and resident loop (`Monitor-Service.ps1`).
- **Hydra integration**: Python-based profiling (`hydra_profile_heads.py`), adaptive weighting (`hydra_adaptive_weighting.py`), health monitoring (`hydra_head_health_monitor.ps1`), and validation suite.
- **Automation**: GitHub Actions workflows (`tests.yml`, `hydra-deploy.yml`), git hooks, branch protection — all non-blocking relative to Hydra services.
- **Documentation ecosystem**: Architecture dashboards, deployment guides, audits, and reconnaissance reports provide context for all changes.

## Key files (open these first)

### Monitor & Health System

- `Monitor-ClaudeHealth.ps1` — core detection & repair. Config: `$CPUThreshold = 500`, `$MaxRetries`, `$RetryDelaySeconds`.
- `Monitor-Service.ps1` — resident loop; interval default 300s; logs to `$env:TEMP\Claude-Monitor-Service.log`.
- `Install-Scheduled-Task.ps1`, `Install-Monitor.bat`, `Setup-Monitor.bat` — register `"Claude Health Monitor"` scheduled task (RunLevel: Highest/SYSTEM).
- `Test-Monitor-Smoke.ps1` — 5 validation tests; triggered by CI/CD before deployment.
- `Diagnose-Monitor-Hydra.ps1` — 11 diagnostic checks for troubleshooting; used for health assessment.

### Hydra Deployment System

- `hydra_profile_heads.py` — Phase 1: profile heads (100 tests each, 15 min total).
- `hydra_adaptive_weighting.py` — Phase 2: calculate dynamic weights (2 min total).
- `hydra_head_health_monitor.ps1` — Phase 4: monitor deployment confidence (5+ min ongoing).
- `test_rebalancing.ps1` — Phase 5: validate improvements (5 min).
- `HYDRA-*.md` files — architecture, audit reports, implementation guides. **Read as authoritative** for distributed behavior.
- `HYDRA-AUDIT-REPORT.json` — baseline metrics, head profiles, threading model.

### Automation & CI/CD

- `.github/workflows/tests.yml` — smoke tests + diagnostics; triggered on push/PR.
- `.github/workflows/hydra-deploy.yml` — 5-phase deployment; triggered manually via `workflow_dispatch`.
- `.git/hooks/pre-commit`, `pre-push` — validation gates (sample templates present, ready for activation).

### Repository state (important)

- `main` is protected: direct pushes to `main` will be rejected by branch protection. Always work on a feature branch and open a pull request.
- Required status check: `smoke-tests` — PRs must pass this CI check before they can be merged into `main`.
- Pull requests require at least 1 approving review (branch-protection is enforced programmatically).
- Use clear branch names (e.g., `feature/xxx`, `fix/yyy`, or `test/phase-e-validation`) and include a short PR description explaining the change.
- If automation needs to interact with repository settings (branch protection, workflow dispatch), use the GitHub CLI (`gh`) with a token that includes the `workflow` and `repo` scopes. Never commit tokens to the repo.

### How AI agents should operate in this repo

- Do not attempt to push directly to `main`. Create a new branch, commit changes there, push, and open a PR. Wait for `smoke-tests` to pass and for an approving review.
- Respect Hydra rules: do not write to Hydra-managed files (read-only only) and avoid long sleeps or blocking operations that could affect Hydra services.
- Follow project conventions: use `-ErrorAction SilentlyContinue` in PowerShell scripts, emit `Log-Message` calls for detectable actions, and keep repair functions idempotent.
- When making automated edits, include small, focused tests (or a smoke test) and reference the relevant CI workflow (`.github/workflows/tests.yml`) in the PR body to speed review.
- If you need to run workflows programmatically, prefer `gh workflow run` / `gh api` calls and ensure the runner token has appropriate scopes — do this only when explicit permission is granted by maintainers.

### Reference & Context

- `SYSTEM-DASHBOARD.md` — five-layer ASCII diagram, status matrix, execution timeline, file map.
- `PRIORITY-1-QUICKSTART.md` — step-by-step deployment guide (30 min read).
- `FULL-SITE-RECONNAISSANCE.md` — complete 60+ KB analysis, all 5 workflow issues, component inventory.
- `GIT-WORKFLOW.md` — branch strategy, commit conventions, PR process, CI/CD pipeline.
- `ColorScheme.ps1` — terminal helpers for colorized output during development.

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

### Hydra-specific checks (add to PRs touching Hydra code)

- Run Python syntax checks: `python -m py_compile hydra_*.py` and `python -m py_compile hydra_dashboard_config_gen.py` locally before opening a PR.
- Do not commit generated artifacts (for example: `hydra_profiles/`, `hydra_dashboard_config.json`) — these are runtime outputs and should remain untracked. If you need to include sample output for review, add an anonymized excerpt to the PR description instead.
- When changing profiling or weighting code, include a short reproducible smoke run (e.g., `python hydra_profile_heads.py --num-tests 10`) and attach the generated summary (sanitized) to the PR.
- Note expected runtime for hydra flows in the PR description when relevant: profiling (~15 min for full run), weighting (~2 min), deploy pipeline (total ~30–40 min across phases).

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

## PR body template (for AI agents)

When opening a PR, use this structure for consistency and speedier review:

```markdown
## What changed?

- <Brief description of the change>

## Why?

- <Reason: feature, fix, docs, or refactor>

## Tests

- [ ] Local smoke tests pass: `Test-Monitor-Smoke.ps1`
- [ ] Checked PowerShell syntax (pre-commit hook)
- [ ] No breaking changes to $CPUThreshold or log paths

## Checklist

- [ ] Branch created from main (not pushed to main directly)
- [ ] PR title clear (e.g., `fix(monitor): resolve Squirrel deadlock`)
- [ ] Commit messages follow `<type>(<scope>): <subject>` format
- [ ] Ready for `smoke-tests` CI check to run

## Reviewer notes

- Required status check: `smoke-tests` must pass
- Required approval: at least 1 review
- Merge strategy: Squash and merge (unless commit history important)
```

## Autonomous CI/CD & Auto-Merge (Important!)

The repository is configured for **fully autonomous PR operations**:

1. **Branch naming**: PRs created with `copilot/`, `ai/`, or `[AI]` prefix are automatically recognized as AI-generated
2. **Auto-review requests**: Maintainers are automatically requested to review AI-generated PRs
3. **Auto-merge**: Once all checks pass (`smoke-tests` ✅) AND 1 maintainer approves, the PR will **automatically merge** (squash strategy)

**For AI agents:**

- Create clear, focused branches: `copilot/fix-xxx` or `ai/feature-yyy`
- Ensure your PR body explains the changes (see `.github/PULL_REQUEST_TEMPLATE.md`)
- The system will handle review requests and merging automatically
- No manual intervention needed if tests pass!

**For maintainers:**

- Reviews trigger auto-merge workflow when all conditions are met
- You can still review/modify the PR before auto-merge happens
- Branch protection ensures all checks pass before any merge

## Critical DON'Ts (from HYDRA audit)

- **Never** commit PAT tokens; use Windows credential manager or environment variables.
- **Never** modify `HYDRA-*.md` or `HYDRA-AUDIT-*.json` files (read-only; managed by Hydra system).
- **Never** use `Start-Sleep` in repair functions; keep core repair logic fast (<100ms target per attempt; excludes any `$RetryDelaySeconds` between retries).
- **Never** write to registry or shared application state outside `%TEMP%`; prefer lock files for coordination.
- **Never** ignore `-ErrorAction SilentlyContinue`; all external operations must handle errors gracefully.
