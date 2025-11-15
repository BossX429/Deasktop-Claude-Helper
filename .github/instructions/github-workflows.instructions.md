---
applies_to: ".github/workflows/**/*.yml"
---

# GitHub Actions Workflow Instructions

## 🎯 Purpose

GitHub Actions workflows automate testing, deployment, and repository operations for the Claude Health Monitor & Hydra Decision System.

## 📂 Existing Workflows

### Test Workflows
- `.github/workflows/tests.yml` - Smoke tests & diagnostics
  - Triggers: push, pull_request to main
  - Required check: `smoke-tests`
  - Runs: `Test-Monitor-Smoke.ps1`, `Diagnose-Monitor-Hydra.ps1`

### Deployment Workflows
- `.github/workflows/hydra-deploy.yml` - 5-phase Hydra deployment
  - Trigger: manual (`workflow_dispatch`)
  - Phases: Profile → Weight → Config → Monitor → Validate
  - Runtime: ~30-40 minutes total

### Automation Workflows
- `.github/workflows/autonomous-pr-operations.yml` - Auto-review & auto-merge
  - Triggers: pull_request (opened, synchronize, labeled)
  - Auto-requests reviews for AI PRs (`copilot/*`, `ai/*`, `[AI]`)
  - Auto-merges when checks pass + approval
- `.github/workflows/auto-populate-pr-template.yml` - PR template automation
  - Trigger: pull_request opened
  - Auto-populates PR description from template

## 🔧 Workflow Conventions (MUST FOLLOW)

### YAML Syntax
```yaml
name: Workflow Name

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  job-name:
    runs-on: ubuntu-latest  # or windows-latest
    steps:
      - uses: actions/checkout@v4
      - name: Step description
        run: |
          echo "Command"
```

### Permissions
```yaml
permissions:
  contents: read          # Read repository contents
  pull-requests: write    # Modify PRs
  issues: write          # Modify issues
  checks: write          # Write check runs
```

### Secrets and Environment Variables
```yaml
env:
  GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}  # Auto-provided
  CUSTOM_VAR: ${{ secrets.CUSTOM_SECRET }}   # User-defined

steps:
  - name: Use secret
    run: echo "Token length: ${#GITHUB_TOKEN}"
    env:
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## ⚠️ Critical Rules

### Security
- **Never** hardcode secrets in workflow files
- **Always** use `${{ secrets.SECRET_NAME }}`
- **Never** echo secrets in logs
- Use `env:` context for passing secrets to steps
- Review permissions - grant minimum necessary

### Testing
- Test workflow changes in a fork or branch first
- Use `workflow_dispatch` for manual testing
- Verify `if:` conditions work as expected
- Check matrix builds for all combinations

### Dependencies
- Pin action versions: `actions/checkout@v4` not `@main`
- Update actions quarterly (security patches)
- Test after updating action versions
- Document breaking changes from action updates

## 🚀 Common Patterns

### PowerShell on Windows
```yaml
jobs:
  test-windows:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Run smoke tests
        shell: pwsh
        run: |
          .\Test-Monitor-Smoke.ps1
```

### Python Setup
```yaml
jobs:
  test-python:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.x'
      
      - name: Run profiling
        run: |
          python -m py_compile hydra_*.py
          python hydra_profile_heads.py --num-tests 10
```

### Conditional Execution
```yaml
steps:
  - name: Only on main branch
    if: github.ref == 'refs/heads/main'
    run: echo "Main branch"
  
  - name: Only for PRs from copilot
    if: startsWith(github.head_ref, 'copilot/')
    run: echo "AI-generated PR"
  
  - name: Only if previous step succeeded
    if: success()
    run: echo "Previous steps passed"
```

### Matrix Builds
```yaml
jobs:
  test:
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest]
        python-version: ['3.7', '3.8', '3.9', '3.10']
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
```

### Artifacts
```yaml
steps:
  - name: Upload test results
    uses: actions/upload-artifact@v4
    if: always()
    with:
      name: test-results
      path: test-output/
      retention-days: 7
```

## 🧪 Testing Workflows

### Local Testing with `act`
```bash
# Install act: https://github.com/nektos/act

# Run a specific workflow
act push -W .github/workflows/tests.yml

# Run a specific job
act -j smoke-tests
```

### Workflow Dispatch
```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy to'
        required: true
        default: 'staging'
        type: choice
        options:
          - staging
          - production
```

### Debug Workflows
```yaml
steps:
  - name: Debug information
    run: |
      echo "Event: ${{ github.event_name }}"
      echo "Ref: ${{ github.ref }}"
      echo "SHA: ${{ github.sha }}"
      echo "Actor: ${{ github.actor }}"
```

## 📝 Documentation Requirements

### Workflow Headers
```yaml
name: Descriptive Workflow Name

# Brief description of what this workflow does
# Triggers: List when it runs
# Required permissions: List what permissions needed
# Outputs: Describe any artifacts or outputs

on:
  # Trigger configuration
```

### Step Comments
```yaml
steps:
  # Checkout the repository code
  - uses: actions/checkout@v4
  
  # Install Python dependencies for Hydra profiling
  - name: Set up Python
    uses: actions/setup-python@v5
```

## ⚠️ Critical DON'Ts

### Performance
- **Don't** run expensive operations on every commit
- **Don't** use matrix builds unnecessarily
- **Don't** download large files without caching
- Use `if:` conditions to skip unnecessary steps

### Security
- **Don't** use `pull_request_target` without understanding risks
- **Don't** grant write permissions unnecessarily
- **Don't** trust user input in `run:` commands without sanitization
- **Don't** expose secrets in logs or artifacts

### Reliability
- **Don't** depend on external services without error handling
- **Don't** assume specific runner environments
- **Don't** hardcode paths (use `$GITHUB_WORKSPACE`)
- **Don't** modify branch protection in workflows

## 🔍 Debugging Failed Workflows

### View Logs
```yaml
steps:
  - name: Show environment
    run: |
      env | sort
      echo "Working directory: $(pwd)"
      ls -la
```

### Enable Debug Logging
Repository Settings → Secrets → Add:
- `ACTIONS_RUNNER_DEBUG` = `true`
- `ACTIONS_STEP_DEBUG` = `true`

### Common Issues

#### Windows Path Issues
```yaml
# ❌ Bad
run: cat C:\path\to\file

# ✅ Good
run: Get-Content "$env:GITHUB_WORKSPACE\path\to\file"
shell: pwsh
```

#### Permission Errors
```yaml
# Add explicit permissions
permissions:
  contents: write
  pull-requests: write
```

#### Timeout Issues
```yaml
jobs:
  long-running:
    timeout-minutes: 60  # Default is 360
    steps:
      - name: Long operation
        timeout-minutes: 30
```

## 📊 Workflow Metrics

Monitor these for quality:
- Success rate: >95% for stable workflows
- Average runtime: Track and optimize
- Queue time: Minimize with concurrency settings
- Artifact size: Keep under 100MB when possible

## 🔄 Maintenance

### Regular Reviews
- Monthly: Check for action updates
- Quarterly: Review workflow efficiency
- After incidents: Post-mortem improvements
- On breaking changes: Update immediately

### Deprecation Process
1. Add deprecation warning to workflow
2. Update documentation
3. Create migration guide
4. Wait 2 release cycles
5. Remove deprecated workflow

## 🤝 Getting Help

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Action Marketplace](https://github.com/marketplace?type=actions)
- [Community Forums](https://github.community/c/code-to-cloud/52)
- Project docs: [AUTOMATION-SUITE.md](../../AUTOMATION-SUITE.md)

## 📋 PR Checklist for Workflow Changes

- [ ] Workflow tested in fork or with `workflow_dispatch`
- [ ] Permissions minimized
- [ ] Secrets not exposed in logs
- [ ] Error handling implemented
- [ ] Documentation updated
- [ ] No breaking changes to existing workflows
- [ ] Branch protection not modified
- [ ] Timeout values appropriate
- [ ] `if:` conditions tested
- [ ] Action versions pinned

## 🎯 Specific Workflow Guidelines

### For `tests.yml`
- Must complete in <5 minutes
- Required check for all PRs
- Should fail fast on critical errors
- Must run on Windows (monitor is Windows-specific)

### For `hydra-deploy.yml`
- Manual trigger only
- Full pipeline: 30-40 minutes
- Must validate each phase before proceeding
- Outputs artifacts for review

### For `autonomous-pr-operations.yml`
- Auto-review for AI PRs only
- Must respect branch protection
- Auto-merge only when checks pass + approval
- Should notify maintainers

## 💡 Best Practices

### Caching
```yaml
- uses: actions/cache@v4
  with:
    path: ~/.cache/pip
    key: ${{ runner.os }}-pip-${{ hashFiles('requirements.txt') }}
```

### Concurrency Control
```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
```

### Reusable Workflows
```yaml
# .github/workflows/reusable-test.yml
on:
  workflow_call:
    inputs:
      environment:
        required: true
        type: string

jobs:
  test:
    runs-on: windows-latest
    steps:
      - run: echo "Testing ${{ inputs.environment }}"
```

```yaml
# .github/workflows/caller.yml
jobs:
  call-reusable:
    uses: ./.github/workflows/reusable-test.yml
    with:
      environment: production
```
