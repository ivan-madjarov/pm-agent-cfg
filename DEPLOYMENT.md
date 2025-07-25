# PM+ Agent Configuration - Deployment Guide

## 🚀 **Quick Deployment**

### Windows - Single Machine
1. **Download** the script: `scripts/windows/pm-agent-config.bat`
2. **Right-click** → "Run as administrator"
3. **Choose mode**:
   - Command-line: `pm-agent-config.bat --mode high`
   - Interactive: `pm-agent-config.bat --menu`

### Linux - Single Machine
1. **Download** the script: `scripts/linux/pm-agent-config.sh`
2. **Make executable**: `chmod +x pm-agent-config.sh`
3. **Run with sudo**: `sudo ./pm-agent-config.sh --mode high`

### Windows - Multiple Machines
```batch
REM Copy to network share
copy scripts\windows\pm-agent-config.bat \\server\share\tools\

REM Run on target machines
\\server\share\tools\pm-agent-config.bat --mode high --verbose
```

### Linux - Multiple Machines
```bash
# Copy to target machines
for server in server1 server2 server3; do
    scp scripts/linux/pm-agent-config.sh root@$server:/tmp/
    ssh root@$server "chmod +x /tmp/pm-agent-config.sh && /tmp/pm-agent-config.sh --mode high"
done
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
echo Checking PM+ Agent Configuration...
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
