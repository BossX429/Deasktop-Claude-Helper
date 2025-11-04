# Install Claude Health Monitor as Scheduled Task
# Run this with admin privileges: powershell -NoProfile -ExecutionPolicy Bypass -File "Install-Scheduled-Task.ps1"

# Check if running as admin
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "✗ ERROR: This script must be run as Administrator" -ForegroundColor Red
    Write-Host "Right-click PowerShell and select 'Run as administrator'" -ForegroundColor Yellow
    exit 1
}

Write-Host "╔═════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  Installing Claude Health Monitor as Scheduled Task    ║" -ForegroundColor Cyan
Write-Host "╚═════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Define task parameters
$taskName = "Claude Health Monitor"
$taskPath = "\Claude\"
$scriptPath = "C:\Users\Someone\AppData\Local\AnthropicClaude\Monitor-Service.ps1"
$logPath = "$env:TEMP\Claude-Monitor-Service.log"

# Check if task already exists
$existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($existingTask) {
    Write-Host "✓ Existing task found, removing..." -ForegroundColor Yellow
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue
}

try {
    # Create trigger (every 5 minutes)
    $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 5) -RepetitionDuration (New-TimeSpan -Days 365*10)
    
    # Create action
    $action = New-ScheduledTaskAction -Execute "powershell.exe" `
        -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`" >> `"$logPath`" 2>&1"
    
    # Create settings
    $settings = New-ScheduledTaskSettingsSet -MultipleInstances IgnoreNew -StartWhenAvailable
    
    # Register task
    Register-ScheduledTask -TaskName $taskName `
        -TaskPath $taskPath `
        -Trigger $trigger `
        -Action $action `
        -Settings $settings `
        -RunLevel Highest `
        -ErrorAction Stop | Out-Null
    
    Write-Host "✓ Task created successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Task Details:" -ForegroundColor Cyan
    Write-Host "  Name: $taskName" -ForegroundColor White
    Write-Host "  Path: $taskPath" -ForegroundColor White
    Write-Host "  Interval: Every 5 minutes" -ForegroundColor White
    Write-Host "  Script: $scriptPath" -ForegroundColor White
    Write-Host "  Log: $logPath" -ForegroundColor White
    Write-Host ""
    
    # Start the task immediately
    Write-Host "Starting monitor..." -ForegroundColor Yellow
    Start-ScheduledTask -TaskName $taskName
    
    Write-Host "✓ Monitor is now running!" -ForegroundColor Green
    Write-Host ""
    Write-Host "The monitor will:" -ForegroundColor Cyan
    Write-Host "  • Run automatically every 5 minutes" -ForegroundColor Green
    Write-Host "  • Detect Squirrel updater deadlocks" -ForegroundColor Green
    Write-Host "  • Kill runaway processes" -ForegroundColor Green
    Write-Host "  • Log all actions to $logPath" -ForegroundColor Green
    Write-Host ""
    
} catch {
    Write-Host "✗ Installation failed: $_" -ForegroundColor Red
    exit 1
}

Write-Host "Installation complete!" -ForegroundColor Cyan
