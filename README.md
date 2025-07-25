# PM Agent Configuration

Cross-platform agent configuration management system supporting both Linux and Windows environments.

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

See platform-specific documentation:
- [Linux Setup](docs/linux-setup.md)
- [Windows Setup](docs/windows-setup.md)

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

