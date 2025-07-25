# PM Agent Configuration - Deployment Guide

## 🚀 **Quick Deployment**

### For Single Machine
1. **Download** or copy `pm-agent-config.bat` 
2. **Right-click** → "Run as administrator"
3. **Choose mode**:
   - Command-line: `pm-agent-config.bat --mode low`
   - Interactive: `pm-agent-config.bat --menu`

### For Multiple Machines
```batch
REM Copy to network share
copy pm-agent-config.bat \\server\share\tools\

REM Run on target machines
\\server\share\tools\pm-agent-config.bat --mode low --verbose
```

### For Enterprise (Group Policy)
1. **Copy** `pm-agent-config.bat` to SYSVOL
2. **Create GPO** with Computer Startup Script:
   ```batch
   \\domain.com\sysvol\domain.com\scripts\pm-agent-config.bat --mode low
   ```

## 📋 **Verification Script**

```batch
@echo off
echo Checking PM Agent Configuration...
pm-agent-config.bat --status
echo.
echo Restarting DCAgent service...
net stop DCAgent
net start DCAgent
echo Done!
```

## 🎯 **Best Practices**

- **Test first** in non-production environment
- **Use low mode** for production servers (15% CPU)
- **Use high mode** for workstations (30% CPU)
- **Restart DCAgent service** after configuration changes
- **Verify settings** with `--status` option

## 📁 **Files Needed**

**Minimum**: Just `pm-agent-config.bat` (10KB)
**Optional**: `pm-agent-config.exe` (if compiled, ~1-2MB)
