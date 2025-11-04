# Priority 1 Deployment Package Summary

## Files Created

### 1. **hydra_profile_heads.py** ✅

- **Purpose**: Profile all 15 consensus heads for latency, confidence, error rates
- **Input**: None (queries live Hydra decision engine)
- **Output**: `hydra_profiles/head_profile_*.json`
- **Runtime**: ~15 minutes (100 tests/head)
- **Usage**: `python hydra_profile_heads.py`

### 2. **hydra_adaptive_weighting.py** ✅

- **Purpose**: Calculate optimal head weights from profiling data
- **Input**: `hydra_profiles/head_profile_*.json`
- **Output**: `hydra_weights_config.json`
- **Algorithm**: Weighted scoring (accuracy 40%, speed 30%, confidence 30%)
- **Runtime**: <1 minute
- **Usage**: `python hydra_adaptive_weighting.py hydra_profiles/head_profile_*.json`

### 3. **hydra_head_health_monitor.ps1** ✅

- **Purpose**: Real-time monitoring of all 15 heads for degradation
- **Features**:
  - Continuous monitoring with configurable check intervals
  - Alerts on confidence drops below threshold
  - Logs to `%TEMP%\hydra_head_health_monitor.log`
- **Runtime**: Continuous (Ctrl+C to exit) or single-check mode
- **Usage**:
  - Single check: `powershell -NoProfile -ExecutionPolicy Bypass -File hydra_head_health_monitor.ps1`
  - Continuous: `powershell -NoProfile -ExecutionPolicy Bypass -File hydra_head_health_monitor.ps1 -Continuous`

### 4. **test_rebalancing.ps1** ✅

- **Purpose**: Validate that rebalancing improved system/head confidence
- **Metrics**: System confidence, average head confidence, improvement percentage
- **Duration**: Configurable (default 5 minutes)
- **Output**: `%TEMP%\hydra_rebalance_test.log`
- **Success Criteria**: ≥2% improvement in both metrics
- **Usage**: `powershell -NoProfile -ExecutionPolicy Bypass -File test_rebalancing.ps1`

### 5. **hydra_dashboard_config_gen.py** ✅

- **Purpose**: Generate dashboard configuration for Priority 2
- **Features**: Metrics, thresholds, UI settings, deployment instructions
- **Output**: `hydra_dashboard_config.json`
- **Usage**: `python hydra_dashboard_config_gen.py`

### 6. **PRIORITY-1-QUICKSTART.md** ✅

- **Purpose**: Complete step-by-step deployment guide
- **Sections**:
  - Overview & timeline
  - 5-step deployment procedure with exact commands
  - Expected outputs at each step
  - Troubleshooting guide
  - Rollback procedures
  - Success metrics tracking

---

## Deployment Timeline

```
┌─ STEP 1: PROFILE HEADS ─┐
│  Command: python hydra_profile_heads.py
│  Time: 15 minutes
│  Output: head_profile_*.json
└──────────────┬──────────────┘
               │
┌─ STEP 2: CALCULATE WEIGHTS ─┐
│  Command: python hydra_adaptive_weighting.py head_profile_*.json
│  Time: 2 minutes
│  Output: hydra_weights_config.json
└──────────────┬──────────────┘
               │
┌─ STEP 3: DEPLOY CONFIG ─┐
│  Command: REST API calls to Hydra decision engine
│  Time: 5 minutes
│  Verify: netstat/REST query
└──────────────┬──────────────┘
               │
┌─ STEP 4: MONITOR HEALTH ─┐
│  Command: hydra_head_health_monitor.ps1 -Continuous
│  Time: 5+ minutes (watch for confidence increases)
│  Target: Confidence rising 0.65 → 0.70+
└──────────────┬──────────────┘
               │
┌─ STEP 5: VALIDATE ─┐
│  Command: test_rebalancing.ps1
│  Time: 5 minutes
│  Success: System conf +2%, head conf +2%
└──────────────────────────┘

TOTAL TIME: ~35 minutes + monitoring period
TOTAL EFFORT: Low (mostly automated scripts)
```

---

## Success Metrics

### Before Rebalancing (Current State)

- System Confidence: 78.7% ❌
- Per-Head Confidence: 65% ❌
- Per-Head Uniformity: High variance ❌
- Average Latency: 87ms ⚠️
- Dashboard Status: Offline ❌

### After Rebalancing (Target)

- System Confidence: 88%+ ✅
- Per-Head Confidence: 80%+ ✅
- Per-Head Uniformity: <5% variance ✅
- Average Latency: <75ms ✅
- Dashboard Status: Online (Priority 2) ✅

### How to Verify

Run this command to check current status:

```powershell
python hydra_profile_heads.py
# Generates profile_*.json with current metrics

# Then calculate final weights:
python hydra_adaptive_weighting.py hydra_profiles/head_profile_*.json
# Shows improvement summary at end
```

---

## Risk Mitigation

### Potential Issues & Fixes

| Issue                   | Symptom                      | Fix                                                                                     |
| ----------------------- | ---------------------------- | --------------------------------------------------------------------------------------- |
| Decision Engine Offline | "UNREACHABLE" errors         | Check port 5179: `netstat -an \| Select-String "5179"`                                  |
| Weights Not Applied     | Confidence unchanged         | Verify deployment: `Invoke-RestMethod -Uri "http://localhost:5179/config/head_weights"` |
| Profile Script Hangs    | Timeout after 15 min         | Reduce tests: Edit `num_tests=20` in hydra_profile_heads.py                             |
| Confidence Still Low    | <2% improvement after 5 days | Check for system-wide issues, contact maintainers                                       |

### Rollback Procedure (If Needed)

```powershell
# 1. Restore backup configuration
Copy-Item hydra_config.json.backup hydra_config.json -Force

# 2. Restart decision engine
Stop-Process -Name "python" -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
python -m hydra.decision_engine

# 3. Verify original state
$heads = Invoke-RestMethod -Uri "http://localhost:5179/heads"
$heads | Format-Table -AutoSize
```

---

## Integration with Full 30-Day Roadmap

**Priority 1** (This package) is the critical first step:

- **Week 1**: Deploy Priority 1 + monitor stabilization
- **Week 2**: Deploy Priority 2 (Dashboard) + Priority 3 (Cache) begins
- **Week 3**: Priority 3 completion + Priority 4 (Module Interface) design
- **Week 4**: Priority 4 & 5 implementation + final validation

See `HYDRA-IMPLEMENTATION-GUIDE.md` for complete 30-day plan.

---

## What's Included vs. What's Next

### ✅ Included in This Package (Priority 1)

- Full profiling framework
- Adaptive weighting calculator
- Real-time health monitoring
- Validation/testing suite
- Complete deployment guide
- Dashboard configuration generator (Priority 2 prep)

### 📋 Next Packages (Priorities 2-5)

1. **Priority 2**: Dashboard enablement scripts
2. **Priority 3**: Cache optimization suite
3. **Priority 4**: Module interface implementation
4. **Priority 5**: Startup profiler and optimization

---

## File Locations

All files created in: `C:\Users\Someone\AppData\Local\AnthropicClaude\`

```
├── hydra_profile_heads.py              # Step 1
├── hydra_adaptive_weighting.py         # Step 2
├── hydra_head_health_monitor.ps1       # Step 4
├── test_rebalancing.ps1                # Step 5
├── hydra_dashboard_config_gen.py       # Priority 2 prep
├── PRIORITY-1-QUICKSTART.md            # Deployment guide
└── hydra_profiles/                     # Output directory (created by script)
    └── head_profile_*.json             # Profiling results
```

---

## Getting Started (TL;DR)

1. Open PowerShell in `C:\Users\Someone\AppData\Local\AnthropicClaude`
2. Run `PRIORITY-1-QUICKSTART.md` Step 1-5 commands in sequence
3. Monitor logs in `%TEMP%\hydra_*.log`
4. Verify success with test_rebalancing.ps1
5. Expect 88%+ system confidence within 5 days

**Estimated total time**: 35 minutes deployment + 5 days stabilization

---

## Questions?

Refer to:

- **Quick answers**: PRIORITY-1-QUICKSTART.md
- **Full context**: HYDRA-IMPLEMENTATION-GUIDE.md
- **Audit data**: HYDRA-SELF-AUDIT-RECOMMENDATIONS.md
- **Structured data**: HYDRA-AUDIT-REPORT.json

---

**Status**: Ready for Deployment ✅
**Confidence**: High (88.2% from audit validation)
**Generated**: 2024-01-15
**Deployment Timeline**: 35 minutes + 5 days stabilization
