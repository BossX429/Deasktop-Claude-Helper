# Claude Health Monitor & Hydra Decision System

Automated health monitoring and repair system for Claude Desktop application with integrated Hydra multi-head decision framework.

## 🎯 Overview

This repository contains a five-layer architecture designed to ensure the Claude Desktop application runs smoothly, automatically detecting and repairing common issues such as:

- **Squirrel updater deadlocks** (stuck lock files)
- **CPU spikes** (>500% threshold)
- **Runaway processes** (Edge, Explorer, Updater)
- **System optimization** through adaptive weighting

## 📋 Quick Start

### For End Users

1. **Install the Monitor** (Recommended - requires admin):
   ```powershell
   # Right-click and "Run as administrator"
   C:\Users\YourName\AppData\Local\AnthropicClaude\Install-Monitor.bat
   ```

2. **Verify Installation**:
   - Open Task Scheduler
   - Look for "Claude Health Monitor" task
   - Should run every 5 minutes automatically

### For Developers

1. **Clone the repository**:
   ```bash
   git clone https://github.com/BossX429/AnthropicClaude.git
   cd AnthropicClaude
   ```

2. **Read the documentation**:
   - [PRIORITY-1-QUICKSTART.md](PRIORITY-1-QUICKSTART.md) - Complete deployment guide
   - [SYSTEM-DASHBOARD.md](SYSTEM-DASHBOARD.md) - Architecture overview
   - [GIT-WORKFLOW.md](GIT-WORKFLOW.md) - Branch strategy and PR process

3. **Run smoke tests** (Windows only):
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File "Test-Monitor-Smoke.ps1"
   ```

## 🏗️ Architecture

Five-layer system architecture:

1. **Deployment Automation Layer** - GitHub Actions CI/CD workflows
2. **Version Control & QA Layer** - Git hooks and branch protection
3. **Monitoring & Diagnostics Layer** - Health monitor, smoke tests, diagnostics
4. **Optimization Layer** - Python-based profiling and adaptive weighting
5. **Application Runtime Layer** - Claude Desktop multi-version deployment

See [SYSTEM-DASHBOARD.md](SYSTEM-DASHBOARD.md) for detailed architecture visualization.

## 🤖 For GitHub Copilot & AI Agents

This repository is optimized for GitHub Copilot coding agent. Key resources:

- **[.github/copilot-instructions.md](.github/copilot-instructions.md)** - Complete AI agent guidelines
- **Branch strategy**: Always work on feature branches (`copilot/*`, `ai/*`, or `feature/*`)
- **Required checks**: `smoke-tests` must pass before merge
- **PR template**: Auto-populated with checklist and guidelines
- **Auto-merge**: Enabled for AI-generated PRs when checks pass and approved

### Key Guidelines for AI Agents

- ✅ Follow PowerShell conventions (`-ErrorAction SilentlyContinue`, `Log-Message` calls)
- ✅ Preserve critical thresholds (`$CPUThreshold = 500`)
- ✅ Keep repair functions idempotent
- ❌ Never write to Hydra-managed files (read-only)
- ❌ Never commit PAT tokens or credentials
- ❌ Never push directly to `main` branch

Read the complete guidelines in [.github/copilot-instructions.md](.github/copilot-instructions.md).

## 📁 Key Files

### Health Monitoring
- `Monitor-ClaudeHealth.ps1` - Core detection and repair logic
- `Monitor-Service.ps1` - Resident service wrapper
- `Test-Monitor-Smoke.ps1` - 5 validation tests
- `Diagnose-Monitor-Hydra.ps1` - 11 diagnostic checks

### Hydra System
- `hydra_profile_heads.py` - Profile decision heads (Phase 1)
- `hydra_adaptive_weighting.py` - Calculate dynamic weights (Phase 2)
- `hydra_head_health_monitor.ps1` - Monitor deployment confidence (Phase 4)
- `test_rebalancing.ps1` - Validate improvements (Phase 5)

### Automation
- `.github/workflows/tests.yml` - Smoke tests and diagnostics
- `.github/workflows/hydra-deploy.yml` - 5-phase deployment pipeline
- `.github/workflows/autonomous-pr-operations.yml` - Auto-merge for AI PRs

## 🧪 Testing

The project uses PowerShell-based smoke tests and diagnostics:

- **Smoke Tests**: 5 core validation checks (Windows only)
- **Diagnostics**: 11 system health checks
- **CI/CD**: Automated via GitHub Actions on push/PR

Tests run automatically in CI/CD pipeline on Windows runners.

## 🔒 Security

- **No hardcoded credentials** - Uses Windows Credential Manager
- **Branch protection** - Direct pushes to `main` blocked
- **Required reviews** - All PRs need at least 1 approval
- **CodeQL scanning** - Automated security analysis via `codeql_checker` tool
- **Audit trails** - See [HYDRA-AUDIT-REPORT.json](HYDRA-AUDIT-REPORT.json)

## 📚 Documentation

### Getting Started
- [README-MONITOR.md](README-MONITOR.md) - Monitor installation guide
- [PRIORITY-1-QUICKSTART.md](PRIORITY-1-QUICKSTART.md) - 30-minute deployment guide
- [QUICK-REFERENCE.md](QUICK-REFERENCE.md) - Commands and shortcuts

### Architecture & Design
- [SYSTEM-DASHBOARD.md](SYSTEM-DASHBOARD.md) - System status and architecture
- [HYDRA-IMPLEMENTATION-GUIDE.md](HYDRA-IMPLEMENTATION-GUIDE.md) - Hydra system details
- [FULL-SITE-RECONNAISSANCE.md](FULL-SITE-RECONNAISSANCE.md) - Complete analysis

### Development
- [GIT-WORKFLOW.md](GIT-WORKFLOW.md) - Branch strategy and PR process
- [.github/copilot-instructions.md](.github/copilot-instructions.md) - AI agent guidelines
- [AUTONOMOUS-CI.md](AUTONOMOUS-CI.md) - Auto-merge documentation

### Reports & Status
- [HYDRA-AUDIT-REPORT.json](HYDRA-AUDIT-REPORT.json) - Baseline metrics
- [AUTOMATION-STATUS.md](AUTOMATION-STATUS.md) - CI/CD status
- [DEPLOYMENT-COMPLETE.md](DEPLOYMENT-COMPLETE.md) - Deployment records

## 🤝 Contributing

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   # or for AI agents:
   git checkout -b copilot/your-feature-name
   ```

2. **Make your changes** following the guidelines in [.github/copilot-instructions.md](.github/copilot-instructions.md)

3. **Run tests locally** (Windows):
   ```powershell
   Test-Monitor-Smoke.ps1
   ```

4. **Commit using conventional format**:
   ```bash
   git commit -m "feat(monitor): add new detection for XYZ"
   ```

5. **Push and create PR**:
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Wait for checks** - `smoke-tests` must pass before merge

See [GIT-WORKFLOW.md](GIT-WORKFLOW.md) for detailed contribution process.

## 📄 License

This project is part of the AnthropicClaude monitoring system. All rights reserved.

## 🆘 Support

- **Issues**: Report bugs or request features via [GitHub Issues](https://github.com/BossX429/AnthropicClaude/issues)
- **Documentation**: Check the [documentation](#-documentation) section above
- **Logs**: Monitor debug logs in `%TEMP%\Claude-Monitor-*.log`

## 🔗 Related Resources

- [Claude Desktop](https://claude.ai/desktop) - Official Claude application
- [GitHub Copilot](https://github.com/features/copilot) - AI pair programming
- [PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/) - For script development

---

**Status**: ✅ System operational | **Last Updated**: November 2025
