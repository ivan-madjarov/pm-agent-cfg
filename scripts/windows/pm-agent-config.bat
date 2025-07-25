@echo off
REM PM Agent Registry Configuration Tool - Standalone Version
REM No Python required - Pure Windows batch script
REM Configures DesktopCentral DCAgent registry settings with performance options

setlocal enabledelayedexpansion

REM ============================================================================
REM Configuration Variables
REM ============================================================================
set "PATCH_KEY=HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\AdventNet\DesktopCentral\DCAgent\Patch"
set "AGENT_KEY=HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\AdventNet\DesktopCentral\DCAgent"
set "PATCH_TIMEOUT_VALUE=Patch_scan_timeout"
set "CPU_USAGE_VALUE=THRDMAXCPUUSAGE_2C"

REM Performance mode settings
set "LOW_CPU=15"
set "HIGH_CPU=30" 
set "TIMEOUT=200"

REM ============================================================================
REM Command Line Argument Processing
REM ============================================================================
set "MODE="
set "SHOW_STATUS="
set "SHOW_HELP="
set "VERBOSE="

:parse_args
if "%~1"=="" goto :args_done
if /i "%~1"=="--mode" (
    set "MODE=%~2"
    shift
    shift
    goto :parse_args
)
if /i "%~1"=="-m" (
    set "MODE=%~2"
    shift
    shift
    goto :parse_args
)
if /i "%~1"=="--status" (
    set "SHOW_STATUS=1"
    shift
    goto :parse_args
)
if /i "%~1"=="-s" (
    set "SHOW_STATUS=1"
    shift
    goto :parse_args
)
if /i "%~1"=="--help" (
    set "SHOW_HELP=1"
    shift
    goto :parse_args
)
if /i "%~1"=="-h" (
    set "SHOW_HELP=1"
    shift
    goto :parse_args
)
if /i "%~1"=="--verbose" (
    set "VERBOSE=1"
    shift
    goto :parse_args
)
if /i "%~1"=="-v" (
    set "VERBOSE=1"
    shift
    goto :parse_args
)
REM Unknown argument
echo ERROR: Unknown argument: %~1
echo Use --help for usage information.
exit /b 1

:args_done

REM ============================================================================
REM Functions
REM ============================================================================

REM Show help function
if defined SHOW_HELP goto :show_help

REM Check administrator privileges
call :check_admin
if %errorLevel% neq 0 exit /b 1

REM Show header
call :show_header

REM Process commands
if defined SHOW_STATUS (
    call :show_current_settings
    exit /b 0
)

if defined MODE (
    call :configure_mode "%MODE%"
    exit /b %errorLevel%
)

REM No arguments provided, show help
goto :show_help

REM ============================================================================
REM Function Definitions
REM ============================================================================

:check_admin
    if defined VERBOSE echo [VERBOSE] Checking administrator privileges...
    net session >nul 2>&1
    if %errorLevel% neq 0 (
        echo.
        echo ERROR: Administrator privileges required
        echo.
        echo This tool modifies Windows Registry settings and requires
        echo Administrator privileges to run.
        echo.
        echo Please run as Administrator:
        echo 1. Right-click Command Prompt
        echo 2. Select "Run as administrator"
        echo 3. Run this script again
        echo.
        exit /b 1
    )
    if defined VERBOSE echo [VERBOSE] Administrator privileges confirmed
    exit /b 0

:show_header
    echo ================================================================
    echo PM Agent Registry Configuration Tool - Standalone Version
    echo ================================================================
    echo.
    exit /b 0

:show_help
    echo PM Agent Registry Configuration Tool for Windows
    echo.
    echo DESCRIPTION:
    echo     Configures DesktopCentral DCAgent registry settings with performance options.
    echo     No Python installation required - pure Windows batch script.
    echo.
    echo USAGE:
    echo     %~nx0 [OPTIONS]
    echo.
    echo OPTIONS:
    echo     --mode, -m ^<low^|high^>    Set performance mode
    echo                              low  = 15%% CPU usage, 200s timeout
    echo                              high = 30%% CPU usage, 200s timeout
    echo.
    echo     --status, -s             Display current registry settings
    echo     --help, -h               Show this help message
    echo     --verbose, -v            Enable verbose output
    echo.
    echo EXAMPLES:
    echo     %~nx0 --mode high        Configure for high performance
    echo     %~nx0 --mode low         Configure for low performance  
    echo     %~nx0 --status           Show current settings
    echo.
    echo REQUIREMENTS:
    echo     - Administrator privileges
    echo     - DesktopCentral DCAgent installed
    echo.
    echo REGISTRY KEYS MODIFIED:
    echo     %PATCH_KEY%
    echo     └── %PATCH_TIMEOUT_VALUE% (DWORD)
    echo.
    echo     %AGENT_KEY%
    echo     └── %CPU_USAGE_VALUE% (DWORD)
    echo.
    exit /b 0

:show_current_settings
    echo Current PM Agent Registry Settings:
    echo ===================================
    echo.
    
    if defined VERBOSE echo [VERBOSE] Querying patch scan timeout...
    for /f "tokens=3" %%a in ('reg query "%PATCH_KEY%" /v "%PATCH_TIMEOUT_VALUE%" 2^>nul ^| findstr "%PATCH_TIMEOUT_VALUE%"') do (
        echo Patch Scan Timeout: %%a seconds
        set "CURRENT_TIMEOUT=%%a"
    )
    if not defined CURRENT_TIMEOUT (
        echo Patch Scan Timeout: Not set
    )
    
    if defined VERBOSE echo [VERBOSE] Querying thread max CPU usage...
    for /f "tokens=3" %%a in ('reg query "%AGENT_KEY%" /v "%CPU_USAGE_VALUE%" 2^>nul ^| findstr "%CPU_USAGE_VALUE%"') do (
        echo Thread Max CPU Usage: %%a%%
        set "CURRENT_CPU=%%a"
    )
    if not defined CURRENT_CPU (
        echo Thread Max CPU Usage: Not set
    )
    
    echo.
    
    REM Determine current performance mode
    if defined CURRENT_CPU (
        if "!CURRENT_CPU!"=="%LOW_CPU%" (
            echo Current Performance Mode: LOW ^(15%% CPU^)
        ) else if "!CURRENT_CPU!"=="%HIGH_CPU%" (
            echo Current Performance Mode: HIGH ^(30%% CPU^)
        ) else (
            echo Current Performance Mode: CUSTOM ^(!CURRENT_CPU!%% CPU^)
        )
    ) else (
        echo Current Performance Mode: UNKNOWN
    )
    
    exit /b 0

:configure_mode
    set "PERF_MODE=%~1"
    
    if /i "%PERF_MODE%"=="low" (
        set "CPU_VALUE=%LOW_CPU%"
        set "MODE_NAME=LOW"
        set "MODE_DESC=low performance"
    ) else if /i "%PERF_MODE%"=="high" (
        set "CPU_VALUE=%HIGH_CPU%"
        set "MODE_NAME=HIGH" 
        set "MODE_DESC=high performance"
    ) else (
        echo ERROR: Invalid performance mode: %PERF_MODE%
        echo Valid options: low, high
        exit /b 1
    )
    
    echo Configuring PM Agent for %MODE_NAME% performance mode...
    echo Agent Resource Utilization Limit: %MODE_DESC%
    echo CPU Usage Limit: %CPU_VALUE%%%
    echo Patch Scan Timeout: %TIMEOUT% seconds
    echo.
    
    set "SUCCESS_COUNT=0"
    set "TOTAL_SETTINGS=2"
    
    REM Set patch scan timeout
    if defined VERBOSE echo [VERBOSE] Setting patch scan timeout to %TIMEOUT%...
    reg add "%PATCH_KEY%" /v "%PATCH_TIMEOUT_VALUE%" /t REG_DWORD /d %TIMEOUT% /f >nul 2>&1
    if %errorLevel% equ 0 (
        echo ✓ Patch scan timeout configured successfully
        set /a SUCCESS_COUNT+=1
    ) else (
        echo ✗ Failed to configure patch scan timeout
        if defined VERBOSE echo [VERBOSE] Registry error code: %errorLevel%
    )
    
    REM Set CPU usage limit
    if defined VERBOSE echo [VERBOSE] Setting CPU usage limit to %CPU_VALUE%%%...
    reg add "%AGENT_KEY%" /v "%CPU_USAGE_VALUE%" /t REG_DWORD /d %CPU_VALUE% /f >nul 2>&1
    if %errorLevel% equ 0 (
        echo ✓ CPU usage limit configured successfully
        set /a SUCCESS_COUNT+=1
    ) else (
        echo ✗ Failed to configure CPU usage limit
        if defined VERBOSE echo [VERBOSE] Registry error code: %errorLevel%
    )
    
    echo.
    
    if %SUCCESS_COUNT% equ %TOTAL_SETTINGS% (
        echo ═══════════════════════════════════════
        echo ✓ Configuration applied successfully!
        echo ═══════════════════════════════════════
        echo.
        echo IMPORTANT: You may need to restart the DCAgent service
        echo for changes to take effect:
        echo.
        echo   net stop DCAgent
        echo   net start DCAgent
        echo.
        echo Or use PowerShell:
        echo   Restart-Service 'DCAgent' -Force
        exit /b 0
    ) else (
        echo ═══════════════════════════════════════
        echo ✗ Configuration partially failed
        echo ═══════════════════════════════════════
        echo.
        echo Applied %SUCCESS_COUNT% of %TOTAL_SETTINGS% settings successfully.
        echo Please check the error messages above.
        exit /b 1
    )

REM End of script
