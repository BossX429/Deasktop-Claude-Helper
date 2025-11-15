# Custom Agent Profiles

This directory contains specialized agent profiles for GitHub Copilot coding agent. Each profile focuses on specific types of tasks to provide better context and results.

## Available Agents

### Documentation Agent
**File:** `documentation-agent.md`
**Purpose:** Handles documentation updates, README improvements, and markdown file changes
**Best for:** 
- Updating technical documentation
- Creating/improving README files
- Writing user guides and onboarding materials
- Maintaining changelog files

### PowerShell Agent
**File:** `powershell-agent.md`
**Purpose:** Handles PowerShell script development and maintenance
**Best for:**
- Monitor script updates
- PowerShell syntax fixes
- Adding logging and error handling
- Script refactoring following project conventions

### Python Agent  
**File:** `python-agent.md`
**Purpose:** Handles Python code for Hydra system components
**Best for:**
- Hydra profiling code
- Adaptive weighting algorithms
- Python syntax validation
- Testing and validation scripts

## How to Use Custom Agents

When creating issues or asking Copilot to work on a task, you can reference these agent profiles:

```
@copilot using @documentation-agent, please update the README.md with installation instructions
```

Or in issue descriptions:
```
[Agent: PowerShell] Fix error handling in Monitor-ClaudeHealth.ps1
```

## Relationship with Copilot Instructions

### Custom Agents vs. Instructions
- **Custom Agents** (this directory): Specialized agent profiles referenced manually in issues/PRs
- **Copilot Instructions** (`.github/instructions/`): Automatically applied based on file type

### Complementary Systems
- **Instructions** provide file-specific guidance (auto-applied when editing `.ps1`, `.py`, `.md`, etc.)
- **Agents** provide task-specific expertise (manually invoked for specialized work)

**Example workflow:**
1. Copilot automatically uses `python.instructions.md` when editing Python files
2. You can also invoke `@python-agent` for specialized Hydra algorithm work
3. Both systems work together for optimal results

## Agent Development Guidelines

All custom agents should:
- Follow the project's coding conventions documented in `.github/instructions/`
- Reference specific instruction files for technical details
- Respect Hydra integration rules
- Maintain compatibility with existing CI/CD workflows
- Include appropriate testing guidance
- Document their specialization area clearly

## See Also

- [`.github/instructions/`](../instructions/) - Automatic, file-based Copilot instructions
- [`.github/copilot-instructions.md`](../copilot-instructions.md) - Legacy comprehensive instructions
- [`COPILOT-SETUP-GUIDE.md`](../../COPILOT-SETUP-GUIDE.md) - Setup documentation
