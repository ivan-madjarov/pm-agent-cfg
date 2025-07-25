@echo off
REM PM Agent Registry Configuration Tool - Interactive Menu
REM Provides a simple menu interface for configuring PM Agent settings

setlocal enabledelayedexpansion

echo ================================================================
echo PM Agent Registry Configuration Tool
echo ================================================================
echo.

REM Check if running as Administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: This tool requires Administrator privileges.
    echo Please run as Administrator and try again.
    echo.
    pause
    exit /b 1
)

echo Select Performance Mode:
echo.
echo 1. Low Performance Mode  (CPU Usage: 15%%, Scan Timeout: 200s)
echo 2. High Performance Mode (CPU Usage: 30%%, Scan Timeout: 200s)
echo 3. Show Current Settings
echo 4. Exit
echo.

:menu
set /p choice="Enter your choice (1-4): "

if "%choice%"=="1" (
    echo.
    echo Configuring PM Agent for LOW performance mode...
    echo Agent Resource Utilization Limit: low performance
    echo CPU Usage Limit: 15%%
    echo Patch Scan Timeout: 200 seconds
    echo.
    
    REM Set registry values for low performance
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\AdventNet\DesktopCentral\DCAgent\Patch" /v "Patch_scan_timeout" /t REG_DWORD /d 200 /f
    if %errorLevel% neq 0 (
        echo ERROR: Failed to set Patch_scan_timeout
        goto :error
    )
    
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\AdventNet\DesktopCentral\DCAgent" /v "THRDMAXCPUUSAGE_2C" /t REG_DWORD /d 15 /f
    if %errorLevel% neq 0 (
        echo ERROR: Failed to set THRDMAXCPUUSAGE_2C
        goto :error
    )
    
    echo.
    echo ^>^> Configuration applied successfully!
    echo ^>^> NOTE: You may need to restart the DCAgent service for changes to take effect.
    goto :end
    
) else if "%choice%"=="2" (
    echo.
    echo Configuring PM Agent for HIGH performance mode...
    echo Agent Resource Utilization Limit: high performance
    echo CPU Usage Limit: 30%%
    echo Patch Scan Timeout: 200 seconds
    echo.
    
    REM Set registry values for high performance
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\AdventNet\DesktopCentral\DCAgent\Patch" /v "Patch_scan_timeout" /t REG_DWORD /d 200 /f
    if %errorLevel% neq 0 (
        echo ERROR: Failed to set Patch_scan_timeout
        goto :error
    )
    
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\AdventNet\DesktopCentral\DCAgent" /v "THRDMAXCPUUSAGE_2C" /t REG_DWORD /d 30 /f
    if %errorLevel% neq 0 (
        echo ERROR: Failed to set THRDMAXCPUUSAGE_2C
        goto :error
    )
    
    echo.
    echo ^>^> Configuration applied successfully!
    echo ^>^> NOTE: You may need to restart the DCAgent service for changes to take effect.
    goto :end
    
) else if "%choice%"=="3" (
    echo.
    echo Current PM Agent Registry Settings:
    echo ===================================
    
    REM Query current values
    for /f "tokens=3" %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\AdventNet\DesktopCentral\DCAgent\Patch" /v "Patch_scan_timeout" 2^>nul ^| findstr "Patch_scan_timeout"') do (
        echo Patch Scan Timeout: %%a seconds
    )
    
    for /f "tokens=3" %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\AdventNet\DesktopCentral\DCAgent" /v "THRDMAXCPUUSAGE_2C" 2^>nul ^| findstr "THRDMAXCPUUSAGE_2C"') do (
        echo Thread Max CPU Usage: %%a%%
    )
    
    echo.
    goto :menu
    
) else if "%choice%"=="4" (
    echo Exiting...
    goto :end
    
) else (
    echo Invalid choice. Please enter 1, 2, 3, or 4.
    echo.
    goto :menu
)

:error
echo.
echo Configuration failed. Please check the error messages above.
echo.

:end
echo.
pause
exit /b 0
