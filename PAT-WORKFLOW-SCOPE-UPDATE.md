# Update GitHub PAT with Workflow Scope

**Goal**: Add `workflow` scope to your Personal Access Token (PAT) so GitHub Actions workflows can be managed.

**Status**: ⏸️ Blocked - Requires your manual action in GitHub UI  
**User**: BossX429  
**Date**: 2025-11-04

---

## Why This Is Needed

GitHub rejected our workflow files during push:
```
error: refusing to allow a Personal Access Token to create or update workflow 
`.github/workflows/tests.yml` without `workflow` scope
```

**Solution**: Add `workflow` scope to your PAT.

---

## Step-by-Step Guide to Update PAT

### Step 1: Go to GitHub Settings

1. Open **GitHub.com** (logged in as `BossX429`)
2. Click your **profile icon** (top right corner)
3. Select **Settings**
4. In left sidebar, click **Developer settings**
5. Click **Personal access tokens**
6. Click **Tokens (classic)** (if you see this option)

### Step 2: Find Your Current Token

Look for a token named something like:
- "AnthropicClaude-Token" 
- "Claude-PAT"
- Or whatever you named it when creating it

**Note the token string** - you'll need to regenerate it. ⚠️ **WARNING**: This will invalidate the old token.

### Step 3: Regenerate the Token

1. Click on the token to view its details
2. Click **Regenerate token** button (or **Delete** and create new)
3. **Important**: Copy the new token immediately - you won't see it again!

### Step 4: Update Token Scopes

Make sure these scopes are checked:

**Current scopes** (should already have):
- ✅ `repo` (full control of private repositories)
- ✅ `read:org` (read organization data)
- ✅ `write:org` (write organization data)

**NEW scope to add**:
- ✅ `workflow` (update GitHub Actions and workflows)

**Final scope list should be**:
```
✅ repo
✅ read:org
✅ write:org
✅ workflow
```

### Step 5: Copy the New Token

1. After regenerating, GitHub displays the token (looks like: `ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`)
2. **Copy it immediately** (you won't see it again!)
3. Keep it safe temporarily

---

## Step 6: Update Git Credentials on Your Machine

Once you have the new token, update your local git credentials:

### Option A: Using Git Credential Manager (Easiest)

```powershell
# Git will prompt you for credentials on next push
# Simply paste the new token when prompted
cd 'C:\Users\Someone\AppData\Local\AnthropicClaude'
git push origin main --no-verify
# ↓ You'll see credential prompt
# ↓ Paste new token
```

### Option B: Update Windows Credential Manager Manually

1. Press `Win + R`, type `credential` and press Enter
2. Look for entry: `git:https://github.com`
3. Click **Edit**
4. Replace password with your new PAT token
5. Click **Save**

### Option C: Update Git Config File

**Not recommended** - storing tokens in files is a security risk.

---

## Step 7: Verify New Token Works

Test the new token with a simple push:

```powershell
cd 'C:\Users\Someone\AppData\Local\AnthropicClaude'

# Verify you're on main branch
git status
# Expected: "On branch main"

# Try a simple push (no changes, but verifies authentication)
git push origin main
# Expected: "Everything up-to-date" or similar
```

If you see no authentication errors, the new token is working! ✅

---

## Step 8: Re-add Workflow Files

Once the new PAT has the `workflow` scope and works:

```powershell
cd 'C:\Users\Someone\AppData\Local\AnthropicClaude'

# Get the workflow files from commit history (before they were removed)
# We can restore them from git history
git log --all --oneline -- .github/workflows/

# Example output:
# 665547c feat: add git automation and workflow documentation
# d2133f0 Initial commit

# Restore from the commit that had them (665547c in this example)
git checkout 665547c -- .github/workflows/

# Verify they're restored
ls .github/workflows/

# Commit the restore
git add .github/workflows/
git commit -m "feat: restore workflow files now that PAT has workflow scope"

# Push to GitHub
git push origin main
```

---

## Success Indicators ✅

When complete, you should see:

### After updating PAT in GitHub UI
- ✅ New token generated
- ✅ Token shows `workflow` scope in token details
- ✅ Token copied and saved temporarily

### After updating git credentials
- ✅ `git push origin main` succeeds without authentication errors
- ✅ No "refusing to allow Personal Access Token" errors

### After re-adding workflows
- ✅ `.github/workflows/tests.yml` is in repository
- ✅ `.github/workflows/hydra-deploy.yml` is in repository
- ✅ `git log` shows new commit with workflows restored
- ✅ GitHub shows workflows are now available

### On GitHub.com
- ✅ Go to https://github.com/BossX429/AnthropicClaude
- ✅ Click **Actions** tab
- ✅ Should show workflow definitions available
- ✅ Workflows will trigger on next push

---

## Troubleshooting

### "Token not recognized"
- Verify you copied the entire token (including `ghp_` prefix)
- Verify you updated the right credential store
- Try clearing cached credentials: `git credential reject`

### "workflow scope not available"
- Your GitHub account/organization may not support this scope
- Check if you're on a free/pro plan that supports Actions
- Try on a different branch to test

### "Still getting workflow rejected error"
- Wait 1-2 minutes for GitHub to sync the new PAT scopes
- Try logging out and back into GitHub.com
- Regenerate the token again

---

## Current Repository Status

**Workflows currently**: ⏸️ Removed (awaiting PAT update)
- Removed in commit: `0b390a5`
- Removed in commit: `50cdeef`
- Will be restored in: (pending your PAT update)

**Once PAT is updated**:
1. Re-add workflow files from git history
2. Push to GitHub
3. GitHub Actions automation becomes active
4. Phase C is complete

---

## Quick Reference: All Commands Needed

```powershell
# After updating PAT in GitHub UI and saving the new token:

# 1. Test new token (git will prompt you to enter it)
cd 'C:\Users\Someone\AppData\Local\AnthropicClaude'
git push origin main

# 2. Restore workflow files (once token works)
git checkout 665547c -- .github/workflows/

# 3. Commit and push
git add .github/workflows/
git commit -m "feat: restore workflow files"
git push origin main

# 4. Verify on GitHub
# Visit: https://github.com/BossX429/AnthropicClaude/actions
```

---

## Security Notes ⚠️

- **NEVER** commit your PAT token to git
- **NEVER** share your PAT token
- **NEVER** paste it in code or documentation
- **DO** regenerate PAT tokens regularly (every 3-6 months)
- **DO** use the minimal scopes needed for your use case
- **DO** delete old tokens after updating

---

## Support

If you get stuck:
1. Check the troubleshooting section above
2. Verify all scopes are checked: `repo`, `read:org`, `write:org`, `workflow`
3. Verify token was copied completely (should start with `ghp_`)
4. Try clearing git credentials and re-entering

Once done, reply with:
> PAT updated with workflow scope - ready to restore workflows

Then I'll help with Step 8 (restoring and re-pushing workflows).

---

**Next Phase**: Phase C - GitHub Actions Automation (pending your PAT update)
