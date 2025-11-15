---
applies_to: "**/*.md"
---

# Documentation Instructions

## 🎯 Purpose

Maintain clear, comprehensive, and consistent documentation across the repository.

## 📂 Documentation Types

### User Documentation
- `README.md` - Main repository overview
- `README-MONITOR.md` - Health monitor installation & usage
- `QUICK-REFERENCE.md` - Command cheat sheet
- `QUICKSTART-CARD.md` - One-page quick start

### Developer Documentation
- `SYSTEM-DASHBOARD.md` - Architecture overview
- `GIT-WORKFLOW.md` - Git & PR procedures
- `CONTRIBUTING.md` - Contribution guidelines
- `PRIORITY-1-QUICKSTART.md` - Deployment guide

### Technical Documentation
- `HYDRA-IMPLEMENTATION-GUIDE.md` - Hydra system details
- `AUTOMATION-SUITE.md` - CI/CD pipeline docs
- `MAINTENANCE-TESTING-GUIDE.md` - Testing procedures

### Status & Reports
- `DEPLOYMENT-COMPLETE.md` - Deployment status
- `AUTONOMOUS-CI.md` - Autonomous operations
- `COPILOT-SETUP-GUIDE.md` - Copilot integration

## ✍️ Writing Style

### Tone
- Clear and concise
- Professional but approachable
- Technical but accessible
- Action-oriented

### Structure
- Start with purpose/overview
- Use headings for navigation
- Include examples and code blocks
- Add emoji for visual hierarchy (sparingly)
- End with next steps or references

### Formatting

#### Headings
```markdown
# Main Title (H1) - One per document
## Section (H2) - Primary sections
### Subsection (H3) - Detailed breakdowns
#### Minor Section (H4) - Specific details
```

#### Code Blocks
````markdown
```powershell
# PowerShell example
Get-Process -Name Claude
```

```python
# Python example
def main():
    pass
```

```bash
# Bash/Shell example
ls -la
```
````

#### Lists
```markdown
- Unordered list item
  - Nested item
  - Another nested item
- Second item

1. Ordered list item
2. Second ordered item
   - Can mix with unordered
3. Third item
```

#### Emphasis
```markdown
**Bold** for strong emphasis
*Italic* for light emphasis
`code` for inline code
[Link text](URL) for hyperlinks
```

## 🎨 Emoji Usage

Use consistently and purposefully:

```markdown
## 🎯 Purpose
## 🚀 Quick Start
## 📖 Documentation
## 🔧 Configuration
## ✅ Success
## ❌ Error
## ⚠️ Warning
## 💡 Tip
## 📝 Note
## 🧪 Testing
## 🔒 Security
## 🏗️ Architecture
## 📊 Metrics
## 🤝 Contributing
```

## 📋 Document Templates

### README Structure
```markdown
# Project Title

Brief 1-2 sentence description.

## 🎯 What This Does
- Key feature 1
- Key feature 2

## 🚀 Quick Start
Installation steps

## 📖 Documentation
Links to detailed docs

## 🏗️ Architecture
High-level overview

## 🤝 Contributing
Contribution guidelines

## 📚 References
Links to related resources
```

### Guide Structure
```markdown
# Guide Title

## Overview
What this guide covers

## Prerequisites
What you need before starting

## Step-by-Step Instructions
1. First step
2. Second step

## Troubleshooting
Common issues and solutions

## Next Steps
What to do after completing the guide
```

## 🔄 Maintenance Guidelines

### When to Update Documentation

Update docs when you:
- Add or change features
- Modify configuration options
- Update installation procedures
- Change CLI commands or APIs
- Fix bugs that affect user behavior
- Deprecate functionality
- Add new files or components

### What NOT to Document

Don't document:
- Implementation details better suited to code comments
- Temporary workarounds (use TODOs instead)
- Personal opinions or preferences
- Incomplete features (use draft docs in separate branch)

## ✅ Quality Checklist

Before submitting documentation changes:

- [ ] Spelling and grammar checked
- [ ] Links work correctly
- [ ] Code examples tested and working
- [ ] Screenshots current (if applicable)
- [ ] Consistent with existing style
- [ ] Table of contents updated (if applicable)
- [ ] Cross-references accurate
- [ ] Version/date information current

## 📝 Common Patterns

### Linking to Other Docs
```markdown
See [System Dashboard](SYSTEM-DASHBOARD.md) for architecture details.
Reference the [Git Workflow](GIT-WORKFLOW.md) for PR guidelines.
For custom agents, see [.github/agents/README.md](.github/agents/README.md).
```

### Command Examples
```markdown
Run the smoke tests:
```powershell
.\Test-Monitor-Smoke.ps1
```

View logs:
```powershell
Get-Content "$env:TEMP\Claude-Monitor-*.log" -Tail 50
```
```

### Configuration Documentation
```markdown
## Configuration

### Critical Settings (Do Not Modify)
- `$CPUThreshold = 500` - CPU spike detection threshold

### User Configurable
- `$MaxRetries = 3` - Maximum repair attempts
- `$RetryDelaySeconds = 5` - Delay between retries
```

### Troubleshooting Sections
```markdown
## Troubleshooting

### Issue: Monitor not running
**Symptom:** Scheduled task exists but doesn't execute

**Solution:**
1. Check task status:
   ```powershell
   Get-ScheduledTask -TaskName "Claude Health Monitor"
   ```
2. Verify permissions (must run as SYSTEM)
3. Check logs for errors

### Issue: Python profiling fails
**Symptom:** `ModuleNotFoundError` when running hydra scripts

**Solution:**
Ensure Python 3.7+ is installed:
```bash
python --version
```
```

## 🚫 Common Mistakes to Avoid

### Don't Use Absolute Paths
```markdown
❌ Bad: C:\Users\Someone\AppData\Local\AnthropicClaude\
✅ Good: %LOCALAPPDATA%\AnthropicClaude\ or $env:LOCALAPPDATA\AnthropicClaude\
```

### Don't Assume Platform
```markdown
❌ Bad: Run `ls` to list files
✅ Good: On Windows PowerShell, use `Get-ChildItem`; on Unix, use `ls`
```

### Don't Skip Code Language Tags
````markdown
❌ Bad:
```
Get-Process
```

✅ Good:
```powershell
Get-Process
```
````

### Don't Duplicate Information
```markdown
❌ Bad: Repeating installation steps in multiple files
✅ Good: Link to canonical installation guide
```

## 🔒 Security in Documentation

### Never Include
- API keys or tokens
- Passwords or credentials
- Personal information
- Absolute file paths with usernames
- Sensitive system information

### Safe to Include
- Example configurations
- Sanitized log outputs
- Generic command examples
- Public repository URLs
- Architecture diagrams

## 📊 Documentation Metrics

Track these for quality:
- Broken links: 0 tolerated
- Outdated screenshots: Update quarterly
- Stale information: Review on major releases
- Missing examples: Add when confusion reported

## 🤝 Getting Help

For documentation tasks:
- Reference `.github/agents/documentation-agent.md` for specialized help
- Check existing docs for style patterns
- Review recent PRs for documentation changes
- Ask maintainers for clarification on technical details

## 📚 Resources

### Writing Guides
- [GitHub Markdown Guide](https://guides.github.com/features/mastering-markdown/)
- [Google Developer Documentation Style Guide](https://developers.google.com/style)

### Project References
- [README.md](../../README.md) - Main documentation
- [CONTRIBUTING.md](../../CONTRIBUTING.md) - Contribution guidelines
- [GIT-WORKFLOW.md](../../GIT-WORKFLOW.md) - Git procedures
