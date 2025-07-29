# PM+ Agent Registry Configuration Tool - Compilable PowerShell Version
# Copyright (c) 2024-2025 Mitel Networks Corporation - Proprietary Software
# Authorized for use by Mitel personnel and designated partners only
# Can be compiled to EXE using ps2exe or similar tools

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

# Configuration constants
$PATCH_KEY = "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\AdventNet\DesktopCentral\DCAgent\Patch"
$AGENT_KEY = "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\AdventNet\DesktopCentral\DCAgent"
$PATCH_TIMEOUT_VALUE = "Patch_scan_timeout"
$CPU_USAGE_VALUE = "THRDMAXCPUUSAGE_2C"

$PERFORMANCE_SETTINGS = @{
    "low" = @{
        "cpu" = 15
        "timeout" = 200
        "description" = "Low Performance Mode (15% CPU, 200s timeout)"
    }
    "high" = @{
        "cpu" = 30
        "timeout" = 200
        "description" = "High Performance Mode (30% CPU, 200s timeout)"
    }
}

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] [$Level] $Message"
}

function Write-Verbose-Log {
    param([string]$Message)
    if ($Verbose) {
        Write-Log $Message "VERBOSE"
    }
}

function Show-Help {
    Write-Host @"
PM+ Agent Registry Configuration Tool for Windows

DESCRIPTION:
    Configures DesktopCentral DCAgent registry settings with performance options.
    Standalone executable - no dependencies required.

USAGE:
    pm-agent-config.exe [OPTIONS]

PARAMETERS:
    -Mode <low|high>    Agent Resource Utilization Limit
                        low  = 15% CPU usage, 200s timeout
                        high = 30% CPU usage, 200s timeout
    
    -Status             Display current registry settings
    -Verbose            Enable verbose output
    -Help               Show this help message

EXAMPLES:
    pm-agent-config.exe -Mode high       # Configure for high performance
    pm-agent-config.exe -Mode low        # Configure for low performance
    pm-agent-config.exe -Status          # Show current settings

REQUIREMENTS:
    - Administrator privileges
    - DesktopCentral DCAgent installed

REGISTRY KEYS MODIFIED:
    $PATCH_KEY
    └── $PATCH_TIMEOUT_VALUE (DWORD)
    
    $AGENT_KEY
    └── $CPU_USAGE_VALUE (DWORD)
"@
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Set-RegistryValue {
    param(
        [string]$KeyPath,
        [string]$ValueName,
        [int]$ValueData
    )
    
    try {
        Write-Verbose-Log "Setting registry value: $KeyPath\$ValueName = $ValueData"
        
        # Convert HKEY_LOCAL_MACHINE format to PowerShell format
        $psKeyPath = $KeyPath -replace "HKEY_LOCAL_MACHINE", "HKLM:"
        
        # Ensure the key exists
        if (-not (Test-Path $psKeyPath)) {
            Write-Verbose-Log "Creating registry key: $psKeyPath"
            New-Item -Path $psKeyPath -Force | Out-Null
        }
        
        # Set the value
        Set-ItemProperty -Path $psKeyPath -Name $ValueName -Value $ValueData -Type DWord
        Write-Log "✓ Successfully set $ValueName = $ValueData"
        return $true
    }
    catch {
        Write-Log "✗ Failed to set $ValueName`: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

function Get-CurrentSettings {
    $settings = @{}
    
    try {
        $patchKey = "HKLM:\SOFTWARE\WOW6432Node\AdventNet\DesktopCentral\DCAgent\Patch"
        if (Test-Path $patchKey) {
            $timeout = Get-ItemProperty -Path $patchKey -Name $PATCH_TIMEOUT_VALUE -ErrorAction SilentlyContinue
            if ($timeout) {
                $settings[$PATCH_TIMEOUT_VALUE] = $timeout.$PATCH_TIMEOUT_VALUE
            }
        }
    }
    catch {
        $settings[$PATCH_TIMEOUT_VALUE] = "Error: $($_.Exception.Message)"
    }
    
    try {
        $agentKey = "HKLM:\SOFTWARE\WOW6432Node\AdventNet\DesktopCentral\DCAgent"
        if (Test-Path $agentKey) {
            $cpuUsage = Get-ItemProperty -Path $agentKey -Name $CPU_USAGE_VALUE -ErrorAction SilentlyContinue
            if ($cpuUsage) {
                $settings[$CPU_USAGE_VALUE] = $cpuUsage.$CPU_USAGE_VALUE
            }
        }
    }
    catch {
        $settings[$CPU_USAGE_VALUE] = "Error: $($_.Exception.Message)"
    }
    
    return $settings
}

function Show-CurrentSettings {
    Write-Host ""
    Write-Host "Current PM+ Agent Registry Settings:" -ForegroundColor Cyan
    Write-Host "===================================" -ForegroundColor Cyan
    Write-Host ""
    
    $settings = Get-CurrentSettings
    
    $timeout = if ($settings.ContainsKey($PATCH_TIMEOUT_VALUE)) { 
        "$($settings[$PATCH_TIMEOUT_VALUE]) seconds" 
    } else { 
        "Not set" 
    }
    
    $cpuUsage = if ($settings.ContainsKey($CPU_USAGE_VALUE)) { 
        "$($settings[$CPU_USAGE_VALUE])%" 
    } else { 
        "Not set" 
    }
    
    Write-Host "Patch Scan Timeout: $timeout"
    Write-Host "Thread Max CPU Usage: $cpuUsage"
    
    # Determine performance mode
    if ($settings.ContainsKey($CPU_USAGE_VALUE)) {
        $cpu = $settings[$CPU_USAGE_VALUE]
        if ($cpu -eq 15) {
            Write-Host "Current Performance Mode: LOW (15% CPU)" -ForegroundColor Green
        }
        elseif ($cpu -eq 30) {
            Write-Host "Current Performance Mode: HIGH (30% CPU)" -ForegroundColor Yellow
        }
        else {
            Write-Host "Current Performance Mode: CUSTOM ($cpu% CPU)" -ForegroundColor Magenta
        }
    }
    else {
        Write-Host "Current Performance Mode: UNKNOWN" -ForegroundColor Red
    }
    
    Write-Host ""
}

function Set-PerformanceMode {
    param([string]$PerformanceMode)
    
    $config = $PERFORMANCE_SETTINGS[$PerformanceMode]
    
    Write-Host ""
    Write-Host "Configuring PM+ Agent for $($config.description)..." -ForegroundColor Yellow
    Write-Host "Agent Resource Utilization Limit: $PerformanceMode performance"
    Write-Host "CPU Usage Limit: $($config.cpu)%"
    Write-Host "Patch Scan Timeout: $($config.timeout) seconds"
    Write-Host ""
    
    $successCount = 0
    $totalSettings = 2
    
    # Set patch scan timeout
    if (Set-RegistryValue -KeyPath $PATCH_KEY -ValueName $PATCH_TIMEOUT_VALUE -ValueData $config.timeout) {
        $successCount++
    }
    
    # Set CPU usage limit
    if (Set-RegistryValue -KeyPath $AGENT_KEY -ValueName $CPU_USAGE_VALUE -ValueData $config.cpu) {
        $successCount++
    }
    
    Write-Host ""
    
    if ($successCount -eq $totalSettings) {
        Write-Host "═══════════════════════════════════════" -ForegroundColor Green
        Write-Host "✓ Configuration applied successfully!" -ForegroundColor Green
        Write-Host "═══════════════════════════════════════" -ForegroundColor Green
        Write-Host ""
        Write-Host "IMPORTANT: You may need to restart the DCAgent service" -ForegroundColor Yellow
        Write-Host "for changes to take effect:" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "  Restart-Service 'DCAgent' -Force" -ForegroundColor Cyan
        Write-Host ""
        return $true
    }
    else {
        Write-Host "═══════════════════════════════════════" -ForegroundColor Red
        Write-Host "✗ Configuration partially failed" -ForegroundColor Red
        Write-Host "═══════════════════════════════════════" -ForegroundColor Red
        Write-Host ""
        Write-Host "Applied $successCount of $totalSettings settings successfully." -ForegroundColor Yellow
        Write-Host "Please check the error messages above." -ForegroundColor Yellow
        return $false
    }
}

# Main execution logic
try {
    Write-Host ""
    Write-Host "PM+ Agent Registry Configuration Tool" -ForegroundColor Cyan
    Write-Host "=====================================" -ForegroundColor Cyan
    
    # Show help if requested
    if ($Help -or (-not $Mode -and -not $Status)) {
        Show-Help
        exit 0
    }
    
    # Check administrator privileges
    if (-not (Test-Administrator)) {
        Write-Host ""
        Write-Host "ERROR: Administrator privileges required" -ForegroundColor Red
        Write-Host ""
        Write-Host "This tool modifies Windows Registry settings and requires" -ForegroundColor Yellow
        Write-Host "Administrator privileges to run." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Please run as Administrator and try again." -ForegroundColor Yellow
        exit 1
    }
    
    Write-Verbose-Log "Administrator privileges confirmed"
    
    # Show current settings
    if ($Status) {
        Show-CurrentSettings
        exit 0
    }
    
    # Configure performance mode
    if ($Mode) {
        if (Set-PerformanceMode -PerformanceMode $Mode) {
            exit 0
        } else {
            exit 1
        }
    }
}
catch {
    Write-Host ""
    Write-Host "FATAL ERROR: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
