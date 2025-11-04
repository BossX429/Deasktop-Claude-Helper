# Claude Health Monitor & Auto-Repair System
# Prevents/fixes Squirrel updater deadlock and runaway processes
# Runs every 5 minutes via Task Scheduler

param(
    [int]$CPUThreshold = 500,      # Trigger cleanup if Claude exceeds 500% CPU
    [int]$MaxRetries = 3,
    [int]$RetryDelaySeconds = 10
)

$DebugLog = "$env:TEMP\Claude-Monitor-$(Get-Date -Format 'yyyyMMdd').log"
$LockFilePattern = "$env:TEMP\.squirrel-lock-*"
$ClaudeProcessName = "claude"
$UpdaterProcessName = "Update"

function Log-Message {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    
    # Color-coded output
    switch ($Level) {
        "INFO"     { Write-Host $logEntry -ForegroundColor Green }
        "WARN"     { Write-Host $logEntry -ForegroundColor Yellow }
        "ERROR"    { Write-Host $logEntry -ForegroundColor Red }
        "CRITICAL" { Write-Host $logEntry -ForegroundColor Red -BackgroundColor Black }
        default    { Write-Host $logEntry }
    }
    
    Add-Content -Path $DebugLog -Value $logEntry -ErrorAction SilentlyContinue
}

function Test-SquirrelDeadlock {
    $lockFiles = @(Get-ChildItem -Path $env:TEMP -Filter ".squirrel-lock-*" -ErrorAction SilentlyContinue)
    if ($lockFiles.Count -gt 0) {
        Log-Message "Detected stuck Squirrel lock files: $($lockFiles.Count) found" "WARN"
        return $true
    }
    return $false
}

function Test-ClaudeCPUSpike {
    $claudeProcesses = @(Get-Process -Name $ClaudeProcessName -ErrorAction SilentlyContinue)
    if ($claudeProcesses.Count -eq 0) {
        return $false
    }
    
    $totalCPU = ($claudeProcesses | Measure-Object -Property CPU -Sum).Sum
    if ($totalCPU -gt $CPUThreshold) {
        Log-Message "CRITICAL: Claude CPU spike detected: $([math]::Round($totalCPU, 2))% (threshold: $CPUThreshold%)" "ERROR"
        return $true
    }
    return $false
}

function Test-RunawayUpdater {
    $updaters = @(Get-Process -Name $UpdaterProcessName -ErrorAction SilentlyContinue)
    if ($updaters.Count -eq 0) {
        return $false
    }
    
    $highCPUUpdaters = $updaters | Where-Object { $_.CPU -gt 100 }
    if ($highCPUUpdaters.Count -gt 0) {
        Log-Message "Detected runaway updater processes: $($highCPUUpdaters.Count) with high CPU" "WARN"
        return $true
    }
    return $false
}

function Repair-SquirrelDeadlock {
    Log-Message "Attempting to repair Squirrel deadlock..." "INFO"
    
    try {
        # Remove stuck lock files
        Remove-Item -Path $LockFilePattern -Force -ErrorAction SilentlyContinue
        Log-Message "Cleaned up Squirrel lock files" "INFO"
        
        # Kill stuck updater processes
        Stop-Process -Name $UpdaterProcessName -Force -ErrorAction SilentlyContinue
        Log-Message "Stopped stuck updater processes" "INFO"
        
        return $true
    }
    catch {
        Log-Message "Failed to repair deadlock: $_" "ERROR"
        return $false
    }
}

function Repair-RunawayProcess {
    param([string]$ProcessName)
    
    Log-Message "Attempting to repair runaway $ProcessName process..." "INFO"
    
    try {
        Stop-Process -Name $ProcessName -Force -ErrorAction SilentlyContinue
        Log-Message "Killed runaway $ProcessName" "INFO"
        
        if ($ProcessName -eq "explorer") {
            Start-Sleep -Seconds 1
            Start-Process explorer.exe
            Log-Message "Restarted explorer" "INFO"
        }
        
        return $true
    }
    catch {
        Log-Message "Failed to repair $ProcessName : $_" "ERROR"
        return $false
    }
}

function Get-SystemHealth {
    $claudeProcesses = @(Get-Process -Name $ClaudeProcessName -ErrorAction SilentlyContinue)
    $totalCPU = if ($claudeProcesses.Count -gt 0) { ($claudeProcesses | Measure-Object -Property CPU -Sum).Sum } else { 0 }
    $ram = Get-CimInstance Win32_OperatingSystem
    $freeMemPercent = [math]::Round($ram.FreePhysicalMemory / $ram.TotalVisibleMemorySize * 100, 1)
    
    return @{
        ClaudeRunning = $claudeProcesses.Count -gt 0
        ClaudeCPU = [math]::Round($totalCPU, 2)
        FreeMemoryPercent = $freeMemPercent
        SquirrelDeadlocked = Test-SquirrelDeadlock
        RunawayUpdater = Test-RunawayUpdater
    }
}

# ============ MAIN LOGIC ============

Log-Message "=== Claude Health Monitor Started ===" "INFO"

$health = Get-SystemHealth

# Report status
Log-Message "Status: Claude=$($health.ClaudeRunning), CPU=$($health.ClaudeCPU)%, Memory=$($health.FreeMemoryPercent)% free" "INFO"

# Check for deadlock condition
if ($health.SquirrelDeadlocked) {
    Log-Message "DEADLOCK DETECTED: Initiating repair..." "CRITICAL"
    $repaired = Repair-SquirrelDeadlock
    if ($repaired) {
        Log-Message "Deadlock repaired successfully" "INFO"
    }
}

# Check for CPU spike
if ($health.ClaudeCPU -gt $CPUThreshold) {
    Log-Message "CPU SPIKE DETECTED: Initiating recovery..." "CRITICAL"
    
    # Try to repair updater first
    if ($health.RunawayUpdater) {
        Repair-RunawayProcess -ProcessName $UpdaterProcessName
    }
    
    # Check for other runaway processes
    $runawayProcesses = @("msedge", "explorer", "ctfmon") | ForEach-Object {
        $proc = Get-Process -Name $_ -ErrorAction SilentlyContinue
        if ($proc -and ($proc | Measure-Object -Property CPU -Sum).Sum -gt 100) {
            $_
        }
    }
    
    foreach ($proc in $runawayProcesses) {
        Repair-RunawayProcess -ProcessName $proc
    }
    
    Log-Message "Recovery actions completed" "INFO"
}

# Final health check
$finalHealth = Get-SystemHealth
Log-Message "Final Status: Claude=$($finalHealth.ClaudeRunning), CPU=$($finalHealth.ClaudeCPU)%, Memory=$($finalHealth.FreeMemoryPercent)% free" "INFO"

Log-Message "=== Monitor Cycle Complete ===" "INFO"
