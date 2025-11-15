# Copilot Instructions Directory

This directory contains **custom instructions** for GitHub Copilot coding agent, organized by file type and domain.

## 📂 Available Instructions

### Global Instructions
- **[global.instructions.md](global.instructions.md)** - Repository-wide guidance
  - Applies to: `**/*` (all files)
  - Purpose: General rules, task suitability, git workflow, testing requirements
  - Key topics: Security, code quality, documentation standards

### Language-Specific Instructions

#### PowerShell
- **[powershell.instructions.md](powershell.instructions.md)** - PowerShell best practices
  - Applies to: `**/*.ps1`
  - Purpose: Health Monitor development conventions
  - Key topics: Error handling, logging, idempotence, critical thresholds

#### Python
- **[python.instructions.md](python.instructions.md)** - Python best practices
  - Applies to: `**/*.py`
  - Purpose: Hydra Decision System development
  - Key topics: Profiling, adaptive weighting, testing, runtime expectations

### Domain-Specific Instructions

#### Documentation
- **[docs.instructions.md](docs.instructions.md)** - Documentation standards
  - Applies to: `**/*.md`
  - Purpose: Maintain consistent, high-quality documentation
  - Key topics: Writing style, formatting, templates, maintenance

#### GitHub Actions
- **[github-workflows.instructions.md](github-workflows.instructions.md)** - Workflow best practices
  - Applies to: `.github/workflows/**/*.yml`
  - Purpose: CI/CD pipeline development and maintenance
  - Key topics: Security, testing, patterns, debugging

## 🎯 How Copilot Uses These Instructions

### Automatic Application
When working on a file, Copilot automatically loads instructions that apply to that file based on the `applies_to` YAML frontmatter.

**Example:**
- Editing `Monitor-ClaudeHealth.ps1` → Loads `powershell.instructions.md` + `global.instructions.md`
- Editing `hydra_profile_heads.py` → Loads `python.instructions.md` + `global.instructions.md`
- Editing `README.md` → Loads `docs.instructions.md` + `global.instructions.md`
- Editing `.github/workflows/tests.yml` → Loads `github-workflows.instructions.md` + `global.instructions.md`

### YAML Frontmatter Format
```yaml
---
applies_to: "pattern"
---
```

**Supported patterns:**
- `**/*` - All files (global)
- `**/*.ext` - All files with extension (e.g., `**/*.ps1`)
- `path/**/*` - All files in directory tree (e.g., `.github/workflows/**/*`)
- Glob patterns supported

## 📋 Instruction Structure

Each instruction file follows this structure:

```markdown
---
applies_to: "file_pattern"
---

# Title

## 🎯 Purpose
What this instruction covers

## 📂 Key Files
Relevant files in the repository

## 🔧 Conventions (MUST FOLLOW)
Critical patterns and rules

## 🚀 Common Patterns
Code examples and templates

## ⚠️ Critical DON'Ts
What to avoid

## 🧪 Testing Requirements
How to validate changes

## 🤝 Getting Help
Where to find more information
```

## 🆚 Comparison with Other Configuration

### `.github/instructions/` (Modern, Recommended)
- ✅ File-specific scoping with YAML frontmatter
- ✅ Multiple instruction files for different contexts
- ✅ Automatic application based on file patterns
- ✅ Cleaner organization and maintainability

### `.github/copilot-instructions.md` (Legacy, Still Supported)
- ⚠️ Single file for all instructions
- ⚠️ No automatic scoping to file types
- ⚠️ Harder to maintain as project grows
- ℹ️ Kept for backward compatibility

### `.github/agents/` (Custom Specialized Agents)
- ℹ️ Different purpose - defines custom agent profiles
- ℹ️ Referenced manually in issues/PRs
- ℹ️ Example: `[Agent: PowerShell] Add logging to function`

## 🔄 Migration from Legacy Format

The repository previously used `.github/copilot-instructions.md` (comprehensive, 241 lines). This content has been:

1. **Reorganized** into focused, domain-specific instruction files
2. **Enhanced** with file-specific patterns and examples
3. **Scoped** using YAML frontmatter for automatic application
4. **Maintained** in legacy file for backward compatibility

**Both systems work together:**
- New system: Targeted, context-aware instructions
- Legacy file: Remains as comprehensive reference

## 📝 Creating New Instructions

### When to Add New Instruction File

Add a new instruction file when:
- New programming language introduced (e.g., `javascript.instructions.md`)
- New domain area needs specific guidance (e.g., `testing.instructions.md`)
- Existing instructions become too large (split into focused files)
- Different conventions needed for subdirectories

### Template for New Instructions

```markdown
---
applies_to: "pattern"
---

# Title

## 🎯 Purpose
Brief description of what this covers

## 📂 Key Files
List of relevant files

## 🔧 Conventions (MUST FOLLOW)
Critical rules and patterns

## 🚀 Common Patterns
Code examples

## ⚠️ Critical DON'Ts
What to avoid

## 🧪 Testing Requirements
How to test

## 🤝 Getting Help
Resources and references
```

## 🛠️ Maintaining Instructions

### Regular Updates
- **After major changes**: Update relevant instructions
- **New patterns emerge**: Document in appropriate file
- **Common mistakes**: Add to "DON'Ts" section
- **New tools/dependencies**: Update testing requirements

### Quality Checks
- [ ] YAML frontmatter valid
- [ ] Pattern matches intended files
- [ ] Examples tested and working
- [ ] Links to docs current
- [ ] No conflicting guidance between files

## 🎓 Best Practices

### For Instruction Writers
1. **Be specific**: Provide concrete examples, not vague guidance
2. **Be consistent**: Follow the established structure
3. **Be actionable**: Tell Copilot what to do, not just what to avoid
4. **Be contextual**: Scope instructions appropriately with `applies_to`
5. **Be current**: Keep instructions updated with project changes

### For Copilot Users
1. **Trust the system**: Instructions apply automatically
2. **Reference when needed**: Mention instruction files in prompts if needed
3. **Provide feedback**: Report issues or gaps in instructions
4. **Follow conventions**: Instructions exist for quality and consistency

## 📚 Additional Resources

### Project Documentation
- [README.md](../../README.md) - Main repository documentation
- [COPILOT-SETUP-GUIDE.md](../../COPILOT-SETUP-GUIDE.md) - Setup details
- [.github/copilot-instructions.md](../copilot-instructions.md) - Legacy instructions
- [.github/agents/README.md](../agents/README.md) - Custom agent profiles

### GitHub Documentation
- [Copilot Instructions Documentation](https://docs.github.com/en/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot)
- [Coding Agent Best Practices](https://docs.github.com/en/copilot/tutorials/coding-agent/get-the-best-results)
- [Custom Agents Guide](https://docs.github.com/en/copilot/using-github-copilot/using-extensions/using-custom-agents)

## 🤝 Contributing

To improve these instructions:
1. Create a branch: `feature/update-instructions`
2. Edit or add instruction files
3. Test with actual Copilot usage
4. Submit PR with examples of improved Copilot behavior
5. Include before/after comparisons if applicable

## ❓ FAQ

**Q: Do instructions apply to nested files?**
A: Yes, if pattern uses `**/*` (e.g., `.github/workflows/**/*` applies to all files in subdirectories)

**Q: Can multiple instructions apply to one file?**
A: Yes! Global + language-specific + domain-specific can all apply (e.g., `.ps1` files get global + PowerShell instructions)

**Q: How do I test if instructions are applied?**
A: Ask Copilot specific questions about conventions - it should reference the instruction content

**Q: Should I update legacy copilot-instructions.md?**
A: Update new instruction files first, optionally sync major changes to legacy file for backward compatibility

**Q: What if instructions conflict?**
A: More specific instructions (e.g., `python.instructions.md`) take precedence over global

---

**Last Updated:** November 2025  
**Status:** ✅ Active - Copilot instructions fully configured  
**Maintainer:** Repository maintainers (see [CODEOWNERS](../../CODEOWNERS))
