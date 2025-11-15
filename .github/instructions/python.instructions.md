---
applies_to: "**/*.py"
---

# Python Instructions for Hydra Decision System

## 🎯 Purpose

Python scripts implement the **Hydra Decision System** - advanced profiling and adaptive optimization for the Claude Health Monitor.

## 📂 Key Files

- `hydra_profile_heads.py` - Phase 1: Profile execution strategies (100 tests each, ~15 min)
- `hydra_adaptive_weighting.py` - Phase 2: Calculate dynamic weights (~2 min)
- `hydra_dashboard_config_gen.py` - Generate dashboard configuration
- `test_rebalancing.ps1` - Phase 5: Validate improvements (5 min)

## 🐍 Python Conventions (MUST FOLLOW)

### Version
- **Python 3.7+** required
- Use type hints where beneficial
- Follow PEP 8 style guide

### Syntax Validation
```bash
# ALWAYS run before committing
python -m py_compile hydra_profile_heads.py
python -m py_compile hydra_adaptive_weighting.py
python -m py_compile hydra_dashboard_config_gen.py
```

### Error Handling
```python
try:
    # Operation that might fail
    result = risky_operation()
except FileNotFoundError as e:
    print(f"Error: Profile file not found - {e}")
    return None
except Exception as e:
    print(f"Unexpected error: {e}")
    raise
```

### Logging
```python
import sys
from datetime import datetime

def log_message(message, level="INFO"):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"[{timestamp}] [{level}] {message}", file=sys.stderr)

# Usage
log_message("Starting profiling phase", "INFO")
log_message("Performance degradation detected", "WARN")
```

## 📊 Hydra System Architecture

### Phase 1: Profiling (`hydra_profile_heads.py`)
- Profiles multiple execution strategies ("heads")
- Runs 100 tests per head
- Records success rate, execution time, resource usage
- Expected runtime: ~15 minutes
- Outputs to `hydra_profiles/` directory

### Phase 2: Adaptive Weighting (`hydra_adaptive_weighting.py`)
- Analyzes profiling results
- Calculates dynamic weights based on performance
- Adjusts strategy preferences
- Expected runtime: ~2 minutes
- Uses profiles from Phase 1

### Phase 3: Dashboard Config (`hydra_dashboard_config_gen.py`)
- Generates visualization configuration
- Summarizes system state
- Creates JSON config for monitoring
- Lightweight operation (<10s)

## 🔒 Critical Rules

### DO NOT Commit Generated Artifacts
```bash
# These are runtime outputs - keep them local
hydra_profiles/          # Profiling results
hydra_dashboard_config.json  # Generated config
*.pyc                    # Compiled Python
__pycache__/            # Python cache
```

### DO Keep in Git
```python
# Source code only
hydra_profile_heads.py
hydra_adaptive_weighting.py
hydra_dashboard_config_gen.py
```

### .gitignore Entries (should exist)
```gitignore
hydra_profiles/
hydra_dashboard_config.json
__pycache__/
*.pyc
*.pyo
```

## 🧪 Testing Requirements

### Before Committing
```bash
# Syntax check
python -m py_compile hydra_*.py

# Short smoke run (10 tests instead of 100)
python hydra_profile_heads.py --num-tests 10

# Verify output structure (don't commit the output!)
ls -la hydra_profiles/
```

### In PRs
- Include reproducible test run in PR description
- Attach sanitized output summary (anonymize paths)
- Note expected runtime changes
- Document performance impact

### PR Description Template for Hydra Changes
```markdown
## Changes
- Modified profiling algorithm in hydra_profile_heads.py

## Testing
```bash
python hydra_profile_heads.py --num-tests 10
# Output: 10 heads profiled, avg success rate: 94.2%
# Runtime: 1m 32s (expected: ~1.5min for 10 tests)
```

## Performance Impact
- No significant runtime change expected
- Memory usage: stable at ~50MB
```

## 🚀 Common Patterns

### Profile Structure
```python
class HeadProfile:
    def __init__(self, name, strategy):
        self.name = name
        self.strategy = strategy
        self.success_count = 0
        self.failure_count = 0
        self.total_time = 0.0
        
    def record_success(self, elapsed_time):
        self.success_count += 1
        self.total_time += elapsed_time
        
    def get_success_rate(self):
        total = self.success_count + self.failure_count
        return (self.success_count / total * 100) if total > 0 else 0.0
```

### File I/O for Profiles
```python
import json
import os

def save_profile(profile, output_dir="hydra_profiles"):
    os.makedirs(output_dir, exist_ok=True)
    filename = os.path.join(output_dir, f"{profile.name}.json")
    
    data = {
        "name": profile.name,
        "success_rate": profile.get_success_rate(),
        "avg_time": profile.total_time / max(profile.success_count, 1),
        "timestamp": datetime.now().isoformat()
    }
    
    with open(filename, 'w') as f:
        json.dump(data, f, indent=2)
```

### Weight Calculation
```python
def calculate_weights(profiles):
    weights = {}
    total_success = sum(p.success_count for p in profiles)
    
    for profile in profiles:
        if total_success > 0:
            weight = profile.success_count / total_success
        else:
            weight = 1.0 / len(profiles)  # Equal weight as fallback
        weights[profile.name] = weight
    
    return weights
```

## 📝 Code Style

### Naming Conventions
```python
# Functions: snake_case
def calculate_adaptive_weight(profile_data):
    pass

# Classes: PascalCase
class HeadProfiler:
    pass

# Constants: UPPER_SNAKE_CASE
MAX_RETRIES = 3
DEFAULT_TIMEOUT = 30

# Variables: snake_case
success_rate = 0.95
```

### Documentation
```python
def profile_head(head_name, num_tests=100):
    """
    Profile a single Hydra head strategy.
    
    Args:
        head_name (str): Name of the head to profile
        num_tests (int): Number of test iterations (default: 100)
    
    Returns:
        HeadProfile: Profile object with results
        
    Raises:
        ValueError: If num_tests < 1
    """
    if num_tests < 1:
        raise ValueError("num_tests must be >= 1")
    # Implementation...
```

## ⚠️ Critical DON'Ts

### Performance
- **Don't** add blocking operations in profiling loops
- **Don't** use excessive sleep/wait times
- Keep profiling focused and efficient
- Avoid memory leaks in long-running profiles

### Data Management
- **Don't** hardcode absolute paths
- **Don't** commit sensitive profiling data
- **Don't** include system-specific information in committed code
- Use relative paths or environment variables

### Hydra Integration
- **Don't** modify `HYDRA-*.md` files (documentation is managed separately)
- **Don't** change `HYDRA-AUDIT-REPORT.json` (audit baseline)
- **Don't** interfere with PowerShell monitor operations
- Keep Python and PowerShell components decoupled

## 📊 Expected Runtimes

Document these in PRs when relevant:

```python
# Phase 1: Profiling
# Default: 100 tests/head × N heads = ~15 minutes
# Smoke: 10 tests/head × N heads = ~1.5 minutes

# Phase 2: Weighting
# ~2 minutes for full analysis

# Phase 3: Dashboard Config
# <10 seconds generation

# Full Pipeline: 30-40 minutes
```

## 🔍 Debugging

### Quick Smoke Test
```bash
# Test with minimal iterations
python hydra_profile_heads.py --num-tests 5

# Check output
ls -la hydra_profiles/
cat hydra_profiles/head_*.json
```

### Verbose Mode
```python
# Add verbose flag to your scripts
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--verbose', action='store_true')
parser.add_argument('--num-tests', type=int, default=100)
args = parser.parse_args()

if args.verbose:
    print(f"Running {args.num_tests} tests...")
```

### Profile Output Inspection
```bash
# View all profiles
cat hydra_profiles/*.json | python -m json.tool

# Check for errors
grep -i error hydra_profiles/*.log 2>/dev/null
```

## 📦 Dependencies

### Standard Library Only (Preferred)
```python
import json
import os
import sys
import time
from datetime import datetime
```

### If External Dependencies Needed
1. Check for vulnerabilities first
2. Document in requirements.txt
3. Note in PR description
4. Justify the dependency

## 🤝 Getting Help

- Review [HYDRA-IMPLEMENTATION-GUIDE.md](../../HYDRA-IMPLEMENTATION-GUIDE.md)
- Check [HYDRA-AUDIT-REPORT.json](../../HYDRA-AUDIT-REPORT.json) for baseline metrics
- See `.github/agents/python-agent.md` for specialized Python tasks
- Reference [SYSTEM-DASHBOARD.md](../../SYSTEM-DASHBOARD.md) for architecture context

## 🎯 Quality Checklist for Python PRs

- [ ] Syntax validated: `python -m py_compile *.py`
- [ ] No generated artifacts committed
- [ ] Reproducible smoke run documented
- [ ] Runtime impact noted
- [ ] Error handling implemented
- [ ] Type hints added where beneficial
- [ ] PEP 8 compliant
- [ ] Comments explain complex logic
- [ ] No hardcoded paths
- [ ] Memory usage considered
