# Security Policy

## Supported Versions

We actively support and provide security updates for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

If you discover a security vulnerability in the PM+ Agent Configuration tool, please report it responsibly:

### Private Disclosure

1. **Do NOT** create a public GitHub issue for security vulnerabilities
2. **Email** the maintainers directly at: [security contact email]
3. **Include** the following information:
   - Description of the vulnerability
   - Steps to reproduce the issue
   - Potential impact assessment
   - Affected platforms (Windows/Linux)
   - Suggested fix (if available)

### Response Timeline

- **Initial Response**: Within 48 hours of report
- **Assessment**: Within 5 business days
- **Fix Development**: Timeline depends on severity and complexity
- **Public Disclosure**: After fix is released (coordinated disclosure)

### Security Best Practices

When using this tool:

1. **Run with Administrator/Root privileges only when necessary**
2. **Validate registry/configuration changes** before applying
3. **Test in non-production environments first**
4. **Keep tool updated** to the latest version
5. **Secure script storage** - protect batch/shell scripts from unauthorized modification
6. **Audit configuration changes** - log and review what changes are made

### Vulnerability Severity Classification

We use the CVSS 3.1 standard for severity classification:

- **Critical** (9.0-10.0): Immediate fix required (privilege escalation, system compromise)
- **High** (7.0-8.9): Fix within 30 days (data exposure, service disruption)
- **Medium** (4.0-6.9): Fix within 90 days (information disclosure, DoS)
- **Low** (0.1-3.9): Fix in next planned release (minor issues)

### Security Features

The PM+ Agent Configuration tool includes several security considerations:

#### Windows Tools
- **Registry access validation** - checks for proper keys before modification
- **Administrator privilege verification** - ensures proper permissions
- **Input validation** - validates performance mode parameters
- **Error handling** - prevents information disclosure through error messages
- **Audit trail** - logs configuration changes made

#### Linux Tools (Coming Soon)
- **Configuration file permission checks**
- **Service validation** before modification
- **Backup creation** before changes
- **Rollback capability** for failed configurations

### Common Security Considerations

#### Registry/Configuration Modification
- **Backup before changes** - always create backups of registry/config files
- **Validate input parameters** - ensure only valid values are accepted
- **Least privilege** - run with minimal required permissions
- **Atomic operations** - ensure changes are applied completely or not at all

#### Script Security
- **Code signing** - verify script integrity (for compiled versions)
- **Path validation** - prevent directory traversal attacks
- **Command injection prevention** - sanitize user inputs
- **Secure defaults** - fail securely when errors occur

## Platform-Specific Security Notes

### Windows
- Registry modifications require Administrator privileges
- DCAgent service interactions need proper permissions
- Compiled EXE files should be digitally signed for enterprise deployment
- PowerShell execution policy considerations

### Linux (Future)
- Configuration file modifications require appropriate sudo/root access
- Service restarts need proper privileges
- Package manager interactions should be validated
- File permission preservation during configuration changes

## Threat Model

### Assets Protected
- System registry settings (Windows)
- Agent configuration files
- Service performance and availability
- System resource utilization

### Threat Actors
- Malicious users with local access
- Compromised scripts or executables
- Insider threats with administrative access
- Supply chain attacks on dependencies

### Attack Vectors
- **Privilege escalation** through improper permission handling
- **Configuration tampering** leading to service disruption
- **Information disclosure** through verbose error messages
- **Denial of service** through resource exhaustion settings

## Contact

For security-related inquiries, please contact:
- **Email**: [security contact]
- **Encryption**: [PGP key information if available]

## Acknowledgments

We appreciate security researchers who report vulnerabilities responsibly and help improve the security of this tool.

Thank you for helping keep the PM+ Agent Configuration tool secure!
