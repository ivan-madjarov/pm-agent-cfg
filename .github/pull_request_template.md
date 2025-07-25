## Description
Brief description of changes made in this PR.

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Code refactoring
- [ ] Security improvement

## Platform Changes
- [ ] Windows-specific changes
- [ ] Linux-specific changes
- [ ] Cross-platform changes
- [ ] Documentation only

## Related Issues
Fixes #(issue number)
Closes #(issue number)
Related to #(issue number)

## Testing

### Windows Testing
- [ ] Tested Windows batch script (pm-agent-config.bat)
- [ ] Tested PowerShell script (pm-agent-config.ps1)
- [ ] Tested interactive menu functionality
- [ ] Tested command-line parameters
- [ ] Tested with Administrator privileges
- [ ] Tested registry modifications
- [ ] Tested DCAgent service interactions
- [ ] Verified error handling

### Linux Testing (if applicable)
- [ ] Tested shell scripts
- [ ] Tested configuration file modifications
- [ ] Tested service interactions
- [ ] Tested permission handling

### Cross-Platform Testing
- [ ] Documentation updates are accurate
- [ ] Build scripts work correctly
- [ ] Configuration templates are valid

## Environment Tested
- **OS:** [e.g. Windows 10, Windows Server 2019, Ubuntu 22.04]
- **Tool Version:** [current version being modified]
- **DCAgent Version:** [if applicable]
- **PowerShell Version:** [if applicable]

## Registry/Configuration Changes
List any registry keys or configuration files that are modified by this change:
- Windows Registry:
- Linux Configuration:
- Service Settings:

## Screenshots/Output
If applicable, add screenshots or sample output to help explain your changes.

## Security Considerations
- [ ] No new security vulnerabilities introduced
- [ ] Proper privilege checking implemented
- [ ] Input validation added where needed
- [ ] Error messages don't expose sensitive information
- [ ] Registry/config access is properly controlled
- [ ] Audit logging considerations addressed

## Checklist
- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review of my code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] I have added entries to CHANGELOG.md for significant changes
- [ ] My changes generate no new warnings
- [ ] I have tested that my fix is effective or that my feature works
- [ ] New and existing scripts pass syntax validation
- [ ] Registry/configuration changes have been tested safely

## Deployment Impact
- [ ] No impact on existing deployments
- [ ] Requires manual intervention during upgrade
- [ ] Backward compatible with previous versions
- [ ] Breaking change requiring documentation update
- [ ] Requires administrator/root privileges
- [ ] Affects enterprise deployment procedures

## Documentation Updates
- [ ] README.md updated (if needed)
- [ ] Windows documentation updated (src/windows/README.md)
- [ ] Linux documentation updated (if applicable)
- [ ] Configuration examples updated
- [ ] Troubleshooting guide updated
- [ ] Deployment guide updated

## Additional Notes
Add any additional notes, considerations, or context for reviewers.

## Rollback Plan
How can this change be rolled back if issues are discovered post-deployment?
- Registry changes:
- Configuration changes:
- Service impacts:
