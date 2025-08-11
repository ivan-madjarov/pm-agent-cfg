# Changelog

All notable changes to the PM+ Agent Configuration tool will be documented in this file.

**Mitel Networks Corporation - Customer Deployment Tool**

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.4.0] - 2025-08-11

### Added
- **PHP Development Enhancement**: Common application stub file for improved VS Code IntelliSense
  - Added `inc/common-stubs.php` with type hints for custom classes and global functions
  - Enhanced PHP validation and autocompletion support

## [v3.1.1] - 2025-01-31 - Service Logic & Documentation Refinement
### 🔧 Critical Fixes & Documentation Updates

### Fixed - Service Restart Logic
- **Windows Batch Script**: Resolved execution flow issues in service restart functionality
  - Fixed error level preservation preventing proper service start after successful stop
  - Corrected logic flow where successful operations would show failure messages
  - Eliminated redundant `goto :eof` statements causing batch parsing errors
  - Reorganized service restart sequence for reliable stop/start operations

### Enhanced - Documentation Consistency 
- **Privilege Requirements**: Updated all documentation for proper elevated console usage
  - Windows: Clarified to start Command Prompt/PowerShell as Administrator (not right-click files)
  - Linux: Enhanced sudo usage guidance for systems without direct root access
  - Removed ambiguous instructions about right-clicking script files
- **Cross-Platform Instructions**: Standardized elevation guidance across all platforms

### Improved - PowerShell Script
- **Interactive Menu**: Added full menu system matching batch script functionality
- **Help Documentation**: Enhanced privilege requirement instructions
- **Parameter Support**: Added -Menu parameter for interactive mode

## [v3.0.0] - 2025-01-31 - Production-Ready Customer Deployment Suite
### 🚀 Major Release - Comprehensive Service Management & Interactive UX

### Added - Interactive Menu Enhancements
- **Menu Relist Functionality**: Added option "0" to redisplay menu options across all platforms
  - Windows Batch: Enhanced interactive menu with instant relist capability
  - Windows PowerShell: Added complete interactive menu system with relist support
  - Linux Shell: Improved menu with refresh option for better navigation
- **Cross-Platform Menu Consistency**: Standardized menu interfaces across all scripts
  - Consistent option numbering and prompts: "Enter your choice (1-7, 0 for menu)"
  - Unified menu option descriptions and behavior patterns
  - Professional user experience across Windows and Linux platforms

### Fixed - Critical Service Management Issues
- **Service Restart Logic Errors**: Resolved critical Windows service restart flow issues
  - Fixed logic error where successful service stops triggered false failure messages
  - Reorganized service start flow to properly exit after successful operations
  - Eliminated contradictory success/failure messages during restart sequences
  - Enhanced error level preservation to prevent command interference
- **Batch Script Parsing**: Fixed critical batch label and function scope issues
  - Removed redundant `goto :eof` statements causing execution flow problems
  - Fixed internal label scope issues (`:start_service` → `:do_service_start`)
  - Eliminated "batch label specified" errors in menu operations
  - Restructured service restart using proper function calls instead of goto labels

### Enhanced - Production Reliability
- **Service State Management**: Comprehensive improvements across all platforms
  - Windows: Enhanced service status verification with accurate state reporting
  - Windows: Improved timeout handling and service state transitions
  - PowerShell: Added complete service management with verification steps
  - Linux: Enhanced service detection with multi-service support
- **Error Handling**: Professional error recovery and user guidance
  - Clear manual restart instructions for service failure scenarios
  - Specific error codes and remediation steps for common issues
  - Enhanced verbose logging with detailed troubleshooting information

### Quality Improvements
- **Code Consistency**: Standardized function structure and error handling patterns
- **User Experience**: Professional interactive interfaces with intuitive navigation
- **Documentation**: Updated all guides and security policies for customer deployment

## [Previous Releases] - Enterprise-Grade Service Management & Cross-Platform Consistency
### Fixed
- **Service Status Display Issues**: Fixed confusing service status output in Windows batch script
  - Windows: Raw numeric codes (4) now display as human-readable text (RUNNING)
  - Added comprehensive service state mapping for all Windows service states
  - Enhanced service status parsing with fallback code-to-text conversion
- **Service Restart Reliability**: Comprehensive improvements to service restart functionality
  - Windows: Added intelligent service state checking before restart attempts
  - Windows: Enhanced error messaging with specific failure context and remediation steps
  - Linux: Improved service detection and state handling with better error recovery
  - Both platforms: Added failsafes to prevent restart attempts on already-stopped services
- **Hex-to-Decimal Conversion**: Fixed Windows registry value display issues
  - Registry values now show human-readable format (200 seconds vs 0xc8 seconds)
  - Added PowerShell-based hex conversion for accurate decimal display
  - Performance mode detection now works correctly with decimal comparisons
- **Character Encoding Issues**: Replaced all Unicode characters with ASCII equivalents for improved compatibility
- **PowerShell Parameter Conflict**: Fixed duplicate Verbose parameter issue by renaming to VerboseOutput
- **Documentation Consistency**: Removed remaining emoji and Unicode characters from all documentation

### Enhanced
- **Service Management System**: Complete overhaul of service restart functionality across all platforms
  - Windows Batch: Intelligent state checking (STOPPED, RUNNING, START_PENDING, STOP_PENDING, etc.)
  - Windows PowerShell: Enhanced service restart with comprehensive state management and timeout handling
  - Linux: Improved service detection with multiple service name support and enhanced state monitoring
  - All platforms: Added visual status indicators ([OK], [X], [~], [!]) for clear user feedback
- **Cross-Platform Service Status**: Standardized service status display across Windows and Linux
  - Consistent status indicators and messaging across all platforms
  - Enhanced error handling and user guidance for service issues
  - Comprehensive service state detection and reporting
- **Four-Mode Performance System**: Standardized all platforms to support Low (15%), Medium (20%), High (30%), Ultra (40%) CPU limits
- **Error Handling & User Experience**: Improved error messages and user guidance
  - Clear remediation steps for common service restart failures
  - Enhanced verbose logging for troubleshooting
  - Better error context and specific manual recovery instructions

### Quality Improvements
- **Enterprise Reliability**: Enhanced service management for production environments
- **Code Standards**: Consistent formatting and best practices across all scripts
- **Cross-Platform Consistency**: Unified user experience across Windows and Linux platforms
- **Documentation Accuracy**: Updated all documentation to reflect enhanced capabilities

### Added
- **Enhanced Service State Monitoring**: Comprehensive service state detection and handling
- **Intelligent Restart Logic**: Prevents unnecessary operations and handles edge cases gracefully
- **Visual Status Indicators**: Clear, consistent status display across all platforms
- **Comprehensive Error Recovery**: Detailed error messages with specific remediation steps
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

