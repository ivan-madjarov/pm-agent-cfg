# Changelog

All notable changes to the PM+ Agent Configuration tool are documented here.
## [1.6.0] - 2025-10-02
### Added
- (Windows/Linux/PowerShell) Concise performance mode summary line in status output: `Performance Mode (summary): <mode>` for quick identification (low|medium|high|ultra|unset|custom).
 - (Windows Batch) Refined export filename timestamp format (removed locale comma / fractional seconds to ensure clean filenames).

### Fixed
- (Windows Batch) Export option crash: Replaced locale-dependent FOR date/time token parsing (causing ". was unexpected at this time." on some regional formats) with sanitizer-based timestamp generation.

### Fixed
- (Windows) Ticket #202510024200014: `--mode unset` previously rejected; now accepted directly without requiring separate `--unset` flag.
- (Windows) Locale issue: removed PowerShell dependency for hex conversion (avoids failures on hosts where `powershell` command name/localization caused errors). Implemented native CMD arithmetic.
- (PowerShell) Added matching performance mode summary to maintain parity with batch/Linux scripts.

### Changed
- (Windows/Linux/Docs) Unified unset handling via `--mode unset`; retained `--unset` / legacy note for backward compatibility.
- (Linux) Direct `--mode unset` support (formerly required standalone `--unset`).
- (Docs) Updated Windows & Linux guides plus README to mention performance mode summary line and unified unset usage.


This changelog follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.6.1] - 2025-10-02
## [1.6.2] - 2025-10-02
### Added
- (Windows Batch / PowerShell) Registry export feature: `--export` (batch) / `-Export` (PowerShell) and interactive menu option (Batch: 9, PowerShell: 9) producing a timestamped `.reg` file for troubleshooting.
- (PowerShell) Test Registry Access function and menu option 8 for parity with batch script (diagnose registry key accessibility and installation issues).

### Changed
- (Windows Batch/PowerShell) Registry export writes to the current working directory (not TEMP). Explicit failure if directory is not writable.
- (Windows Batch & PowerShell) Interactive menus renumbered for parity (Test Registry = 8, Export = 9, Exit = 10 in batch; PowerShell mirrors numbering where applicable).
- (PowerShell) Export naming standardized; removed `-ExportPath` parameter for consistency and simplicity.
- (Windows Batch) Export operation (menu option 9 / `--export`) now intentionally exits after success with a summary to eliminate fragile post-export menu looping on certain locales.

### Fixed
- (Windows Batch) Locale-dependent export timestamp crashes (`. was unexpected at this time.`) eliminated by abandoning complex `%DATE%` / `%TIME%` token parsing in favor of a simplified time+random strategy.
- (Windows Batch) Removed comma / fractional second artifacts from filenames (sanitized timestamp generation).
- (Windows Batch) Missing internal label reference when using `--export` (legacy call to `:export_registry`) now resolved via an alias label pointing to the implemented `:export_registry_exit` logic.
- (PowerShell) Fallback minimal writer uses standardized filename when `reg.exe export` fails.
- (PowerShell) Added GNU-style double-dash flag compatibility (`--export`, `--status`, `--mode`, `--unset`, `--help`, `--menu`, `--verbose`) for parity with batch usage patterns; manual mode validation replaces previous ValidateSet to enable preprocessing.

### Notes
- Batch filename format: `pm-agent-dca-<HHMMSS><RANDOM>.reg` (time+random only) for maximum compatibility; PowerShell keeps full datetime pattern `pm-agent-dca-YYYYMMDDHHmmss.reg` for richer timestamping.
- Export always targets the directory from which the script is launched—ensure it's writable (run elevated if required).
- Linux variant uses file collection (`PerformanceSettings.json`) instead of registry export; no export flag required.

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

# Changelog

All notable changes to the PM+ Agent Configuration tool are documented here.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html) and follows the spirit of [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [1.6.2] - 2025-10-02
### Added
- Registry export feature (Batch `--export` / PS `-Export` or `--export`) with timestamped `.reg` output in the current working directory.
- PowerShell Test Registry Access (menu option 8) matching batch functionality.
- PowerShell GNU-style double-dash flag compatibility: `--mode`, `--unset`, `--status`, `--export`, `--menu`, `--help`, `--verbose`.

### Changed
- Batch export (menu option 9 / `--export`) now intentionally exits after a successful export (clear UX; avoids locale edge cases that previously broke the menu loop).
- PowerShell export keeps the session open (non-disruptive for continued diagnostics).
- Standardized export naming: Batch uses `pm-agent-dca-<HHMMSS><RANDOM>.reg`; PowerShell uses `pm-agent-dca-YYYYMMDDHHmmss.reg` (higher precision timestamp).
- Menus renumbered/confirmed for parity (batch & PowerShell: Test Registry = 8, Export = 9, Exit = 10).

### Fixed
- Batch: Eliminated locale-dependent timestamp parsing crash (`. was unexpected at this time.`) by removing fragile `%DATE%/%TIME%` token FOR loops.
- Batch: Removed comma/fractional artifacts from filenames (sanitized time + random approach).
- Batch: Missing `:export_registry` label (legacy call path) restored via alias to `:export_registry_exit`.
- PowerShell: Fallback minimal export now produces standardized file when `reg.exe` export fails.
- PowerShell: Manual mode validation replaces prior `ValidateSet` to enable preprocessing of GNU-style arguments.

### Notes
- Export requires an elevated, writable working directory. Failure is explicit with guidance.
- Batch exit-on-export is a deliberate design choice to guarantee deterministic completion on long-tail locale environments.

## [1.6.1] - 2025-10-02
### Added
- Performance mode summary line: `Performance Mode (summary): <mode>` across Batch, PowerShell, and Linux.

### Changed
- Unified unset handling (`--mode unset`) while retaining legacy `--unset` for backward compatibility.

### Fixed
- Batch: Replaced hex conversion PowerShell dependency with native CMD arithmetic (improves portability & reliability).
- PowerShell / Linux: Parity maintenance for summary output.

## [1.6.0] - 2025-10-02
Initial stabilization tranche preceding export work.

### Added
- Foundational improvements enabling later export feature (refined status outputs, preparatory menu alignment groundwork).

### Fixed
- Early locale parsing inconsistencies in preparation for later timestamp simplification.

## [1.5.0] - 2025-09-24
### Added
- Unset functionality (remove limits / restore defaults).
- Registry access diagnostics (Batch option 8).
- Linux implementation achieving feature parity.

### Fixed
- Menu loop reliability across platforms (post-operation return consistency).
- Multiple registry permission and verification edge cases.

### Changed
- Unified option numbering and enhanced success/partial reporting.

## [1.4.0] - 2025-08-11
Service management and interactive UX enhancements; improved error handling and status reporting.

## [1.3.0] - 2025-01-31
Introduced PowerShell interactive menu; major service restart logic corrections in Batch.

## [1.2.0] - 2024-01-19
Initial public release (Batch + PowerShell) with performance mode configuration and interactive menus.

---

## Upgrade & Migration Notes
- 1.6.x introduces export capability and safer locale handling; no breaking changes.
- Older automation invoking `--unset` still works; prefer `--mode unset` going forward.
- Batch scripts relying on post-export continuation must adapt (export now exits intentionally starting 1.6.2).

## Known Issues
- Windows: Requires elevation; lack of elevation produces explicit failures.
- PowerShell EXE compilation (optional) may trigger unsigned execution warnings (code signing planned).

## Contributing / License / Support
See `CONTRIBUTING.md`, `LICENSE`, and repository issue templates for guidance.


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

