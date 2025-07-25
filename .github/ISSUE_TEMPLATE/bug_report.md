---
name: Bug Report
about: Create a report to help us improve
title: '[BUG] '
labels: 'bug'
assignees: ''

---

**Describe the bug**
A clear and concise description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Run command '...'
2. With parameters '...'
3. See error

**Expected behavior**
A clear and concise description of what you expected to happen.

**Environment Information:**
- **OS**: [e.g. Windows 10, Windows Server 2019, Ubuntu 22.04]
- **Tool Version**: [e.g. pm-agent-config.bat v1.0]
- **Administrator/Root**: [yes/no]
- **DCAgent Version**: [if applicable]

**Command Used**
```
Paste the exact command you ran here
```

**Error Output**
```
Paste any error messages or logs here
```

**Registry/Configuration State**
- Were any changes applied before the error? [yes/no]
- Current performance mode (if known): [low/high/unknown]
- Any manual registry/config modifications: [yes/no]

**Screenshots**
If applicable, add screenshots to help explain your problem.

**Additional context**
Add any other context about the problem here.

**Platform-Specific Information**

### Windows
- [ ] Used batch script (pm-agent-config.bat)
- [ ] Used PowerShell script (pm-agent-config.ps1)
- [ ] Used compiled EXE
- [ ] Used interactive menu
- **PowerShell Version**: [if applicable]
- **Execution Policy**: [if using PowerShell]

### Linux (if applicable)
- [ ] Used shell script
- **Shell**: [bash/zsh/etc.]
- **Distribution**: [Ubuntu/RHEL/CentOS/etc.]

**Registry/Service Status** (Windows)
If possible, provide output of:
```powershell
# Check DCAgent service status
Get-Service DCAgent

# Check current registry values (if accessible)
# Include any relevant registry query results
```
