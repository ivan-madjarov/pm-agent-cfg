# PM Agent Configuration

Cross-platform agent configuration management system supporting both Linux and Windows environments.

## Current Features

### Windows Registry Configuration Tool ✅
Complete solution for configuring DesktopCentral DCAgent registry settings with performance options:
- **Performance Modes**: Low (15% CPU) and High (30% CPU) resource utilization
- **Multiple Interfaces**: Interactive menu, PowerShell script, and Python command-line tool
- **Registry Settings**: Configures patch scan timeout and thread CPU usage limits
- **Administrator Checks**: Ensures proper permissions before making changes

See [Windows Configuration Guide](src/windows/README.md) for detailed usage instructions.

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
1. **Open Command Prompt or PowerShell as Administrator**
2. **Navigate to the project directory**
3. **Choose your preferred method**:

#### Option 1: Interactive Menu (Easiest)
```batch
cd scripts\windows
configure-agent-menu.bat
```

#### Option 2: PowerShell Script (Recommended)
```powershell
cd scripts\windows
.\configure-agent.ps1 -Mode high    # or -Mode low
```

#### Option 3: Python Script (Advanced)
```bash
cd src\windows
python registry_config.py --mode high    # or --mode low
```

### Performance Mode Options
- **Low Performance**: 15% CPU usage limit (ideal for production servers)
- **High Performance**: 30% CPU usage limit (ideal for workstations)

See platform-specific documentation:
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

