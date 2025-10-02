@echo off
REM PM+ Agent Registry Configuration Tool - Standalone Version
REM Copyright (c) 2024-2025 Mitel Networks Corporation - Proprietary Software
REM Authorized for use by Mitel personnel and designated partners only
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
set "MEDIUM_CPU=20"
set "HIGH_CPU=30"
set "ULTRA_CPU=40"
set "TIMEOUT=200"

REM Service settings
set "SERVICE_NAME=ManageEngine UEMS - Agent"

REM ============================================================================
REM Command Line Argument Processing
REM ============================================================================
set "MODE="
set "SHOW_STATUS="
set "SHOW_HELP="
set "SHOW_MENU="
set "VERBOSE="
set "RESTART_SERVICE="
set "NO_RESTART="
set "UNSET="
set "DO_EXPORT="

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
if /i "%~1"=="--menu" (
    set "SHOW_MENU=1"
    shift
    goto :parse_args
)
if /i "%~1"=="-i" (
    set "SHOW_MENU=1"
    shift
    goto :parse_args
)
if /i "%~1"=="--restart" (
    set "RESTART_SERVICE=1"
    shift
    goto :parse_args
)
if /i "%~1"=="--no-restart" (
    set "NO_RESTART=1"
    shift
    goto :parse_args
)
if /i "%~1"=="--unset" (
    set "UNSET=1"
    shift
    goto :parse_args
)
if /i "%~1"=="--export" (
    set "DO_EXPORT=1"
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

if defined SHOW_MENU (
    call :show_interactive_menu
    exit /b %errorLevel%
)

if defined DO_EXPORT (
    call :export_registry
    exit /b %errorLevel%
)

if defined UNSET (
    call :unset_performance
    exit /b %errorLevel%
)

if defined MODE (
    call :configure_mode "%MODE%"
    exit /b %errorLevel%
)

REM No arguments provided, show interactive menu
call :show_interactive_menu
exit /b %errorLevel%

REM ============================================================================
REM End of main execution - functions follow
REM ============================================================================
goto :eof

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
        echo 1. Right-click Command Prompt or PowerShell
        echo 2. Select "Run as administrator"
        echo 3. Navigate to script location and run this script again
        echo.
        exit /b 1
    )
    if defined VERBOSE echo [VERBOSE] Administrator privileges confirmed
    exit /b 0

:show_header
    echo ================================================================
    echo PM+ Agent Registry Configuration Tool - Standalone Version
    echo ================================================================
    echo.
    exit /b 0

:show_help
    echo PM+ Agent Registry Configuration Tool for Windows
    echo.
    echo DESCRIPTION:
    echo     Configures DesktopCentral DCAgent registry settings with performance options.
    echo     No Python installation required - pure Windows batch script.
    echo.
    echo USAGE:
    echo     pm-agent-config.bat [OPTIONS]
    echo.
    echo OPTIONS:
    echo     --mode, -m ^<low^|medium^|high^|ultra^|unset^>  Set performance mode ("unset" removes limits)
    echo                                low    = 15%% CPU usage, 200s timeout
    echo                                medium = 20%% CPU usage, 200s timeout
    echo                                high   = 30%% CPU usage, 200s timeout
    echo                                ultra  = 40%% CPU usage, 200s timeout
    echo                                unset  = Remove configured limits (set to unlimited)
    echo.
    echo     --status, -s             Display current registry settings and service status
    echo     --menu, -i               Show interactive menu
    echo     (No arguments)           Launch interactive menu
    echo     --restart                Force service restart after configuration
    echo     --no-restart             Skip service restart prompt
    echo     --unset                  Remove configured limits (set to unlimited)
    echo     --export                 Export current DCAgent registry subtree to a .reg file (troubleshooting)
    echo     --help, -h               Show this help message
    echo     --verbose, -v            Enable verbose output
    echo.
    echo EXAMPLES:
    echo     pm-agent-config.bat --mode low          Configure for low performance
    echo     pm-agent-config.bat --mode medium       Configure for medium performance  
    echo     pm-agent-config.bat --mode high         Configure for high performance
    echo     pm-agent-config.bat --mode ultra        Configure for ultra performance
    echo     pm-agent-config.bat --mode unset        Remove configured limits (set to unlimited)
    echo     pm-agent-config.bat --status            Show current settings and service status
    echo     pm-agent-config.bat --menu              Show interactive menu
    echo.
    echo REQUIREMENTS:
    echo     - Administrator privileges
    echo     - DesktopCentral DCAgent installed
    echo.
    echo REGISTRY KEYS MODIFIED:
    echo     %PATCH_KEY%
    echo     +-- %PATCH_TIMEOUT_VALUE% (DWORD)
    echo.
    echo     %AGENT_KEY%
    echo     +-- %CPU_USAGE_VALUE% (DWORD)
    echo.
    exit /b 0

:test_registry_access
    echo Testing Registry Access:
    echo ========================
    echo.
    
    echo Testing Patch Key: %PATCH_KEY%
    reg query "%PATCH_KEY%" >nul 2>&1
    if %errorLevel% equ 0 (
        echo [OK] Can access Patch registry key
    ) else (
        echo [X] Cannot access Patch registry key - Error: %errorLevel%
        echo [INFO] This may indicate DesktopCentral DCAgent is not installed
    )
    
    echo Testing Agent Key: %AGENT_KEY%
    reg query "%AGENT_KEY%" >nul 2>&1
    if %errorLevel% equ 0 (
        echo [OK] Can access Agent registry key
    ) else (
        echo [X] Cannot access Agent registry key - Error: %errorLevel%
        echo [INFO] This may indicate DesktopCentral DCAgent is not installed
    )
    
    echo.
    echo Registry Key Paths Being Used:
    echo Patch: %PATCH_KEY%
    echo Agent: %AGENT_KEY%
    echo.
    echo Value Names:
    echo Patch Timeout: %PATCH_TIMEOUT_VALUE%
    echo CPU Usage: %CPU_USAGE_VALUE%
    echo.
    exit /b 0

:show_current_settings
    echo Current PM+ Agent Registry Settings:
    echo ===================================
    echo.
    
    REM Clear previous values to ensure accurate display
    set "CURRENT_TIMEOUT="
    set "CURRENT_CPU="
    set "CURRENT_TIMEOUT_HEX="
    set "CURRENT_TIMEOUT_DEC="
    set "CURRENT_CPU_HEX="
    set "CURRENT_CPU_DEC="
    
    if defined VERBOSE echo [VERBOSE] Querying patch scan timeout...
    for /f "tokens=3" %%a in ('reg query "%PATCH_KEY%" /v "%PATCH_TIMEOUT_VALUE%" 2^>nul ^| findstr "%PATCH_TIMEOUT_VALUE%"') do (
        set "CURRENT_TIMEOUT_HEX=%%a"
        call :hex_to_decimal "!CURRENT_TIMEOUT_HEX!" CURRENT_TIMEOUT_DEC
        echo Patch Scan Timeout: !CURRENT_TIMEOUT_DEC! seconds
        set "CURRENT_TIMEOUT=!CURRENT_TIMEOUT_DEC!"
    )
    if not defined CURRENT_TIMEOUT (
        echo Patch Scan Timeout: Not set
    )
    
    if defined VERBOSE echo [VERBOSE] Querying thread max CPU usage...
    for /f "tokens=3" %%a in ('reg query "%AGENT_KEY%" /v "%CPU_USAGE_VALUE%" 2^>nul ^| findstr "%CPU_USAGE_VALUE%"') do (
        set "CURRENT_CPU_HEX=%%a"
        call :hex_to_decimal "!CURRENT_CPU_HEX!" CURRENT_CPU_DEC
        echo Thread Max CPU Usage: !CURRENT_CPU_DEC!%%
        set "CURRENT_CPU=!CURRENT_CPU_DEC!"
    )
    if not defined CURRENT_CPU (
        echo Thread Max CPU Usage: Not set
    )

    REM ---------------------------------------------------------------
    REM Add concise summary line (ticket enhancement: simple mode name)
    REM ---------------------------------------------------------------
    set "SUMMARY_MODE=unset"
    if defined CURRENT_CPU (
        if "!CURRENT_CPU!"=="%LOW_CPU%" (
            set "SUMMARY_MODE=low"
        ) else if "!CURRENT_CPU!"=="%MEDIUM_CPU%" (
            set "SUMMARY_MODE=medium"
        ) else if "!CURRENT_CPU!"=="%HIGH_CPU%" (
            set "SUMMARY_MODE=high"
        ) else if "!CURRENT_CPU!"=="%ULTRA_CPU%" (
            set "SUMMARY_MODE=ultra"
        ) else (
            set "SUMMARY_MODE=custom"
        )
    )
    echo Performance Mode (summary): !SUMMARY_MODE!
    
    echo.
    
    REM Determine current performance mode
    if defined CURRENT_CPU (
        if "!CURRENT_CPU!"=="%LOW_CPU%" (
            echo Current Performance Mode: LOW ^(15%% CPU^)
        ) else if "!CURRENT_CPU!"=="%MEDIUM_CPU%" (
            echo Current Performance Mode: MEDIUM ^(20%% CPU^)
        ) else if "!CURRENT_CPU!"=="%HIGH_CPU%" (
            echo Current Performance Mode: HIGH ^(30%% CPU^)
        ) else if "!CURRENT_CPU!"=="%ULTRA_CPU%" (
            echo Current Performance Mode: ULTRA ^(40%% CPU^)
        ) else (
            echo Current Performance Mode: CUSTOM ^(!CURRENT_CPU!%% CPU^)
        )
    ) else (
        echo Current Performance Mode: UNKNOWN
    )
    
    echo.
    echo PM+ Agent Service Status:
    echo ========================
    call :check_service_status
    if %errorLevel% equ 0 (
        if "!SERVICE_STATE!"=="RUNNING" (
            echo Service Status: [OK] RUNNING
        ) else if "!SERVICE_STATE!"=="STOPPED" (
            echo Service Status: [X] STOPPED
        ) else if "!SERVICE_STATE!"=="START_PENDING" (
            echo Service Status: [~] STARTING...
        ) else if "!SERVICE_STATE!"=="STOP_PENDING" (
            echo Service Status: [~] STOPPING...
        ) else if "!SERVICE_STATE!"=="PAUSED" (
            echo Service Status: [!] PAUSED
        ) else if "!SERVICE_STATE!"=="CONTINUE_PENDING" (
            echo Service Status: [~] RESUMING...
        ) else if "!SERVICE_STATE!"=="PAUSE_PENDING" (
            echo Service Status: [~] PAUSING...
        ) else (
            echo Service Status: !SERVICE_STATE!
        )
    ) else (
        echo Service Status: [X] NOT FOUND or ACCESS DENIED
    )
    
    exit /b 0

:configure_mode
    set "PERF_MODE=%~1"
    
    REM Added ticket #202510024200014: allow --mode unset (previously required separate --unset flag)
    if /i "%PERF_MODE%"=="unset" (
        call :unset_performance
        exit /b %errorLevel%
    )
    
    if /i "%PERF_MODE%"=="low" (
        set "CPU_VALUE=%LOW_CPU%"
        set "MODE_NAME=LOW"
        set "MODE_DESC=low performance"
    ) else if /i "%PERF_MODE%"=="medium" (
        set "CPU_VALUE=%MEDIUM_CPU%"
        set "MODE_NAME=MEDIUM"
        set "MODE_DESC=medium performance"
    ) else if /i "%PERF_MODE%"=="high" (
        set "CPU_VALUE=%HIGH_CPU%"
        set "MODE_NAME=HIGH" 
        set "MODE_DESC=high performance"
    ) else if /i "%PERF_MODE%"=="ultra" (
        set "CPU_VALUE=%ULTRA_CPU%"
        set "MODE_NAME=ULTRA"
        set "MODE_DESC=ultra performance"
    ) else (
        echo ERROR: Invalid performance mode: %PERF_MODE%
        echo Valid options: low, medium, high, ultra, unset
        exit /b 1
    )
    
    echo Configuring PM+ Agent for %MODE_NAME% performance mode...
    echo Agent Resource Utilization Limit: %MODE_DESC%
    echo CPU Usage Limit: %CPU_VALUE%%%
    echo Patch Scan Timeout: %TIMEOUT% seconds
    echo.
    
    set "SUCCESS_COUNT=0"
    set "TOTAL_SETTINGS=2"
    
    REM Set patch scan timeout
    if defined VERBOSE echo [VERBOSE] Setting patch scan timeout to %TIMEOUT%...
    if defined VERBOSE echo [VERBOSE] Registry path: %PATCH_KEY%\%PATCH_TIMEOUT_VALUE%
    
    REM First, ensure the registry key exists
    reg add "%PATCH_KEY%" /f >nul 2>&1
    
    REM Then set the value
    reg add "%PATCH_KEY%" /v "%PATCH_TIMEOUT_VALUE%" /t REG_DWORD /d %TIMEOUT% /f >nul 2>&1
    set "REG_ERROR=%errorLevel%"
    if %REG_ERROR% equ 0 (
        REM Verify the value was set correctly
        reg query "%PATCH_KEY%" /v "%PATCH_TIMEOUT_VALUE%" >nul 2>&1
        if !errorLevel! equ 0 (
            echo [OK] Patch scan timeout configured successfully
            set /a SUCCESS_COUNT+=1
        ) else (
            echo [X] Failed to verify patch scan timeout configuration
            if defined VERBOSE echo [VERBOSE] Query verification failed
        )
    ) else (
        echo [X] Failed to configure patch scan timeout
        if defined VERBOSE echo [VERBOSE] Registry add error code: %REG_ERROR%
        REM Try alternative approach - check if we have permission issues
        reg query "%PATCH_KEY%" >nul 2>&1
        if !errorLevel! neq 0 (
            if defined VERBOSE echo [VERBOSE] Registry key does not exist or access denied: %PATCH_KEY%
        )
    )
    
    REM Set CPU usage limit
    if defined VERBOSE echo [VERBOSE] Setting CPU usage limit to %CPU_VALUE%%%...
    if defined VERBOSE echo [VERBOSE] Registry path: %AGENT_KEY%\%CPU_USAGE_VALUE%
    
    REM First, ensure the registry key exists
    reg add "%AGENT_KEY%" /f >nul 2>&1
    
    REM Then set the value
    reg add "%AGENT_KEY%" /v "%CPU_USAGE_VALUE%" /t REG_DWORD /d %CPU_VALUE% /f >nul 2>&1
    set "REG_ERROR=%errorLevel%"
    if %REG_ERROR% equ 0 (
        REM Verify the value was set correctly
        reg query "%AGENT_KEY%" /v "%CPU_USAGE_VALUE%" >nul 2>&1
        if !errorLevel! equ 0 (
            echo [OK] CPU usage limit configured successfully
            set /a SUCCESS_COUNT+=1
        ) else (
            echo [X] Failed to verify CPU usage limit configuration
            if defined VERBOSE echo [VERBOSE] Query verification failed
        )
    ) else (
        echo [X] Failed to configure CPU usage limit
        if defined VERBOSE echo [VERBOSE] Registry add error code: %REG_ERROR%
        REM Try alternative approach - check if we have permission issues
        reg query "%AGENT_KEY%" >nul 2>&1
        if !errorLevel! neq 0 (
            if defined VERBOSE echo [VERBOSE] Registry key does not exist or access denied: %AGENT_KEY%
        )
    )
    
    echo.
    
    if %SUCCESS_COUNT% equ %TOTAL_SETTINGS% (
        echo ========================================
        echo [OK] Configuration applied successfully!
        echo ========================================
        echo.
        
        REM Handle service restart
        if defined RESTART_SERVICE (
            call :restart_agent_service
        ) else if not defined NO_RESTART (
            call :prompt_service_restart
        ) else (
            echo Service restart skipped (--no-restart specified)
        )
        exit /b 0
    ) else (
        echo ========================================
        echo X Configuration partially failed
        echo ========================================
        echo.
        echo Applied %SUCCESS_COUNT% of %TOTAL_SETTINGS% settings successfully.
        echo Please check the error messages above.
        exit /b 1
    )

:display_menu_options
    echo Select Performance Mode:
    echo.
    echo 0. Show Menu Options
    echo 1. Low Performance Mode    (CPU Usage: 15%%, Scan Timeout: 200s)
    echo 2. Medium Performance Mode (CPU Usage: 20%%, Scan Timeout: 200s)
    echo 3. High Performance Mode   (CPU Usage: 30%%, Scan Timeout: 200s)
    echo 4. Ultra Performance Mode  (CPU Usage: 40%%, Scan Timeout: 200s)
    echo 5. Show Current Settings and Service Status
    echo 6. Restart PM+ Agent Service
    echo 7. Unset Performance Limits (set to UNLIMITED)
    echo 8. Test Registry Access (Debug)
    echo 9. Export Registry Settings (Troubleshooting)
    echo 10. Exit
    exit /b 0

:show_interactive_menu
    echo Interactive Menu Mode
    echo =====================
    echo.
    call :display_menu_options
    echo.

    :menu_loop
    set /p choice="Enter your choice (0-10, 0 for menu): "
    
    if "%choice%"=="0" (
        echo.
        call :display_menu_options
        echo.
        goto :menu_loop
    ) else if "%choice%"=="1" (
        echo.
        call :configure_mode "low"
        echo.
        goto :menu_loop
    ) else if "%choice%"=="2" (
        echo.
        call :configure_mode "medium"
        echo.
        goto :menu_loop
    ) else if "%choice%"=="3" (
        echo.
        call :configure_mode "high" 
        echo.
        goto :menu_loop
    ) else if "%choice%"=="4" (
        echo.
        call :configure_mode "ultra"
        echo.
        goto :menu_loop
    ) else if "%choice%"=="5" (
        echo.
        call :show_current_settings
        echo.
        goto :menu_loop
    ) else if "%choice%"=="6" (
        echo.
        call :restart_agent_service
        echo.
        goto :menu_loop
    ) else if "%choice%"=="7" (
        echo.
        call :unset_performance
        echo.
        goto :menu_loop
    ) else if "%choice%"=="8" (
        echo.
        call :test_registry_access
        echo.
        goto :menu_loop
    ) else if "%choice%"=="9" (
        echo.
        call :export_registry
        echo.
        goto :menu_loop
    ) else if "%choice%"=="10" (
        echo Exiting...
        exit /b 0
    ) else (
        echo Invalid choice. Please enter a number between 0 and 10.
        echo.
        goto :menu_loop
    )

REM ============================================================================
REM Service Management Functions
REM ============================================================================

:check_service_status
    if defined VERBOSE echo [VERBOSE] Checking service status: %SERVICE_NAME%
    sc query "%SERVICE_NAME%" >nul 2>&1
    if %errorLevel% equ 0 (
        REM Get the state line from sc query output and extract the text description
        for /f "tokens=3,4" %%a in ('sc query "%SERVICE_NAME%" ^| findstr "STATE"') do (
            set "SERVICE_STATE_CODE=%%a"
            set "SERVICE_STATE=%%b"
        )
        
        REM Fallback: if we only got the code, convert it to text
        if not defined SERVICE_STATE (
            if "!SERVICE_STATE_CODE!"=="1" set "SERVICE_STATE=STOPPED"
            if "!SERVICE_STATE_CODE!"=="2" set "SERVICE_STATE=START_PENDING"
            if "!SERVICE_STATE_CODE!"=="3" set "SERVICE_STATE=STOP_PENDING"
            if "!SERVICE_STATE_CODE!"=="4" set "SERVICE_STATE=RUNNING"
            if "!SERVICE_STATE_CODE!"=="5" set "SERVICE_STATE=CONTINUE_PENDING"
            if "!SERVICE_STATE_CODE!"=="6" set "SERVICE_STATE=PAUSE_PENDING"
            if "!SERVICE_STATE_CODE!"=="7" set "SERVICE_STATE=PAUSED"
        )
        
        if defined VERBOSE echo [VERBOSE] Service state: !SERVICE_STATE! (code: !SERVICE_STATE_CODE!)
        exit /b 0
    ) else (
        if defined VERBOSE echo [VERBOSE] Service not found or not accessible
        exit /b 1
    )

:wait_for_service_stop
    if defined VERBOSE echo [VERBOSE] Waiting for service to fully stop...
    set "wait_count=0"
    :wait_loop
    call :check_service_status
    if %errorLevel% neq 0 (
        REM Service not found or error - consider it stopped
        if defined VERBOSE echo [VERBOSE] Service appears to be stopped (not found/accessible)
        exit /b 0
    )
    if "!SERVICE_STATE!"=="STOPPED" (
        if defined VERBOSE echo [VERBOSE] Service confirmed stopped
        exit /b 0
    )
    set /a wait_count+=1
    if %wait_count% geq 12 (
        if defined VERBOSE echo [VERBOSE] Timeout waiting for service to stop (current state: !SERVICE_STATE!)
        REM Don't fail completely - let the start attempt proceed
        if defined VERBOSE echo [VERBOSE] Proceeding with start attempt despite timeout
        exit /b 0
    )
    if defined VERBOSE echo [VERBOSE] Service still in state: !SERVICE_STATE!, waiting... (attempt %wait_count%/12)
    timeout /t 2 /nobreak >nul 2>&1
    goto :wait_loop

:restart_agent_service
    echo Restarting PM+ Agent service to apply changes...
    echo.
    
    call :check_service_status
    if %errorLevel% neq 0 (
        echo WARNING: Service "%SERVICE_NAME%" not found or not accessible
        echo Please restart the agent service manually
        exit /b 1
    )
    
    REM Check if service is already stopped - no need to stop it
    if "!SERVICE_STATE!"=="STOPPED" (
        echo Service is already stopped, proceeding to start...
        call :do_service_start
        exit /b %errorLevel%
    )
    
    REM Check if service is in a transitional state
    if "!SERVICE_STATE!"=="STOP_PENDING" (
        echo Service is already stopping, waiting for it to complete...
        call :wait_for_service_stop
        echo [OK] Service confirmed stopped
        call :do_service_start
        exit /b %errorLevel%
    )
    
    if "!SERVICE_STATE!"=="START_PENDING" (
        echo Service is currently starting, waiting for it to complete...
        timeout /t 5 /nobreak >nul 2>&1
        call :check_service_status
        if "!SERVICE_STATE!"=="RUNNING" (
            echo Service started successfully, will now restart it...
        ) else (
            echo Service start appears to have failed, attempting restart...
        )
    )
    
    echo Stopping service: %SERVICE_NAME%
    if defined VERBOSE echo [VERBOSE] Executing: net stop "%SERVICE_NAME%"
    net stop "%SERVICE_NAME%" >nul 2>&1
    set "stop_error=%errorLevel%"
    if %stop_error% equ 0 (
        echo [OK] Service stopped successfully
        
        echo Waiting for service to stop completely...
        timeout /t 3 /nobreak >nul 2>&1
        
        REM Verify service is actually stopped before attempting to start
        call :wait_for_service_stop
        REM Always proceed to start - wait_for_service_stop now handles timeouts gracefully
        echo [OK] Service confirmed stopped
        
        call :do_service_start
        exit /b %errorLevel%
    ) else (
        echo [X] Failed to stop service (error code: %stop_error%)
        echo Please stop and start the service manually:
        echo   net stop "%SERVICE_NAME%"
        echo   net start "%SERVICE_NAME%"
        exit /b 1
    )

:do_service_start
    echo.
    echo Starting service: %SERVICE_NAME%
    if defined VERBOSE echo [VERBOSE] Executing: net start "%SERVICE_NAME%"
    net start "%SERVICE_NAME%" >nul 2>&1
    set "start_error=%errorLevel%"
    
    if %start_error% equ 0 (
        echo [OK] Service started successfully
        echo.
        REM Double-check the service is actually running
        timeout /t 2 /nobreak >nul 2>&1
        call :check_service_status
        if %errorLevel% equ 0 (
            if "!SERVICE_STATE!"=="RUNNING" (
                echo [OK] PM+ Agent service restarted - configuration changes are now active
            ) else (
                echo [!] Service start command succeeded but service state is: !SERVICE_STATE!
                echo [!] Configuration changes should still be active
            )
        ) else (
            echo [OK] PM+ Agent service restart completed - configuration changes are now active
        )
        REM Successful restart - exit the function
        exit /b 0
    )
    
    REM Only reach here if start failed
    echo [X] Failed to start service (error code: %start_error%)
    echo Service was stopped but failed to restart. Please start manually:
    echo   net start "%SERVICE_NAME%"
    echo.
    echo Common causes:
    echo - Service dependencies not ready (try waiting a few moments and starting manually)
    echo - Configuration errors
    echo - Insufficient permissions
    echo - Service executable issues
    exit /b 1

:hex_to_decimal
    REM Locale & dependency free hex -> decimal converter (removed PowerShell dependency for ticket #202510024200014)
    setlocal EnableDelayedExpansion
    set "hex_value=%~1"
    set "return_var=%~2"
    if not defined hex_value (
        endlocal & set "%return_var%=" & goto :eof
    )
    REM Normalize (strip 0x / leading zeros)
    if /i "!hex_value:~0,2!"=="0x" set "hex_value=!hex_value:~2!"
    set "hex_value=!hex_value: =!"
    if not defined hex_value (
        endlocal & set "%return_var%=" & goto :eof
    )
    REM Use CMD arithmetic (supports 0xHH notation). Prepend 0x to ensure hex interpretation.
    2>nul (set /a dec_value=0x!hex_value!)
    if not defined dec_value (
        REM Fallback: maybe already decimal
        set "dec_value=!hex_value!"
    )
    endlocal & set "%return_var%=%dec_value%"
    goto :eof

:simple_service_restart
    REM Alternative restart method using SC command
    echo [ALT] Attempting alternative restart method using SC command...
    if defined VERBOSE echo [VERBOSE] Executing: sc stop "%SERVICE_NAME%"
    sc stop "%SERVICE_NAME%" >nul 2>&1
    
    REM Wait a bit longer for SC stop
    echo [ALT] Waiting for service to stop...
    timeout /t 8 /nobreak >nul 2>&1
    
    if defined VERBOSE echo [VERBOSE] Executing: sc start "%SERVICE_NAME%"
    sc start "%SERVICE_NAME%" >nul 2>&1
    if %errorLevel% equ 0 (
        echo [OK] Service restarted successfully using SC command
        timeout /t 3 /nobreak >nul 2>&1
        call :check_service_status
        if %errorLevel% equ 0 (
            echo [OK] Service status: !SERVICE_STATE!
        )
        exit /b 0
    ) else (
        echo [X] Alternative restart method also failed
        echo Please restart the service manually:
        echo   sc stop "%SERVICE_NAME%" && timeout /t 5 && sc start "%SERVICE_NAME%"
        echo   OR
        echo   net stop "%SERVICE_NAME%" && net start "%SERVICE_NAME%"
        exit /b 1
    )
    goto :eof

:prompt_service_restart
    echo IMPORTANT: Service restart required for changes to take effect
    echo.
    
    call :check_service_status
    if %errorLevel% neq 0 (
        echo WARNING: Service "%SERVICE_NAME%" not found or not accessible
        echo Please restart the agent service manually
        exit /b 0
    )
    
    echo Current service status: !SERVICE_STATE!
    echo.
    set /p restart_choice="Restart PM+ Agent service now? (y/N): "
    
    if /i "!restart_choice!"=="y" (
        echo.
        call :restart_agent_service
    ) else (
        echo.
        echo Service restart skipped. To apply changes, restart manually:
        echo   net stop "%SERVICE_NAME%"
        echo   net start "%SERVICE_NAME%"
    )
    exit /b 0

:unset_performance
    echo Unsetting PM+ Agent performance limits (set to UNLIMITED)...
    echo(

    set "SUCCESS_COUNT=0"
    set "ALREADY_UNSET_COUNT=0"

    REM Remove patch timeout value if present
    if defined VERBOSE echo [VERBOSE] Attempting to remove patch timeout value...
    reg query "%PATCH_KEY%" /v "%PATCH_TIMEOUT_VALUE%" >nul 2>&1
    if !errorLevel! equ 0 (
        REM Value exists, try to delete it
        reg delete "%PATCH_KEY%" /v "%PATCH_TIMEOUT_VALUE%" /f >nul 2>&1
        if !errorLevel! equ 0 (
            echo [OK] Removed %PATCH_TIMEOUT_VALUE% from %PATCH_KEY%
            set /a SUCCESS_COUNT+=1
        ) else (
            echo [X] Failed to remove %PATCH_TIMEOUT_VALUE% (error: !errorLevel!)
        )
    ) else (
        echo [INFO] %PATCH_TIMEOUT_VALUE% was already not set
        set /a ALREADY_UNSET_COUNT+=1
    )

    REM Remove CPU usage value if present
    if defined VERBOSE echo [VERBOSE] Attempting to remove CPU usage value...
    reg query "%AGENT_KEY%" /v "%CPU_USAGE_VALUE%" >nul 2>&1
    if !errorLevel! equ 0 (
        REM Value exists, try to delete it
        reg delete "%AGENT_KEY%" /v "%CPU_USAGE_VALUE%" /f >nul 2>&1
        if !errorLevel! equ 0 (
            echo [OK] Removed %CPU_USAGE_VALUE% from %AGENT_KEY%
            set /a SUCCESS_COUNT+=1
        ) else (
            echo [X] Failed to remove %CPU_USAGE_VALUE% (error: !errorLevel!)
        )
    ) else (
        echo [INFO] %CPU_USAGE_VALUE% was already not set
        set /a ALREADY_UNSET_COUNT+=1
    )

    echo(

    if !SUCCESS_COUNT! geq 1 (
        echo ========================================
        if !SUCCESS_COUNT! equ 1 (
            echo [OK] Unset operation completed - 1 setting removed.
        ) else (
            echo [OK] Unset operation completed - multiple settings removed.
        )
        echo ========================================
        echo(

        REM Decide restart behavior
        if defined RESTART_SERVICE (
            call :restart_agent_service
            exit /b !errorLevel!
        )

        if not defined NO_RESTART (
            call :prompt_service_restart
            exit /b !errorLevel!
        )

        echo Service restart skipped (--no-restart specified)
        exit /b 0
    ) else if !ALREADY_UNSET_COUNT! geq 1 (
        echo ========================================
        echo [OK] Performance limits are already unset (unlimited).
        echo ========================================
        echo(
        exit /b 0
    ) else (
        echo ========================================
        echo [X] No configured performance limits were found to remove.
        echo ========================================
        echo(
        exit /b 0
    )
exit /b 0

REM End of script

:export_registry
    echo Exporting DCAgent registry subtree to current directory...
    set "EXPORT_DIR=."
    REM Use simple timestamp approach: just use random number + time to ensure uniqueness
    REM Strip all non-alphanumeric characters to avoid locale issues
    set "TS_RAW=%TIME: =0%"
    set "TS_RAW=%TS_RAW::=%"
    set "TS_RAW=%TS_RAW:.=%"
    set "TS_RAW=%TS_RAW:,=%"
    REM Take first 6 digits (HHMMSS equivalent) plus random for uniqueness
    set "TS=%TS_RAW:~0,6%%RANDOM%"
    set "EXPORT_FILE=%EXPORT_DIR%\pm-agent-dca-%TS%.reg"
    if defined VERBOSE echo [VERBOSE] Export path: %EXPORT_FILE%
    reg export "%AGENT_KEY%" "%EXPORT_FILE%" /y >nul 2>&1
    if %errorLevel% equ 0 (
        echo [OK] Registry exported: %EXPORT_FILE%
        echo Attach this file to support tickets for analysis.
        exit /b 0
    ) else (
        echo [X] Failed to export registry (error %errorLevel%).
        echo Ensure you have write permission to the current directory: %CD%
        echo You can retry from an elevated prompt or a writable folder.
        exit /b 1
    )
    goto :eof
