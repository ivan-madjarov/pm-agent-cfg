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

### Windows Registry Configuration Tool [PRODUCTION-READY v3.2]
**Zero-dependency solution** for configuring DesktopCentral DCAgent registry settings:
- **Standalone Batch Script** - works on any Windows machine (no Python/PowerShell required)
- **Enhanced Interactive Menu** - professional interface with menu relist functionality (option 0)
- **Multiple Interfaces** - command-line AND interactive menu in one tool
- **Performance Modes** - Low (15% CPU), Medium (20% CPU), High (30% CPU), Ultra (40% CPU)
- **Built-in Security** - administrator privilege checking and validation
- **Status Display** - view current registry configurations with decimal values and comprehensive service status
- **Status Summary** - concise `Performance Mode (summary): low|medium|high|ultra|unset|custom` line for quick identification
- **Intelligent Service Management** - enhanced restart logic with state verification and error recovery
- **Registry Diagnostics** - built-in registry access testing and troubleshooting (option 8)
- **Registry Export** - export DCAgent registry subtree for support (Batch: `--export` exits after creating `pm-agent-dca-<HHMMSS><RANDOM>.reg`; PowerShell: `-Export` creates `pm-agent-dca-YYYYMMDDHHmmss.reg` and returns to menu)
- **Enhanced Error Handling** - improved permission error handling with value verification
- **Command Options** - --restart/--no-restart flags for automated deployments
- **Single File Deployment** - copy `pm-agent-config.bat` and run (13KB)
- **Production Reliability** - comprehensive error handling and service restart verification
- **Menu Navigation** - option 0 to redisplay menu for improved usability

**Bonus**: PowerShell version with full interactive menu system matching batch script functionality.

### Linux JSON Configuration Tool [PRODUCTION-READY v3.1]
**Zero-dependency solution** for configuring DesktopCentral UEMS Agent performance settings:
- **Shell Script** - pure bash with no external dependencies
- **Enhanced Interactive Menu** - professional interface with clear screen functionality
- **Multiple Interfaces** - command-line AND interactive menu modes
- **Performance Modes** - Low (15% CPU), Medium (20% CPU), High (30% CPU), Ultra (40% CPU)
- **Built-in Security** - root privilege checking and automatic backups
- **Status Display** - view current JSON configurations and comprehensive service status
- **Status Summary** - concise `Performance Mode (summary): low|medium|high|ultra|unset|custom` line for quick identification
- **Config Collection** - `--status` reveals path to `PerformanceSettings.json` so you can copy it for support
- **Intelligent Service Management** - enhanced restart logic with multi-service detection
- **Command Options** - --restart/--no-restart flags for automated deployments
- **Single File Deployment** - copy `pm-agent-config.sh` and run
- **Production Reliability** - comprehensive service state management and error recovery

See platform-specific guides:
- [Windows Configuration Guide](docs/windows-guide.md) **Available**
- [Linux Configuration Guide](docs/linux-guide.md) **Available**

## Project Structure

```
pm-agent-cfg/
├── .github/               # GitHub templates and CI/CD workflows
│   ├── workflows/         # Automated testing and validation
│   └── ISSUE_TEMPLATE/    # Issue and PR templates
├── scripts/               # Main configuration tools
│   ├── linux/             # pm-agent-config.sh (Linux JSON config)
│   └── windows/           # pm-agent-config.bat/.ps1 (Windows Registry)
├── docs/                  # Platform-specific documentation
│   ├── linux-guide.md     # Linux configuration guide
│   └── windows-guide.md   # Windows configuration guide
├── CHANGELOG.md           # Version history
├── CONTRIBUTING.md        # Development guidelines
├── DEPLOYMENT.md          # Deployment instructions
├── SECURITY.md            # Security policy
├── LICENSE                # Mitel proprietary license
└── README.md              # This file
```

## Platform Support

- **Linux**: CentOS, Ubuntu, RHEL, Debian (any modern distribution)
- **Windows**: Windows Server 2019+, Windows 10+ (any edition)

## Architecture

This project provides **zero-dependency, single-file solutions** for both platforms:

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

### Windows Registry Configuration [READY]
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

### Linux JSON Configuration [READY]
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
- [OK] Windows 7+ (any edition)
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
- [Windows Registry Configuration](docs/windows-guide.md) [AVAILABLE]
- [Linux JSON Configuration](docs/linux-guide.md) [AVAILABLE]

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

