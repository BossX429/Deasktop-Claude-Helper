# Pull Request

## What changed?

- [ ] Brief description of changes

## Why?

- [ ] Reason: feature / fix / docs / refactor / test

## Related Issue

Closes #<!-- Issue number, if applicable -->

## Type of Change

- [ ] Bug fix (non-breaking)
- [ ] Feature (non-breaking)
- [ ] Breaking change
- [ ] Documentation only

## Tests Passing

- [ ] `Test-Monitor-Smoke.ps1` passes locally
- [ ] Pre-commit hook passed (syntax validation)
- [ ] No breaking changes to `$CPUThreshold` or log paths
- [ ] Hydra-managed files untouched (read-only)

## Checklist

- [ ] Created feature branch (not pushing to `main` directly)
- [ ] Commits follow `<type>(<scope>): <subject>` format (e.g., `fix(monitor): resolve deadlock`)
- [ ] No PAT tokens or credentials committed
- [ ] Code follows project conventions (`-ErrorAction SilentlyContinue`, `Log-Message` calls)
- [ ] Ready for `smoke-tests` CI status check

## Reviewer Notes

**Required to merge:**

- ✅ Status check `smoke-tests` must pass
- ✅ At least 1 approving review required
- ✅ Branch must be up to date with `main`

**For maintainers:** Use squash-and-merge unless commit history is important for auditing.
