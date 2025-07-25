# Windows Registry Configuration Tool

**Zero-dependency solution for configuring DesktopCentral DCAgent registry settings.**

## 🎯 **The Solution**

A single, comprehensive tool that configures PM+ Agent registry settings with **no external dependencies**. Choose your preferred interface:

### ✅ **Primary Tool: Standalone Batch Script**
**File**: `scripts/windows/pm-agent-config.bat`

**Why This is Perfect:**
- 🚀 **Zero Dependencies** - works on any Windows machine (7 through 11)
- 📦 **Single File** - just copy and run (10KB)
- 🎮 **Multiple Interfaces** - command-line AND interactive menu
- 🔒 **Built-in Security** - administrator privilege checking
- 📊 **Status Display** - shows current configuration
- 🔧 **Professional Help** - comprehensive documentation

## 🚀 **Quick Start**

### Command-Line Usage (IT Professionals)
```batch
# Configure for high performance (30% CPU)
pm-agent-config.bat --mode high

# Configure for low performance (15% CPU)  
pm-agent-config.bat --mode low

# Show current settings
pm-agent-config.bat --status

# Interactive menu
pm-agent-config.bat --menu
```

### Interactive Menu (End Users)
```batch
# Run the interactive menu
pm-agent-config.bat --menu

# Follow the on-screen prompts:
# 1. Low Performance Mode  (15% CPU, 200s timeout)
# 2. High Performance Mode (30% CPU, 200s timeout)
# 3. Show Current Settings
# 4. Exit
```

### Double-Click Usage
Simply double-click `pm-agent-config.bat` to launch the interactive menu.

## ⚙️ **What It Configures**

### Registry Settings Modified

#### Patch Scan Timeout
- **Path**: `HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\AdventNet\DesktopCentral\DCAgent\Patch`
- **Value**: `Patch_scan_timeout` (DWORD)
- **Data**: `200` seconds (both modes)

#### CPU Usage Limit  
- **Path**: `HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\AdventNet\DesktopCentral\DCAgent`
- **Value**: `THRDMAXCPUUSAGE_2C` (DWORD)
- **Data**: 
  - **Low Performance**: `15` (15% CPU)
  - **High Performance**: `30` (30% CPU)

### Performance Modes

| Mode | CPU Limit | Use Case | When to Use |
|------|-----------|----------|-------------|
| **Low** | 15% | Production servers | Minimal system impact, background operation |
| **High** | 30% | Workstations | Faster processing, acceptable CPU usage |

## 🔧 **Advanced Options**

### ✅ **Option 2: Compiled Executable (Optional)**

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
- ✅ **Windows 7+** (including Windows 10, 11, Server editions)
- ✅ **Administrator privileges** (for registry modification)
- ✅ **DesktopCentral DCAgent** installed

### Batch Script (Primary)
- ✅ **No additional requirements** - uses built-in Windows commands

### Compiled EXE (Optional)
- **Build Requirements**: PowerShell 5.1+, `ps2exe` module
- **Runtime Requirements**: None (fully standalone)

## 🚀 **Deployment Guide**

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
**Solution**: Verify DCAgent installation and version

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

# Verify registry directly
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\AdventNet\DesktopCentral\DCAgent" /v "THRDMAXCPUUSAGE_2C"
```

## 📁 **File Organization**

```
scripts/windows/
├── pm-agent-config.bat         # 🎯 Primary tool (use this!)
├── pm-agent-config.ps1         # Source for EXE compilation
└── build-exe.ps1              # EXE build script

src/windows/
├── README.md                   # This documentation
└── (no Python files!)         # ✅ Python dependency removed

config/windows/
└── agent.conf                 # Configuration reference
```

## 🎯 **Summary**

**Use `pm-agent-config.bat` for everything!**

- ✅ **Zero dependencies** - works everywhere
- ✅ **Command-line AND menu** - fits all users
- ✅ **Professional features** - status, help, verbose logging
- ✅ **Single file deployment** - copy and run
- ✅ **Comprehensive solution** - no need for multiple tools

This replaces all previous Windows tools with one superior solution.
