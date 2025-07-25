# Windows PM Agent Registry Configuration Tool

This tool configures DesktopCentral DCAgent registry settings with selectable performance options.

## 🚀 **NEW: Standalone Versions Available!**

**No Python Required!** Choose from multiple deployment options:

### ✅ **Recommended: Pure Batch Script**
- **Zero dependencies** - runs on any Windows machine
- **Single file deployment** - just copy and run
- **Full command-line interface** with help and status
- **File**: `scripts/windows/pm-agent-config.bat`

### ✅ **Alternative: Compiled Executable**  
- **Standalone EXE file** - no runtime dependencies
- **Professional appearance** with version info
- **Requires Administrator** privileges (built-in UAC prompt)
- **Build from**: `scripts/windows/pm-agent-config.ps1`

## Features

- **Performance Mode Selection**: Choose between low (15% CPU) and high (30% CPU) performance modes
- **Registry Configuration**: Automatically configures both patch scan timeout and CPU usage limits
- **Multiple Interfaces**: Command-line, PowerShell, and interactive menu options
- **Administrator Check**: Ensures proper permissions before making changes
- **Current Settings Display**: View existing registry configurations

## Registry Settings Configured

### Patch Scan Timeout
- **Path**: `HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\AdventNet\DesktopCentral\DCAgent\Patch`
- **Value**: `Patch_scan_timeout` (DWORD)
- **Data**: `200` (seconds)

### Thread Max CPU Usage
- **Path**: `HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\AdventNet\DesktopCentral\DCAgent`
- **Value**: `THRDMAXCPUUSAGE_2C` (DWORD)
- **Data**: 
  - Low Performance: `15` (15% CPU usage)
  - High Performance: `30` (30% CPU usage)

## Usage Options

### 🎯 **Option 1: Standalone Batch Script (RECOMMENDED)**

**Zero dependencies - works on any Windows machine!**

```batch
# Navigate to the scripts directory
cd scripts\windows

# Configure for high performance
pm-agent-config.bat --mode high

# Configure for low performance
pm-agent-config.bat --mode low

# Show current settings
pm-agent-config.bat --status

# Show help
pm-agent-config.bat --help
```

**Features:**
- ✅ No Python, PowerShell, or other dependencies
- ✅ Single file deployment (just copy the .bat file)
- ✅ Full command-line interface
- ✅ Works on Windows 7+ through Windows 11
- ✅ Verbose mode available with `--verbose`

### 🎯 **Option 2: Compiled Executable**

**Professional standalone EXE with UAC integration:**

```batch
# First, build the executable (one-time setup)
cd scripts\windows
powershell -ExecutionPolicy Bypass .\build-exe.ps1

# Then use the compiled EXE
pm-agent-config.exe -Mode high
pm-agent-config.exe -Mode low
pm-agent-config.exe -Status
```

**Build Requirements:**
- PowerShell 5.1+ (for building only)
- `ps2exe` module: `Install-Module ps2exe`

**Runtime Requirements:**
- ✅ None! Fully standalone EXE

### 🔧 **Option 3: Interactive Menu (Simple)**
**For users who prefer point-and-click:**

```batch
# Double-click or run from command prompt
configure-agent-menu.bat
```

### 🔧 **Option 4: PowerShell Script (IT Admins)**
```powershell
# Configure for high performance
.\configure-agent.ps1 -Mode high

# Configure for low performance
.\configure-agent.ps1 -Mode low

# Show current settings
.\configure-agent.ps1 -Status

# Show help
.\configure-agent.ps1 -Help
```

### 🔧 **Option 5: Python Script (Advanced - Requires Python)**
```bash
# Configure for high performance
python registry_config.py --mode high

# Configure for low performance
python registry_config.py --mode low

# Show current settings
python registry_config.py --status

# Verbose output
python registry_config.py --mode high --verbose
```

## Performance Modes

| Mode | CPU Usage Limit | Patch Scan Timeout | Use Case |
|------|----------------|-------------------|----------|
| **Low** | 15% | 200 seconds | Production servers, minimal impact |
| **High** | 30% | 200 seconds | Workstations, faster processing |

## Requirements

### All Methods
- **Administrator privileges** (required for registry modification)
- **DesktopCentral DCAgent** installed

### PowerShell Script
- **PowerShell 5.1+** (included with Windows 10/Server 2016+)

### Python Script
- **Python 3.6+** installed and in PATH
- **winreg module** (included with Python on Windows)

## Installation & Setup

1. **Download/Clone** the repository
2. **Navigate** to the `scripts/windows/` directory
3. **Run as Administrator**:
   - For interactive use: Double-click `configure-agent-menu.bat`
   - For PowerShell: Open PowerShell as Admin, run `.\configure-agent.ps1`
   - For Python: Open Command Prompt as Admin, run `python ../../src/windows/registry_config.py`

## Service Restart

After configuration changes, you may need to restart the DCAgent service:

### Using PowerShell
```powershell
Restart-Service 'DCAgent' -Force
```

### Using Command Prompt
```batch
net stop DCAgent
net start DCAgent
```

### Using Services GUI
1. Press `Win + R`, type `services.msc`
2. Find "DCAgent" service
3. Right-click → Restart

## Troubleshooting

### "Access Denied" Error
- Ensure you're running as Administrator
- Check if DCAgent service is running and accessible

### "Registry Key Not Found"
- Verify DesktopCentral DCAgent is installed
- Check if the software is the correct version (WOW6432Node indicates 32-bit on 64-bit Windows)

### Python Not Found
- Install Python 3.6+ from python.org
- Add Python to system PATH during installation
- Verify with `python --version` in Command Prompt

### PowerShell Execution Policy
If PowerShell script won't run:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Files Structure

```
scripts/windows/
├── configure-agent.ps1           # PowerShell script with full features
├── configure-agent-menu.bat      # Simple interactive menu
└── README.md                     # This documentation

src/windows/
└── registry_config.py            # Python implementation
```

## Examples

### Quick Configuration
```batch
# Run the menu version for simple setup
configure-agent-menu.bat
# Select option 1 (Low) or 2 (High)
```

### Automated Deployment
```powershell
# Configure multiple machines for low performance
.\configure-agent.ps1 -Mode low

# Restart service
Restart-Service 'DCAgent' -Force
```

### Check Current Configuration
```powershell
# Display current settings
.\configure-agent.ps1 -Status
```

## Security Notes

- **Administrator rights required**: All tools require elevated privileges to modify registry
- **Service impact**: Changes may require DCAgent service restart
- **Backup recommended**: Consider backing up registry keys before modification
- **Testing**: Test configuration changes in a non-production environment first
