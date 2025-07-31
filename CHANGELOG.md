# Changelog

All notable changes to the PM+ Agent Configuration tool will be documented in this file.

**Mitel Networks Corporation - Internal Project**

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] - Project Quality Enhancement & Code Optimization
### Fixed
- **Character Encoding Issues**: Replaced all Unicode characters (✓, ✗, ═, └, ──) with ASCII equivalents for improved compatibility
  - Windows batch script: All Unicode symbols → ASCII text equivalents
  - PowerShell script: All Unicode symbols → ASCII text equivalents  
  - Linux shell script: All Unicode symbols → ASCII text equivalents
- **Help Display**: Fixed script name display in help output (now shows "pm-agent-config.bat" instead of parameter expansion)
- **Tree Structure Display**: Registry key tree structure now uses ASCII characters (+--) instead of Unicode
- **Documentation Emoji Issues**: Replaced all problematic emoji characters (⚠️, 🚨, 🔑, ✅, 🚀, etc.) with ASCII text equivalents
- **Cross-Platform Compatibility**: Eliminated all Unicode characters that cause display issues in different environments
- **Batch Script Error**: Resolved "batch label not found" error caused by Unicode character parsing issues
- **PowerShell Parameter Conflict**: Fixed duplicate Verbose parameter issue by renaming to VerboseOutput

### Enhanced
- **Four-Mode Performance System**: Standardized all platforms to support Low (15%), Medium (20%), High (30%), Ultra (40%) CPU limits
  - Windows batch script: Expanded from 2 to 4 performance modes with full interactive menu support
  - PowerShell script: Updated with all 4 modes and improved parameter validation
  - Linux shell script: Already supported 4 modes, cleaned up unused variables
  - Documentation: Updated all guides to reflect consistent 4-mode system across platforms
- **Code Optimization**: Comprehensive cleanup and streamlining of all scripts and documentation
  - Build scripts: Improved efficiency and error handling
  - CI/CD workflow: Streamlined from 5 jobs to 3 for better performance
  - Documentation: Removed redundancy while maintaining comprehensive coverage
  - Security documentation: Streamlined threat model and contact information
- **Documentation Standards**: Professional formatting and consistency improvements
- **Professional Deployment**: Enhanced build processes and deployment procedures

### Quality Improvements
- **Code Standards**: Consistent formatting and best practices across all scripts
- **Project Structure**: Optimized file organization and removed unnecessary complexity
- **Enterprise Compatibility**: Enhanced reliability for corporate deployment scenarios
- **Maintenance**: Streamlined codebase for easier long-term maintenance

### Changed
- Updated license to Mitel proprietary
- Enhanced documentation for internal Mitel use
- Optimized CI/CD pipeline for efficiency
- Streamlined contributing guidelines and security policy

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
