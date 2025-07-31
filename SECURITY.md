# Security Policy

**Mitel Networks Corporation - Internal Project**

## Important Notice
This security policy applies to Mitel's proprietary PM+ Agent Configuration tool. This software is for internal use by authorized Mitel personnel and designated partners only.

## Supported Versions

Mitel actively supports and provides security updates for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

If you discover a security vulnerability in the PM+ Agent Configuration tool, please report it through Mitel's internal security channels:

### Internal Disclosure Process

1. **Do NOT** create public issues or external reports for security vulnerabilities
2. **Contact** Mitel Security Team directly at: security@mitel.com
3. **Use** Mitel's internal vulnerability reporting system if available
4. **Include** the following information:
   - Description of the vulnerability
   - Steps to reproduce the issue
   - Potential impact assessment
   - Affected platforms (Windows/Linux)
   - Suggested fix (if available)

### Response Timeline

- **Initial Response**: Within 24 hours of report (Mitel business hours)
- **Assessment**: Within 3 business days
- **Fix Development**: Timeline depends on severity and complexity
- **Internal Notification**: Immediate for critical vulnerabilities
- **Documentation**: Security incident logged in Mitel's internal systems

### Security Best Practices for Mitel Environments

When deploying this tool in Mitel infrastructure:

> **[LOCK] PRIVILEGE SECURITY NOTICE [LOCK]**  
> **These tools REQUIRE elevated privileges by design:**
> - **Windows**: Administrator privileges (registry modification requirement)
> - **Linux**: Root/sudo privileges (system file modification requirement)
> - **This is NOT a security flaw - it's required functionality!**

1. **Follow Mitel security policies** and procedures for internal tools
2. **UNDERSTAND privilege requirements** - Administrator/Root privileges are mandatory
3. **Validate registry/configuration changes** before applying in production
4. **Test in Mitel development environments first**
5. **Keep tool updated** to the latest approved version
6. **Secure script storage** - protect batch/shell scripts from unauthorized modification
7. **Audit configuration changes** - log and review what changes are made
8. **Use Mitel-approved deployment methods** only
9. **Ensure only authorized personnel** have access to run these tools

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
