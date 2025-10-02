# PM+ Agent Configuration

**Mitel Networks Corporation - Customer Deployment Tool**

Cross-platform agent configuration management system supporting both Linux and Windows environments for Mitel's PM+ (Performance Monitoring Plus) infrastructure. Designed for deployment in both Mitel and customer environments with enterprise-grade reliability.

> **[!] CRITICAL REQUIREMENT [!]**  
> **ALL CONFIGURATION SCRIPTS MUST BE EXECUTED WITH ELEVATED PRIVILEGES**
> - **Windows**: Start **Command Prompt** or **PowerShell** as Administrator, then run scripts
> - **Linux**: Use `sudo` for elevated privileges (or run as root if available)
> 
> **These tools modify system registry/configuration files and will fail without proper elevation!**

## Current Features

### Windows Registry Configuration Tool (v1.6.x)
Key capabilities:
- Standalone Batch Script (zero external dependencies)
- Interactive menu with reliable looping (option 0 re-lists menu)
- Performance modes: low (15%), medium (20%), high (30%), ultra (40%), unset
- Export (Batch: `--export` / menu 9) creates `pm-agent-dca-<HHMMSS><RANDOM>.reg` and then exits intentionally
- Export (PowerShell: `-Export` or `--export` / menu 9) creates `pm-agent-dca-YYYYMMDDHHmmss.reg` and stays in session
- Registry diagnostics (menu option 8) to validate key accessibility
- Unified status summary line: `Performance Mode (summary): <mode>`
- Intelligent service restart prompts and error handling
- Supports both native PowerShell parameter syntax and GNU-style double-dash flags (e.g. `--mode high`, `--export`)

### Linux JSON Configuration Tool (v1.6.x parity)
Key capabilities:
- Pure bash script (no jq required; jq optional for pretty print)
- Interactive menu with refresh (option 0)
- Same performance modes + unset parity
- Safe JSON modification with automatic backup & restore
- Status output includes summary line and service detection
- Designed for automation with flags (`--mode`, `--status`, `--restart`, `--no-restart`)

**PowerShell Companion**: Provides identical functional surface to batch (except batch exits after export; PowerShell does not) and now supports GNU-style `--flags` for operator muscle memory consistency.

See platform-specific guides:
- [Windows Configuration Guide](docs/windows-guide.md)
- [Linux Configuration Guide](docs/linux-guide.md)

## Project Structure

```
pm-agent-cfg/
├── scripts/
│   ├── windows/                 # pm-agent-config.bat / pm-agent-config.ps1
│   └── linux/                   # pm-agent-config.sh
├── docs/
│   ├── windows-guide.md
│   └── linux-guide.md
├── CHANGELOG.md
├── README.md
├── SECURITY.md
├── CONTRIBUTING.md
└── LICENSE
```

## Architecture


### Windows Implementation
- **Method**: Direct Windows Registry manipulation
- **Technology**: Pure Windows Batch scripting + optional PowerShell
- **Dependencies**: None (uses built-in Windows commands only)
- **Target**: `HKLM\SOFTWARE\AdventNet\DesktopCentral\DCAgent\*`

### Linux Implementation  
- **Method**: JSON configuration file management
- **Technology**: Pure Bash scripting with built-in JSON handling
- **Dependencies**: None (pure bash, optional jq for pretty printing)
- **Target**: `/usr/local/manageengine/uems_agent/data/PerformanceSettings.json`

Both implementations provide identical user experiences while using platform-appropriate configuration methods.

## Getting Started

> **[KEY] ADMINISTRATIVE PRIVILEGES REQUIRED [KEY]**  
> All commands below must be executed with elevated privileges:
> - **Windows**: Open Command Prompt as Administrator
> - **Linux**: Use sudo or run as root

### Windows Registry Configuration
**One tool, multiple ways to use it:**

#### Option 1: Command-Line (IT Professionals)
```batch
# IMPORTANT: Run Command Prompt as Administrator first!
cd scripts\windows
pm-agent-config.bat --mode high     # 30% CPU limit
pm-agent-config.bat --mode medium   # 20% CPU limit  
pm-agent-config.bat --mode low      # 15% CPU limit
pm-agent-config.bat --mode ultra    # 40% CPU limit
pm-agent-config.bat --mode unset    # Remove limits (set to unlimited)
pm-agent-config.bat --status        # Show current settings
```

#### Option 2: Interactive Menu (End Users)
```batch
# IMPORTANT: Run Command Prompt as Administrator first!
cd scripts\windows
pm-agent-config.bat --menu
# Enhanced interactive menu with relist functionality:
# - Enter "0" to redisplay menu options when screen gets cluttered
# - Perfect for multiple consecutive operations
# - Professional user interface with clear navigation
```

#### Option 3: Double-Click (Simplest)
**IMPORTANT**: Right-click `pm-agent-config.bat` → "Run as administrator" to launch the interactive menu.

### Linux JSON Configuration
**Comprehensive shell script with multiple interfaces:**

#### Option 1: Command-Line (IT Professionals)
```bash
# IMPORTANT: Use sudo or run as root!
cd scripts/linux
sudo ./pm-agent-config.sh --mode high     # 30% CPU limit
sudo ./pm-agent-config.sh --mode medium   # 20% CPU limit
sudo ./pm-agent-config.sh --mode low      # 15% CPU limit
sudo ./pm-agent-config.sh --mode ultra    # 40% CPU limit
sudo ./pm-agent-config.sh --mode unset    # Remove limits (set to unlimited)
sudo ./pm-agent-config.sh --status        # Show current settings
```

#### Option 2: Interactive Menu (End Users)
```bash
# IMPORTANT: Use sudo or run as root!
cd scripts/linux
sudo ./pm-agent-config.sh --menu
# Enhanced interactive menu with refresh functionality:
# - Enter "0" to refresh/redisplay menu options
# - Automatic screen clearing for clean interface
# - Professional user experience with clear navigation
```

#### Option 3: Default Behavior
```bash
# IMPORTANT: Use sudo or run as root!
sudo ./pm-agent-config.sh
# Launches interactive menu by default
```

### Performance Modes (Both Platforms)
- **Low Performance**: 15% CPU usage limit (ideal for production servers)
- **Medium Performance**: 20% CPU usage limit (balanced workloads)
- **High Performance**: 30% CPU usage limit (ideal for workstations)
- **Ultra Performance**: 40% CPU usage limit (maximum throughput)
- **Unset**: Remove configured limits (set to unlimited - use with caution)

### Requirements

> **[!] ELEVATION REQUIRED [!]**  
> **BOTH PLATFORMS REQUIRE ELEVATED PRIVILEGES - NON-NEGOTIABLE!**

#### Windows
- Windows 10 / Windows Server 2019+ (earlier versions may work but are not primary targets)
- **[CRITICAL]**: Administrator privileges (Run as Administrator)
- [OK] DesktopCentral DCAgent installed
- [OK] **That's it!** No Python, PowerShell modules, or other dependencies

#### Linux
- [OK] Linux (CentOS, Ubuntu, RHEL, Debian)
- **[CRITICAL]**: Root/sudo privileges (must run with sudo)
- [OK] DesktopCentral UEMS Agent installed
- [OK] **That's it!** No external dependencies (pure bash)

**Advanced**: Optional EXE compilation available for Windows professional deployment packages.

See detailed platform documentation:
- [Windows Registry Configuration](docs/windows-guide.md)
- [Linux JSON Configuration](docs/linux-guide.md)

## Development

### Prerequisites
- Git
- Basic shell environment (bash for Linux, Command Prompt/PowerShell for Windows)
- Text editor for script modifications (optional)

### Building
- Linux: `./scripts/linux/build.sh` (creates executable and copies to dist/)
- Windows: `.\scripts\windows\build-exe.ps1` (optional - compiles PowerShell to EXE)

### Usage Guidelines
**IMPORTANT**: This tool is proprietary to Mitel Networks Corporation and is intended for use by authorized Mitel personnel and designated partners in both Mitel and customer environments. Follow all applicable security policies and change management procedures.

### Customer Environment Considerations
- **Change Management**: Obtain proper change approvals before deployment
- **Security Compliance**: Ensure tool usage meets customer compliance requirements
- **Documentation**: Maintain audit trail of configuration changes
- **Access Controls**: Respect customer identity and access management policies

### Usage Testing
- Linux: Test with `sudo ./scripts/linux/pm-agent-config.sh --help`
- Windows: **Run Command Prompt as Administrator**, then test with `.\scripts\windows\pm-agent-config.bat --help`
- Both platforms: Use `--dry-run` flag to preview changes without applying them (Linux only)

The scripts are self-contained and require no external dependencies beyond the target platform's built-in shell capabilities.

## Deployment

**IMPORTANT**: This is proprietary Mitel software. Deploy within authorized Mitel infrastructure and customer environments following all applicable security policies, change management procedures, and compliance requirements.

> **[!] DEPLOYMENT CRITICAL REQUIREMENT [!]**  
> **ALL DEPLOYMENTS MUST ENSURE ELEVATED PRIVILEGE EXECUTION**
> - Windows: Ensure scripts run "As Administrator"
> - Linux: Ensure scripts run with sudo/root privileges
> - **Deployment will fail without proper elevation!**

### Single Server Deployment
Copy the appropriate script to your target system and run with proper privileges:

#### Windows
```batch
# Copy pm-agent-config.bat to target Windows server
# CRITICAL: Open Command Prompt as Administrator
# Run with administrator privileges
pm-agent-config.bat --mode high
```

#### Linux  
```bash
# Copy pm-agent-config.sh to target Linux server
# CRITICAL: Run with sudo privileges
sudo ./pm-agent-config.sh --mode high
```

### Bulk Deployment
Use your preferred configuration management system (Ansible, Puppet, etc.) or simple shell loops to deploy to multiple systems. Both tools support automation through command-line arguments.

### Customer Environment Deployment
- **Pre-Deployment**: Coordinate with customer security teams and obtain proper approvals
- **Change Windows**: Follow customer change management processes
- **Documentation**: Provide configuration change documentation to customer
- **Validation**: Verify changes meet customer requirements and security standards

