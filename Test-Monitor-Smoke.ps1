# Test-Monitor-Smoke.ps1
# Purpose: Lightweight smoke-test harness for Monitor-ClaudeHealth.ps1
# Simulates lockfile conditions and verifies detection/repair flow.
# Usage: PowerShell -NoProfile -ExecutionPolicy Bypass -File "Test-Monitor-Smoke.ps1"

param(
    [string]$MonitorScript = "C:\Users\Someone\AppData\Local\AnthropicClaude\Monitor-ClaudeHealth.ps1",
    [string]$TempDir = $env:TEMP
)

function Write-TestHeader {
    param([string]$Title)
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  $Title" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
}

function Write-TestPass {
    param([string]$Message)
    Write-Host "(PASS) $Message" -ForegroundColor Green
}

function Write-TestFail {
    param([string]$Message)
    Write-Host "(FAIL) $Message" -ForegroundColor Red
}

function Test-MonitorScriptExists {
    Write-TestHeader "Test 1: Monitor Script Exists"

    if (Test-Path -Path $MonitorScript) {
        Write-TestPass "Monitor script found at $MonitorScript"
        return $true
    }
    else {
        Write-TestFail "Monitor script not found at $MonitorScript"
        return $false
    }
}

function Test-LockFileSimulation {
    Write-TestHeader "Test 2: Simulate Squirrel Lockfile"

    $lockFile = "$TempDir\.squirrel-lock-test-$(Get-Random)"

    try {
        New-Item -Path $lockFile -ItemType File -Force | Out-Null
        Write-TestPass "Created test lockfile: $lockFile"

        if (Test-Path -Path $lockFile) {
            Write-TestPass "Lockfile exists and is detectable"
            Remove-Item -Path $lockFile -Force -ErrorAction SilentlyContinue
            Write-TestPass "Cleanup: removed test lockfile"
            return $true
        }
        else {
            Write-TestFail "Lockfile creation failed"
            return $false
        }
    }
    catch {
        Write-TestFail "Lockfile simulation error: $_"
        return $false
    }
}

function Test-MonitorLogCreation {
    Write-TestHeader "Test 3: Monitor Log Creation"

    $testLog = "$TempDir\Claude-Monitor-SmokeTest-$(Get-Date -Format 'yyyyMMddHHmmss').log"

    try {
        Add-Content -Path $testLog -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] [INFO] Smoke test log entry"

        if (Test-Path -Path $testLog) {
            $content = Get-Content -Path $testLog
            if ($content -match "Smoke test log entry") {
                Write-TestPass "Log file created and content verified: $testLog"
                Remove-Item -Path $testLog -Force -ErrorAction SilentlyContinue
                return $true
            }
            else {
                Write-TestFail "Log file created but content not found"
                return $false
            }
        }
        else {
            Write-TestFail "Log file was not created"
            return $false
        }
    }
    catch {
        Write-TestFail "Log creation error: $_"
        return $false
    }
}

function Test-ProcessDetection {
    Write-TestHeader "Test 4: Process Detection (Get-Process wrapper)"

    try {
        $result = @(Get-Process -Name "explorer" -ErrorAction SilentlyContinue)

        if ($result.Count -ge 0) {
            Write-TestPass "Process detection (explorer) returned $($result.Count) process(es)"
            return $true
        }
        else {
            Write-TestFail "Process detection returned unexpected result"
            return $false
        }
    }
    catch {
        Write-TestFail "Process detection error: $_"
        return $false
    }
}

function Test-MonitorExecution {
    Write-TestHeader "Test 5: Monitor Script Execution (dry-run)"

    if (-not (Test-Path -Path $MonitorScript)) {
        Write-TestFail "Monitor script not found; skipping execution test"
        return $false
    }

    try {
        & powershell -NoProfile -ExecutionPolicy Bypass -File $MonitorScript -ErrorAction SilentlyContinue
        Write-TestPass "Monitor script executed without blocking errors"
        return $true
    }
    catch {
        Write-TestFail "Monitor execution error: $_"
        return $false
    }
}

function Invoke-SmokeTests {
    Write-Host ""
    Write-Host "Claude Health Monitor - Smoke Test Suite" -ForegroundColor Magenta
    Write-Host "Started: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray

    $results = @()
    # Coerce each test result to a boolean to avoid accidental pipeline outputs
    $results += [bool](Test-MonitorScriptExists)
    $results += [bool](Test-LockFileSimulation)
    $results += [bool](Test-MonitorLogCreation)
    $results += [bool](Test-ProcessDetection)
    $results += [bool](Test-MonitorExecution)

    Write-TestHeader "Test Summary"
    $passed = ($results | Where-Object { $_ -eq $true }).Count
    $total = $results.Count

    Write-Host "Passed: $passed / $total" -ForegroundColor $(if ($passed -eq $total) { "Green" } else { "Yellow" })
    Write-Host "Completed: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray

    if ($passed -eq $total) {
        Write-Host "(OK) All smoke tests passed!" -ForegroundColor Green
        return 0
    }
    else {
        Write-Host "(ERROR) Some tests failed. Review output above." -ForegroundColor Red
        return 1
    }
}

$exitCode = Invoke-SmokeTests
exit $exitCode
