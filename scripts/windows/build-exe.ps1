# Build Script - Compile PowerShell to EXE
# Requires ps2exe module: Install-Module ps2exe

param(
    [switch]$InstallPs2exe,
    [switch]$BuildOnly
)

function Install-Ps2exe {
    Write-Host "Installing ps2exe module..." -ForegroundColor Yellow
    try {
        Install-Module -Name ps2exe -Force -Scope CurrentUser
        Write-Host "✓ ps2exe installed successfully" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "✗ Failed to install ps2exe: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

function Build-Executable {
    $scriptPath = Join-Path $PSScriptRoot "pm-agent-config.ps1"
    $outputPath = Join-Path $PSScriptRoot "pm-agent-config.exe"
    
    if (-not (Test-Path $scriptPath)) {
        Write-Host "✗ Source script not found: $scriptPath" -ForegroundColor Red
        return $false
    }
    
    Write-Host "Building executable..." -ForegroundColor Yellow
    Write-Host "Source: $scriptPath"
    Write-Host "Output: $outputPath"
    
    try {
        # Build the executable with ps2exe
        Invoke-ps2exe -inputFile $scriptPath -outputFile $outputPath `
            -title "PM Agent Configuration Tool" `
            -description "PM Agent Registry Configuration Tool for Windows" `
            -company "Mitel Networks" `
            -product "PM Agent Config" `
            -copyright "© 2025 Mitel Networks" `
            -version "1.0.0.0" `
            -iconFile $null `
            -requireAdmin `
            -noConsole:$false `
            -noOutput:$false `
            -noError:$false `
            -verbose:$false
        
        if (Test-Path $outputPath) {
            $fileSize = (Get-Item $outputPath).Length
            $fileSizeMB = [math]::Round($fileSize / 1MB, 2)
            
            Write-Host ""
            Write-Host "✓ Executable built successfully!" -ForegroundColor Green
            Write-Host "File: $outputPath"
            Write-Host "Size: $fileSizeMB MB"
            Write-Host ""
            Write-Host "The executable can now be deployed to machines without PowerShell or Python." -ForegroundColor Cyan
            return $true
        }
        else {
            Write-Host "✗ Build failed - output file not created" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "✗ Build failed: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

function Test-Ps2exe {
    try {
        Get-Module -Name ps2exe -ListAvailable | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

# Main execution
Write-Host "PM Agent Configuration Tool - Build Script" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

if ($InstallPs2exe) {
    if (Install-Ps2exe) {
        Write-Host "ps2exe installation completed. Run the script again with -BuildOnly to compile." -ForegroundColor Green
    }
    exit
}

# Check if ps2exe is available
if (-not (Test-Ps2exe)) {
    Write-Host "ps2exe module not found." -ForegroundColor Yellow
    Write-Host "To install ps2exe, run:" -ForegroundColor Yellow
    Write-Host "  .\build-exe.ps1 -InstallPs2exe" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Or install manually:" -ForegroundColor Yellow
    Write-Host "  Install-Module ps2exe -Force" -ForegroundColor Cyan
    exit 1
}

# Build the executable
if (Build-Executable) {
    Write-Host "Build completed successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Usage examples:" -ForegroundColor Yellow
    Write-Host "  pm-agent-config.exe -Mode high" -ForegroundColor Cyan
    Write-Host "  pm-agent-config.exe -Mode low" -ForegroundColor Cyan
    Write-Host "  pm-agent-config.exe -Status" -ForegroundColor Cyan
} else {
    Write-Host "Build failed!" -ForegroundColor Red
    exit 1
}
