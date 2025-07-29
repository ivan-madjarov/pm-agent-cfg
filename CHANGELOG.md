# Changelog

All notable changes to the PM+ Agent Configuration tool will be documented in this file.

**Mitel Networks Corporation - Internal Project**

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Changed
- Updated license to Mitel proprietary
- Enhanced documentation for internal Mitel use
- Updated repository references for internal distribution

### Added
- Comprehensive CI/CD workflow with Windows and Linux testing
- Security policy with vulnerability reporting procedures
- GitHub issue templates for bug reports and feature requests
- Pull request template with platform-specific testing checklist
- Contributing guidelines with development standards

### Changed
- Enhanced project structure with professional GitHub integration
- Improved documentation organization

## [1.0.0] - 2024-01-19
### Added
- Cross-platform PM+ agent configuration tool repository
- Windows registry configuration tool for DesktopCentral DCAgent
- Standalone batch script (`pm-agent-config.bat`) with zero dependencies
- PowerShell version (`pm-agent-config.ps1`) for professional EXE compilation
- Interactive menu mode for batch script
- Command-line argument support for automation
- Registry backup functionality before modifications
- Administrator privilege checking and validation
- Performance mode configuration options
- Comprehensive Windows documentation and deployment guide
- Support for Windows 10 and Windows Server environments

### Features
#### Windows Batch Script (`pm-agent-config.bat`)
- Command-line mode: `pm-agent-config.bat --performance-mode high`
- Interactive menu mode for guided configuration
- Registry validation and error handling
- Automatic privilege escalation prompts
- Safe registry modification with backup
- Support for multiple performance modes (low, medium, high, ultra)
- Verbose output option for troubleshooting
- Zero external dependencies - runs on any Windows system

#### PowerShell Script (`pm-agent-config.ps1`)
- Professional parameter handling with validation
- UAC integration for seamless privilege escalation
- Enhanced error handling and logging
- EXE compilation support with ps2exe
- Professional appearance with progress indicators
- Registry access with proper error recovery

#### Project Structure
- Organized scripts in platform-specific directories
- Comprehensive documentation for deployment scenarios
- Build scripts for PowerShell EXE generation
- Configuration templates for enterprise deployment
- Troubleshooting guides for common issues

### Security
- Registry modifications require administrator privileges
- Input validation for all user-provided values
- Safe registry backup before making changes
- Error handling prevents system instability
- Documentation includes security considerations

### Compatibility
- Windows 10 (1903 and later)
- Windows Server 2019 and later
- DesktopCentral DCAgent (multiple versions)
- Command Prompt and PowerShell environments
- Enterprise deployment scenarios

---

## Version History Summary

- **v1.0.0**: Initial release with Windows registry configuration tool
  - Standalone batch script with menu and command-line modes
  - PowerShell version with EXE compilation support
  - Comprehensive documentation and deployment guides
  - Enterprise-ready with security considerations

---

## Upgrade Guide

### From Future Versions
*Guidelines for upgrading between versions will be added here*

### Migration Notes
*Breaking changes and migration steps will be documented here*

---

## Known Issues

### Windows
- Administrator privileges required for registry modifications
- Some antivirus software may flag PowerShell EXE files (false positive)
- Windows Defender SmartScreen may require approval for unsigned EXE files

### Planned Fixes
- Code signing for PowerShell EXE to reduce security warnings
- Additional registry validation for edge cases
- Enhanced error recovery mechanisms

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to contribute to this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support, please:
1. Check the [troubleshooting guide](docs/windows-guide.md#troubleshooting) or [Linux guide](docs/linux-guide.md#troubleshooting)
2. Search existing [issues](https://github.com/ivan-madjarov/pm-agent-cfg/issues)
3. Create a new issue using the appropriate template

## Acknowledgments

- Thanks to the Mitel team for enterprise deployment feedback
- Windows registry modification best practices from Microsoft documentation
- PowerShell community for EXE compilation techniques
