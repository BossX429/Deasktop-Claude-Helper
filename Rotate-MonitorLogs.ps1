# Rotate-MonitorLogs.ps1
# Purpose: Clean up old monitor logs to prevent %TEMP% bloat.
# Usage: Run manually or via scheduled task weekly.
# Config: Adjust $RetentionDays to keep logs older/younger than 7 days.

param(
    [int]$RetentionDays = 7,
    [string]$LogDir = $env:TEMP
)

function Log-Rotation {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$timestamp] [$Level] $Message"
    Add-Content -Path "$LogDir\Claude-Monitor-Rotation.log" -Value $line
    Write-Host $line
}

function Remove-OldLogs {
    <#
    .SYNOPSIS
    Remove monitor logs older than $RetentionDays.
    #>
    param([int]$Days = 7)

    $cutoffDate = (Get-Date).AddDays(-$Days)
    $monitorLogs = @(Get-ChildItem -Path "$LogDir\Claude-Monitor-*.log" -File -ErrorAction SilentlyContinue)

    if ($monitorLogs.Count -eq 0) {
        Log-Rotation "No old logs found." "INFO"
        return
    }

    $removed = 0
    foreach ($log in $monitorLogs) {
        if ($log.LastWriteTime -lt $cutoffDate) {
            try {
                Remove-Item -Path $log.FullName -Force -ErrorAction SilentlyContinue
                Log-Rotation "Removed old log: $($log.Name) (LastWrite: $($log.LastWriteTime))" "INFO"
                $removed++
            }
            catch {
                Log-Rotation "Failed to remove $($log.Name): $_" "WARN"
            }
        }
    }

    Log-Rotation "Rotation complete: removed $removed log(s)." "INFO"
}

# Main
try {
    Log-Rotation "=== Monitor Log Rotation Started ===" "INFO"
    Remove-OldLogs -Days $RetentionDays
    Log-Rotation "=== Monitor Log Rotation Completed ===" "INFO"
}
catch {
    Log-Rotation "Rotation error: $_" "ERROR"
    exit 1
}
