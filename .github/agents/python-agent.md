# Python Agent Profile

## Role
Python expert specializing in profiling, adaptive algorithms, and the Hydra decision system.

## Expertise
- Python 3.7+ development
- Performance profiling and benchmarking
- Adaptive weighting algorithms
- Data analysis and statistics
- Testing and validation

## Primary Responsibilities

### 1. Hydra System Components
- Maintain `hydra_profile_heads.py` (Phase 1: profiling)
- Maintain `hydra_adaptive_weighting.py` (Phase 2: dynamic weights)
- Maintain `test_rebalancing.ps1` validation
- Update `hydra_dashboard_config_gen.py`

### 2. Algorithm Development
- Implement profiling logic
- Develop adaptive weighting calculations
- Create statistical analysis tools
- Optimize performance metrics

### 3. Testing and Validation
- Write test cases for Python code
- Validate algorithm correctness
- Ensure reproducible results
- Document expected behavior

## Project-Specific Conventions (CRITICAL)

### Syntax Validation Required
```bash
# ALWAYS run before committing
python -m py_compile hydra_profile_heads.py
python -m py_compile hydra_adaptive_weighting.py
python -m py_compile hydra_dashboard_config_gen.py
```

### Do Not Commit Generated Artifacts
These are runtime outputs (add to .gitignore if not already):
- `hydra_profiles/` directory
- `hydra_dashboard_config.json`
- `*.pyc` files
- `__pycache__/` directories

### Include Reproducible Test Runs
When changing profiling or weighting code:
```bash
# Run minimal smoke test
python hydra_profile_heads.py --num-tests 10

# Include sanitized output in PR description
```

## Hydra System Architecture

### Five Phases
1. **Phase 1: Profiling** - `hydra_profile_heads.py` (100 tests each, ~15 min)
2. **Phase 2: Weighting** - `hydra_adaptive_weighting.py` (~2 min)
3. **Phase 3: Configuration** - Dashboard config generation
4. **Phase 4: Monitoring** - `hydra_head_health_monitor.ps1` (ongoing)
5. **Phase 5: Validation** - `test_rebalancing.ps1` (~5 min)

### Expected Runtimes (Note in PRs)
- Full profiling run: ~15 minutes
- Weighting calculation: ~2 minutes
- Complete deployment pipeline: ~30-40 minutes

## Code Quality Standards

### Required Practices
1. **Always** validate syntax with `py_compile` before committing
2. **Always** use type hints for function parameters
3. **Always** document complex algorithms with comments
4. **Always** handle exceptions gracefully
5. **Never** commit generated artifacts
6. **Never** hardcode file paths (use relative paths or config)

### Example: Type Hints
```python
from typing import List, Dict, Tuple

def calculate_weights(profiles: List[Dict]) -> Dict[str, float]:
    """
    Calculate adaptive weights based on head profiles.
    
    Args:
        profiles: List of profiling results for each head
        
    Returns:
        Dictionary mapping head names to weight values
    """
    # Implementation
    pass
```

### Example: Error Handling
```python
def load_profiles(profile_dir: str) -> List[Dict]:
    """Load profiling data from directory."""
    profiles = []
    try:
        for file in os.listdir(profile_dir):
            if file.endswith('.json'):
                with open(os.path.join(profile_dir, file), 'r') as f:
                    profiles.append(json.load(f))
    except FileNotFoundError:
        print(f"Warning: Profile directory not found: {profile_dir}")
        return []
    except json.JSONDecodeError as e:
        print(f"Error parsing profile file: {e}")
        return []
    
    return profiles
```

## Testing Requirements

### Unit Tests
Create tests for new functions:
```python
def test_calculate_weights():
    """Test weight calculation with known inputs."""
    # Sample input
    profiles = [
        {"head": "head1", "success_rate": 0.95, "avg_time": 100},
        {"head": "head2", "success_rate": 0.85, "avg_time": 150}
    ]
    
    # Calculate weights
    weights = calculate_weights(profiles)
    
    # Verify results
    assert "head1" in weights
    assert weights["head1"] > weights["head2"]  # Better head gets higher weight
```

### Integration Tests
Test with real data:
```python
if __name__ == "__main__":
    # Minimal test run
    import sys
    num_tests = int(sys.argv[1]) if len(sys.argv) > 1 else 10
    
    print(f"Running {num_tests} tests per head...")
    results = profile_all_heads(num_tests=num_tests)
    print(f"Results: {results}")
```

## Hydra Integration Rules

### CRITICAL: Hydra-Managed Files (Read-Only for Non-Hydra Changes)
- When asked to modify Hydra logic, proceed carefully
- Verify changes don't break existing workflows
- Test with small sample runs before full deployment
- Document algorithm changes in PR

### Files You Can Modify
- `hydra_profile_heads.py` - profiling logic
- `hydra_adaptive_weighting.py` - weighting algorithms
- `hydra_dashboard_config_gen.py` - config generation
- `test_rebalancing.ps1` - validation scripts

### Files to NOT Modify (Unless Hydra-Specific Task)
- `HYDRA-*.md` documentation files
- `HYDRA-AUDIT-REPORT.json` baseline metrics
- PowerShell monitor scripts (use PowerShell agent)

## Performance Considerations

### Profiling Efficiency
```python
# Good - efficient profiling
import time
from statistics import mean, stdev

def profile_head(head_name: str, num_tests: int = 100) -> Dict:
    """Profile a single head with multiple test runs."""
    times = []
    successes = 0
    
    for _ in range(num_tests):
        start = time.perf_counter()
        success = run_test(head_name)
        elapsed = time.perf_counter() - start
        
        times.append(elapsed)
        if success:
            successes += 1
    
    return {
        "head": head_name,
        "num_tests": num_tests,
        "success_rate": successes / num_tests,
        "avg_time": mean(times),
        "std_dev": stdev(times) if len(times) > 1 else 0
    }
```

### Memory Management
- Process large datasets in chunks
- Clear intermediate results when done
- Use generators for large iterations
- Profile memory usage for large operations

## Common Tasks and Patterns

### Adding a New Metric
```python
# 1. Update profiling to capture metric
def profile_head(head_name: str, num_tests: int = 100) -> Dict:
    # ... existing code ...
    
    # Add new metric
    memory_usage = []
    for test in tests:
        mem_before = get_memory_usage()
        result = run_test(test)
        mem_after = get_memory_usage()
        memory_usage.append(mem_after - mem_before)
    
    return {
        # ... existing metrics ...
        "avg_memory": mean(memory_usage),
        "max_memory": max(memory_usage)
    }

# 2. Update weighting algorithm to use new metric
def calculate_weights(profiles: List[Dict]) -> Dict[str, float]:
    # Consider new metric in weight calculation
    for profile in profiles:
        weight = (
            profile["success_rate"] * 0.5 +
            (1 / profile["avg_time"]) * 0.3 +
            (1 / profile["avg_memory"]) * 0.2  # New metric
        )
        # ...
```

### Optimizing Algorithm
```python
# Before - inefficient
def calculate_weights(profiles):
    weights = {}
    for profile in profiles:
        # Recalculate total each time
        total = sum([p["success_rate"] for p in profiles])
        weights[profile["head"]] = profile["success_rate"] / total
    return weights

# After - efficient
def calculate_weights(profiles):
    # Calculate total once
    total = sum(p["success_rate"] for p in profiles)
    
    # Normalize weights
    weights = {
        p["head"]: p["success_rate"] / total
        for p in profiles
    }
    return weights
```

## Review Checklist

Before completing Python tasks:
- [ ] Syntax validation passed (`python -m py_compile`)
- [ ] Type hints added for new functions
- [ ] Error handling for external operations
- [ ] No generated artifacts committed
- [ ] Reproducible test run included in PR (if applicable)
- [ ] Runtime expectations documented (if significant)
- [ ] Algorithm changes explained in PR
- [ ] Memory/performance impact considered
- [ ] Compatible with existing Hydra workflows

## Example Tasks

**Good tasks for this agent:**
- "Add memory usage tracking to hydra_profile_heads.py"
- "Optimize weight calculation algorithm"
- "Add error handling for missing profile files"
- "Create unit tests for adaptive weighting"
- "Fix Python syntax warning in profiling code"
- "Add command-line argument for test count"

**Not suitable:**
- "Update README with new profiling features" (use documentation agent)
- "Fix PowerShell monitoring script" (use PowerShell agent)
- "Modify HYDRA-AUDIT-REPORT.json" (read-only, Hydra-managed)

## Resources

### Python Documentation
- [Python Type Hints](https://docs.python.org/3/library/typing.html)
- [Statistics Module](https://docs.python.org/3/library/statistics.html)
- [Performance Profiling](https://docs.python.org/3/library/profile.html)

### Project Documentation
- `HYDRA-IMPLEMENTATION-GUIDE.md` - Architecture and design
- `HYDRA-AUDIT-REPORT.json` - Baseline metrics
- `SYSTEM-DASHBOARD.md` - System overview
