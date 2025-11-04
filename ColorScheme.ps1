# PowerShell Color Scheme Configuration
# Green = Good/Success, Yellow = Caution/Warning, Red = Bad/Error

# Define color functions
function Write-Good {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Green
}

function Write-Caution {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Yellow
}

function Write-Bad {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Red
}

# Alias shortcuts
New-Alias -Name "✓" -Value Write-Good -Force
New-Alias -Name "⚠" -Value Write-Caution -Force
New-Alias -Name "✗" -Value Write-Bad -Force

# Example usage:
# ✓ "Operation completed successfully"
# ⚠ "Warning: This action requires attention"
# ✗ "Error: Operation failed"

# Export functions for use in other scripts
Export-ModuleMember -Function Write-Good, Write-Caution, Write-Bad -Alias *, ⚠, ✗
