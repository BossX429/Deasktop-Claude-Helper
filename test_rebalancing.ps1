# Priority 1: Test & Validation - Rebalancing Effectiveness Checker
# Verifies that head rebalancing has improved system confidence

param(
    [int]$TestDurationMinutes = 5,
    [int]$SampleIntervalSeconds = 30
)

$script:LogFile = "$env:TEMP\hydra_rebalance_test.log"

function Write-Log {
    param([string]$Msg, [string]$Lvl = "INFO")
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $entry = "[$ts] [$Lvl] $Msg"
    Add-Content -Path $script:LogFile -Value $entry -ErrorAction SilentlyContinue
    Write-Host $entry
}

function Get-SystemConfidence {
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:5179/system/metrics" `
            -Method Get -ErrorAction SilentlyContinue -TimeoutSec 5
        return $response.confidence
    }
    catch {
        return $null
    }
}

function Get-AverageHeadConfidence {
    $heads = @(
        "COORDINATOR", "ANALYST", "EXECUTOR", "GUARDIAN", "ARCHITECT",
        "MEDIATOR", "SENTINEL", "SYNTHESIZER", "NAVIGATOR", "RESEARCHER",
        "COMMUNICATOR", "CATALYST", "INNOVATOR", "ORACLE", "STRATEGIST"
    )

    $confidences = @()
    foreach ($head in $heads) {
        try {
            $resp = Invoke-RestMethod -Uri "http://localhost:5179/heads/$head/metrics" `
                -Method Get -ErrorAction SilentlyContinue -TimeoutSec 5
            $confidences += $resp.confidence
        }
        catch { }
    }

    if ($confidences.Count -gt 0) {
        return ([array]$confidences | Measure-Object -Average).Average
    }
    return $null
}

function Test-Rebalancing {
    Write-Log "Starting rebalancing effectiveness test" "INFO"
    Write-Log "Test duration: $TestDurationMinutes minutes" "INFO"
    Write-Log "Sample interval: $SampleIntervalSeconds seconds" "INFO"
    Write-Log ("=" * 70) "INFO"

    $startTime = Get-Date
    $endTime = $startTime.AddMinutes($TestDurationMinutes)
    $samples = @()

    while ((Get-Date) -lt $endTime) {
        $systemConf = Get-SystemConfidence
        $avgHeadConf = Get-AverageHeadConfidence

        if ($null -ne $systemConf -and $null -ne $avgHeadConf) {
            $sample = @{
                Timestamp = Get-Date
                SystemConfidence = $systemConf
                AvgHeadConfidence = $avgHeadConf
            }
            $samples += $sample

            Write-Log "System Conf: $systemConf | Avg Head Conf: $avgHeadConf" "INFO"
        }
        else {
            Write-Log "Failed to retrieve metrics" "WARN"
        }

        Start-Sleep -Seconds $SampleIntervalSeconds
    }

    # Analyze results
    if ($samples.Count -gt 0) {
        $systemConfs = $samples | ForEach-Object { $_.SystemConfidence }
        $headConfs = $samples | ForEach-Object { $_.AvgHeadConfidence }

        $systemStart = $systemConfs[0]
        $systemEnd = $systemConfs[-1]
        $systemImprovement = $systemEnd - $systemStart

        $headStart = $headConfs[0]
        $headEnd = $headConfs[-1]
        $headImprovement = $headEnd - $headStart

        Write-Log ("=" * 70) "INFO"
        Write-Log "Test Results:" "INFO"
        Write-Log "  System Confidence: $systemStart -> $systemEnd (change: $($systemImprovement:+0.00;-0.00))" "INFO"
        Write-Log "  Avg Head Confidence: $headStart -> $headEnd (change: $($headImprovement:+0.00;-0.00))" "INFO"

        if ($systemImprovement -gt 0.02 -or $headImprovement -gt 0.02) {
            Write-Log "PASS: Significant confidence improvement detected" "OK"
        }
        else {
            Write-Log "WARN: Limited improvement - check rebalancing configuration" "WARN"
        }
    }
    else {
        Write-Log "ERROR: No metrics collected - verify Hydra service is running" "ERROR"
    }
}

# Initialize
if (-not (Test-Path $script:LogFile)) {
    New-Item -Path $script:LogFile -ItemType File -Force | Out-Null
}

# Run test
Test-Rebalancing
Write-Log "Test complete. Results in: $script:LogFile" "INFO"
