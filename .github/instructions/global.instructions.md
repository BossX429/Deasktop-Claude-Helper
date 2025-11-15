---
applies_to: "**/*"
---

# Global Copilot Instructions for AnthropicClaude

## 🎯 Repository Overview

This is the **Claude Health Monitor & Hydra Decision System** - an automated Windows health monitoring and repair system for Anthropic's Claude desktop application with advanced decision system optimization.

## 🏗️ Architecture

Five-layer system:
1. **Application Layer**: Multi-release Electron Claude apps
2. **Health Monitoring**: PowerShell auto-repair system
3. **Hydra Decision System**: Python profiling & optimization
4. **VS Code Optimization**: Development environment
5. **GitHub Actions CI/CD**: Automated testing & deployment

## ✅ Task Suitability

### Good Tasks for Copilot
- Bug fixes with clear reproduction steps
- Test additions for existing functionality
- Documentation updates matching code changes
- Code refactoring following project conventions
- Logging improvements (`Log-Message` calls)
- Error handling additions (`-ErrorAction SilentlyContinue`)

### Review Carefully
- Performance optimizations (verify benchmarks)
- Configuration changes (not `$CPUThreshold`)
- New features (clear requirements needed)
- Dependency updates (check compatibility)

### Not Suitable for Copilot
- Security-critical fixes
- Breaking changes
- Architecture redesign
- Critical threshold adjustments (`$CPUThreshold = 500`)
- Production deployment decisions
- Hydra algorithm redesign

## 🔒 Critical Rules

### Security
- Never commit PAT tokens or secrets
- Use environment variables for credentials
- Follow secure coding practices
- Run security scans before committing

### Code Quality
- All code changes require tests
- Follow language-specific conventions
- Maintain backward compatibility
- Document breaking changes

### Git Workflow
- **Never push directly to `main`** - always use feature branches
- Branch naming: `copilot/feature-name`, `ai/fix-name`, `feature/xxx`, `fix/yyy`
- Required status check: `smoke-tests` must pass
- PRs require at least 1 approving review
- Use conventional commits: `type(scope): subject`
  - `feat:` new features
  - `fix:` bug fixes
  - `docs:` documentation
  - `refactor:` code improvements
  - `test:` test additions
  - `chore:` maintenance

## 🧪 Testing Requirements

### Before Committing
- Run relevant test suite
- Validate syntax (language-specific)
- Check for linting errors
- Ensure no breaking changes

### CI/CD Pipeline
- Smoke tests run automatically on PR
- All checks must pass before merge
- Auto-merge enabled for AI branches when approved

## 📝 Documentation Standards

- Update docs when changing functionality
- Keep README.md current
- Document new features and APIs
- Include code examples in guides
- Maintain consistency with existing style

## 🤝 Custom Agents Available

Reference specialized agents in issues:
- `.github/agents/documentation-agent.md` - README, guides, markdown
- `.github/agents/powershell-agent.md` - Monitor scripts, error handling
- `.github/agents/python-agent.md` - Hydra profiling, weighting algorithms

Example usage: `[Agent: PowerShell] Add logging to CPU spike detection`

## 📚 Key References

- [System Dashboard](SYSTEM-DASHBOARD.md) - Architecture overview
- [Git Workflow](GIT-WORKFLOW.md) - Branch strategy, commit conventions
- [Priority 1 Quickstart](PRIORITY-1-QUICKSTART.md) - Deployment guide
- [Contributing Guide](CONTRIBUTING.md) - Contribution guidelines

## ⚠️ What NOT to Do

- Don't modify `HYDRA-*.md` or `HYDRA-AUDIT-*.json` files (read-only, managed by Hydra)
- Don't use `Start-Sleep` in repair functions (keep fast, <100ms)
- Don't write to registry or shared app state outside `%TEMP%`
- Don't ignore error handling requirements
- Don't commit generated artifacts (`hydra_profiles/`, build outputs)

## 💡 General Guidelines

- Make minimal, focused changes
- Preserve existing behavior unless explicitly changing it
- Add logging for detectable actions
- Keep functions idempotent
- Consider edge cases
- Write clear commit messages
- Test thoroughly before submitting
