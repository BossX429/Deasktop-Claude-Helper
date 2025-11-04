# Priority 1: Consensus Head Rebalancing - Real-time Health Monitor
# Monitors all 15 Hydra consensus heads for confidence degradation
# Logs to $env:TEMP\hydra_head_health_monitor.log

param(
    [int]$CheckIntervalSeconds = 60,
    [double]$ConfidenceThreshold = 0.70,
    [int]$AlertThreshold = 3,
    [switch]$Continuous = $false
)

$script:LogFile = "$env:TEMP\hydra_head_health_monitor.log"
$script:AlertCount = @{}
$script:HeadStates = @{}

function Log-Message {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    Add-Content -Path $script:LogFile -Value $logEntry -ErrorAction SilentlyContinue
    Write-Host $logEntry
}

function Get-HeadConfidence {
    param([string]$HeadName)
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:5179/heads/$HeadName/metrics" `
            -Method Get -ErrorAction SilentlyContinue -TimeoutSec 5
        return $response.confidence
    }
    catch {
        Log-Message "Failed to query $HeadName confidence" "WARN"
        return $null
    }
}

function Check-AllHeads {
    $heads = @(
        "COORDINATOR", "ANALYST", "EXECUTOR", "GUARDIAN", "ARCHITECT",
        "MEDIATOR", "SENTINEL", "SYNTHESIZER", "NAVIGATOR", "RESEARCHER",
        "COMMUNICATOR", "CATALYST", "INNOVATOR", "ORACLE", "STRATEGIST"
    )

    Log-Message "=" * 70 "INFO"
    Log-Message "Checking head health..." "INFO"

    $degradedHeads = @()
    $healthyHeads = @()

    foreach ($head in $heads) {
        $confidence = Get-HeadConfidence -HeadName $head

        if ($null -eq $confidence) {
            Log-Message "$head: UNREACHABLE" "ERROR"
            $script:AlertCount[$head] = ($script:AlertCount[$head] -or 0) + 1
            $degradedHeads += $head
        }
        elseif ($confidence -lt $ConfidenceThreshold) {
            Log-Message "$head: DEGRADED (confidence=$confidence, threshold=$ConfidenceThreshold)" "WARN"
            $script:AlertCount[$head] = ($script:AlertCount[$head] -or 0) + 1
            $degradedHeads += $head

            if ($script:AlertCount[$head] -ge $AlertThreshold) {
                Log-Message "ALERT: $head has been degraded for $AlertThreshold checks - IMMEDIATE INTERVENTION REQUIRED" "ALERT"
            }
        }
        else {
            Log-Message "$head: OK (confidence=$confidence)" "INFO"
            $script:AlertCount[$head] = 0
            $healthyHeads += $head
        }

        $script:HeadStates[$head] = $confidence
    }

    # Summary
    $summary = "Health Check: $($healthyHeads.Count) healthy, $($degradedHeads.Count) degraded"
    Log-Message $summary "INFO"

    if ($degradedHeads.Count -gt 0) {
        Log-Message "Degraded heads: $($degradedHeads -join ', ')" "WARN"
    }

    return @{
        Timestamp = Get-Date
        HealthyCount = $healthyHeads.Count
        DegradedCount = $degradedHeads.Count
        DegradedHeads = $degradedHeads
        States = $script:HeadStates.Clone()
    }
}

function Start-Monitor {
    Log-Message "Starting Hydra Head Health Monitor" "INFO"
    Log-Message "Configuration:" "INFO"
    Log-Message "  Check Interval: ${CheckIntervalSeconds}s" "INFO"
    Log-Message "  Confidence Threshold: $ConfidenceThreshold" "INFO"
    Log-Message "  Alert Threshold: $AlertThreshold checks" "INFO"
    Log-Message "  Continuous Mode: $Continuous" "INFO"

    if (-not $Continuous) {
        Log-Message "Running single health check..." "INFO"
        $result = Check-AllHeads

        if ($result.DegradedCount -gt 0) {
            Log-Message "ACTION REQUIRED: Run Priority 1 implementation to rebalance heads" "WARN"
        }
        exit 0
    }

    Log-Message "Entering continuous monitoring mode (Ctrl+C to exit)" "INFO"

    $checkCount = 0
    while ($true) {
        $checkCount++
        Log-Message "Check #$checkCount" "INFO"

        $result = Check-AllHeads

        if ($result.DegradedCount -gt 5) {
            Log-Message "CRITICAL: More than half of heads degraded!" "ALERT"
        }

        Start-Sleep -Seconds $CheckIntervalSeconds
    }
}

# Initialize log file
if (-not (Test-Path $script:LogFile)) {
    New-Item -Path $script:LogFile -ItemType File -Force | Out-Null
}

Log-Message "=" * 70 "INFO"
Log-Message "Hydra Head Health Monitor initialized" "INFO"

# Run monitor
Start-Monitor
