# PM+ Agent Configuration

Cross-platform agent configuration management system supporting both Linux and Windows environments.

## Current Features

### Windows Registry Configuration Tool ✅
**Zero-dependency solution** for configuring DesktopCentral DCAgent registry settings:
- 🚀 **Standalone Batch Script** - works on any Windows machine (no Python/PowerShell required)
- 🎮 **Multiple Interfaces** - command-line AND interactive menu in one tool
- ⚙️ **Performance Modes** - Low (15% CPU), Medium (20% CPU), High (30% CPU), Ultra (40% CPU)
- 🔒 **Built-in Security** - administrator privilege checking and validation
- 📊 **Status Display** - view current registry configurations and service status
- � **Service Management** - automatic agent service restart with --restart/--no-restart options
- �📦 **Single File Deployment** - copy `pm-agent-config.bat` and run (10KB)

**Bonus**: Optional PowerShell-to-EXE compilation for professional deployment packages.

### Linux JSON Configuration Tool ✅
**Zero-dependency solution** for configuring DesktopCentral UEMS Agent performance settings:
- 🚀 **Shell Script** - pure bash with no external dependencies
- 🎮 **Multiple Interfaces** - command-line AND interactive menu modes
- ⚙️ **Performance Modes** - Low (15% CPU), Medium (20% CPU), High (30% CPU), Ultra (40% CPU)
- 🔒 **Built-in Security** - root privilege checking and automatic backups
- 📊 **Status Display** - view current JSON configurations and service status
- 🔄 **Service Management** - intelligent service restart with --restart/--no-restart options
- 📦 **Single File Deployment** - copy `pm-agent-config.sh` and run

See platform-specific guides:
- [Windows Configuration Guide](docs/windows-guide.md) ✅ **Available**
- [Linux Configuration Guide](docs/linux-guide.md) ✅ **Available**

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
├── LICENSE                # MIT license
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

### Windows Registry Configuration ✅
**One tool, multiple ways to use it:**

#### Option 1: Command-Line (IT Professionals)
```batch
cd scripts\windows
pm-agent-config.bat --mode high    # 30% CPU limit
pm-agent-config.bat --mode low     # 15% CPU limit
pm-agent-config.bat --status       # Show current settings
```

#### Option 2: Interactive Menu (End Users)
```batch
cd scripts\windows
pm-agent-config.bat --menu
# Follow the numbered menu prompts
```

#### Option 3: Double-Click (Simplest)
Just double-click `pm-agent-config.bat` to launch the interactive menu.

### Linux JSON Configuration ✅
**Comprehensive shell script with multiple interfaces:**

#### Option 1: Command-Line (IT Professionals)
```bash
cd scripts/linux
sudo ./pm-agent-config.sh --mode high    # 30% CPU limit
sudo ./pm-agent-config.sh --mode low     # 15% CPU limit
sudo ./pm-agent-config.sh --status       # Show current settings
```

#### Option 2: Interactive Menu (End Users)
```bash
cd scripts/linux
sudo ./pm-agent-config.sh --menu
# Follow the numbered menu prompts
```

#### Option 3: Default Behavior
```bash
sudo ./pm-agent-config.sh
# Launches interactive menu by default
```

### Performance Modes (Both Platforms)
- **Low Performance**: 15% CPU usage limit (ideal for production servers)
- **Medium Performance**: 20% CPU usage limit (balanced workloads)
- **High Performance**: 30% CPU usage limit (ideal for workstations)
- **Ultra Performance**: 40% CPU usage limit (maximum throughput)

### Requirements

#### Windows
- ✅ Windows 7+ (any edition)
- ✅ Administrator privileges
- ✅ DesktopCentral DCAgent installed
- ✅ **That's it!** No Python, PowerShell modules, or other dependencies

#### Linux
- ✅ Linux (CentOS, Ubuntu, RHEL, Debian)
- ✅ Root/sudo privileges
- ✅ DesktopCentral UEMS Agent installed
- ✅ **That's it!** No external dependencies (pure bash)

**Advanced**: Optional EXE compilation available for Windows professional deployment packages.

See detailed platform documentation:
- [Windows Registry Configuration](docs/windows-guide.md) ✅ **Available**
- [Linux JSON Configuration](docs/linux-guide.md) ✅ **Available**

## Development

### Prerequisites
- Git
- Basic shell environment (bash for Linux, Command Prompt/PowerShell for Windows)
- Text editor for script modifications (optional)

### Building
- Linux: `./scripts/linux/build.sh` (creates executable and copies to dist/)
- Windows: `.\scripts\windows\build-exe.ps1` (optional - compiles PowerShell to EXE)

### Usage Testing
- Linux: Test with `sudo ./scripts/linux/pm-agent-config.sh --help`
- Windows: Test with `.\scripts\windows\pm-agent-config.bat --help`
- Both platforms: Use `--dry-run` flag to preview changes without applying them

The scripts are self-contained and require no external dependencies beyond the target platform's built-in shell capabilities.

## Deployment

### Single Server Deployment
Copy the appropriate script to your target system and run:

#### Windows
```batch
# Copy pm-agent-config.bat to target Windows server
# Run with administrator privileges
pm-agent-config.bat --mode high
```

#### Linux  
```bash
# Copy pm-agent-config.sh to target Linux server
# Run with sudo privileges
sudo ./pm-agent-config.sh --mode high
```

### Bulk Deployment
Use your preferred configuration management system (Ansible, Puppet, etc.) or simple shell loops to deploy to multiple systems. Both tools support automation through command-line arguments.

