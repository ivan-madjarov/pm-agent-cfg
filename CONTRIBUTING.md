# Contributing to PM+ Agent Configuration

Thank you for your interest in contributing to the PM+ Agent Configuration tool! This document provides guidelines for contributing to this cross-platform project.

## How to Contribute

### Reporting Issues
- Check existing issues before creating a new one
- Use the provided issue templates (Bug Report or Feature Request)
- Provide detailed information about your environment (OS, version, privileges)
- Include error messages and logs when applicable
- Describe steps to reproduce the issue
- Specify which platform/tool you're using (Windows batch, PowerShell, Linux, etc.)

### Suggesting Features
- Check if the feature has already been requested
- Use the Feature Request template
- Provide a clear description of the feature
- Explain the use case and benefits
- Consider cross-platform implications
- Think about enterprise deployment scenarios

### Code Contributions

#### Setting up Development Environment

**For Windows Development:**
```batch
git clone https://github.com/ivan-madjarov/pm-agent-cfg.git
cd pm-agent-cfg
# Test the batch script
scripts\windows\pm-agent-config.bat --help
```

**For Linux Development:**
```bash
git clone https://github.com/ivan-madjarov/pm-agent-cfg.git
cd pm-agent-cfg
# Test shell scripts
sudo bash scripts/linux/pm-agent-config.sh --help
```

#### Making Changes
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test your changes thoroughly on target platforms
5. Update documentation if needed
6. Commit your changes with conventional commit messages
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request using the provided template

#### Code Style and Standards

**Windows Batch Scripts:**
- Use meaningful variable names with quotes: `set "VARIABLE_NAME=value"`
- Include error handling for all operations
- Provide verbose mode support where applicable
- Use consistent indentation (2 spaces)
- Add comments for complex logic
- Test with both Command Prompt and PowerShell

**PowerShell Scripts:**
- Follow PowerShell best practices
- Use approved verbs for function names
- Include parameter validation
- Implement proper error handling
- Support common parameters (-Verbose, -WhatIf where applicable)
- Use consistent formatting and indentation

**Shell Scripts (Linux):**
- Follow POSIX standards where possible
- Use shellcheck for validation
- Include proper error handling (`set -e`)
- Use meaningful variable names
- Add comments for complex operations
- Test on multiple distributions

**Documentation:**
- Use clear, concise language
- Include examples for all features
- Update both general and platform-specific documentation
- Follow markdown best practices
- Include troubleshooting information

#### Testing Requirements

**Windows Testing:**
- Test on Windows 10 and Windows Server (latest versions)
- Verify Administrator privilege checking
- Test registry modifications safely (use test VMs)
- Validate both command-line and interactive menu modes
- Test PowerShell execution policies
- Verify error handling and rollback scenarios
- Test with different DCAgent versions if available
- Use `--dry-run` for safe testing

**Linux Testing (when applicable):**
- Test on Ubuntu, RHEL/CentOS, and Debian
- Verify root/sudo privilege handling
- Test JSON file modifications safely (use test VMs)
- Validate service interactions
- Test with different UEMS Agent versions if available
- Verify error handling and rollback scenarios
- Use `--dry-run` for safe testing

**Cross-Platform Testing:**
- Ensure documentation is accurate for all platforms
- Validate build scripts work correctly
- Test script help and menu functions
- Verify consistent behavior where applicable

### Pull Request Process

1. **Pre-submission Checklist:**
   - All tests pass on target platforms
   - Documentation updated appropriately
   - CHANGELOG.md updated for significant changes
   - Security implications considered
   - Backward compatibility maintained (unless breaking change)

2. **Review Process:**
   - Maintainers will review for functionality and security
   - Platform-specific testing may be requested
   - Documentation review for clarity and completeness
   - Security review for registry/configuration changes

3. **Merge Requirements:**
   - Approval from maintainers
   - All CI checks passing
   - No unresolved review comments
   - Proper commit message format

## Development Guidelines

### Security First
- Always validate user input
- Check privileges before making system changes
- Handle errors gracefully without exposing system details
- Test rollback scenarios
- Consider enterprise security requirements
- Document security implications of changes

### Cross-Platform Considerations
- Consider how changes affect both Windows and Linux implementations
- Maintain consistent user experience across platforms
- Document platform-specific behaviors clearly
- Test on multiple OS versions when possible

### Registry and Configuration Safety
- Always backup before making changes
- Implement atomic operations where possible
- Provide rollback mechanisms
- Validate configuration before applying
- Test in non-production environments first

### Commit Messages
Use conventional commit format:
- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation changes
- `refactor:` for code refactoring
- `test:` for test additions
- `security:` for security improvements
- `perf:` for performance improvements

Examples:
- `feat(windows): add registry backup before modifications`
- `fix(linux): resolve permission issue with config files`
- `docs: update deployment guide for enterprise scenarios`

### Adding New Features

**For Windows Features:**
1. Update `pm-agent-config.bat` with new functionality
2. Update PowerShell version if needed (`pm-agent-config.ps1`)
3. Add appropriate registry validation
4. Update Windows documentation (`docs/windows-guide.md`)
5. Test with various Windows versions and DCAgent configurations

**For Linux Features (future):**
1. Update shell script (`scripts/linux/pm-agent-config.sh`)
2. Add JSON configuration handling
3. Implement service interaction logic
4. Update Linux documentation (`docs/linux-guide.md`)
5. Test across multiple distributions

**For Cross-Platform Features:**
1. Update main README.md
2. Update troubleshooting guides
3. Consider deployment implications

### Documentation Standards
- Include examples for all new features
- Document required privileges and permissions
- Provide troubleshooting information
- Update deployment guides for enterprise scenarios
- Include security considerations
- Maintain version compatibility information

## Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help others learn and grow
- Maintain professional communication
- Respect different deployment environments and use cases
- Consider the impact of changes on enterprise users

## Release Process

1. **Version Planning**: Features are planned for specific releases
2. **Testing Phase**: Comprehensive testing on target platforms
3. **Documentation Review**: All documentation updated and reviewed
4. **Security Review**: Security implications assessed
5. **Release Preparation**: CHANGELOG updated, version tags applied
6. **Deployment Testing**: Test in various deployment scenarios

## Questions?

Feel free to open an issue for questions about contributing or reach out to the maintainers. We're here to help!

For security-related questions, please see our [Security Policy](SECURITY.md).

Thank you for contributing to the PM+ Agent Configuration tool!
