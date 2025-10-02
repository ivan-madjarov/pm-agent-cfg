# Windows Registry Configuration Tool

**Zero-dependency solution for configuring DesktopCentral DCAgent registry settings.**

> **[!] CRITICAL REQUIREMENT [!]**  
> **THIS TOOL MUST BE RUN AS ADMINISTRATOR**
> 
> **How to run as Administrator:**
> 1. Right-click **Command Prompt** → "Run as administrator"
> 2. OR Right-click **PowerShell** → "Run as administrator"
> 3. Navigate to script location and run the tool
> 4. **The tool will FAIL without Administrator privileges!**

## **The Solution**

A single, comprehensive tool that configures PM+ Agent registry settings with **no external dependencies**. Choose your preferred interface:

### [READY] **Primary Tool: Standalone Batch Script**
**File**: `scripts/windows/pm-agent-config.bat`

**Why This is Perfect:**
- [READY] **Zero Dependencies** - works on any Windows machine (7 through 11)
- [READY] **Single File** - just copy and run (10KB)
- [READY] **Multiple Interfaces** - command-line AND interactive menu
- [READY] **Built-in Security** - administrator privilege checking
- [READY] **Status Display** - shows current configuration with decimal values and comprehensive service status
- [READY] **Professional Help** - comprehensive documentation

## **Quick Start**

> **[!] ADMINISTRATOR PRIVILEGES REQUIRED [!]**  
> **ALL commands below require Administrator privileges!**
> **Open Command Prompt or PowerShell as Administrator before running any commands.**

### Command-Line Usage (IT Professionals)
```batch
# IMPORTANT: Run Command Prompt as Administrator first!
# Configure for high performance (30% CPU)
pm-agent-config.bat --mode high

# Configure for medium performance (20% CPU)
pm-agent-config.bat --mode medium

# Configure for low performance (15% CPU)  
pm-agent-config.bat --mode low

# Configure for ultra performance (40% CPU)
pm-agent-config.bat --mode ultra

# Remove configured limits (set to unlimited)
pm-agent-config.bat --mode unset

# Show current settings
pm-agent-config.bat --status

# Export registry (troubleshooting)
pm-agent-config.bat --export

# Interactive menu
pm-agent-config.bat --menu
```

Legacy alias: Older versions (<= v1.5.0) documented a separate `--unset` flag. For backward compatibility the batch script still accepts `--unset`, but the unified and preferred form is `--mode unset`.

### Status Output Enhancements (v1.6.0)
When you run either `pm-agent-config.bat --status` or choose menu option 5, the tool now prints a concise summary line:

```
Performance Mode (summary): low
```

Possible values: `low`, `medium`, `high`, `ultra`, `unset`, or `custom` (if a non-standard CPU value is detected). The detailed legacy lines (Patch Scan Timeout, Thread Max CPU Usage, and the colorized descriptive mode line) remain for full context.

### Interactive Menu (End Users)
```batch
# IMPORTANT: Run Command Prompt as Administrator first!
# Run the interactive menu
pm-agent-config.bat --menu

# Follow the on-screen prompts:
# 0. Show Menu Options (refresh menu display)
# 1. Low Performance Mode    (15% CPU, 200s timeout)
# 2. Medium Performance Mode (20% CPU, 200s timeout)
# 3. High Performance Mode   (30% CPU, 200s timeout)
# 4. Ultra Performance Mode  (40% CPU, 200s timeout)
# 5. Show Current Settings and Service Status
# 6. Restart PM+ Agent Service
# 7. Unset Performance Limits (set to UNLIMITED)
# 8. Test Registry Access (Debug)
# 9. Export Registry Settings (Troubleshooting)
# 10. Exit
```

### Elevated Console Usage
When using the batch script, always start an elevated Command Prompt first and run the script from there. This ensures all registry modifications and service operations can be performed properly.

## **CONFIGURATION DETAILS**

### Registry Settings Modified

#### Patch Scan Timeout
- **Path**: `HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\AdventNet\DesktopCentral\DCAgent\Patch`
- **Value**: `Patch_scan_timeout` (DWORD)
- **Data**: `200` seconds (all modes)

#### CPU Usage Limit  
- **Path**: `HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\AdventNet\DesktopCentral\DCAgent`
- **Value**: `THRDMAXCPUUSAGE_2C` (DWORD)
- **Data**: 
  - **Low Performance**: `15` (15% CPU)
  - **Medium Performance**: `20` (20% CPU)
  - **High Performance**: `30` (30% CPU)
  - **Ultra Performance**: `40` (40% CPU)

### Performance Modes

| Mode | CPU Limit | Use Case | When to Use |
|------|-----------|----------|-------------|
| **Low** | 15% | Production servers | Minimal system impact, background operation |
| **Medium** | 20% | Mixed workloads | Balanced performance for general use |
| **High** | 30% | Workstations | Faster processing, acceptable CPU usage |
| **Ultra** | 40% | High-performance needs | Maximum throughput, use with caution |
| **Unset** | Unlimited | Remove limits | Agent defaults (use with extreme caution) |

## **ADVANCED OPTIONS**

### [READY] **Option 2: Compiled Executable (Optional)**

For organizations requiring a professional executable:

**File**: `scripts/windows/pm-agent-config.ps1` (source)  
**Build**: `scripts/windows/build-exe.ps1` (compiler)

```powershell
# Build the EXE (one-time setup)
.\build-exe.ps1

# Use the compiled executable
pm-agent-config.exe -Mode high
pm-agent-config.exe -Status
```

**Features:**
- Professional EXE with version info
- UAC integration for administrator privileges
- Standalone deployment (~1-2MB)
- Identical functionality to batch script

## 📋 **Requirements**

### All Options
- [OK] **Windows 7+** (including Windows 10, 11, Server editions)
- [CRITICAL] **Administrator privileges** (for registry modification)
- [OK] **DesktopCentral DCAgent** installed

### Batch Script (Primary)
- [OK] **No additional requirements** - uses built-in Windows commands

### Compiled EXE (Optional)
- **Build Requirements**: PowerShell 5.1+, `ps2exe` module
- **Runtime Requirements**: None (fully standalone)

## **DEPLOYMENT GUIDE**

### Simple Deployment (Recommended)
1. **Copy** `pm-agent-config.bat` to target machines
2. **Run as Administrator** or use right-click "Run as administrator"
3. **Choose mode** using `--mode high` or `--mode low`

### Enterprise Deployment
```batch
# Automated deployment script
pm-agent-config.bat --mode low --verbose

# Restart DCAgent service
net stop DCAgent
net start DCAgent
```

### Group Policy Deployment
1. Copy `pm-agent-config.bat` to a network share
2. Create GPO with startup script:
   ```batch
   \\server\share\pm-agent-config.bat --mode low
   ```

## 🔍 **Troubleshooting**

### Common Issues

#### "Administrator privileges required"
**Solution**: Run as Administrator
- Right-click Command Prompt → "Run as administrator"
- Or right-click the batch file → "Run as administrator"

#### "Registry key not found"
**Cause**: DesktopCentral DCAgent not installed or wrong version  
**Solution**: 
1. Use **Option 8 (Test Registry Access)** to diagnose registry access issues
2. Verify DCAgent installation and version
3. Check if registry paths exist manually

#### Registry Access Testing
**New Feature**: Use **Menu Option 8 - Test Registry Access (Debug)** to:
- Verify registry key accessibility
- Display exact registry paths being used
- Diagnose permission or installation issues
- Confirm DCAgent registry structure

#### Settings not taking effect
**Solution**: Restart DCAgent service
```batch
net stop DCAgent
net start DCAgent
```

### Verification
```batch
# Check current configuration
pm-agent-config.bat --status

# Export registry (creates a .reg file in %TEMP%)
pm-agent-config.bat --export

# Verify registry directly
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\AdventNet\DesktopCentral\DCAgent" /v "THRDMAXCPUUSAGE_2C"

# Export registry subtree (timestamped .reg file in %TEMP%)
pm-agent-config.bat --export
```

## 📁 **File Organization**

```
scripts/windows/
+-- pm-agent-config.bat         # [PRIMARY] Primary tool (use this!)
+-- pm-agent-config.ps1         # Source for EXE compilation
+-- build-exe.ps1              # EXE build script
```

## 🎯 **Summary**

**Use `pm-agent-config.bat` for everything!**

- [READY] **Zero dependencies** - works everywhere
- [READY] **Command-line AND menu** - fits all users
- [READY] **Professional features** - status, help, verbose logging
- [READY] **Single file deployment** - copy and run
- [READY] **Comprehensive solution** - no need for multiple tools

This replaces all previous Windows tools with one superior solution.
