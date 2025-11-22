# CLAUDE.md - AI Assistant Guide

**Last Updated:** 2025-11-22
**Repository:** Desktop Claude Helper - Health Monitor & Hydra Decision System
**Purpose:** Comprehensive guide for AI assistants working with this codebase

---

## Table of Contents

1. [Quick Start for AI Assistants](#quick-start-for-ai-assistants)
2. [Repository Overview](#repository-overview)
3. [Codebase Structure](#codebase-structure)
4. [Development Workflows](#development-workflows)
5. [Critical Conventions & Rules](#critical-conventions--rules)
6. [File Organization Patterns](#file-organization-patterns)
7. [Testing & Validation](#testing--validation)
8. [Hydra System Guidelines](#hydra-system-guidelines)
9. [Git Workflow & Branching](#git-workflow--branching)
10. [Common Tasks & Examples](#common-tasks--examples)
11. [Safety & Security](#safety--security)
12. [Troubleshooting](#troubleshooting)

---

## Quick Start for AI Assistants

### Essential Information

**What This Repository Does:**
- Automated Windows health monitoring for Claude desktop application
- Detects and repairs: Squirrel updater deadlocks, CPU spikes, process management issues
- Advanced Hydra decision system for adaptive optimization
- Runs via Task Scheduler every 5 minutes or as continuous service

**Before Making Changes:**
1. ✅ Read the relevant instruction file in `.github/instructions/` for your file type
2. ✅ Review `Monitor-ClaudeHealth.ps1:1-50` to understand core monitoring logic
3. ✅ Check if your changes affect critical configuration (see [Critical Settings](#critical-settings))
4. ✅ Ensure changes are idempotent (safe to run multiple times)
5. ✅ Run smoke tests before committing: `.\Test-Monitor-Smoke.ps1`

**Key Files to Understand:**
- `Monitor-ClaudeHealth.ps1` - Core health detection and repair engine
- `.github/instructions/` - File-scoped instructions (auto-loaded by Copilot)
- `SYSTEM-DASHBOARD.md` - Architecture overview
- `GIT-WORKFLOW.md` - Branch strategy and commit conventions

**Critical Rules:**
- ❌ **NEVER** modify `$CPUThreshold = 500` without explicit review
- ❌ **NEVER** write to `hydra_profiles/` directory from non-Hydra scripts
- ❌ **NEVER** modify Hydra-managed files (HYDRA-*.md, HYDRA-AUDIT-*.json)
- ✅ **ALWAYS** use `-ErrorAction SilentlyContinue` on Get-Process/Stop-Process
- ✅ **ALWAYS** wrap Get-Process in `@(...)` for safe iteration
- ✅ **ALWAYS** run `Test-Monitor-Smoke.ps1` before pushing

---

## Repository Overview

### Architecture: Five-Layer System

```
┌─────────────────────────────────────────┐
│  Layer 5: GitHub Actions CI/CD          │ ← Automated testing & deployment
│  (.github/workflows/)                   │
├─────────────────────────────────────────┤
│  Layer 4: VS Code Optimization          │ ← Development environment tuning
│  (Optimize-VSCode.ps1)                  │
├─────────────────────────────────────────┤
│  Layer 3: Hydra Decision System         │ ← Python-based profiling & optimization
│  (hydra_*.py, hydra_profiles/)          │
├─────────────────────────────────────────┤
│  Layer 2: Health Monitoring             │ ← PowerShell auto-repair system
│  (Monitor-*.ps1, Test-*.ps1)            │
├─────────────────────────────────────────┤
│  Layer 1: Application Layer             │ ← Claude desktop (multiple versions)
│  (External - not in repo)               │
└─────────────────────────────────────────┘
```

### Technology Stack

| Component | Technology | Version | Purpose |
|-----------|-----------|---------|---------|
| Health Monitor | PowerShell | 5.1+ | Detection, repair, logging |
| Hydra System | Python | 3.7+ | Profiling, adaptive weighting |
| Installation | Batch, VBScript | N/A | User-friendly installers |
| Automation | GitHub Actions | N/A | CI/CD, testing, deployment |
| Configuration | JSON, YAML | N/A | Profiles, workflows, rules |

### Key Statistics

- **Total Files:** 92 (79 root + 13 in `.github/`)
- **Documentation:** 58 markdown files (63% of files)
- **Scripts:** 10 PowerShell + 3 Python + 5 Batch + 1 VBScript
- **Workflows:** 4 GitHub Actions workflows
- **Tests:** 5 smoke tests + 11 diagnostic checks

---

## Codebase Structure

### Directory Layout

```
/Deasktop-Claude-Helper/
├── .github/                          # GitHub metadata & automation
│   ├── workflows/                    # CI/CD pipeline definitions
│   │   ├── tests.yml                 # Smoke tests + diagnostics (required check)
│   │   ├── hydra-deploy.yml          # 5-phase Hydra deployment
│   │   ├── autonomous-pr-operations.yml  # AI PR auto-merge
│   │   └── auto-populate-pr-template.yml # PR template automation
│   ├── instructions/                 # Modern file-scoped Copilot instructions
│   │   ├── global.instructions.md    # Repository-wide rules
│   │   ├── powershell.instructions.md # PowerShell-specific patterns
│   │   ├── python.instructions.md    # Python-specific patterns
│   │   ├── docs.instructions.md      # Documentation standards
│   │   └── github-workflows.instructions.md # Workflow conventions
│   ├── agents/                       # Custom specialized agent profiles
│   │   ├── documentation-agent.md    # README updates, user guides
│   │   ├── powershell-agent.md       # Monitor script enhancements
│   │   └── python-agent.md           # Hydra system modifications
│   ├── copilot-instructions.md       # Legacy comprehensive instructions
│   ├── PULL_REQUEST_TEMPLATE.md      # Standard PR template
│   └── branch-protection.json        # Branch protection configuration
│
├── hydra_profiles/                   # Generated Hydra profiling data
│   └── head_profile_*.json           # Timestamped profile outputs
│
├── .editorconfig                     # Editor consistency (2 spaces, CRLF, UTF-8)
├── .gitignore                        # VCS exclusions
├── CODEOWNERS                        # Repository ownership (BossX429)
│
├── Core Health Monitoring Scripts (Layer 2)
│   ├── Monitor-ClaudeHealth.ps1      # Primary detection & repair engine
│   ├── Monitor-Service.ps1           # Resident service wrapper (300s interval)
│   ├── ColorScheme.ps1               # Logging utility (Log-Message function)
│   └── Rotate-MonitorLogs.ps1        # Log maintenance
│
├── Testing & Diagnostics
│   ├── Test-Monitor-Smoke.ps1        # 5 validation tests (CI required check)
│   └── Diagnose-Monitor-Hydra.ps1    # 11-point full diagnostic
│
├── Hydra Profiling System (Layer 3)
│   ├── hydra_profile_heads.py        # Phase 1: Profile 15 consensus heads
│   ├── hydra_adaptive_weighting.py   # Phase 2: Dynamic weight calculation
│   ├── hydra_dashboard_config_gen.py # Phase 3: Dashboard config generation
│   ├── hydra_head_health_monitor.ps1 # Phase 4: Deployment monitoring
│   └── test_rebalancing.ps1          # Phase 5: Validation
│
├── Installation & Setup (Layer 4)
│   ├── Install-Monitor.bat           # Task Scheduler installation
│   ├── Install-Scheduled-Task.ps1    # PowerShell installer core
│   ├── Install-Task.bat              # Alternate installer
│   ├── Create-StartupLink.bat        # Startup folder installer
│   └── Install-Monitor.vbs           # VBScript installer UI
│
├── Optimization (Layer 4)
│   └── Optimize-VSCode.ps1           # 5 VS Code performance tweaks
│
└── Documentation (58 files)
    ├── User Documentation
    │   ├── README.md                 # Main entry point
    │   ├── README-MONITOR.md         # Installation guide
    │   ├── QUICK-REFERENCE.md        # Command cheat sheet
    │   └── QUICKSTART-CARD.md        # One-page reference
    │
    ├── Developer Documentation
    │   ├── SYSTEM-DASHBOARD.md       # Architecture overview
    │   ├── GIT-WORKFLOW.md           # Branch strategy & commits
    │   ├── CONTRIBUTING.md           # Contribution guidelines
    │   └── PRIORITY-1-QUICKSTART.md  # Deployment guide
    │
    ├── Technical Documentation
    │   ├── HYDRA-IMPLEMENTATION-GUIDE.md  # 38 KB comprehensive guide
    │   ├── AUTOMATION-SUITE.md       # CI/CD pipeline details
    │   └── AUTONOMOUS-CI.md          # Autonomous operations
    │
    └── Status & Reports
        ├── PHASE-*.md               # Phase completion reports
        ├── PRIORITY-1-*.md          # Deployment manifests
        ├── HYDRA-AUDIT-*.md         # Audit reports
        └── STATUS-*.md              # Current status tracking
```

### File Type Distribution

| Type | Count | Extensions | Primary Purpose |
|------|-------|------------|-----------------|
| Documentation | 58 | `.md` | Guides, reports, references |
| PowerShell | 10 | `.ps1` | Monitoring, testing, Hydra operations |
| Python | 3 | `.py` | Hydra profiling & weighting |
| Batch | 5 | `.bat` | Windows installers |
| VBScript | 1 | `.vbs` | Alternative installer |
| YAML | 4 | `.yml` | GitHub Actions workflows |
| JSON | 3 | `.json` | Configuration, profiles |
| Config | 2 | `.editorconfig`, `.gitignore` | Development setup |

---

## Development Workflows

### Copilot Integration System

This repository uses **modern file-scoped instructions** with YAML frontmatter:

#### Instruction Files (`.github/instructions/`)

1. **global.instructions.md** - Applies to: `**/*`
   - Repository overview
   - Task suitability matrix
   - Security rules
   - Git workflow requirements

2. **powershell.instructions.md** - Applies to: `**/*.ps1`
   - Error handling patterns (`-ErrorAction SilentlyContinue`)
   - Process enumeration wrapping (`@(...)`)
   - Logging conventions (`Log-Message`)
   - Idempotence requirements
   - Critical configuration warnings

3. **python.instructions.md** - Applies to: `**/*.py`
   - Python 3.7+ requirement
   - Syntax validation (`py_compile`)
   - Error handling patterns
   - Hydra system phases

4. **docs.instructions.md** - Applies to: `**/*.md`
   - Writing style (clear, professional, action-oriented)
   - Structure guidelines
   - Formatting standards

5. **github-workflows.instructions.md** - Applies to: `.github/workflows/**/*.yml`
   - YAML syntax conventions
   - Permissions management
   - Secrets handling
   - Security requirements

**How Instructions Work:**
- GitHub Copilot automatically loads relevant instructions based on file type
- Instructions use `applies_to` glob patterns to scope rules
- Multiple instructions can apply simultaneously (e.g., global + powershell)

#### Custom Agent Profiles (`.github/agents/`)

Specialized agent profiles for specific task categories:

1. **documentation-agent.md** - README updates, user guides, changelog
2. **powershell-agent.md** - Monitor script updates, error handling
3. **python-agent.md** - Hydra profiling, weight algorithms

**Usage in Issues/PRs:**
```markdown
[Agent: PowerShell] Add retry logic to Squirrel deadlock detection
[Agent: Documentation] Update QUICK-REFERENCE.md with new commands
[Agent: Python] Optimize hydra_adaptive_weighting.py performance
```

### CI/CD Pipeline

#### Workflow 1: tests.yml (Required Check)

**Triggers:** Push/PR to `main`, manual dispatch
**Platform:** Windows-latest
**Runtime:** ~3-5 minutes

**Jobs:**
1. **smoke-tests** (REQUIRED for merge)
   - Executes `Test-Monitor-Smoke.ps1`
   - 5 validation tests
   - Blocks PR merging if fails

2. **diagnostics**
   - Executes `Diagnose-Monitor-Hydra.ps1`
   - 11 comprehensive checks
   - Informational only

**Status Check:** `smoke-tests` must pass to merge to `main`

#### Workflow 2: hydra-deploy.yml (Manual)

**Trigger:** Manual (`workflow_dispatch`)
**Platform:** Windows-latest
**Runtime:** ~30-40 minutes

**Phases (Sequential):**
1. **Phase 1 - Profile** (~15 min)
   - Executes `hydra_profile_heads.py`
   - Tests each of 15 consensus heads 100 times
   - Outputs to `hydra_profiles/head_profile_*.json`

2. **Phase 2 - Weights** (~2 min)
   - Executes `hydra_adaptive_weighting.py`
   - Calculates dynamic weights from profiles
   - Formula: (accuracy × 0.40) + (speed × 0.30) + (confidence × 0.30)

3. **Phase 3 - Deploy** (<1 min)
   - Deployment message
   - Configuration application

4. **Phase 4 - Monitor** (5+ min)
   - Executes `hydra_head_health_monitor.ps1`
   - Real-time deployment confidence tracking
   - Target: 78.7% → 88%+

5. **Phase 5 - Validate** (~5 min)
   - Executes `test_rebalancing.ps1`
   - Effectiveness verification
   - Success rate analysis

#### Workflow 3: autonomous-pr-operations.yml

**Triggers:** PR opened/reopened/synchronized, PR reviews
**Purpose:** Enable AI agent autonomy with safeguards

**Jobs:**
1. **request-reviews** - Auto-requests reviews for `copilot/*` or `ai/*` branches
2. **auto-merge-on-approval** - Auto-merges when:
   - At least 1 approving review
   - `smoke-tests` check passes
   - No requested changes

**AI Detection:** Branch prefix (`copilot/`, `ai/`) or PR labels

#### Workflow 4: auto-populate-pr-template.yml

**Trigger:** PR opened
**Purpose:** Auto-populate PR description from template

---

## Critical Conventions & Rules

### PowerShell Mandatory Patterns

#### 1. Error Handling

**ALWAYS use `-ErrorAction SilentlyContinue`:**

```powershell
# ✅ CORRECT
Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
Get-Process -Name Claude -ErrorAction SilentlyContinue

# ❌ INCORRECT - Will throw errors and halt execution
Stop-Process -Name explorer -Force
Get-Process -Name Claude
```

**Why:** External processes may not exist; errors should be silent for monitoring.

#### 2. Process Enumeration

**ALWAYS wrap Get-Process in `@(...)`:**

```powershell
# ✅ CORRECT - Ensures $processes is always an array
$processes = @(Get-Process -Name "Claude" -ErrorAction SilentlyContinue)
if ($processes.Count -gt 0) { ... }

# ❌ INCORRECT - May be $null or single object, breaking .Count
$processes = Get-Process -Name "Claude" -ErrorAction SilentlyContinue
```

**Why:** Ensures consistent array handling for iteration and counting.

#### 3. Logging

**ALWAYS use Log-Message for important actions:**

```powershell
# ✅ CORRECT - Uses ColorScheme.ps1 helper
. "$PSScriptRoot\ColorScheme.ps1"
Log-Message "Detected stuck Squirrel lock files" "WARN"
Log-Message "Repair completed successfully" "SUCCESS"

# ✅ ALSO CORRECT - Direct log file writing
Add-Content -Path "$env:TEMP\Claude-Monitor-Service.log" `
    -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] [INFO] Action completed"

# ❌ INCORRECT - Using Write-Host (not logged to file)
Write-Host "Action completed"
```

**Log Levels:** `INFO`, `WARN`, `ERROR`, `SUCCESS`

#### 4. Idempotence Requirement

**ALL repair functions MUST be safe to re-run:**

```powershell
# ✅ CORRECT - Guards operation before executing
function Repair-SquirrelDeadlock {
    $lockFiles = Get-ChildItem -Path "$env:TEMP" -Filter ".squirrel-lock-*" -ErrorAction SilentlyContinue
    if ($lockFiles) {
        Log-Message "Removing Squirrel lock files" "INFO"
        $lockFiles | Remove-Item -Force -ErrorAction SilentlyContinue
    } else {
        Log-Message "No lock files found" "INFO"
    }
}

# ❌ INCORRECT - No guard, assumes files exist
function Repair-SquirrelDeadlock {
    Remove-Item -Path "$env:TEMP\.squirrel-lock-*" -Force
}
```

**Why:** Monitoring runs every 5 minutes; operations must not fail on repeat.

#### 5. Critical Settings

**DO NOT MODIFY without explicit review:**

```powershell
# ❌ CRITICAL - Requires team review before changing
[int]$CPUThreshold = 500      # 500% = 5 cores at 100%

# REASON: False positives can kill legitimate processes
# CHANGE PROCESS: Create issue → Team review → Testing → PR approval
```

**Safe to modify:**

```powershell
# ✅ SAFE - Configuration parameters
[int]$MaxRetries = 3                # Repair attempt limit
[int]$RetryDelaySeconds = 10        # Delay between retries
[int]$MonitorInterval = 300         # 5-minute interval (seconds)
```

### Python Mandatory Patterns

#### 1. Version Requirement

**Python 3.7+ required:**

```python
# Add to all Hydra scripts
import sys

if sys.version_info < (3, 7):
    print("Error: Python 3.7 or higher required", file=sys.stderr)
    sys.exit(1)
```

#### 2. Syntax Validation

**BEFORE committing, ALWAYS validate:**

```bash
# Run in repository root
python -m py_compile hydra_profile_heads.py
python -m py_compile hydra_adaptive_weighting.py
python -m py_compile hydra_dashboard_config_gen.py
```

#### 3. Error Handling

```python
# ✅ CORRECT - Specific exceptions with fallback
try:
    with open(profile_path, 'r') as f:
        data = json.load(f)
except FileNotFoundError as e:
    print(f"Error: Profile file not found: {e}", file=sys.stderr)
    sys.exit(1)
except json.JSONDecodeError as e:
    print(f"Error: Invalid JSON in profile: {e}", file=sys.stderr)
    sys.exit(1)
except Exception as e:
    print(f"Unexpected error: {e}", file=sys.stderr)
    raise

# ❌ INCORRECT - Generic catch-all without re-raising
try:
    process()
except Exception as e:
    print(f"Error: {e}")
```

#### 4. Logging

```python
from datetime import datetime
import sys

def log_message(message, level="INFO"):
    """Log message with timestamp to stderr"""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"[{timestamp}] [{level}] {message}", file=sys.stderr)

# Usage
log_message("Starting profiling phase", "INFO")
log_message("Profile completed successfully", "SUCCESS")
```

### Documentation Standards

#### 1. Markdown Structure

```markdown
# Title (H1 - One per document)

## Section (H2 - Major sections)

### Subsection (H3 - Details)

#### Detail (H4 - Fine details)

**Bold** for emphasis
*Italic* for technical terms
`code` for inline code
```

#### 2. Code Blocks

**ALWAYS specify language for syntax highlighting:**

```markdown
# ✅ CORRECT
```powershell
Get-Process -Name Claude
```

```python
import sys
```

# ❌ INCORRECT - No language specified
```
Get-Process -Name Claude
```
```

#### 3. File References

**ALWAYS use absolute paths with line numbers:**

```markdown
# ✅ CORRECT
The CPU threshold is defined in Monitor-ClaudeHealth.ps1:15

# ❌ INCORRECT - Ambiguous reference
The CPU threshold is set in the monitor script
```

**Format:** `filename.ext:line_number` or `path/to/file.ext:line_number`

---

## File Organization Patterns

### Naming Conventions

#### PowerShell Scripts: `[Verb]-[Noun].ps1`

| Pattern | Examples | Purpose |
|---------|----------|---------|
| Monitor-*.ps1 | Monitor-ClaudeHealth.ps1, Monitor-Service.ps1 | Health monitoring & detection |
| Test-*.ps1 | Test-Monitor-Smoke.ps1 | Testing & validation |
| Diagnose-*.ps1 | Diagnose-Monitor-Hydra.ps1 | Diagnostic tools |
| Install-*.ps1 | Install-Scheduled-Task.ps1 | Installation scripts |
| Optimize-*.ps1 | Optimize-VSCode.ps1 | Optimization tools |
| Rotate-*.ps1 | Rotate-MonitorLogs.ps1 | Maintenance utilities |

**Approved Verbs:** Monitor, Test, Diagnose, Install, Optimize, Rotate, Repair, Get, Set, Start, Stop

#### Python Scripts: `hydra_[component]_[function].py`

| Pattern | Examples | Phase |
|---------|----------|-------|
| hydra_profile_*.py | hydra_profile_heads.py | Phase 1 - Profiling |
| hydra_adaptive_*.py | hydra_adaptive_weighting.py | Phase 2 - Weighting |
| hydra_dashboard_*.py | hydra_dashboard_config_gen.py | Phase 3 - Configuration |
| hydra_*_monitor.ps1 | hydra_head_health_monitor.ps1 | Phase 4 - Monitoring |

**ALL Hydra scripts start with `hydra_` prefix**

#### Installation Scripts: `[Action]-[Component].[ext]`

| Type | Examples | Admin Required |
|------|----------|----------------|
| Batch | Install-Monitor.bat, Setup-Monitor.bat | YES (first time) |
| VBScript | Install-Monitor.vbs | YES (first time) |

#### Documentation: `SCREAMING_CAPS.md`

| Pattern | Examples | Purpose |
|---------|----------|---------|
| README*.md | README.md, README-MONITOR.md | Entry points |
| QUICK*.md | QUICK-REFERENCE.md, QUICKSTART-CARD.md | Quick access |
| [SYSTEM]-[TYPE].md | SYSTEM-DASHBOARD.md, GIT-WORKFLOW.md | Technical guides |
| HYDRA-*.md | HYDRA-IMPLEMENTATION-GUIDE.md | Hydra documentation |
| PRIORITY-[N]-*.md | PRIORITY-1-QUICKSTART.md | Deployment phases |
| PHASE-[LETTER]-*.md | PHASE-B-COMPLETE.md | Phase reports |

### File Location Defaults

**Installation Paths:**
```
C:\Users\[Username]\AppData\Local\AnthropicClaude\
├── Monitor-ClaudeHealth.ps1
├── Monitor-Service.ps1
├── Install-Scheduled-Task.ps1
└── [other scripts]
```

**Log Outputs:**
```
%TEMP%\Claude-Monitor-[YYYYMMDD].log      # Daily logs
%TEMP%\Claude-Monitor-Service.log          # Continuous service log
%TEMP%\hydra_head_health_monitor.log       # Hydra monitoring
```

**Profile Outputs:**
```
hydra_profiles\head_profile_[TIMESTAMP].json
```

---

## Testing & Validation

### Smoke Tests (Required)

**File:** `Test-Monitor-Smoke.ps1`
**Tests:** 5 validation checks
**Runtime:** ~30 seconds
**CI Integration:** Required check for PR merging

**Tests:**
1. **Deadlock Detection** - Verifies Squirrel lock file detection
2. **CPU Spike Detection** - Validates CPU threshold monitoring
3. **Process Enumeration** - Ensures Get-Process wrapping works
4. **Repair Function** - Tests idempotent repair execution
5. **Log Creation** - Confirms logging functionality

**Run Locally:**
```powershell
.\Test-Monitor-Smoke.ps1
```

**Expected Output:**
```
[PASS] Test 1: Deadlock detection
[PASS] Test 2: CPU spike detection
[PASS] Test 3: Process enumeration
[PASS] Test 4: Repair function
[PASS] Test 5: Log creation
All smoke tests passed!
```

### Diagnostics (Informational)

**File:** `Diagnose-Monitor-Hydra.ps1`
**Checks:** 11 diagnostic tests
**Runtime:** ~1 minute
**CI Integration:** Informational only

**Checks:**
1. Task Scheduler registration status
2. Log file accessibility
3. PowerShell version compatibility
4. Process conflict detection
5. Hydra profile directory existence
6. Hydra script syntax validation
7. Python version check
8. Git hooks presence
9. Branch protection status
10. CI workflow validation
11. Documentation completeness

**Run Locally:**
```powershell
.\Diagnose-Monitor-Hydra.ps1
```

### Manual Testing

**Single Monitor Execution:**
```powershell
PowerShell -NoProfile -ExecutionPolicy Bypass -File "Monitor-ClaudeHealth.ps1"
```

**View Logs:**
```powershell
# Tail service log
Get-Content "$env:TEMP\Claude-Monitor-Service.log" -Tail 100 -Wait

# View daily logs
Get-Content "$env:TEMP\Claude-Monitor-*.log" -Tail 50
```

**Check Task Status:**
```powershell
Get-ScheduledTask -TaskName "Claude Health Monitor" -ErrorAction SilentlyContinue
```

### Pre-Commit Validation

**Git hooks automatically validate:**

1. **PowerShell Syntax** - `Test-Path` on all `.ps1` files
2. **Python Syntax** - `py_compile` on all `.py` files
3. **Markdown Linting** - Basic structure validation
4. **Critical Settings** - Warns if `$CPUThreshold` modified

**Location:** `.git/hooks/pre-commit`

---

## Hydra System Guidelines

### Overview

**Hydra Decision System** is a Python-based profiling and adaptive optimization framework.

**Components:**
- **15 consensus heads** - Multiple execution strategies
- **Adaptive weighting** - Dynamic weight calculation
- **Health monitoring** - Deployment confidence tracking
- **Validation** - Effectiveness verification

**Target:** Improve system confidence from 78.7% → 88%+

### Critical Rules

#### 1. Hydra Files are READ-ONLY

**DO NOT MODIFY these files from Health Monitor or other scripts:**
- `HYDRA-*.md` (4 files) - Audit reports and guides
- `HYDRA-AUDIT-*.json` - Baseline metrics
- `hydra_profiles/*.json` - Generated profile data

**Why:** Hydra manages these files; external modifications corrupt profiling data.

#### 2. No Write Operations to hydra_profiles/

```powershell
# ❌ INCORRECT - Health Monitor writing to Hydra directory
Add-Content -Path "hydra_profiles\monitor_log.txt" -Value "Log entry"

# ✅ CORRECT - Use dedicated log location
Add-Content -Path "$env:TEMP\Claude-Monitor-Service.log" -Value "Log entry"
```

#### 3. No Blocking Operations

**Hydra profiling requires uninterrupted execution:**

```powershell
# ❌ INCORRECT - Kills Python during profiling
Stop-Process -Name python -Force

# ✅ CORRECT - Check if Hydra is running first
$hydraPython = @(Get-Process -Name python -ErrorAction SilentlyContinue |
    Where-Object { $_.CommandLine -like "*hydra_*" })
if ($hydraPython.Count -eq 0) {
    # Safe to proceed
}
```

### Hydra Workflow Phases

#### Phase 1: Profiling (~15 min)

**File:** `hydra_profile_heads.py`
**Action:** Profile each of 15 consensus heads with 100 test runs
**Output:** `hydra_profiles/head_profile_[TIMESTAMP].json`

**Metrics Collected:**
- Accuracy (correctness of decisions)
- Speed (execution time)
- Confidence (certainty level)
- Success rate (completion percentage)

#### Phase 2: Weighting (~2 min)

**File:** `hydra_adaptive_weighting.py`
**Action:** Calculate dynamic weights from profile data
**Formula:** `(accuracy × 0.40) + (speed × 0.30) + (confidence × 0.30)`

**Output:** Weight assignments for each head

#### Phase 3: Deployment (<1 min)

**Action:** Apply calculated weights to decision system
**Output:** Configuration updates

#### Phase 4: Monitoring (5+ min)

**File:** `hydra_head_health_monitor.ps1`
**Action:** Track deployment confidence in real-time
**Metrics:** System confidence percentage

#### Phase 5: Validation (~5 min)

**File:** `test_rebalancing.ps1`
**Action:** Verify effectiveness of rebalancing
**Output:** Success rate analysis

### When to Run Hydra Deployment

**Trigger manually via GitHub Actions when:**
- ✅ Significant changes to Monitor-ClaudeHealth.ps1
- ✅ CPU threshold or retry logic modified
- ✅ New repair functions added
- ✅ Performance degradation observed
- ✅ After major refactoring

**DO NOT run for:**
- ❌ Documentation updates
- ❌ Log message changes
- ❌ Installation script modifications
- ❌ Minor bug fixes not affecting core logic

---

## Git Workflow & Branching

### Branch Strategy

**Protected Branches:**
- `main` - Production-ready code (PROTECTED)
  - Required status check: `smoke-tests`
  - Requires 1+ approving review
  - No direct pushes
  - No force pushes
  - No deletions

**Working Branches:**
- `feature/*` - New features
- `bugfix/*` - Bug fixes
- `hotfix/*` - Urgent production fixes
- `copilot/*` or `ai/*` - AI agent-generated (auto-detected for autonomous operations)

### Commit Convention

**Format:** `<type>(<scope>): <subject>`

**Types:**
- `feat` - New features
- `fix` - Bug fixes
- `docs` - Documentation changes
- `refactor` - Code refactoring (no behavior change)
- `test` - Test additions or modifications
- `chore` - Maintenance (dependencies, tooling)
- `style` - Code style changes (formatting, whitespace)
- `perf` - Performance improvements

**Scopes:**
- `monitor` - Health Monitor changes
- `hydra` - Hydra system changes
- `vscode` - VS Code optimization
- `ci-cd` - Automation changes
- `deployment` - Deployment-related
- `docs` - Documentation (when type is not `docs`)

**Examples:**
```bash
feat(hydra): Add confidence threshold detection
fix(monitor): Resolve Squirrel deadlock detection race condition
docs(deployment): Update PRIORITY-1-QUICKSTART.md with new steps
refactor(monitor): Extract CPU spike detection to separate function
test(monitor): Add edge cases for process enumeration
chore(ci-cd): Update smoke tests workflow to use latest actions
```

**Subject Line Rules:**
- Use imperative mood ("Add feature" not "Added feature")
- No period at end
- Max 72 characters
- Lowercase first word (except proper nouns)

### Pull Request Process

#### 1. Create Branch

```bash
# Feature branch
git checkout -b feature/add-memory-monitoring

# Bug fix branch
git checkout -b bugfix/cpu-threshold-edge-case
```

#### 2. Make Changes

- Follow conventions in `.github/instructions/[filetype].instructions.md`
- Run smoke tests locally: `.\Test-Monitor-Smoke.ps1`
- Validate syntax (pre-commit hook does this automatically)

#### 3. Commit

```bash
# Stage changes
git add Monitor-ClaudeHealth.ps1

# Commit with conventional message
git commit -m "feat(monitor): Add memory usage threshold detection"
```

#### 4. Push

```bash
git push -u origin feature/add-memory-monitoring
```

#### 5. Create Pull Request

- Use PR template (auto-populated)
- Fill in:
  - **Change Description** - What and why
  - **Testing** - How you verified
  - **Hydra Impact** - Does it affect profiling?
  - **Documentation** - Updated relevant docs?

#### 6. Wait for CI

- `smoke-tests` job MUST pass (required check)
- `diagnostics` job runs for informational purposes

#### 7. Request Review

- At least 1 approving review required
- For AI-generated PRs (`copilot/*`, `ai/*`), reviews auto-requested

#### 8. Merge

- **Human PRs:** Manual merge after approval + CI pass
- **AI PRs:** Auto-merge if approval + CI pass (autonomous-pr-operations.yml)
- **Merge strategy:** Squash and merge

### Branch Protection Enforcement

**Configuration:** `.github/branch-protection.json`

**Rules for `main` branch:**
- ✅ Require pull request before merging
- ✅ Require status checks to pass: `smoke-tests`
- ✅ Require 1 approving review (CODEOWNERS not required)
- ✅ Dismiss stale reviews on new commits
- ✅ Require branch up-to-date before merging
- ✅ Enforce for administrators
- ❌ Allow force pushes: NO
- ❌ Allow deletions: NO

---

## Common Tasks & Examples

### Task 1: Add New Repair Function

**Scenario:** Add memory leak detection and repair

#### Step 1: Read Existing Code

```powershell
# Read current monitor to understand patterns
# File: Monitor-ClaudeHealth.ps1
```

#### Step 2: Add Detection Function

```powershell
function Test-MemoryLeak {
    <#
    .SYNOPSIS
    Detects memory leaks in Claude processes

    .DESCRIPTION
    Checks if Claude process memory usage exceeds threshold
    #>
    param(
        [int]$MemoryThresholdMB = 2048
    )

    $processes = @(Get-Process -Name "Claude" -ErrorAction SilentlyContinue)

    foreach ($process in $processes) {
        $memoryMB = [math]::Round($process.WorkingSet64 / 1MB, 2)
        if ($memoryMB -gt $MemoryThresholdMB) {
            Log-Message "Memory leak detected: Claude using $memoryMB MB" "WARN"
            return $true
        }
    }

    return $false
}
```

#### Step 3: Add Repair Function (Idempotent)

```powershell
function Repair-MemoryLeak {
    <#
    .SYNOPSIS
    Repairs memory leaks by restarting Claude

    .DESCRIPTION
    Safely restarts Claude process to clear memory
    Safe to run multiple times (idempotent)
    #>

    # Guard: Check if repair needed
    if (-not (Test-MemoryLeak)) {
        Log-Message "No memory leak detected, skipping repair" "INFO"
        return
    }

    Log-Message "Repairing memory leak: Restarting Claude" "INFO"

    # Stop Claude
    $processes = @(Get-Process -Name "Claude" -ErrorAction SilentlyContinue)
    foreach ($process in $processes) {
        Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
    }

    # Wait for clean shutdown
    Start-Sleep -Seconds 2

    # Restart Claude (if auto-restart configured)
    # Note: Implementation depends on Claude installation method

    Log-Message "Memory leak repair completed" "SUCCESS"
}
```

#### Step 4: Update Main Logic

```powershell
# In Monitor-ClaudeHealth.ps1 main loop
if (Test-MemoryLeak) {
    Repair-MemoryLeak
}
```

#### Step 5: Add Test

```powershell
# In Test-Monitor-Smoke.ps1
function Test-MemoryLeakDetection {
    Write-Host "[TEST] Memory leak detection..."

    # Test detection function exists
    if (Get-Command Test-MemoryLeak -ErrorAction SilentlyContinue) {
        Write-Host "[PASS] Test-MemoryLeak function exists" -ForegroundColor Green
    } else {
        Write-Host "[FAIL] Test-MemoryLeak function not found" -ForegroundColor Red
        return $false
    }

    # Test repair function exists
    if (Get-Command Repair-MemoryLeak -ErrorAction SilentlyContinue) {
        Write-Host "[PASS] Repair-MemoryLeak function exists" -ForegroundColor Green
    } else {
        Write-Host "[FAIL] Repair-MemoryLeak function not found" -ForegroundColor Red
        return $false
    }

    return $true
}

# Add to test suite
Test-MemoryLeakDetection
```

#### Step 6: Test Locally

```powershell
# Run smoke tests
.\Test-Monitor-Smoke.ps1

# Run manual test
.\Monitor-ClaudeHealth.ps1
```

#### Step 7: Commit & Push

```bash
git add Monitor-ClaudeHealth.ps1 Test-Monitor-Smoke.ps1
git commit -m "feat(monitor): Add memory leak detection and repair

- Add Test-MemoryLeak function with 2048 MB threshold
- Add Repair-MemoryLeak function (idempotent)
- Add smoke test for memory leak detection
- Integrate into main monitoring loop"

git push -u origin feature/memory-leak-detection
```

#### Step 8: Create PR

- Use PR template
- Wait for `smoke-tests` CI check
- Request review
- Merge after approval

---

### Task 2: Update Documentation

**Scenario:** Add new command to QUICK-REFERENCE.md

#### Step 1: Read Existing Documentation

```bash
# Read current quick reference
cat QUICK-REFERENCE.md
```

#### Step 2: Follow Documentation Standards

**From `.github/instructions/docs.instructions.md`:**
- Clear, professional, action-oriented
- Use proper markdown formatting
- Include code examples with language tags
- Reference absolute file paths with line numbers

#### Step 3: Make Changes

```markdown
## New Command: Check Memory Usage

View current Claude memory usage:

```powershell
Get-Process -Name Claude | Select-Object Name,
    @{Name="Memory (MB)";Expression={[math]::Round($_.WorkingSet64/1MB,2)}}
```

**Related:** Memory leak detection in Monitor-ClaudeHealth.ps1:150-175
```

#### Step 4: Validate Markdown

```bash
# Check for syntax errors (pre-commit hook does this)
# Manually verify:
# - Headers use proper levels (##, ###, ####)
# - Code blocks specify language
# - No broken links
```

#### Step 5: Commit

```bash
git add QUICK-REFERENCE.md
git commit -m "docs: Add memory usage check command to quick reference"
git push
```

---

### Task 3: Modify Hydra Profiling

**Scenario:** Adjust adaptive weighting formula

#### Step 1: Read Current Implementation

```python
# Read hydra_adaptive_weighting.py
```

#### Step 2: Understand Current Formula

```python
# Current formula (from hydra_adaptive_weighting.py)
weight = (accuracy * 0.40) + (speed * 0.30) + (confidence * 0.30)
```

#### Step 3: Modify Formula

```python
# New formula: Prioritize accuracy over speed
weight = (accuracy * 0.50) + (speed * 0.20) + (confidence * 0.30)

# Add comment explaining change
# Modified from 0.40/0.30/0.30 to 0.50/0.20/0.30
# Rationale: Accuracy more critical than speed for stability
```

#### Step 4: Validate Syntax

```bash
python -m py_compile hydra_adaptive_weighting.py
```

#### Step 5: Document Change

Update HYDRA-IMPLEMENTATION-GUIDE.md:

```markdown
## Adaptive Weighting Formula

**Current Formula (as of 2025-11-22):**
```python
weight = (accuracy * 0.50) + (speed * 0.20) + (confidence * 0.30)
```

**Rationale:** Prioritizes accuracy (50%) over speed (20%) for improved stability.

**Previous Formula:**
```python
weight = (accuracy * 0.40) + (speed * 0.30) + (confidence * 0.30)
```

**Change History:**
- 2025-11-22: Increased accuracy weight 0.40 → 0.50, decreased speed 0.30 → 0.20
```

#### Step 6: Trigger Hydra Deployment

After merging PR, manually trigger Hydra deployment via GitHub Actions:

1. Go to Actions tab
2. Select "Hydra Deploy" workflow
3. Click "Run workflow"
4. Select environment: staging or production
5. Monitor 5-phase deployment (~30-40 min)

---

## Safety & Security

### Critical Settings

**DO NOT MODIFY without team review:**

```powershell
# In Monitor-ClaudeHealth.ps1
$CPUThreshold = 500      # CRITICAL - See safety section below
```

**Why Critical:**
- False positives can kill legitimate processes
- System stability depends on accurate threshold
- Tuned over multiple iterations
- Requires extensive testing before changing

**Change Process:**
1. Create issue with justification
2. Team review and discussion
3. Testing on non-production system
4. Smoke tests validation
5. PR approval with detailed reasoning
6. Gradual rollout with monitoring

### Safe Configuration Parameters

**OK to modify after testing:**

```powershell
$MaxRetries = 3                # Repair attempt limit
$RetryDelaySeconds = 10        # Delay between retries
$MonitorInterval = 300         # Monitoring interval (5 minutes)
$MemoryThresholdMB = 2048      # Memory leak threshold (if added)
```

### Idempotence Requirement

**ALL operations MUST be safe to re-run:**

```powershell
# ✅ CORRECT - Idempotent
function Repair-Example {
    if (Test-ProblemExists) {
        Log-Message "Problem detected, repairing" "INFO"
        # Perform repair
    } else {
        Log-Message "No problem detected" "INFO"
    }
}

# ❌ INCORRECT - Not idempotent, fails on second run
function Repair-Example {
    Remove-Item "C:\file-that-may-not-exist.txt"  # Throws error if missing
}
```

### Read-Only Restrictions

**NEVER modify these files from non-Hydra scripts:**

- `HYDRA-*.md` (4 files)
- `HYDRA-AUDIT-*.json`
- `hydra_profiles/*.json`

**Why:** Hydra manages these files; external modifications corrupt data.

### Secrets & Credentials

**NEVER commit:**
- ❌ PAT tokens
- ❌ API keys
- ❌ Passwords
- ❌ Connection strings
- ❌ Private keys

**Use environment variables:**
```powershell
$apiKey = $env:CLAUDE_API_KEY  # Set in environment, not hardcoded
```

### Process Safety

**Before killing processes:**

```powershell
# ✅ CORRECT - Check if critical before killing
$process = Get-Process -Name "example" -ErrorAction SilentlyContinue
if ($process -and $process.ProcessName -ne "csrss" -and $process.ProcessName -ne "winlogon") {
    Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
}

# ❌ INCORRECT - Blindly killing processes
Stop-Process -Name "*" -Force  # DANGER: Can crash system
```

### Log File Safety

**Use temporary locations only:**

```powershell
# ✅ CORRECT - Use %TEMP%
$logPath = "$env:TEMP\Claude-Monitor-Service.log"

# ❌ INCORRECT - Writing to system directories
$logPath = "C:\Windows\System32\monitor.log"  # Permission denied
```

---

## Troubleshooting

### Common Issues

#### Issue 1: Smoke Tests Failing

**Symptoms:** `smoke-tests` CI check fails, blocking PR merge

**Diagnosis:**
```powershell
# Run locally to see detailed output
.\Test-Monitor-Smoke.ps1
```

**Common Causes:**
1. **Syntax error** - Check PowerShell syntax
   ```powershell
   # Validate syntax
   Get-Content Monitor-ClaudeHealth.ps1 | Out-Null
   ```

2. **Missing function** - Verify all functions defined
   ```powershell
   # Check function exists
   Get-Command Test-SquirrelDeadlock -ErrorAction SilentlyContinue
   ```

3. **Process enumeration** - Missing `@(...)` wrapper
   ```powershell
   # WRONG: $processes = Get-Process -Name "Claude"
   # RIGHT: $processes = @(Get-Process -Name "Claude" -ErrorAction SilentlyContinue)
   ```

**Resolution:**
- Fix identified issue
- Run smoke tests locally until passing
- Commit fix and push
- CI will re-run automatically

#### Issue 2: Hydra Profiling Hangs

**Symptoms:** Phase 1 of Hydra deployment exceeds 20 minutes

**Diagnosis:**
```bash
# Check if Python process is running
ps aux | grep hydra_profile_heads.py

# Check profiling output
ls -la hydra_profiles/
```

**Common Causes:**
1. **Python version** - Requires 3.7+
   ```bash
   python --version  # Check version
   ```

2. **Infinite loop** - Logic error in profiling
   ```python
   # Check for while True without break condition
   ```

3. **File I/O blocking** - Profile output directory missing
   ```bash
   mkdir -p hydra_profiles
   ```

**Resolution:**
- Verify Python 3.7+
- Check profile output directory exists
- Review profiling logic for infinite loops
- Add timeout to profiling loop (30 second max per test)

#### Issue 3: Monitor Not Running

**Symptoms:** Claude issues not being repaired

**Diagnosis:**
```powershell
# Check scheduled task
Get-ScheduledTask -TaskName "Claude Health Monitor"

# View task history
Get-ScheduledTask -TaskName "Claude Health Monitor" | Get-ScheduledTaskInfo

# Check logs
Get-Content "$env:TEMP\Claude-Monitor-*.log" -Tail 50
```

**Common Causes:**
1. **Task not registered** - Installation didn't complete
   ```powershell
   # Re-run installer
   .\Install-Monitor.bat
   ```

2. **Task disabled** - Manually disabled in Task Scheduler
   ```powershell
   # Enable task
   Enable-ScheduledTask -TaskName "Claude Health Monitor"
   ```

3. **Execution policy** - PowerShell blocked
   ```powershell
   # Check policy
   Get-ExecutionPolicy

   # Should be RemoteSigned or Bypass for monitor
   ```

**Resolution:**
- Re-run installation: `.\Install-Monitor.bat`
- Verify task enabled: `Get-ScheduledTask -TaskName "Claude Health Monitor"`
- Check logs for error messages

#### Issue 4: False Positive CPU Spikes

**Symptoms:** Monitor kills legitimate processes

**Diagnosis:**
```powershell
# Check current CPU threshold
Get-Content Monitor-ClaudeHealth.ps1 | Select-String "CPUThreshold"

# Monitor actual CPU usage
Get-Process -Name Claude | Select-Object Name, CPU
```

**Common Causes:**
1. **Threshold too low** - 500% may be too aggressive
   ```powershell
   # Current threshold
   $CPUThreshold = 500  # 5 cores at 100%

   # Consider increasing to 800 for high-performance systems
   ```

2. **Legitimate spike** - Build process, indexing
   ```powershell
   # Add exclusion for legitimate high-CPU processes
   if ($process.ProcessName -ne "msbuild" -and $process.CPU -gt $CPUThreshold) {
       # Repair
   }
   ```

**Resolution:**
- Increase `$CPUThreshold` from 500 to 800
- Add process name exclusions
- Document change in commit message
- Test thoroughly before deploying

#### Issue 5: Git Pre-Commit Hook Failing

**Symptoms:** Commit blocked with validation error

**Diagnosis:**
```bash
# Check hook exists
ls -la .git/hooks/pre-commit

# Run hook manually
.git/hooks/pre-commit
```

**Common Causes:**
1. **Python syntax error** - `py_compile` failed
   ```bash
   python -m py_compile hydra_*.py
   ```

2. **PowerShell syntax error** - `Get-Content` failed
   ```powershell
   Get-Content Monitor-ClaudeHealth.ps1 | Out-Null
   ```

3. **Critical setting modified** - Hook warns about $CPUThreshold
   ```powershell
   # If intentional, add justification in commit message
   ```

**Resolution:**
- Fix syntax errors
- If critical setting changed, document why in commit message
- Re-run commit after fixes

---

## Additional Resources

### Key Documentation Files

**Start Here:**
- `README.md` - Main overview and quick start
- `SYSTEM-DASHBOARD.md` - Architecture and component status
- `GIT-WORKFLOW.md` - Branch strategy and commit conventions

**For Development:**
- `.github/instructions/` - File-scoped Copilot instructions
- `.github/agents/` - Specialized agent profiles
- `CONTRIBUTING.md` - Contribution guidelines

**For Deep Dives:**
- `HYDRA-IMPLEMENTATION-GUIDE.md` - 38 KB comprehensive Hydra guide
- `AUTOMATION-SUITE.md` - CI/CD pipeline details
- `MAINTENANCE-TESTING-GUIDE.md` - Testing procedures

**For Status Tracking:**
- `STATUS-REPORT.md` - Current system status
- `PHASE-*.md` - Phase completion reports
- `PRIORITY-1-*.md` - Deployment manifests

### External Links

- **GitHub Repository:** https://github.com/BossX429/AnthropicClaude
- **Issue Tracker:** https://github.com/BossX429/AnthropicClaude/issues
- **Discussions:** https://github.com/BossX429/AnthropicClaude/discussions
- **Actions:** https://github.com/BossX429/AnthropicClaude/actions

### Contact

**Repository Owner:** BossX429 (see CODEOWNERS)

---

## Revision History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2025-11-22 | Initial comprehensive CLAUDE.md creation | Claude (AI Assistant) |

---

**End of CLAUDE.md - AI Assistant Guide**
