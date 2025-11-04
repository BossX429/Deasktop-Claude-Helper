# Git Workflow Guide - Claude Health Monitor

**Version**: 1.0
**Date**: November 4, 2025
**Status**: ACTIVE

---

## Quick Reference

### Branch Strategy

- `main` - Production-ready code (protected, requires PR + tests)
- `develop` - Development branch (active work)
- `feature/*` - Feature branches (from develop)
- `bugfix/*` - Bug fix branches (from develop)
- `hotfix/*` - Urgent production fixes (from main)

### Commit Message Convention

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**: feat, fix, docs, style, refactor, test, chore
**Scope**: monitor, hydra, vscode, ci-cd, deployment
**Subject**: Imperative mood, 50 characters max

**Examples**:

```
feat(hydra): Add confidence threshold detection
fix(monitor): Resolve Squirrel deadlock on update
docs(deployment): Update Priority 1 quickstart
```

---

## Workflow Steps

### 1. Create Feature Branch

```powershell
git checkout develop
git pull origin develop
git checkout -b feature/your-feature-name
```

### 2. Make Changes & Commit

```powershell
git add .
git commit -m "feat(scope): description"
# Pre-commit hook runs automatically
# Validates PowerShell/Python syntax
```

### 3. Push & Create PR

```powershell
git push -u origin feature/your-feature-name
# Go to GitHub → Create Pull Request to develop
```

### 4. PR Review & Merge

- ✅ At least 1 approval required
- ✅ All checks must pass (tests.yml)
- ✅ Branches must be up to date
- ✅ Squash and merge to develop

### 5. Merge to Main (Release)

```powershell
git checkout main
git pull origin main
git merge --no-ff develop -m "release: v1.0.0"
git push origin main
```

---

## Protected Branches

### Main Branch Rules

- Require pull request reviews: YES (1+)
- Require status checks to pass: YES (tests.yml, smoke-tests)
- Require branches to be up to date: YES
- Dismiss stale PR approvals: YES
- Enforce for administrators: YES

### Develop Branch Rules

- Require pull request reviews: YES (1+)
- Require status checks to pass: YES

---

## CI/CD Pipeline

### Automatic Triggers

- **Push to main**: Run all tests + deploy checks
- **Push to develop**: Run tests only
- **Pull Request to main**: Run all tests (required for merge)
- **Manual trigger**: Deploy workflow (workflow_dispatch)

### Workflow Files

- `.github/workflows/tests.yml` - Smoke tests + diagnostics
- `.github/workflows/hydra-deploy.yml` - Priority 1-5 deployments

---

## Rollback Procedures

### Rollback Recent Commit

```powershell
git revert <commit-hash>
git push origin main
```

### Rollback to Previous Version

```powershell
git reset --hard <commit-hash>
git push -f origin main  # Use with caution!
```

### Emergency Hotfix

```powershell
git checkout -b hotfix/critical-issue main
# Make fixes
git commit -m "fix: critical issue"
git push -u origin hotfix/critical-issue
# Create PR to main (bypass if emergency)
# Then merge back to develop
```

---

## Pre-commit Hook

**Automatic Validation** (runs before commit):

- ✅ PowerShell syntax validation
- ✅ Python syntax validation (py_compile)
- ✅ Check for TODO/FIXME comments
- ⚠️ Warning if issues found
- ❌ Block commit if errors found

**Override** (if needed):

```powershell
git commit --no-verify
```

---

## Pre-push Hook

**Automatic Testing** (runs before push):

- ✅ Smoke test suite (5 tests)
- ❌ Block push if tests fail
- ⚠️ Skip if test file not found

**Override** (if needed):

```powershell
git push --no-verify
```

---

## Best Practices

1. **Small commits** - Logical, atomic changes
2. **Frequent pushes** - Don't hoard local commits
3. **Clear messages** - Describe the "why"
4. **Test before push** - Run tests locally
5. **Rebase often** - Keep branches up to date
6. **Review code** - Every PR needs review
7. **Delete branches** - Clean up after merge

---

## Continuous Integration

### Status Checks

All PRs to main must pass:

- ✅ `tests.yml` - Smoke tests + diagnostics
- ✅ Code style checks
- ✅ Security scans (if enabled)

### Deployment Gates

- ✅ All status checks passing
- ✅ Code review approved
- ✅ Branches up to date
- ✅ No unresolved conversations

---

## Team Communication

### When Pushing

- Use clear commit messages
- Reference issues if applicable
- Update related documentation

### When Creating PR

- Write comprehensive description
- Link related issues
- Mention reviewers if needed
- Set labels (enhancement, bug, etc.)

### When Reviewing

- Check code quality
- Verify tests pass
- Request changes if needed
- Approve when satisfied

---

## Troubleshooting

### "Pre-commit hook failed"

```powershell
# Fix syntax errors, then:
git add .
git commit -m "fix: syntax errors"
```

### "Pre-push hook failed"

```powershell
# Run tests locally:
powershell -File "Test-Monitor-Smoke.ps1"
# Fix issues, then push again
```

### "Branch protection blocked PR"

- ✅ Get PR approved
- ✅ Ensure all checks pass
- ✅ Rebase on latest main
- ✅ Merge when ready

---

## Useful Commands

```powershell
# View commit history
git log --oneline -10

# Check branch status
git branch -a
git status

# See what changed
git diff
git diff --staged

# View remote info
git remote -v

# Clean up local branches
git branch -d feature/completed-work

# Sync with remote
git fetch origin
git pull origin main
git push origin main
```

---

**Questions?** See RECONNAISSANCE-INDEX.md for reference guides.
