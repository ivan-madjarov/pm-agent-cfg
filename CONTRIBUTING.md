# Contributing to PM+ Agent Configuration

**Mitel Networks Corporation - Internal Project**

Thank you for your interest in contributing to the PM+ Agent Configuration tool! This document provides guidelines for Mitel personnel and authorized partners contributing to this internal project.

## Important Notice
This is proprietary software owned by Mitel Networks Corporation. Contributions are limited to authorized Mitel employees and designated partners only. All contributions become the property of Mitel Networks Corporation.

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
git clone <internal-mitel-repository-url>
cd pm-agent-cfg
# Test the batch script
scripts\windows\pm-agent-config.bat --help
```

**For Linux Development:**
```bash
git clone <internal-mitel-repository-url>
cd pm-agent-cfg
# Test shell scripts
sudo bash scripts/linux/pm-agent-config.sh --help
```

#### Making Changes
1. Fork the internal repository (or create a feature branch if you have direct access)
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test thoroughly on target platforms
5. Update documentation if needed
6. Commit with conventional commit messages
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Create a Pull Request for internal review

#### Code Style and Standards

**Windows Batch Scripts:**
- Use meaningful variable names with quotes: `set "VARIABLE_NAME=value"`
- Include error handling for all operations
- Use consistent indentation (2 spaces)
- Test with both Command Prompt and PowerShell

**PowerShell Scripts:**
- Follow PowerShell best practices
- Use approved verbs for function names
- Include parameter validation and error handling
- Use consistent formatting

**Shell Scripts (Linux):**
- Follow POSIX standards where possible
- Include proper error handling (`set -e`)
- Use meaningful variable names
- Test on multiple distributions

**Documentation:**
- Use clear, concise language
- Include examples for all features
- Follow markdown best practices

#### Testing Requirements

**Windows Testing:**
- Test on Windows 10 and Windows Server
- Verify Administrator privilege checking
- Test registry modifications safely (use test VMs)
- Validate both command-line and interactive modes

**Linux Testing:**
- Test on major distributions (Ubuntu, CentOS, RHEL)
- Verify sudo privilege requirements
- Test JSON configuration handling
- Validate service restart functionality
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
- Validate configuration before applying
- Test in non-production environments first

### Commit Messages
Use conventional commit format:
- `feat:` for new features
- `fix:` for bug fixes  
- `docs:` for documentation changes
- `refactor:` for code refactoring
- `security:` for security improvements

Examples:
- `feat(windows): add registry backup before modifications`
- `fix(linux): resolve permission issue with config files`
- `docs: update deployment guide for enterprise scenarios`

### Documentation Standards
- Include examples for all new features
- Document required privileges and permissions
- Provide troubleshooting information
- Include security considerations

## Questions?

Feel free to open an issue for questions about contributing. For security-related questions, see our [Security Policy](SECURITY.md).

Thank you for contributing to the PM+ Agent Configuration tool!
