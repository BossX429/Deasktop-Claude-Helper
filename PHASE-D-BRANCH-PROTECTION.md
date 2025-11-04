# 🔒 Phase D: Branch Protection Configuration

**Goal**: Enforce code quality and automated testing before merging to `main`

**Time**: ~5 minutes on GitHub UI  
**Status**: Ready to configure

---

## Why Branch Protection?

Ensures that:
- ✅ All code is reviewed (requires pull request + approval)
- ✅ All tests pass before merge (status checks)
- ✅ Branch is up-to-date (no conflicts)
- ✅ Rules apply to everyone (including admins)

---

## Step-by-Step Configuration

### Step 1: Open Branch Settings

1. Go to: https://github.com/BossX429/AnthropicClaude/settings/branches
2. Click **"Add rule"** button (or click existing `main` rule if already there)

### Step 2: Configure Branch Name Pattern

**Branch name pattern**: `main`

This applies protection rules to the `main` branch.

### Step 3: Enable Required Protections

Check these boxes:

#### ✅ Require a pull request before merging
- Prevents direct commits to `main`
- All changes must go through PR review process
- **Check**: ✅ "Require approvals"
- **Approvals needed**: `1`

#### ✅ Require status checks to pass before merging
- Automatically fails merge if tests don't pass
- **Check**: ✅ "Require status checks to pass before merging"
- **Check**: ✅ "Require branches to be up to date before merging"
- **Select status checks**:
  - ✅ `smoke-tests` (from `tests.yml` workflow)
  - ✅ Any other checks you want to require

**How to select checks**:
- If checks appear in the list, click them to select
- If they don't appear yet, create a PR first (which runs tests), then come back and select them

#### ✅ Include administrators
- **Check**: ✅ "Include administrators"
- This means branch rules apply to EVERYONE, including repo admins
- Prevents accidental bad merges even by admins

### Step 4: Optional Protections (Recommended)

Consider also enabling:

- ✅ **Require code reviews from code owners** (if you add `.github/CODEOWNERS` later)
- ✅ **Restrict who can push to matching branches** (if you have team permissions)
- ✅ **Require conversation resolution before merging** (good for larger teams)
- ✅ **Require signed commits** (for security-critical repos)

For now, focus on the 3 main ones above.

### Step 5: Save Configuration

1. Scroll to bottom
2. Click **"Create"** (or **"Save changes"** if updating existing rule)
3. GitHub confirms: "Branch protection rule created"

---

## Verification Checklist

After saving, verify:

- ✅ You're on the branch settings page
- ✅ Shows `main` branch with protection enabled
- ✅ "Require pull requests before merging" is checked
- ✅ "Require status checks to pass" is checked
- ✅ "Require branches to be up to date" is checked
- ✅ "Include administrators" is checked

---

## Test the Protection

### Try to Commit Directly to main (should FAIL)

```powershell
cd 'C:\Users\Someone\AppData\Local\AnthropicClaude'
git checkout main

# Try direct push (this will be rejected by GitHub)
git push origin main
# ↓ GitHub rejects: "refusing to allow a force push"
```

### Proper Way: Create PR

```powershell
# Create feature branch
git checkout -b feature/test-branch-protection

# Make a change
Add-Content TEST.txt "Testing branch protection"

# Commit and push
git add TEST.txt
git commit -m "test: verify branch protection works"
git push origin feature/test-branch-protection

# Go to GitHub and create PR
# PR shows: ✅ Tests pass, ✅ Ready to merge
# Merge via UI (only option now)
```

---

## GitHub UI Walkthrough (Visual)

```
Settings tab
  ↓
Branches (left sidebar)
  ↓
Add rule button
  ↓
Branch name pattern: main
  ↓
✅ Require a pull request before merging
   ✅ Require approvals (1)
  ↓
✅ Require status checks to pass
   ✅ Require branches to be up to date
   ✅ Select: smoke-tests
  ↓
✅ Include administrators
  ↓
Create button
  ↓
✅ Rule created!
```

---

## Troubleshooting

### "Status checks" not showing in dropdown
- This is normal if no PR has run tests yet
- Create a test PR first (Phase E)
- Come back and select checks afterward
- Or manually type the job name if available

### Can't merge PR even though tests pass
- Verify the branch is up-to-date with `main`
- If behind, click "Update branch" on PR
- Then try merge again

### Admin can't override protection
- This is by design (✅ "Include administrators" is checked)
- To bypass: Temporarily disable rule, merge, re-enable
- Better: Always go through PR process

---

## After Phase D

Once branch protection is configured:

1. **Phase E** will test it
2. **Hydra Deployment** phase can proceed safely
3. All changes are protected by:
   - Code review requirement
   - Automated testing requirement
   - Up-to-date branch requirement

---

## Quick Reference

**GitHub URL**: https://github.com/BossX429/AnthropicClaude/settings/branches

**Configuration**:
```
Branch name: main
✅ Require PR + 1 approval
✅ Require status checks (smoke-tests pass)
✅ Require up-to-date branches
✅ Include administrators
```

**Time**: 5 minutes  
**Difficulty**: Easy (just checkboxes)  
**Impact**: High (protects main branch)

---

## Next: Phase E

After Phase D is complete, Phase E will:
1. Create a test branch
2. Commit with validation
3. Push and trigger `tests.yml`
4. Watch GitHub Actions run
5. Verify branch protection blocks direct merges
6. Delete test branch

Then: Hydra deployment (35 minutes, 5 phases)

---

**Ready to configure?** Go to: https://github.com/BossX429/AnthropicClaude/settings/branches

Once configured, reply and I'll help you run Phase E testing.
