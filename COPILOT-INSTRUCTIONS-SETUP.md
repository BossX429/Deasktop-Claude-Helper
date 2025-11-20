# Copilot Instructions Setup — Configuration Summary

**Date**: November 14, 2025
**Status**: ✅ Complete
**Issue**: #[issue-number]
**PR**: #[pr-number]

## What was configured

This repository now has comprehensive **GitHub Copilot coding agent instructions** configured according to [GitHub's best practices](https://docs.github.com/en/copilot/tutorials/coding-agent/get-the-best-results).

### Enhanced `.github/copilot-instructions.md`

The existing instructions file (199 lines) was enhanced with:

#### 1. YAML Frontmatter for Targeted Guidance

```yaml
---
applies_to:
  - "**/*.ps1"      # PowerShell scripts
  - "**/*.py"       # Python scripts
  - "**/*.md"       # Documentation
  - ".github/**"    # GitHub configuration
---
```

This YAML frontmatter tells GitHub Copilot to apply these instructions specifically to relevant file types, improving context awareness and reducing noise.

#### 2. Comprehensive "How to Build, Test, and Lint" Section

Added explicit, copy-paste commands for:

**Testing:**
- Smoke tests: `Test-Monitor-Smoke.ps1` (required before PR)
- Diagnostics: `Diagnose-Monitor-Hydra.ps1` (troubleshooting)
- Hydra rebalancing: `test_rebalancing.ps1` (after Hydra changes)

**Linting & Validation:**
- PowerShell syntax checking (PSParser tokenization)
- Python syntax validation (`python -m py_compile`)
- Optional Python type checking (`mypy`)

**Running Hydra Components:**
- Profile heads: `python hydra_profile_heads.py` (15 min)
- Adaptive weights: `python hydra_adaptive_weighting.py` (2 min)
- Health monitoring: `hydra_head_health_monitor.ps1` (ongoing)

**CI/CD Validation:**
- Automatic smoke tests on all PRs
- Manual workflow triggers via `gh workflow run`

**Pre-commit Checklist:**
- Step-by-step validation guide
- Syntax checks
- Documentation updates

#### 3. File Size and Content

- **Before**: 199 lines
- **After**: 286 lines (+87 lines)
- **Added**: 87 lines of actionable, copy-paste commands and guidance

## Best practices alignment

✅ **Custom instructions location**: `.github/copilot-instructions.md` (canonical location)
✅ **YAML frontmatter**: Applied to target specific file types
✅ **Build/test/lint commands**: Explicit, executable commands
✅ **Project-specific conventions**: Error handling, logging, idempotence
✅ **Safety guidelines**: Critical DON'Ts, repository rules, Hydra restrictions
✅ **PR templates**: Structured workflow for AI agents
✅ **CI/CD integration**: Automatic validation and auto-merge

## How AI agents benefit

1. **Clear build/test commands**: No guessing how to validate changes
2. **Targeted guidance**: YAML frontmatter ensures relevant instructions for each file type
3. **Copy-paste workflows**: All commands are executable examples
4. **Pre-commit validation**: Step-by-step checklist prevents mistakes
5. **CI/CD awareness**: Knows about automatic smoke tests and workflows
6. **Safety first**: Clear DON'Ts prevent breaking changes
7. **Hydra-specific rules**: Explicit guidance for Python profiling/weighting code

## File structure

```
.github/
├── copilot-instructions.md          ← Enhanced with frontmatter + build/test/lint
├── PULL_REQUEST_TEMPLATE.md         ← PR template for consistency
└── workflows/
    ├── tests.yml                     ← Smoke tests (automatic)
    ├── hydra-deploy.yml              ← 5-phase deployment (manual)
    ├── autonomous-pr-operations.yml  ← Auto-merge on approval
    └── auto-populate-pr-template.yml ← Auto-fill PR bodies
```

## Commands added

### Testing (new section)
```powershell
# Smoke tests (required)
PowerShell -NoProfile -ExecutionPolicy Bypass -File "Test-Monitor-Smoke.ps1"

# Diagnostics
PowerShell -NoProfile -ExecutionPolicy Bypass -File "Diagnose-Monitor-Hydra.ps1"

# Hydra rebalancing
PowerShell -NoProfile -ExecutionPolicy Bypass -File "test_rebalancing.ps1"
```

### Linting (new section)
```powershell
# PowerShell syntax
Get-ChildItem -Filter *.ps1 | ForEach-Object {
    $null = [System.Management.Automation.PSParser]::Tokenize((Get-Content $_.FullName -Raw), [ref]$null)
    if ($?) { Write-Host "✓ $($_.Name)" -ForegroundColor Green }
}
```

```bash
# Python syntax
python -m py_compile hydra_profile_heads.py
python -m py_compile hydra_adaptive_weighting.py
python -m py_compile hydra_dashboard_config_gen.py

# Python type checking
mypy hydra_*.py --ignore-missing-imports
```

### CI/CD (new section)
```bash
# Manual workflow triggers
gh workflow run tests.yml
gh workflow run hydra-deploy.yml
```

## Validation

✅ Python syntax checked (all 3 Hydra scripts valid)
✅ Markdown structure verified (28 section headings)
✅ YAML frontmatter validated
✅ Instructions comprehensive and actionable
✅ Follows GitHub Copilot best practices

## What's already in place

The repository already had excellent foundations:

1. **Five-layer architecture** documentation
2. **Comprehensive conventions** (PowerShell error handling, logging, idempotence)
3. **Hydra integration rules** (critical restrictions)
4. **Safe-edit checklist** (PR guidance)
5. **PR body template** (structured reviews)
6. **Autonomous CI/CD** (auto-merge workflow)
7. **Developer workflows** (copy-paste commands)

## What was enhanced

This configuration added:

1. **YAML frontmatter** → Better file targeting
2. **Build/test/lint section** → Explicit validation commands
3. **Pre-commit checklist** → Step-by-step guide
4. **CI/CD validation** → Workflow trigger commands

## Next steps

1. ✅ **Created**: Enhanced `.github/copilot-instructions.md`
2. ✅ **Validated**: Python syntax, markdown structure
3. ✅ **Committed**: Changes pushed to PR branch
4. 🔄 **Review**: Awaiting PR review and approval
5. ⏳ **Merge**: Auto-merge after `smoke-tests` pass + 1 approval
6. ⏳ **Monitor**: Verify AI agents use instructions effectively

## References

- [GitHub Copilot Best Practices](https://docs.github.com/en/copilot/tutorials/coding-agent/get-the-best-results)
- [Copilot Instructions Documentation](https://docs.github.com/en/copilot/concepts/agents/coding-agent)
- [.instructions.md Support](https://github.blog/changelog/2025-07-23-github-copilot-coding-agent-now-supports-instructions-md-custom-instructions/)

## Summary

The Claude Health Monitor repository now has **production-ready GitHub Copilot instructions** that:

- ✅ Target specific file types (PowerShell, Python, Markdown, GitHub config)
- ✅ Provide explicit build, test, and lint commands
- ✅ Follow GitHub's best practices for coding agent workflows
- ✅ Enable safe, guided AI-assisted development
- ✅ Integrate seamlessly with existing CI/CD automation

AI coding agents working in this repository now have comprehensive, actionable guidance for making safe, tested, and validated changes.
