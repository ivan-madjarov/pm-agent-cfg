# PM+ Agent Registry Configuration Tool - Compilable PowerShell Version
# Copyright (c) 2024-2025 Mitel Networks Corporation - Proprietary Software
# Authorized for use by Mitel personnel and designated partners only
# Can be compiled to EXE using ps2exe or similar tools

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("low", "medium", "high", "ultra", "unset")]
    [string]$Mode,
    
    [Parameter(Mandatory=$false)]
    [switch]$Status,

    [Parameter(Mandatory=$false)]
    [switch]$Export,
    
    [Alias("i")]
    [Parameter(Mandatory=$false)]
    [switch]$Menu,
    
    [Parameter(Mandatory=$false)]
    [switch]$VerboseOutput,
    
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
    "medium" = @{
        "cpu" = 20
        "timeout" = 200
        "description" = "Medium Performance Mode (20% CPU, 200s timeout)"
    }
    "high" = @{
        "cpu" = 30
        "timeout" = 200
        "description" = "High Performance Mode (30% CPU, 200s timeout)"
    }
    "ultra" = @{
        "cpu" = 40
        "timeout" = 200
        "description" = "Ultra Performance Mode (40% CPU, 200s timeout)"
    }
}

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] [$Level] $Message"
}

function Write-Verbose-Log {
    param([string]$Message)
    if ($VerboseOutput) {
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
    -Mode <low|medium|high|ultra|unset>   Agent Resource Utilization Limit
                        low    = 15% CPU usage, 200s timeout
                        medium = 20% CPU usage, 200s timeout
                        high   = 30% CPU usage, 200s timeout
                        ultra  = 40% CPU usage, 200s timeout
                        unset  = Remove configured limits (set to unlimited)
    
    -Status             Display current registry settings and service status
    -Export             Export DCAgent registry subtree to timestamped .reg file (current directory)
    -Menu               Show interactive menu
    (No arguments)      Launch interactive menu
    -VerboseOutput      Enable verbose output
    -Help               Show this help message

EXAMPLES:
    pm-agent-config.exe -Mode low         # Configure for low performance
    pm-agent-config.exe -Mode medium      # Configure for medium performance
    pm-agent-config.exe -Mode high        # Configure for high performance
    pm-agent-config.exe -Mode ultra       # Configure for ultra performance
    pm-agent-config.exe -Mode unset       # Remove configured limits (set to unlimited)
    pm-agent-config.exe -Status           # Show current settings
    pm-agent-config.exe -Menu             # Show interactive menu

REQUIREMENTS:
    - Administrator privileges
    - DesktopCentral DCAgent installed

REGISTRY KEYS MODIFIED:
    $PATCH_KEY
    +-- $PATCH_TIMEOUT_VALUE (DWORD)
    
    $AGENT_KEY
    +-- $CPU_USAGE_VALUE (DWORD)
"@
}

function Unset-PerformanceLimits {
    Write-Host "";
    Write-Host "Unsetting PM+ Agent performance limits (set to UNLIMITED)..." -ForegroundColor Yellow

    $successCount = 0
    $totalSettings = 2

    try {
        # Convert paths
        $patchPsKey = $PATCH_KEY -replace "HKEY_LOCAL_MACHINE", "HKLM:"
        $agentPsKey = $AGENT_KEY -replace "HKEY_LOCAL_MACHINE", "HKLM:"

        # Remove patch timeout if present
        if (Test-Path $patchPsKey) {
            try {
                Remove-ItemProperty -Path $patchPsKey -Name $PATCH_TIMEOUT_VALUE -ErrorAction Stop
                Write-Log "[OK] Removed $PATCH_TIMEOUT_VALUE from $patchPsKey"
                $successCount++
            }
            catch {
                Write-Verbose-Log "Patch timeout not present or removal failed: $($_.Exception.Message)"
            }
        }

        # Remove CPU usage value if present
        if (Test-Path $agentPsKey) {
            try {
                Remove-ItemProperty -Path $agentPsKey -Name $CPU_USAGE_VALUE -ErrorAction Stop
                Write-Log "[OK] Removed $CPU_USAGE_VALUE from $agentPsKey"
                $successCount++
            }
            catch {
                Write-Verbose-Log "CPU usage value not present or removal failed: $($_.Exception.Message)"
            }
        }

        if ($successCount -ge 1) {
            Write-Host "";
            Write-Host "========================================" -ForegroundColor Green
            Write-Host "[OK] Unset operation completed (at least one setting removed)." -ForegroundColor Green
            Write-Host "========================================" -ForegroundColor Green
            Write-Host ""

            try {
                $service = Get-Service -Name "ManageEngine UEMS - Agent" -ErrorAction Stop
                Write-Host "Current service status: $($service.Status)" -ForegroundColor Cyan
                Write-Host ""

                $choice = Read-Host "Restart PM+ Agent service now to apply 'unset' changes? (y/N)"
                if ($choice -match "^[Yy]") {
                    if (Restart-AgentService) { return $true } else { return $false }
                } else {
                    Write-Host ""
                    Write-Host "Service restart skipped. To apply changes, restart manually:" -ForegroundColor Yellow
                    Write-Host "  Stop-Service -Name 'ManageEngine UEMS - Agent' -Force" -ForegroundColor Cyan
                    Write-Host "  Start-Service -Name 'ManageEngine UEMS - Agent'" -ForegroundColor Cyan
                    return $true
                }
            }
            catch {
                Write-Host "WARNING: Service 'ManageEngine UEMS - Agent' not found or not accessible" -ForegroundColor Yellow
                Write-Host "Please restart the agent service manually" -ForegroundColor Yellow
                return $true
            }
        }
        else {
            Write-Host "=======================================" -ForegroundColor Yellow
            Write-Host "No configured performance limits were found to remove." -ForegroundColor Yellow
            Write-Host "=======================================" -ForegroundColor Yellow
            return $true
        }
    }
    catch {
        Write-Host "[X] Failed to unset performance limits: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
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
        
        # Set the value with error handling
        Set-ItemProperty -Path $psKeyPath -Name $ValueName -Value $ValueData -Type DWord -ErrorAction Stop
        Write-Log "[OK] Successfully set $ValueName = $ValueData"
        return $true
    }
    catch [System.UnauthorizedAccessException] {
        Write-Verbose-Log "Permission denied for $ValueName, but checking if value was set..."
        # Sometimes the operation fails but the value is still set
        try {
            $currentValue = Get-ItemProperty -Path $psKeyPath -Name $ValueName -ErrorAction SilentlyContinue
            if ($currentValue.$ValueName -eq $ValueData) {
                Write-Log "[OK] Successfully set $ValueName = $ValueData (despite permission warning)"
                return $true
            }
        }
        catch { }
        Write-Log "[X] Failed to set $ValueName due to insufficient permissions" "ERROR"
        return $false
    }
    catch {
        Write-Log "[X] Failed to set $ValueName`: $($_.Exception.Message)" "ERROR"
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
    
    # Concise summary line (ticket #202510024200014) similar to batch/linux implementations
    if ($settings.ContainsKey($CPU_USAGE_VALUE)) {
        $cpu = $settings[$CPU_USAGE_VALUE]
        $modeSummary = switch ($cpu) {
            15 { 'low' ; break }
            20 { 'medium' ; break }
            30 { 'high' ; break }
            40 { 'ultra' ; break }
            default { "custom ($cpu%)" }
        }
    } else {
        $modeSummary = 'unset'
    }

    Write-Host "Performance Mode (summary): $modeSummary"

    Write-Host "Patch Scan Timeout: $timeout"
    Write-Host "Thread Max CPU Usage: $cpuUsage"
    
    # Determine performance mode
    if ($settings.ContainsKey($CPU_USAGE_VALUE)) {
        $cpu = $settings[$CPU_USAGE_VALUE]
        if ($cpu -eq 15) {
            Write-Host "Current Performance Mode: LOW (15% CPU)" -ForegroundColor Green
        }
        elseif ($cpu -eq 20) {
            Write-Host "Current Performance Mode: MEDIUM (20% CPU)" -ForegroundColor Blue
        }
        elseif ($cpu -eq 30) {
            Write-Host "Current Performance Mode: HIGH (30% CPU)" -ForegroundColor Yellow
        }
        elseif ($cpu -eq 40) {
            Write-Host "Current Performance Mode: ULTRA (40% CPU)" -ForegroundColor Red
        }
        else {
            Write-Host "Current Performance Mode: CUSTOM ($cpu% CPU)" -ForegroundColor Magenta
        }
    }
    else {
        Write-Host "Current Performance Mode: UNKNOWN" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "PM+ Agent Service Status:" -ForegroundColor Cyan
    Write-Host "========================" -ForegroundColor Cyan
    Show-ServiceStatus
    Write-Host ""
}

function Show-ServiceStatus {
    $serviceName = "ManageEngine UEMS - Agent"
    
    try {
        $service = Get-Service -Name $serviceName -ErrorAction Stop
        $status = $service.Status
        
        switch ($status) {
            "Running" { Write-Host "Service Status: [OK] RUNNING" -ForegroundColor Green }
            "Stopped" { Write-Host "Service Status: [X] STOPPED" -ForegroundColor Red }
            "StartPending" { Write-Host "Service Status: [~] STARTING..." -ForegroundColor Yellow }
            "StopPending" { Write-Host "Service Status: [~] STOPPING..." -ForegroundColor Yellow }
            "Paused" { Write-Host "Service Status: [!] PAUSED" -ForegroundColor Magenta }
            "ContinuePending" { Write-Host "Service Status: [~] RESUMING..." -ForegroundColor Yellow }
            "PausePending" { Write-Host "Service Status: [~] PAUSING..." -ForegroundColor Yellow }
            default { Write-Host "Service Status: $status" -ForegroundColor White }
        }
    }
    catch {
        Write-Host "Service Status: [X] NOT FOUND or ACCESS DENIED" -ForegroundColor Red
    }
}

function Restart-AgentService {
    $serviceName = "ManageEngine UEMS - Agent"
    
    Write-Host "Restarting PM+ Agent service to apply changes..." -ForegroundColor Yellow
    Write-Host ""
    
    try {
        $service = Get-Service -Name $serviceName -ErrorAction Stop
        $currentStatus = $service.Status
        
        # Check if service is already stopped - no need to stop it
        if ($currentStatus -eq "Stopped") {
            Write-Host "Service is already stopped, proceeding to start..." -ForegroundColor Cyan
        }
        # Check if service is in a transitional state
        elseif ($currentStatus -eq "StopPending") {
            Write-Host "Service is already stopping, waiting for it to complete..." -ForegroundColor Cyan
            $service.WaitForStatus("Stopped", (New-TimeSpan -Seconds 30))
        }
        elseif ($currentStatus -eq "StartPending") {
            Write-Host "Service is currently starting, waiting for it to complete..." -ForegroundColor Cyan
            try {
                $service.WaitForStatus("Running", (New-TimeSpan -Seconds 10))
                Write-Host "Service started successfully, will now restart it..." -ForegroundColor Cyan
            }
            catch {
                Write-Host "Service start appears to have failed, attempting restart..." -ForegroundColor Yellow
            }
        }
        
        # Stop the service if it's running
        if ($service.Status -ne "Stopped") {
            Write-Host "Stopping service: $serviceName" -ForegroundColor Yellow
            Stop-Service -Name $serviceName -Force
            Write-Host "[OK] Service stopped successfully" -ForegroundColor Green
            
            # Wait for service to fully stop
            Write-Host "Waiting for service to stop completely..." -ForegroundColor Cyan
            $service.WaitForStatus("Stopped", (New-TimeSpan -Seconds 30))
        }
        
        # Start the service
        Write-Host ""
        Write-Host "Starting service: $serviceName" -ForegroundColor Yellow
        Start-Service -Name $serviceName
        Write-Host "[OK] Service started successfully" -ForegroundColor Green
        
        # Verify service is actually running
        Start-Sleep -Seconds 2
        $service.Refresh()
        if ($service.Status -eq "Running") {
            Write-Host ""
            Write-Host "[OK] PM+ Agent service restarted - configuration changes are now active" -ForegroundColor Green
        } else {
            Write-Host ""
            Write-Host "[!] Service start command succeeded but service state is: $($service.Status)" -ForegroundColor Yellow
            Write-Host "[!] Configuration changes should still be active" -ForegroundColor Yellow
        }
        
        return $true
    }
    catch {
        Write-Host "[X] Failed to restart service: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host ""
        Write-Host "Please restart the service manually:" -ForegroundColor Yellow
        Write-Host "  Stop-Service -Name '$serviceName' -Force" -ForegroundColor Cyan
        Write-Host "  Start-Service -Name '$serviceName'" -ForegroundColor Cyan
        return $false
    }
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
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "[OK] Configuration applied successfully!" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green
    } elseif ($successCount -gt 0) {
        Write-Host "========================================" -ForegroundColor Yellow
        Write-Host "[PARTIAL] Configuration partially applied ($successCount/$totalSettings settings)" -ForegroundColor Yellow
        Write-Host "========================================" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Note: Some registry permission warnings may appear but settings" -ForegroundColor Yellow
        Write-Host "can still be successfully applied. Check current settings to verify." -ForegroundColor Yellow
    } else {
        Write-Host "========================================" -ForegroundColor Red
        Write-Host "[ERROR] Configuration failed - no settings were applied" -ForegroundColor Red
        Write-Host "========================================" -ForegroundColor Red
        Write-Host ""
        Write-Host "Please ensure you're running as Administrator and try again." -ForegroundColor Red
        return
    }
    
    Write-Host ""
    
    if ($successCount -gt 0) {
        # Prompt for service restart
        Write-Host "IMPORTANT: Service restart required for changes to take effect" -ForegroundColor Yellow
        Write-Host ""
        
        try {
            $service = Get-Service -Name "ManageEngine UEMS - Agent" -ErrorAction Stop
            Write-Host "Current service status: $($service.Status)" -ForegroundColor Cyan
            Write-Host ""
            
            $choice = Read-Host "Restart PM+ Agent service now? (y/N)"
            if ($choice -match "^[Yy]") {
                Write-Host ""
                if (Restart-AgentService) {
                    return $true
                } else {
                    return $false
                }
            } else {
                Write-Host ""
                Write-Host "Service restart skipped. To apply changes, restart manually:" -ForegroundColor Yellow
                Write-Host "  Stop-Service -Name 'ManageEngine UEMS - Agent' -Force" -ForegroundColor Cyan
                Write-Host "  Start-Service -Name 'ManageEngine UEMS - Agent'" -ForegroundColor Cyan
                return $true
            }
        }
        catch {
            Write-Host "WARNING: Service 'ManageEngine UEMS - Agent' not found or not accessible" -ForegroundColor Yellow
            Write-Host "Please restart the agent service manually" -ForegroundColor Yellow
            return $true
        }
    }
    else {
        Write-Host "=======================================" -ForegroundColor Red
        Write-Host "[X] Configuration partially failed" -ForegroundColor Red
        Write-Host "=======================================" -ForegroundColor Red
        Write-Host ""
        Write-Host "Applied $successCount of $totalSettings settings successfully." -ForegroundColor Yellow
        Write-Host "Please check the error messages above." -ForegroundColor Yellow
        return $false
    }
}

function Test-RegistryAccess {
    Write-Host ""
    Write-Host "Testing Registry Access:" -ForegroundColor Cyan
    Write-Host "========================" -ForegroundColor Cyan
    Write-Host ""
    
    # Test Patch Key
    $patchPsKey = $PATCH_KEY -replace "HKEY_LOCAL_MACHINE", "HKLM:"
    Write-Host "Testing Patch Key: $PATCH_KEY" -ForegroundColor Yellow
    if (Test-Path $patchPsKey) {
        Write-Host "[OK] Can access Patch registry key" -ForegroundColor Green
    } else {
        Write-Host "[X] Cannot access Patch registry key" -ForegroundColor Red
        Write-Host "[INFO] This may indicate DesktopCentral DCAgent is not installed" -ForegroundColor Yellow
    }
    
    # Test Agent Key
    $agentPsKey = $AGENT_KEY -replace "HKEY_LOCAL_MACHINE", "HKLM:"
    Write-Host "Testing Agent Key: $AGENT_KEY" -ForegroundColor Yellow
    if (Test-Path $agentPsKey) {
        Write-Host "[OK] Can access Agent registry key" -ForegroundColor Green
    } else {
        Write-Host "[X] Cannot access Agent registry key" -ForegroundColor Red
        Write-Host "[INFO] This may indicate DesktopCentral DCAgent is not installed" -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Host "Registry Key Paths Being Used:" -ForegroundColor Cyan
    Write-Host "Patch: $PATCH_KEY"
    Write-Host "Agent: $AGENT_KEY"
    Write-Host ""
    Write-Host "Value Names:" -ForegroundColor Cyan
    Write-Host "Patch Timeout: $PATCH_TIMEOUT_VALUE"
    Write-Host "CPU Usage: $CPU_USAGE_VALUE"
    Write-Host ""
}

function Show-MenuOptions {
    Write-Host ""
    Write-Host "Select Performance Mode:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "0. Show Menu Options" -ForegroundColor Yellow
    Write-Host "1. Low Performance Mode    (CPU Usage: 15%, Scan Timeout: 200s)"
    Write-Host "2. Medium Performance Mode (CPU Usage: 20%, Scan Timeout: 200s)"
    Write-Host "3. High Performance Mode   (CPU Usage: 30%, Scan Timeout: 200s)"
    Write-Host "4. Ultra Performance Mode  (CPU Usage: 40%, Scan Timeout: 200s)"
    Write-Host "5. Show Current Settings and Service Status"
    Write-Host "6. Restart PM+ Agent Service"
    Write-Host "7. Unset Performance Limits (set to UNLIMITED)"
    Write-Host "8. Test Registry Access (Debug)"
    Write-Host "9. Export Registry Settings (Troubleshooting)"
    Write-Host "10. Exit"
    Write-Host ""
}

function Show-InteractiveMenu {
    Write-Host ""
    Write-Host "Interactive Menu Mode" -ForegroundColor Cyan
    Write-Host "====================" -ForegroundColor Cyan
    Show-MenuOptions
    
    do {
    $choice = Read-Host "Enter your choice (0-10, 0 for menu)"
        
        switch ($choice) {
            "0" {
                Show-MenuOptions
                continue
            }
            "1" {
                Write-Host ""
                Set-PerformanceMode -PerformanceMode "low" | Out-Null
                Write-Host ""
                continue
            }
            "2" {
                Write-Host ""
                Set-PerformanceMode -PerformanceMode "medium" | Out-Null
                Write-Host ""
                continue
            }
            "3" {
                Write-Host ""
                Set-PerformanceMode -PerformanceMode "high" | Out-Null
                Write-Host ""
                continue
            }
            "4" {
                Write-Host ""
                Set-PerformanceMode -PerformanceMode "ultra" | Out-Null
                Write-Host ""
                continue
            }
            "5" {
                Write-Host ""
                Show-CurrentSettings
                Write-Host ""
                continue
            }
            "6" {
                Write-Host ""
                Restart-AgentService | Out-Null
                Write-Host ""
                continue
            }
            "7" {
                Write-Host ""
                Unset-PerformanceLimits | Out-Null
                Write-Host ""
                continue
            }
            "8" {
                Write-Host ""
                Test-RegistryAccess | Out-Null
                Write-Host ""
                continue
            }
            "9" {
                Write-Host ""
                Export-Registry | Out-Null
                Write-Host ""
                continue
            }
            "10" {
                Write-Host "Exiting..." -ForegroundColor Yellow
                return
            }
            default {
                Write-Host "Invalid choice. Please enter a number between 0 and 10." -ForegroundColor Red
                Write-Host ""
                continue
            }
        }
    } while ($true)
}

function Export-Registry {
    Write-Host ""; Write-Host "Exporting DCAgent registry subtree to current directory..." -ForegroundColor Yellow
    $timestamp = Get-Date -Format 'yyyyMMddHHmmss'  # Align with batch: pm-agent-dca-YYYYMMDDHHMMSS.reg
    $exportPath = Join-Path (Get-Location) ("pm-agent-dca-$timestamp.reg")
    $regExe = (Get-Command reg.exe -ErrorAction SilentlyContinue)
    if ($regExe) {
        # Use native reg.exe export (full subtree)
        & $regExe export $AGENT_KEY $exportPath /y *> $null
        if ($LASTEXITCODE -eq 0 -and (Test-Path $exportPath)) {
            Write-Host "[OK] Registry exported to: $exportPath" -ForegroundColor Green
            Write-Host "Attach this file to support tickets for analysis." -ForegroundColor Cyan
            return
        } else {
            Write-Host "[WARN] reg.exe export failed (code $LASTEXITCODE). Falling back to minimal writer..." -ForegroundColor Yellow
        }
    } else {
        Write-Host "[WARN] reg.exe not found. Using minimal writer..." -ForegroundColor Yellow
    }
    # Fallback minimal writer capturing only the two values if present
    $lines = @('Windows Registry Editor Version 5.00','')
    function Append-Key($rootKey) {
        if (Test-Path $rootKey) {
            $props = Get-ItemProperty -Path $rootKey -ErrorAction SilentlyContinue
            if ($props) {
                $winKey = $rootKey -replace '^HKLM:', 'HKEY_LOCAL_MACHINE'
                $lines += "[$winKey]"
                foreach ($n in $props.PSObject.Properties.Name) {
                    if ($n -in @($PATCH_TIMEOUT_VALUE,$CPU_USAGE_VALUE)) {
                        $val = $props.$n
                        if ($val -is [int]) {
                            $lines += '"{0}"=dword:{1}' -f $n, ($val.ToString('x8'))
                        } else {
                            $escaped = $val.ToString().Replace('\\','\\\\').Replace('"','\"')
                            $lines += '"{0}"="{1}"' -f $n,$escaped
                        }
                    }
                }
                $lines += ''
            }
        }
    }
    Append-Key ($AGENT_KEY -replace 'HKEY_LOCAL_MACHINE','HKLM:')
    Append-Key ($PATCH_KEY -replace 'HKEY_LOCAL_MACHINE','HKLM:')
    try {
        $lines | Out-File -FilePath $exportPath -Encoding ASCII -Force
    } catch {
        Write-Host "[X] Failed to write export file: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Ensure you have write permissions to: $(Get-Location)" -ForegroundColor Yellow
        return
    }
    if (Test-Path $exportPath) {
        Write-Host "[OK] Minimal registry export written to: $exportPath" -ForegroundColor Green
    } else {
        Write-Host "[X] Failed to write fallback registry export" -ForegroundColor Red
    }
}

# Main execution logic
try {
    Write-Host ""
    Write-Host "PM+ Agent Registry Configuration Tool" -ForegroundColor Cyan
    Write-Host "=====================================" -ForegroundColor Cyan
    
    # Show help if requested. If no specific action is provided, open interactive menu by default.
    if ($Help) {
        Show-Help
        exit 0
    }

    if (-not $Mode -and -not $Status -and -not $Menu -and -not $Export) {
        Show-InteractiveMenu
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
        Write-Host ""
        Write-Host "To run as Administrator:" -ForegroundColor Yellow
        Write-Host "1. Right-click Command Prompt or PowerShell" -ForegroundColor Yellow
        Write-Host "2. Select 'Run as administrator'" -ForegroundColor Yellow
        Write-Host "3. Navigate to script location and run again" -ForegroundColor Yellow
        exit 1
    }
    
    Write-Verbose-Log "Administrator privileges confirmed"
    
    # Show current settings
    if ($Status) {
        Show-CurrentSettings
        exit 0
    }

    if ($Export) {
        Export-Registry
        exit 0
    }
    
    # Show interactive menu
    if ($Menu) {
        Show-InteractiveMenu
        exit 0
    }
    
    # Configure performance mode
    if ($Mode) {
        if ($Mode -eq 'unset') {
            if (Unset-PerformanceLimits) { exit 0 } else { exit 1 }
        } else {
            if (Set-PerformanceMode -PerformanceMode $Mode) { exit 0 } else { exit 1 }
        }
    }
}
catch {
    Write-Host ""
    Write-Host "FATAL ERROR: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
