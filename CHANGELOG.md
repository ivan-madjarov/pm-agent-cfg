# Changelog

All notable changes to the PM+ Agent Configuration tool are documented here.
## [Unreleased]
### Fixed
- (Windows) Ticket #202510024200014: `--mode unset` was rejected as invalid; now accepted directly without requiring separate `--unset` flag.
- (Windows) Removed PowerShell dependency in hex-to-decimal conversion to avoid failures on systems where `powershell` command is localized or unavailable in PATH (e.g., German locale reporting "Der Befehl 'powershell' ist entweder falsch geschrieben..."). Conversion now uses native CMD arithmetic for locale independence.
- (Windows) Updated help and error messages to list `unset` explicitly in valid `--mode` options.

### Changed
- (Docs) Will update Windows guide to reflect unified `--mode unset` usage (pending in this cycle).


This changelog follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.5.0] - 2025-09-24
### Added
- Unset functionality: Added "unset limits (unlimited)" option to remove performance limits and restore agent defaults
- Enhanced interactive menus: Fixed menu cycling to return to menu after operations instead of exiting
- Improved menu consistency: Standardized menu options 0-9 across Windows and Linux versions (added debug option)
- Linux implementation: Added `pm-agent-config.sh` with full feature parity including unset functionality
- Enhanced error handling: Better permission error handling with verification of successful registry updates
- Registry diagnostics: Added registry access testing functionality (Windows batch script option 8)
- Smart status display: Enhanced settings display with variable clearing to prevent stale data

### Fixed
- Interactive menu behavior: Scripts now properly cycle back to menu after operations
- PowerShell output suppression: Eliminated unwanted "True" output using `| Out-Null`
- Menu flow control: Changed `return` statements to `continue` for proper menu cycling
- Batch script parsing: Improved error handling and safer echo syntax
- Registry permission handling: Added specific handling for UnauthorizedAccessException with value verification
- Batch script registry operations: Enhanced registry key creation and value verification
- Batch script syntax error: Fixed malformed goto statement in unset performance function
- Variable expansion issues: Fixed delayed expansion problems in batch script conditional blocks
- Silent unset behavior: Enhanced unset function to provide feedback even when values are already removed

### Changed
- Menu structure: Unified option numbering (0-9) across all platforms with debug option
- Documentation: Updated all guides to reflect new unset functionality, menu improvements, and registry test feature
- Cross-platform consistency: Aligned Windows and Linux script behavior and capabilities
- Success reporting: Added partial success reporting for cases where some registry operations encounter permission warnings
- Version increment: Updated to v3.2 to reflect significant enhancements and debugging capabilities

## [1.4.0] - 2025-08-11
### Added
- Interactive menu enhancements: Option to redisplay menu, consistent option numbering, unified descriptions, and cross-platform consistency.
- Service state management: Improved status verification, timeout handling, and multi-service support.
- Error handling: Clear manual restart instructions, specific error codes, verbose logging.

### Fixed
- Service restart reliability: Intelligent state checking, improved error messaging, and failsafes for stopped services.
- Hex-to-decimal conversion: Registry values now display in human-readable format.
- Character encoding: Replaced Unicode with ASCII for compatibility.
- PowerShell parameter conflict: Renamed duplicate `Verbose` parameter.

### Changed
- Code consistency: Standardized function structure and error handling.
- Documentation: Removed emojis and Unicode, updated guides and security policies.

## [1.3.0] - 2025-01-31
### Fixed
- Windows batch script: Resolved execution flow issues in service restart functionality (error level preservation, logic flow, redundant `goto :eof` statements, reliable stop/start sequence).
- Service restart logic: Corrected success/failure messaging and improved error handling.
- Batch script parsing: Fixed label scope issues and removed redundant statements.

### Changed
- Documentation: Updated privilege requirements and standardized elevation guidance for Windows and Linux.
- PowerShell script: Added interactive menu system, improved help documentation, and added `-Menu` parameter for interactive mode.

## [1.2.0] - 2024-01-19
### Added
- Initial release: Cross-platform PM+ agent configuration tool repository.
- Windows registry configuration tool for DesktopCentral DCAgent.
- Standalone batch script (`pm-agent-config.bat`) and PowerShell version (`pm-agent-config.ps1`).
- Interactive menu mode and command-line argument support.
- Registry backup functionality and administrator privilege checking.
- Performance mode configuration options and comprehensive documentation.

### Features
- Windows batch script: Command-line and interactive menu modes, registry validation, privilege escalation, safe modification, multiple performance modes, verbose output, zero dependencies.
- PowerShell script: Professional parameter handling, UAC integration, error handling, EXE compilation support, progress indicators, registry access.

### Security
- Registry modifications require administrator privileges, input validation, safe backup, error handling.

### Compatibility
- Windows 10 (1903+), Windows Server 2019+, DesktopCentral DCAgent, Command Prompt, PowerShell, enterprise deployment.

---

## Version History Summary

- **1.2.0**: Initial release with Windows registry configuration tool, batch and PowerShell scripts, documentation, security considerations.

---

## Upgrade Guide

Guidelines for upgrading between versions will be added here.

---

## Known Issues

### Windows
- Administrator privileges required for registry modifications.
- Antivirus may flag PowerShell EXE files (false positive).
- Windows Defender SmartScreen may require approval for unsigned EXE files.

### Planned Fixes
- Code signing for PowerShell EXE.
- Additional registry validation.
- Enhanced error recovery mechanisms.

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT License - see [LICENSE](LICENSE).

## Support

For support, check the troubleshooting guide, search issues, or create a new issue using the template.

## Acknowledgments

- Thanks to the Mitel team for feedback.
- Windows registry modification best practices from Microsoft documentation.
- PowerShell community for EXE compilation techniques.
### Fixed
- Windows batch script: Resolved execution flow issues in service restart functionality (error level preservation, logic flow, redundant `goto :eof` statements, reliable stop/start sequence).
- Service restart logic: Corrected success/failure messaging and improved error handling.
- Batch script parsing: Fixed label scope issues and removed redundant statements.

### Changed
- Documentation: Updated privilege requirements and standardized elevation guidance for Windows and Linux.
- PowerShell script: Added interactive menu system, improved help documentation, and added `-Menu` parameter for interactive mode.

## [3.0.0] - 2025-01-31
### Added
- Interactive menu enhancements: Option to redisplay menu, consistent option numbering, unified descriptions, and cross-platform consistency.
- Service state management: Improved status verification, timeout handling, and multi-service support.
- Error handling: Clear manual restart instructions, specific error codes, verbose logging.

### Fixed
- Service restart reliability: Intelligent state checking, improved error messaging, and failsafes for stopped services.
- Hex-to-decimal conversion: Registry values now display in human-readable format.
- Character encoding: Replaced Unicode with ASCII for compatibility.
- PowerShell parameter conflict: Renamed duplicate `Verbose` parameter.

### Changed
- Code consistency: Standardized function structure and error handling.
- Documentation: Removed emojis and Unicode, updated guides and security policies.

## [1.0.0] - 2024-01-19
### Added
- Initial release: Cross-platform PM+ agent configuration tool repository.
- Windows registry configuration tool for DesktopCentral DCAgent.
- Standalone batch script (`pm-agent-config.bat`) and PowerShell version (`pm-agent-config.ps1`).
- Interactive menu mode and command-line argument support.
- Registry backup functionality and administrator privilege checking.
- Performance mode configuration options and comprehensive documentation.

### Features
- Windows batch script: Command-line and interactive menu modes, registry validation, privilege escalation, safe modification, multiple performance modes, verbose output, zero dependencies.
- PowerShell script: Professional parameter handling, UAC integration, error handling, EXE compilation support, progress indicators, registry access.

### Security
- Registry modifications require administrator privileges, input validation, safe backup, error handling.

### Compatibility
- Windows 10 (1903+), Windows Server 2019+, DesktopCentral DCAgent, Command Prompt, PowerShell, enterprise deployment.

---

## Version History Summary

- **1.0.0**: Initial release with Windows registry configuration tool, batch and PowerShell scripts, documentation, security considerations.

---

## Upgrade Guide

Guidelines for upgrading between versions will be added here.

---

## Known Issues

### Windows
- Administrator privileges required for registry modifications.
- Antivirus may flag PowerShell EXE files (false positive).
- Windows Defender SmartScreen may require approval for unsigned EXE files.

### Planned Fixes
- Code signing for PowerShell EXE.
- Additional registry validation.
- Enhanced error recovery mechanisms.

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT License - see [LICENSE](LICENSE).

## Support

For support, check the troubleshooting guide, search issues, or create a new issue using the template.

## Acknowledgments

- Thanks to the Mitel team for feedback.
- Windows registry modification best practices from Microsoft documentation.
- PowerShell community for EXE compilation techniques.

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

