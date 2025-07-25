# PM Agent Registry Configuration Tool
# PowerShell wrapper for the Python registry configuration tool

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("low", "high")]
    [string]$Mode,
    
    [Parameter(Mandatory=$false)]
    [switch]$Status,
    
    [Parameter(Mandatory=$false)]
    [switch]$Verbose,
    
    [Parameter(Mandatory=$false)]
    [switch]$Help
)

function Show-Help {
    Write-Host @"
PM Agent Registry Configuration Tool for Windows

DESCRIPTION:
    Configures DesktopCentral DCAgent registry settings with performance options.

USAGE:
    .\configure-agent.ps1 -Mode <low|high>      # Configure performance mode
    .\configure-agent.ps1 -Status               # Show current settings
    .\configure-agent.ps1 -Help                 # Show this help

PARAMETERS:
    -Mode <low|high>    Agent Resource Utilization Limit
                        low  = 15% CPU usage, 200s timeout
                        high = 30% CPU usage, 200s timeout
    
    -Status             Display current registry settings
    -Verbose            Enable verbose output
    -Help               Show this help message

EXAMPLES:
    # Configure for high performance
    .\configure-agent.ps1 -Mode high
    
    # Configure for low performance  
    .\configure-agent.ps1 -Mode low
    
    # Check current settings
    .\configure-agent.ps1 -Status

REQUIREMENTS:
    - Administrator privileges
    - Python 3.6+ installed
    - DesktopCentral DCAgent installed

REGISTRY KEYS MODIFIED:
    HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\AdventNet\DesktopCentral\DCAgent\Patch
    └── Patch_scan_timeout (DWORD)
    
    HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\AdventNet\DesktopCentral\DCAgent  
    └── THRDMAXCPUUSAGE_2C (DWORD)
"@
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-PythonInstalled {
    try {
        $pythonVersion = python --version 2>$null
        if ($pythonVersion) {
            Write-Host "✓ Python detected: $pythonVersion" -ForegroundColor Green
            return $true
        }
    }
    catch {
        Write-Host "✗ Python not found. Please install Python 3.6+ and add it to PATH." -ForegroundColor Red
        return $false
    }
    return $false
}

# Show help if requested or no parameters
if ($Help -or (-not $Mode -and -not $Status)) {
    Show-Help
    exit 0
}

# Check if running as Administrator
if (-not (Test-Administrator)) {
    Write-Host "⚠️  This script requires Administrator privileges." -ForegroundColor Yellow
    Write-Host "Please run PowerShell as Administrator and try again." -ForegroundColor Yellow
    exit 1
}

# Check if Python is installed
if (-not (Test-PythonInstalled)) {
    exit 1
}

# Get the script directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$pythonScript = Join-Path $scriptDir "..\src\windows\registry_config.py"

# Check if Python script exists
if (-not (Test-Path $pythonScript)) {
    Write-Host "✗ Registry configuration script not found: $pythonScript" -ForegroundColor Red
    exit 1
}

# Build Python command arguments
$pythonArgs = @()

if ($Mode) {
    $pythonArgs += "--mode", $Mode
}

if ($Status) {
    $pythonArgs += "--status"
}

if ($Verbose) {
    $pythonArgs += "--verbose"
}

# Execute the Python script
try {
    Write-Host "PM Agent Registry Configuration Tool" -ForegroundColor Cyan
    Write-Host "=====================================" -ForegroundColor Cyan
    Write-Host ""
    
    if ($Mode) {
        Write-Host "Configuring PM Agent for $Mode performance mode..." -ForegroundColor Yellow
        Write-Host ""
    }
    
    # Run the Python script
    & python $pythonScript @pythonArgs
    $exitCode = $LASTEXITCODE
    
    if ($exitCode -eq 0) {
        Write-Host ""
        Write-Host "Operation completed successfully!" -ForegroundColor Green
        
        if ($Mode) {
            Write-Host ""
            Write-Host "IMPORTANT: You may need to restart the DCAgent service for changes to take effect:" -ForegroundColor Yellow
            Write-Host "  Restart-Service 'DCAgent' -Force" -ForegroundColor Cyan
        }
    } else {
        Write-Host ""
        Write-Host "Operation failed with exit code: $exitCode" -ForegroundColor Red
    }
    
    exit $exitCode
}
catch {
    Write-Host "✗ Failed to execute Python script: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
