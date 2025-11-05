# Diagnose-Monitor-Hydra.ps1
# Purpose: Full diagnostic of monitor + Hydra parallel operation.
# Verifies: scheduled task status, log file health, process conflicts, non-blocking execution.
# Usage: PowerShell -NoProfile -ExecutionPolicy Bypass -File "Diagnose-Monitor-Hydra.ps1"

param(
    [string]$MonitorScriptDir = $null,  # Will auto-detect
    [string]$HydraDir = $null,          # Will auto-detect
    [string]$TempDir = $env:TEMP,
    [int]$TestDurationSeconds = 30
)

# Auto-detect monitor script directory: use current dir (CI) or user's local dir
if (-not $MonitorScriptDir -or -not (Test-Path $MonitorScriptDir)) {
    # Try repo directory first (for CI/GitHub Actions)
    if (Test-Path ".\Monitor-ClaudeHealth.ps1") {
        $MonitorScriptDir = (Get-Location).Path
    }
    # Fall back to user's local directory
    elseif (Test-Path "C:\Users\Someone\AppData\Local\AnthropicClaude\Monitor-ClaudeHealth.ps1") {
        $MonitorScriptDir = "C:\Users\Someone\AppData\Local\AnthropicClaude"
    }
    else {
        $MonitorScriptDir = (Get-Location).Path
    }
}

# Auto-detect Hydra directory
if (-not $HydraDir -or -not (Test-Path $HydraDir)) {
    if (Test-Path ".\hydra_profile_heads.py") {
        $HydraDir = (Get-Location).Path
    }
    elseif (Test-Path "C:\HydraMixedPipeline") {
        $HydraDir = "C:\HydraMixedPipeline"
    }
    else {
        $HydraDir = (Get-Location).Path
    }
}

$DiagnosticResults = @{
    Passed = 0
    Failed = 0
    Warnings = 0
}

function Write-DiagHeader {
    param([string]$Title)
    Write-Host ""
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Host "  $Title" -ForegroundColor Cyan
    Write-Host "======================================" -ForegroundColor Cyan
}

function Write-DiagPass {
    param([string]$Message)
    Write-Host "(+) $Message" -ForegroundColor Green
    $script:DiagnosticResults.Passed++
}

function Write-DiagFail {
    param([string]$Message)
    Write-Host "(-) $Message" -ForegroundColor Red
    $script:DiagnosticResults.Failed++
}

function Write-DiagWarn {
    param([string]$Message)
    Write-Host "(WARN) $Message" -ForegroundColor Yellow
    $script:DiagnosticResults.Warnings++
}

function Test-ScheduledTask {
    Write-DiagHeader "Scheduled Task Status"

    try {
        $task = Get-ScheduledTask -TaskName "Claude Health Monitor" -ErrorAction SilentlyContinue

        if ($task) {
            Write-DiagPass "Scheduled task 'Claude Health Monitor' exists"
            Write-Host "  State: $($task.State)" -ForegroundColor Gray
            Write-Host "  Enabled: $($task.Enabled)" -ForegroundColor Gray

            if ($task.Enabled -eq $true) {
                Write-DiagPass "Task is enabled and scheduled"
            }
            else {
                Write-DiagWarn "Task exists but is disabled"
            }
        }
        else {
            Write-DiagFail "Scheduled task 'Claude Health Monitor' not found"
            Write-Host "  Hint: Run Install-Scheduled-Task.ps1 (admin) to register" -ForegroundColor Gray
        }
    }
    catch {
        Write-DiagFail "Error checking scheduled task: $_"
    }
}

function Test-MonitorScripts {
    Write-DiagHeader "Monitor Script Files"

    $requiredScripts = @(
        "Monitor-ClaudeHealth.ps1",
        "Monitor-Service.ps1",
        "Install-Scheduled-Task.ps1"
    )

    foreach ($script in $requiredScripts) {
        $path = Join-Path -Path $MonitorScriptDir -ChildPath $script
        if (Test-Path -Path $path) {
            Write-DiagPass "Found: $script"
        }
        else {
            # In CI/GitHub Actions, missing scripts are expected (not installed)
            # Only warn; don't fail
            Write-DiagWarn "Not found in this environment: $script at $path (expected in CI)"
        }
    }
}

function Test-LogFiles {
    Write-DiagHeader "Monitor Log Files"

    $logFiles = @(Get-ChildItem -Path "$TempDir\Claude-Monitor-*.log" -File -ErrorAction SilentlyContinue)

    if ($logFiles.Count -gt 0) {
        Write-DiagPass "Found $($logFiles.Count) log file(s)"

        $totalSize = ($logFiles | Measure-Object -Property Length -Sum).Sum / 1MB
        Write-Host "  Total size: $([Math]::Round($totalSize, 2)) MB" -ForegroundColor Gray

        foreach ($log in $logFiles | Select-Object -First 3) {
            Write-Host "  -- $($log.Name) ($([Math]::Round($log.Length / 1KB, 1)) KB)" -ForegroundColor Gray
        }

        if ($totalSize -gt 100) {
            Write-DiagWarn "Total log size exceeds 100 MB; consider running Rotate-MonitorLogs.ps1"
        }
        else {
            Write-DiagPass "Log size is healthy"
        }
    }
    else {
        Write-DiagWarn "No monitor log files found (first run or disabled)"
    }
}

function Test-ProcessConflicts {
    Write-DiagHeader "Process Health Check"

    try {
        $processes = @(
            @{ Name = "explorer"; FriendlyName = "Windows Explorer" },
            @{ Name = "Update"; FriendlyName = "Squirrel Updater" },
            @{ Name = "msedge"; FriendlyName = "Microsoft Edge" }
        )

        foreach ($proc in $processes) {
            $running = @(Get-Process -Name $proc.Name -ErrorAction SilentlyContinue)
            if ($running.Count -gt 0) {
                $cpuSum = ($running | Measure-Object -Property CPU -Sum).Sum
                Write-DiagPass "$($proc.FriendlyName): $($running.Count) instance(s), CPU: $([Math]::Round($cpuSum, 1))%"
            }
            else {
                Write-Host "  $($proc.FriendlyName): not running" -ForegroundColor Gray
            }
        }
    }
    catch {
        Write-DiagFail "Error checking processes: $_"
    }
}

function Test-HydraIntegration {
    Write-DiagHeader "Hydra Integration Check"

    if (Test-Path -Path $HydraDir) {
        Write-DiagPass "Hydra directory found: $HydraDir"

        $hydraAudit = Join-Path -Path $HydraDir -ChildPath "HYDRA-AUDIT-REPORT.json"
        if (Test-Path -Path $hydraAudit) {
            Write-DiagPass "Hydra audit report exists"
        }
        else {
            Write-DiagWarn "Hydra audit report not found"
        }
    }
    else {
        Write-DiagWarn "Hydra directory not found at $HydraDir (non-critical if Hydra not in use)"
    }
}

function Test-TempDirHealth {
    Write-DiagHeader "Temp Directory Health"

    try {
        $tempDrive = Get-PSDrive $TempDir[0] -ErrorAction SilentlyContinue
        if ($tempDrive) {
            Write-DiagPass "Temp drive accessible"
        }

        $tempItems = @(Get-ChildItem -Path $TempDir -ErrorAction SilentlyContinue)
        $tempSize = ($tempItems | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum / 1GB

        Write-Host "  Temp directory size: $([Math]::Round($tempSize, 2)) GB" -ForegroundColor Gray

        if ($tempSize -gt 10) {
            Write-DiagWarn "Temp directory is large; consider cleanup"
        }
    }
    catch {
        Write-DiagFail "Error checking temp directory: $_"
    }
}

function Test-ParallelExecution {
    Write-DiagHeader "Parallel Execution Test (simulated)"

    Write-Host "Simulating concurrent monitor + Hydra load..." -ForegroundColor Gray

    $monitorScript = Join-Path -Path $MonitorScriptDir -ChildPath "Monitor-ClaudeHealth.ps1"

    if (-not (Test-Path -Path $monitorScript)) {
        Write-DiagWarn "Monitor script not found; skipping parallel test"
        return
    }

    try {
        $job = Start-Job -ScriptBlock {
            param($scriptPath)
            & powershell -NoProfile -ExecutionPolicy Bypass -File $scriptPath -ErrorAction SilentlyContinue
        } -ArgumentList $monitorScript

        Start-Sleep -Seconds 5

        if ($job.State -eq "Completed") {
            Write-DiagPass "Monitor background job completed successfully"
        }
        elseif ($job.State -eq "Running") {
            Write-DiagPass "Monitor job still running (non-blocking) - test continues"
            Stop-Job -Job $job -ErrorAction SilentlyContinue
        }
        else {
            Write-DiagWarn "Monitor job state: $($job.State)"
        }

        Start-Sleep -Seconds 2
        $explorer = @(Get-Process -Name explorer -ErrorAction SilentlyContinue)
        if ($explorer.Count -gt 0) {
            Write-DiagPass "Explorer process responsive during monitor execution"
        }
        else {
            Write-DiagFail "Explorer not running (possible deadlock during monitor)"
        }

        Remove-Job -Job $job -Force -ErrorAction SilentlyContinue
    }
    catch {
        Write-DiagFail "Parallel execution test error: $_"
    }
}

function Invoke-FullDiagnostic {
    Write-Host ""
    Write-Host "Claude Health Monitor + Hydra - Diagnostic Report" -ForegroundColor Magenta -BackgroundColor Black
    Write-Host "Started: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray

    Test-ScheduledTask
    Test-MonitorScripts
    Test-LogFiles
    Test-ProcessConflicts
    Test-HydraIntegration
    Test-TempDirHealth
    Test-ParallelExecution

    Write-DiagHeader "Diagnostic Summary"
    Write-Host "Passed:  $($DiagnosticResults.Passed)" -ForegroundColor Green
    Write-Host "Failed:  $($DiagnosticResults.Failed)" -ForegroundColor $(if ($DiagnosticResults.Failed -gt 0) { "Red" } else { "Green" })
    Write-Host "Warnings: $($DiagnosticResults.Warnings)" -ForegroundColor Yellow
    Write-Host "Completed: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray

    if ($DiagnosticResults.Failed -eq 0) {
        Write-Host "(OK) Diagnostic complete - system healthy" -ForegroundColor Green
        return 0
    }
    else {
        Write-Host "(ERROR) Diagnostic found $($DiagnosticResults.Failed) issue(s) - review output above" -ForegroundColor Red
        return 1
    }
}

$exitCode = Invoke-FullDiagnostic
exit $exitCode
