# Claude Health Monitor Startup Service (Alternative to Task Scheduler)
# This script runs automatically on startup and stays resident
# Place in Startup folder for automatic launch

$MonitorScript = "C:\Users\Someone\AppData\Local\AnthropicClaude\Monitor-ClaudeHealth.ps1"
$DebugLog = "$env:TEMP\Claude-Monitor-Service.log"
$CheckIntervalSeconds = 300  # 5 minutes

function Out-Monitor {
    param([string]$Msg)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$timestamp] $Msg"
    Write-Host $line
    Add-Content -Path $DebugLog -Value $line -ErrorAction SilentlyContinue
}

Out-Monitor "=== Claude Health Monitor Service Started ==="
Out-Monitor "Monitoring interval: Every $CheckIntervalSeconds seconds (5 minutes)"
Out-Monitor "Log file: $DebugLog"

# Main monitoring loop
$loopCount = 0
while ($true) {
    try {
        $loopCount++
        
        # Run the health check
        & $MonitorScript
        
        # Wait before next check
        Start-Sleep -Seconds $CheckIntervalSeconds
    }
    catch {
        Out-Monitor "ERROR in monitor loop: $_"
        Start-Sleep -Seconds $CheckIntervalSeconds
    }
}
