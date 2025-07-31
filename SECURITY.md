# Security Policy

**Mitel Networks Corporation - Customer Deployment Tool**

## Important Notice
This security policy applies to Mitel's proprietary PM+ Agent Configuration tool. This software is for use by authorized Mitel personnel and designated partners in both Mitel and customer infrastructure environments.

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

### Security Best Practices for Mitel and Customer Environments

When deploying this tool in Mitel or customer infrastructure:

> **[LOCK] PRIVILEGE SECURITY NOTICE [LOCK]**  
> **These tools REQUIRE elevated privileges by design:**
> - **Windows**: Administrator privileges (registry modification requirement)
> - **Linux**: Root/sudo privileges (system file modification requirement)
> - **This is NOT a security flaw - it's required functionality!**

1. **Follow applicable security policies** - adhere to Mitel security policies and customer security requirements
2. **UNDERSTAND privilege requirements** - Administrator/Root privileges are mandatory
3. **Validate registry/configuration changes** before applying in production environments
4. **Test in development environments first** - verify in non-production systems
5. **Keep tool updated** to the latest approved version
6. **Secure script storage** - protect batch/shell scripts from unauthorized modification
7. **Audit configuration changes** - log and review what changes are made
8. **Use approved deployment methods** - follow organizational deployment procedures
9. **Ensure only authorized personnel** have access to run these tools
10. **Customer environment considerations** - respect customer security policies and change management procedures

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

### Customer Deployment Security Guidelines

When deploying at customer sites, additional security considerations apply:

#### Pre-Deployment
- **Security Assessment** - coordinate with customer security teams
- **Change Approval** - obtain proper change management approvals
- **Risk Assessment** - document potential impacts and mitigation strategies
- **Tool Validation** - verify tool integrity and authenticity

#### During Deployment
- **Minimum Access** - use least privilege principles for installation and execution
- **Documentation** - maintain clear audit trail of all changes made
- **Rollback Plan** - prepare and test rollback procedures
- **Customer Oversight** - allow customer personnel to monitor deployment process

#### Post-Deployment
- **Cleanup** - remove deployment artifacts if not needed permanently
- **Documentation** - provide customer with configuration change documentation
- **Validation** - verify changes meet customer requirements
- **Support Handoff** - ensure customer can manage ongoing configuration if needed

## Platform-Specific Security Notes

### Windows (Customer and Mitel Environments)
- Registry modifications require Administrator privileges
- DCAgent service interactions need proper permissions
- Compiled EXE files should be digitally signed for enterprise deployment
- PowerShell execution policy considerations
- Customer Windows security policies may require additional approvals

### Linux (Customer and Mitel Environments)
- Configuration file modifications require sudo/root access
- Service restarts need proper privileges
- File permission preservation during configuration changes
- Customer Linux security frameworks may require compliance validation

### Customer Environment Considerations
- **Change Management**: Follow customer change approval processes
- **Security Scanning**: Tool may trigger security monitoring systems
- **Compliance Requirements**: Ensure tool usage meets customer compliance standards (SOX, HIPAA, etc.)
- **Access Controls**: Respect customer identity and access management policies
- **Audit Requirements**: Tool usage may require additional logging for customer audit trails

## Contact

For security-related inquiries, please contact Mitel Security Team at: security@mitel.com

## Acknowledgments

We appreciate security researchers who report vulnerabilities responsibly through proper Mitel channels.
