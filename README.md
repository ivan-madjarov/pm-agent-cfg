# PM Agent Configuration

Cross-platform agent configuration management system supporting both Linux and Windows environments.

## Current Features

### Windows Registry Configuration Tool ✅
**Zero-dependency solution** for configuring DesktopCentral DCAgent registry settings:
- 🚀 **Standalone Batch Script** - works on any Windows machine (no Python/PowerShell required)
- 🎮 **Multiple Interfaces** - command-line AND interactive menu in one tool
- ⚙️ **Performance Modes** - Low (15% CPU) and High (30% CPU) resource utilization
- 🔒 **Built-in Security** - administrator privilege checking and validation
- 📊 **Status Display** - view current registry configurations
- 📦 **Single File Deployment** - copy `pm-agent-config.bat` and run (10KB)

**Bonus**: Optional PowerShell-to-EXE compilation for professional deployment packages.

See [Windows Configuration Guide](src/windows/README.md) for complete usage instructions.

## Project Structure

```
pm-agent-cfg/
├── src/                    # Shared source code
│   ├── common/            # Platform-agnostic utilities  
│   ├── linux/             # Linux-specific implementation
│   └── windows/           # Windows-specific implementation
├── config/                # Configuration files
│   ├── common/            # Shared configuration
│   ├── linux/             # Linux-specific config
│   └── windows/           # Windows-specific config  
├── scripts/               # Build and deployment scripts
│   ├── linux/             # Linux build/deploy scripts
│   └── windows/           # Windows build/deploy scripts
├── tests/                 # Test suites
│   ├── common/            # Shared tests
│   ├── linux/             # Linux-specific tests
│   └── windows/           # Windows-specific tests
├── docs/                  # Documentation
├── dist/                  # Build outputs (gitignored)
│   ├── linux/             # Linux artifacts
│   └── windows/           # Windows artifacts
└── deploy/                # Deployment configurations
    ├── linux/             # Linux deployment
    └── windows/           # Windows deployment
```

## Platform Support

- **Linux**: CentOS, Ubuntu, RHEL
- **Windows**: Windows Server 2019+, Windows 10+

## Getting Started

### Windows Registry Configuration (Available Now)
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

### Performance Modes
- **Low Performance**: 15% CPU usage limit (ideal for production servers)
- **High Performance**: 30% CPU usage limit (ideal for workstations)

### Requirements
- ✅ Windows 7+ (any edition)
- ✅ Administrator privileges
- ✅ DesktopCentral DCAgent installed
- ✅ **That's it!** No Python, PowerShell modules, or other dependencies

**Advanced**: Optional EXE compilation available for professional deployment packages.

See detailed documentation:
- [Windows Registry Configuration](src/windows/README.md) ✅ **Available**
- [Linux Setup](docs/linux-setup.md) *Coming Soon*

## Development

### Prerequisites
- Git
- Python 3.8+ (for shared utilities)
- Platform-specific build tools

### Building
- Linux: `./scripts/linux/build.sh`
- Windows: `.\scripts\windows\build.ps1`

### Testing
- Linux: `./scripts/linux/test.sh`  
- Windows: `.\scripts\windows\test.ps1`

## Deployment

Each platform has its own deployment configuration in the `deploy/` directory.

