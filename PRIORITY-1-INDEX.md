# Hydra Priority 1 Deployment - Complete Package Index

## 📦 Package Contents

**Status**: ✅ All files created and ready for deployment

### Executable Scripts (Deploy in this order)

1. **hydra_profile_heads.py** (100 lines)

   - Profiles all 15 consensus heads
   - Time: ~15 minutes
   - Output: `hydra_profiles/head_profile_*.json`
   - Run: `python hydra_profile_heads.py`

2. **hydra_adaptive_weighting.py** (150 lines)

   - Calculates optimal head weights
   - Time: ~2 minutes
   - Output: `hydra_weights_config.json`
   - Run: `python hydra_adaptive_weighting.py hydra_profiles/head_profile_*.json`

3. **hydra_head_health_monitor.ps1** (90 lines)

   - Real-time head health monitoring
   - Time: Continuous (5+ minutes minimum)
   - Output: `%TEMP%\hydra_head_health_monitor.log`
   - Run: `powershell -NoProfile -ExecutionPolicy Bypass -File hydra_head_health_monitor.ps1`

4. **test_rebalancing.ps1** (110 lines)

   - Validates rebalancing effectiveness
   - Time: ~5 minutes
   - Output: `%TEMP%\hydra_rebalance_test.log`
   - Run: `powershell -NoProfile -ExecutionPolicy Bypass -File test_rebalancing.ps1`

5. **hydra_dashboard_config_gen.py** (140 lines)
   - Prepares Priority 2 (Dashboard)
   - Time: <1 minute
   - Output: `hydra_dashboard_config.json`
   - Run: `python hydra_dashboard_config_gen.py`

### Documentation

1. **PRIORITY-1-QUICKSTART.md** ⭐ START HERE

   - Complete step-by-step deployment guide
   - Includes exact commands, expected outputs, troubleshooting
   - Success criteria and rollback procedures
   - ~5 minute read for quick understanding

2. **PRIORITY-1-DEPLOYMENT-PACKAGE.md**
   - Package overview and file inventory
   - Risk mitigation strategies
   - Integration with full 30-day roadmap
   - ~3 minute read for context

### Reference Documents (From Previous Audit)

- `HYDRA-IMPLEMENTATION-GUIDE.md` - Complete 30-day roadmap for all 5 priorities
- `HYDRA-SELF-AUDIT-RECOMMENDATIONS.md` - Detailed audit analysis
- `HYDRA-AUDIT-SUMMARY.md` - Executive summary
- `HYDRA-AUDIT-REPORT.json` - Structured audit data
- `HYDRA-AUDIT-INDEX.md` - Navigation guide for all audit documents

---

## 🚀 Quick Start (5 Steps, 35 minutes)

### Prerequisites

- ✅ Hydra decision engine running (port 5179)
- ✅ Python 3.7+ available
- ✅ PowerShell (Windows built-in)

### Step-by-Step Execution

```powershell
# Step 1: Profile all 15 heads (~15 min)
python hydra_profile_heads.py
# Output: hydra_profiles/head_profile_*.json

# Step 2: Calculate adaptive weights (~2 min)
python hydra_adaptive_weighting.py hydra_profiles/head_profile_*.json
# Output: hydra_weights_config.json

# Step 3: Deploy to Hydra (Manual - ~5 min via REST API)
# See PRIORITY-1-QUICKSTART.md Step 3 for exact REST commands

# Step 4: Monitor head health (~5 min continuous)
powershell -NoProfile -ExecutionPolicy Bypass -File hydra_head_health_monitor.ps1 -Continuous
# Watch for confidence values rising from 0.65 toward 0.70+

# Step 5: Validate improvement (~5 min)
powershell -NoProfile -ExecutionPolicy Bypass -File test_rebalancing.ps1
# Success: System confidence +2%, head confidence +2%
```

**Expected Timeline**:

- Deploy: 35 minutes
- Stabilize: 3-5 days
- Full validation: 30 days (per HYDRA-IMPLEMENTATION-GUIDE.md)

---

## 📊 Success Metrics

### Before Deployment

```
System Confidence:      78.7% ❌
Per-Head Confidence:    65%   ❌
Per-Head Uniformity:    High variance ❌
Average Latency:        87ms  ⚠️
Dashboard:              Offline ❌
```

### After Deployment (Expected)

```
System Confidence:      88%+  ✅
Per-Head Confidence:    80%+  ✅
Per-Head Uniformity:    <5% variance ✅
Average Latency:        <75ms ✅
Dashboard:              Ready (Priority 2) ✅
```

---

## 🔧 What Each Script Does

### profiling Framework (hydra_profile_heads.py)

- Runs 100 test decisions per head
- Measures: latency, confidence, error rates
- Generates statistical analysis
- Detects variance across heads
- Output is input for weighting calculator

### Adaptive Weighting (hydra_adaptive_weighting.py)

- Loads profiling results
- Calculates scores: accuracy(40%) + speed(30%) + confidence(30%)
- Generates probability distribution
- Creates deployment-ready config JSON
- Includes REST API deployment steps

### Health Monitoring (hydra_head_health_monitor.ps1)

- Queries all 15 heads every 60 seconds
- Logs confidence levels with timestamps
- Alerts if confidence drops below 0.70
- Runs in continuous mode for long-term tracking
- Critical for detecting post-deployment improvements

### Rebalancing Validation (test_rebalancing.ps1)

- Measures system confidence before/after
- Measures average head confidence before/after
- Calculates percentage improvements
- Pass/Fail based on 2% improvement threshold
- Confirms deployment was effective

### Dashboard Config Gen (hydra_dashboard_config_gen.py)

- Creates dashboard configuration
- Sets up metrics, thresholds, UI
- Generates deployment instructions
- Prepares Priority 2 for immediate rollout

---

## 🛠️ Customization Options

### Profiler Configuration (hydra_profile_heads.py)

```python
profiler.profile_all_heads(num_tests=100)  # Change to 50 for faster runs
```

### Health Monitor Configuration (hydra_head_health_monitor.ps1)

```powershell
# Single check with custom confidence threshold
.\hydra_head_health_monitor.ps1 -ConfidenceThreshold 0.75

# Continuous with custom intervals
.\hydra_head_health_monitor.ps1 -Continuous -CheckIntervalSeconds 120 -AlertThreshold 5
```

### Test Duration (test_rebalancing.ps1)

```powershell
# Run for 10 minutes instead of 5
.\test_rebalancing.ps1 -TestDurationMinutes 10 -SampleIntervalSeconds 60
```

### Dashboard Port (hydra_dashboard_config_gen.py)

```powershell
python hydra_dashboard_config_gen.py --port 5181  # Custom port
```

---

## 🚨 Troubleshooting

### "UNREACHABLE" errors in health monitor

**Cause**: Hydra decision engine not running
**Fix**: Check `netstat -an | Select-String "5179"` or restart Hydra

### Profile script times out

**Cause**: 100 tests taking too long
**Fix**: Reduce `num_tests` parameter or verify Hydra responsiveness

### Weights don't improve confidence

**Cause**: Configuration not actually deployed
**Fix**: Verify REST API calls succeeded and check current weights

### Test shows <2% improvement

**Cause**: May need more stabilization time
**Fix**: Run continuous monitoring for 24 hours, then retest

---

## 📈 Monitoring During Rollout

### Real-time Monitoring Logs

```powershell
# Watch head health in real-time
Get-Content "$env:TEMP\hydra_head_health_monitor.log" -Wait

# View latest profiling results
Get-Content "$env:TEMP\hydra_profiles\head_profile_*.json" | Select-Object -Last 50
```

### Check Hydra System Status

```powershell
# Query decision engine health
Invoke-RestMethod -Uri "http://localhost:5179/system/metrics" -Method Get | ConvertTo-Json

# Check individual head status
Invoke-RestMethod -Uri "http://localhost:5179/heads" -Method Get | ConvertTo-Json
```

---

## 📋 Pre-Deployment Checklist

- [ ] Hydra decision engine is running (`netstat -an | Select-String "5179"`)
- [ ] Python 3.7+ installed and accessible
- [ ] PowerShell available (Windows built-in)
- [ ] Write access to `C:\Users\Someone\AppData\Local\AnthropicClaude\`
- [ ] All 5 scripts in workspace:
  - [ ] hydra_profile_heads.py
  - [ ] hydra_adaptive_weighting.py
  - [ ] hydra_head_health_monitor.ps1
  - [ ] test_rebalancing.ps1
  - [ ] hydra_dashboard_config_gen.py
- [ ] Read PRIORITY-1-QUICKSTART.md for overview

---

## 🎯 Next Steps After Priority 1

Once head confidence reaches 0.80+:

1. **Priority 2: Dashboard Service** (5 minutes)

   - Run: `python hydra_dashboard_config_gen.py` (already prepared)
   - Access: http://localhost:5180
   - Purpose: Real-time observability

2. **Priority 3: Cache Expansion** (30 minutes)

   - Grow from 0.01 MB to 100-500 MB
   - Optimize hit rates
   - Scripts in HYDRA-IMPLEMENTATION-GUIDE.md

3. **Priority 4: Module Interface** (1-2 weeks)

   - Formal ABC definition
   - Dynamic module loading
   - Full details in HYDRA-IMPLEMENTATION-GUIDE.md

4. **Priority 5: Startup Optimization** (1-2 weeks)
   - Profile initialization
   - Reduce boot time
   - Details in HYDRA-IMPLEMENTATION-GUIDE.md

---

## 📞 Support & Escalation

**If deployment fails**:

1. Check logs: `Get-ChildItem $env:TEMP\hydra*.log | ForEach-Object { Get-Content $_ -Tail 50 }`
2. Verify prerequisites in pre-deployment checklist
3. Review troubleshooting section above
4. Check HYDRA-SELF-AUDIT-RECOMMENDATIONS.md for context
5. Consult HYDRA-IMPLEMENTATION-GUIDE.md for detailed architecture

**If confidence doesn't improve after 5 days**:

- Run profiler again: `python hydra_profile_heads.py`
- Check for system-wide issues
- Review decision engine logs
- Consider Priority 2 (Dashboard) for better observability

---

## 📝 Deployment Log Template

Use this to track deployment progress:

```markdown
# Priority 1 Deployment Log

**Start Time**: [timestamp]
**Deployer**: [name]

## Step 1: Profiling

- Start: [time]
- Status: [IN_PROGRESS/COMPLETE]
- Issues: [none]

## Step 2: Weight Calculation

- Start: [time]
- Status: [IN_PROGRESS/COMPLETE]
- Issues: [none]

## Step 3: Configuration Deployment

- Start: [time]
- Status: [IN_PROGRESS/COMPLETE]
- Issues: [none]

## Step 4: Health Monitoring (5+ min)

- Start: [time]
- Status: [IN_PROGRESS/COMPLETE]
- Observations: [confidence trends]

## Step 5: Validation Test

- Start: [time]
- Status: [PASS/FAIL]
- Results: [system improvement %, head improvement %]

**End Time**: [timestamp]
**Total Duration**: [XX minutes]
**Status**: [SUCCESS/ROLLBACK/PARTIAL]
```

---

## 🎓 Learning Path

**For first-time users**:

1. Read PRIORITY-1-QUICKSTART.md (5 min)
2. Run profiler and observe output (20 min)
3. Review hydra_weights_config.json output (5 min)
4. Run health monitor for 10 minutes (10 min)
5. Run validation test (5 min)

**For deep understanding**:

1. Review HYDRA-SELF-AUDIT-RECOMMENDATIONS.md
2. Study HYDRA-IMPLEMENTATION-GUIDE.md
3. Examine script code comments
4. Review HYDRA-AUDIT-REPORT.json for data

---

## 📦 Package Manifest

| File                             | Type      | Size   | Purpose            |
| -------------------------------- | --------- | ------ | ------------------ |
| hydra_profile_heads.py           | Script    | ~6 KB  | Head profiling     |
| hydra_adaptive_weighting.py      | Script    | ~8 KB  | Weight calculation |
| hydra_head_health_monitor.ps1    | Script    | ~5 KB  | Monitoring         |
| test_rebalancing.ps1             | Script    | ~4 KB  | Validation         |
| hydra_dashboard_config_gen.py    | Script    | ~7 KB  | Dashboard prep     |
| PRIORITY-1-QUICKSTART.md         | Guide     | ~15 KB | Deployment steps   |
| PRIORITY-1-DEPLOYMENT-PACKAGE.md | Guide     | ~12 KB | Package context    |
| PRIORITY-1-INDEX.md              | This file | ~8 KB  | Navigation         |

**Total Package**: ~65 KB (mostly documentation)

---

**Generated**: 2024-01-15
**Status**: ✅ Ready for Immediate Deployment
**Confidence Level**: High (88.2% per audit)
**Expected Outcome**: System confidence 78.7% → 88%+ within 5 days
**Risk Level**: Low (full rollback procedures included)

---

## 🎉 You're Ready to Deploy!

Start with **PRIORITY-1-QUICKSTART.md** for step-by-step instructions.

Questions? Check the **Troubleshooting** section above or review **HYDRA-IMPLEMENTATION-GUIDE.md** for full context.
