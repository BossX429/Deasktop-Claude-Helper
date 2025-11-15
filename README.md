# Claude Health Monitor & Hydra Decision System

[![Tests](https://github.com/BossX429/AnthropicClaude/actions/workflows/tests.yml/badge.svg)](https://github.com/BossX429/AnthropicClaude/actions/workflows/tests.yml)

An automated Windows health monitoring and repair system for Anthropic's Claude desktop application, featuring an advanced Hydra decision system for adaptive optimization.

## 🎯 What This System Does

### Health Monitor
Automatically detects and repairs common Claude desktop issues:
- ✅ **Squirrel Updater Deadlocks** - Removes stuck lock files and processes
- ✅ **CPU Spikes** - Kills runaway processes (Edge, Explorer, Updater)
- ✅ **Process Management** - Auto-restarts critical services
- ✅ **24/7 Monitoring** - Runs every 5 minutes via Task Scheduler

### Hydra Decision System
Advanced profiling and adaptive optimization:
- 📊 **Performance Profiling** - Benchmarks multiple execution strategies
- 🎯 **Adaptive Weighting** - Dynamically adjusts based on success rates
- 🔍 **Health Monitoring** - Continuous deployment confidence tracking
- ✅ **Automated Testing** - Validates improvements and stability

## 🚀 Quick Start

### Prerequisites
- Windows 10/11
- PowerShell 5.1 or later
- Python 3.7+ (for Hydra system)
- Administrator privileges (for installation)

### Installation

#### Option 1: Task Scheduler (Recommended)
```batch
# Right-click and "Run as administrator"
Install-Monitor.bat
```

#### Option 2: Manual Setup
```powershell
# Run in PowerShell (as Administrator)
PowerShell -NoProfile -ExecutionPolicy Bypass -File "Install-Scheduled-Task.ps1"
```

#### Option 3: Startup Folder (No Admin After First Run)
```batch
# Right-click and "Run as administrator" once
Create-StartupLink.bat
```

### Verification
```powershell
# Check if scheduled task is registered
Get-ScheduledTask -TaskName "Claude Health Monitor" -ErrorAction SilentlyContinue

# View recent logs
Get-Content "$env:TEMP\Claude-Monitor-*.log" -Tail 20
```

## 📖 Documentation

### For Users
- **[Installation Guide](README-MONITOR.md)** - Detailed installation and configuration
- **[Quick Reference](QUICK-REFERENCE.md)** - Common commands and troubleshooting
- **[Quickstart Card](QUICKSTART-CARD.md)** - One-page quick reference

### For Developers
- **[System Dashboard](SYSTEM-DASHBOARD.md)** - Architecture overview and component map
- **[Git Workflow](GIT-WORKFLOW.md)** - Branch strategy, commit conventions, PR process
- **[Automation Suite](AUTOMATION-SUITE.md)** - CI/CD pipeline and automation details
- **[Priority 1 Quickstart](PRIORITY-1-QUICKSTART.md)** - Complete deployment guide

### For Contributors
- **[Copilot Instructions](.github/copilot-instructions.md)** - AI coding agent guidelines
- **[Custom Agents](.github/agents/README.md)** - Specialized agent profiles
- **[Pull Request Template](.github/PULL_REQUEST_TEMPLATE.md)** - PR guidelines

## 🏗️ Architecture

### Five-Layer System
```
┌─────────────────────────────────────────┐
│  Application Layer                       │
│  (Multi-release Electron Claude apps)   │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│  Health Monitoring Layer                 │
│  (PowerShell auto-repair system)        │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│  Hydra Decision System                   │
│  (Python profiling & optimization)      │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│  VS Code Optimization                    │
│  (Development environment setup)        │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│  GitHub Actions CI/CD                    │
│  (Automated testing & deployment)       │
└─────────────────────────────────────────┘
```

### Key Components

#### PowerShell Scripts
- `Monitor-ClaudeHealth.ps1` - Core detection and repair logic
- `Monitor-Service.ps1` - Resident service wrapper (300s interval)
- `Install-Scheduled-Task.ps1` - Task Scheduler registration
- `Test-Monitor-Smoke.ps1` - 5-test validation suite
- `Diagnose-Monitor-Hydra.ps1` - 11-check diagnostic tool

#### Python Scripts (Hydra System)
- `hydra_profile_heads.py` - Performance profiling (Phase 1)
- `hydra_adaptive_weighting.py` - Weight calculation (Phase 2)
- `hydra_head_health_monitor.ps1` - Deployment monitoring (Phase 4)
- `test_rebalancing.ps1` - Validation suite (Phase 5)

#### Automation
- `.github/workflows/tests.yml` - Smoke tests + diagnostics on push/PR
- `.github/workflows/hydra-deploy.yml` - 5-phase Hydra deployment
- `.github/workflows/autonomous-pr-operations.yml` - Auto-merge for AI PRs
- `.git/hooks/pre-commit` - Syntax validation gate
- `.git/hooks/pre-push` - Test execution gate

## 🔧 Configuration

### Health Monitor Settings
Edit `Monitor-ClaudeHealth.ps1`:
```powershell
$CPUThreshold = 500      # CPU spike threshold (500% = 5 cores at 100%)
$MaxRetries = 3          # Repair attempt limit
$RetryDelaySeconds = 10  # Delay between retry attempts
```

### Hydra System Settings
Edit `hydra_profile_heads.py`:
```python
NUM_TESTS = 100          # Tests per head during profiling
TIMEOUT = 30             # Test timeout in seconds
```

## 🧪 Testing

### Run Smoke Tests
```powershell
# Execute 5 validation tests
.\Test-Monitor-Smoke.ps1
```

### Run Diagnostics
```powershell
# Execute 11 diagnostic checks
.\Diagnose-Monitor-Hydra.ps1
```

### Manual Health Check
```powershell
# Single execution of monitor
PowerShell -NoProfile -ExecutionPolicy Bypass -File "Monitor-ClaudeHealth.ps1"
```

## 🤝 Contributing

We welcome contributions! This repository is configured for GitHub Copilot coding agent integration.

### For Human Contributors

1. **Fork and Clone**
   ```bash
   git clone https://github.com/YOUR-USERNAME/AnthropicClaude.git
   cd AnthropicClaude
   ```

2. **Create Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Changes**
   - Follow conventions in `.github/copilot-instructions.md`
   - Run smoke tests: `.\Test-Monitor-Smoke.ps1`
   - Validate syntax (pre-commit hook does this automatically)

4. **Submit Pull Request**
   - Use the PR template (auto-populated)
   - Wait for `smoke-tests` CI check to pass
   - At least 1 approving review required

### For GitHub Copilot

This repository has custom agent profiles for specialized tasks:

- **[Documentation Agent](.github/agents/documentation-agent.md)** - README updates, guides, markdown
- **[PowerShell Agent](.github/agents/powershell-agent.md)** - Monitor scripts, error handling
- **[Python Agent](.github/agents/python-agent.md)** - Hydra system, profiling algorithms

**To use Copilot:**
1. Create issues with clear acceptance criteria
2. Reference agent profiles for specialized work
3. Let autonomous PR operations handle review and merge

**Branch naming for auto-operations:**
- `copilot/feature-name` - Copilot-generated changes
- `ai/fix-name` - AI-generated fixes
- Branches with these prefixes trigger auto-review and auto-merge

### Best Practices for Copilot Tasks

✅ **Good Tasks:**
- Fix bugs with clear reproduction steps
- Add/improve tests for existing functionality
- Update documentation to match code changes
- Refactor code following project conventions
- Address technical debt with defined scope

❌ **Avoid Assigning to Copilot:**
- Critical security fixes (human review required)
- Complex architectural changes
- Breaking changes without migration plan
- Tasks requiring deep domain knowledge

## 📊 CI/CD Pipeline

### Automated Workflows

**On Push/PR:**
- Syntax validation (PowerShell, Python)
- Smoke tests (5 tests)
- Diagnostics (11 checks)

**On PR Approval:**
- Auto-merge if all checks pass
- Squash-and-merge strategy

**Manual Trigger:**
- Hydra deployment (5 phases, ~30-40 min)

### Branch Protection

The `main` branch is protected:
- ✅ Requires PR (no direct pushes)
- ✅ Requires status check: `smoke-tests`
- ✅ Requires 1+ approving review
- ✅ Requires branch up-to-date

## 📝 Logs and Debugging

### Log Locations
```
%TEMP%\Claude-Monitor-Service.log      - Continuous service log
%TEMP%\Claude-Monitor-YYYY-MM-DD.log   - Daily monitor logs
```

### View Real-Time Logs
```powershell
# Tail service log
Get-Content "$env:TEMP\Claude-Monitor-Service.log" -Tail 100 -Wait

# View daily logs
Get-Content "$env:TEMP\Claude-Monitor-*.log" -Tail 50
```

### Common Issues

**Monitor not running:**
```powershell
# Check task status
Get-ScheduledTask -TaskName "Claude Health Monitor"

# Run manually to test
PowerShell -NoProfile -ExecutionPolicy Bypass -File "Monitor-ClaudeHealth.ps1"
```

**False positives (too many repairs):**
- Increase `$CPUThreshold` in `Monitor-ClaudeHealth.ps1`
- Default is 500 (5 cores at 100%), try 800 for less sensitive

**Need to disable:**
```powershell
# Remove scheduled task
schtasks /delete /tn "Claude Health Monitor" /f

# Or via Task Scheduler GUI
# Search "Task Scheduler" > Find and delete "Claude Health Monitor"
```

## 🔒 Security

### Automated Security

- **Pre-commit hooks** - Syntax validation prevents broken code
- **Pre-push hooks** - Test execution prevents untested releases
- **Branch protection** - Prevents direct pushes to `main`
- **Required reviews** - Human approval for all merges
- **CI/CD checks** - Automated testing on every change

### Security Best Practices

- ❌ Never commit PAT tokens or credentials
- ❌ Never modify `HYDRA-*.md` or `HYDRA-AUDIT-*.json` (managed files)
- ✅ Use environment variables for sensitive data
- ✅ Review all auto-generated PRs like human contributions
- ✅ Keep branch protection rules enabled

## 📈 Project Status

### Current State
- ✅ Health Monitor: Fully operational
- ✅ Hydra System: Deployed and profiling
- ✅ CI/CD Pipeline: Automated testing active
- ✅ Autonomous PR Operations: Configured
- ✅ Documentation: Comprehensive coverage

### System Confidence
- **Baseline**: 78.7% (initial deployment)
- **Target**: 88%+ (after 5-day stabilization)
- **Current**: Monitoring ongoing

## 📚 Additional Resources

### Reports and Audits
- `HYDRA-AUDIT-SUMMARY.md` - Hydra system audit overview
- `HYDRA-IMPLEMENTATION-GUIDE.md` - Technical implementation details
- `FULL-SITE-RECONNAISSANCE.md` - Complete 60KB+ analysis
- `STATUS-REPORT.md` - Current system status

### Setup Guides
- `AUTONOMOUS-SETUP-COMPLETE.md` - Autonomous setup summary
- `PHASE-D-BRANCH-PROTECTION.md` - Branch protection setup
- `GITHUB-SETUP-FINAL.md` - GitHub integration steps

## 🙏 Acknowledgments

- **Anthropic** - For the Claude desktop application
- **GitHub Copilot** - AI pair programming integration
- **Hydra Contributors** - Multi-head decision system design

## 📄 License

This project is an internal tool for Claude desktop health monitoring. See individual files for specific usage terms.

---

**Quick Links:**
- 📖 [Full Documentation](SYSTEM-DASHBOARD.md)
- 🔧 [Installation Guide](README-MONITOR.md)
- 🤝 [Contributing Guidelines](.github/copilot-instructions.md)
- 🐛 [Issue Tracker](https://github.com/BossX429/AnthropicClaude/issues)
- 💬 [Discussions](https://github.com/BossX429/AnthropicClaude/discussions)
