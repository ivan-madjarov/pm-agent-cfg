# Linux Configuration Tool

**Zero-dependency solution** for configuring DesktopCentral UEMS Agent performance settings via JSON configuration.

## 🎯 **The Solution**

A comprehensive shell script that manages PM+ Agent CPU throttling settings through the `PerformanceSettings.json` file with **no external dependencies**. Choose your preferred interface:

### ✅ **Primary Tool: Shell Script**
**File**: `scripts/linux/pm-agent-config.sh`
- **Zero dependencies** - pure bash script with built-in JSON handling
- **Multiple interfaces** - command-line AND interactive menu modes
- **Performance modes** - Low (15%), Medium (20%), High (30%), Ultra (40%) CPU limits
- **Built-in safety** - automatic backup before changes, rollback support
- **Service integration** - automatic service restart to apply changes
- **Comprehensive validation** - checks for UEMS agent installation and privileges

## 🚀 **Quick Start**

### Command-Line Usage (IT Professionals)
```bash
sudo ./pm-agent-config.sh --mode high    # 30% CPU limit
sudo ./pm-agent-config.sh --mode low     # 15% CPU limit  
sudo ./pm-agent-config.sh --status       # Show current settings
sudo ./pm-agent-config.sh --backup       # Create configuration backup
```

### Interactive Menu (End Users)
```bash
sudo ./pm-agent-config.sh --menu
# Follow the numbered menu prompts
```

### Default Behavior
```bash
sudo ./pm-agent-config.sh
# Launches interactive menu by default
```

## ⚙️ **Performance Modes**

| Mode | CPU Limit | Description | Use Case |
|------|-----------|-------------|----------|
| **low** | 15% | Conservative resource usage | Production servers, critical systems |
| **medium** | 20% | Balanced performance | Mixed workloads, general purpose |
| **high** | 30% | Aggressive scanning | Workstations, development systems |
| **ultra** | 40% | Maximum performance | Testing, temporary high-throughput needs |

## 📁 **Configuration Details**

### Target File Location
```
/usr/local/manageengine/uems_agent/data/PerformanceSettings.json
```

### Configuration Format
The script generates JSON configurations like:
```json
{
    "cpu": {
        "dcservice": 30,
        "dcfilescan": 30,
        "dcconfig": 30,
        "dcinventory": 30,
        "dcpatchscan": 30
    }
}
```

### Automatic Backup
- **Backup location**: `/usr/local/manageengine/uems_agent/data/PerformanceSettings.json.backup`
- **Auto-backup**: Created before each configuration change
- **Restore option**: `--restore` flag to rollback changes

## 🔧 **Complete Command Reference**

### Basic Operations
```bash
# Set performance modes
sudo ./pm-agent-config.sh --mode low      # 15% CPU limit
sudo ./pm-agent-config.sh --mode medium   # 20% CPU limit
sudo ./pm-agent-config.sh --mode high     # 30% CPU limit
sudo ./pm-agent-config.sh --mode ultra    # 40% CPU limit

# Status and information
sudo ./pm-agent-config.sh --status        # Show current configuration
sudo ./pm-agent-config.sh --help          # Show help information

# Backup and restore
sudo ./pm-agent-config.sh --backup        # Create backup manually
sudo ./pm-agent-config.sh --restore       # Restore from backup

# Interactive mode
sudo ./pm-agent-config.sh --menu          # Interactive menu
sudo ./pm-agent-config.sh                 # Default to menu mode
```

### Advanced Options
```bash
# Dry run (preview changes without applying)
sudo ./pm-agent-config.sh --dry-run --mode high

# Verbose output (detailed logging)
sudo ./pm-agent-config.sh --verbose --mode low

# Combined options
sudo ./pm-agent-config.sh --verbose --dry-run --mode medium
```

## 📊 **Interactive Menu**

The interactive menu provides a user-friendly interface:

```
================================================================
PM+ Agent Configuration Tool - Linux Version
================================================================

Select an option:

Performance Modes:
  1) Low Performance (15% CPU limit)
  2) Medium Performance (20% CPU limit)
  3) High Performance (30% CPU limit)
  4) Ultra Performance (40% CPU limit)

Other Options:
  5) Show Current Settings
  6) Create Backup
  7) Restore from Backup
  8) Help
  9) Exit

Enter your choice (1-9):
```

## 🔒 **Security & Safety**

### Privileges Required
- **Root access**: Must run with `sudo` or as root user
- **File permissions**: Write access to `/usr/local/manageengine/uems_agent/data/`

### Safety Features
- **Automatic backup**: Before each configuration change
- **Privilege checking**: Validates root access before making changes
- **Path validation**: Confirms UEMS agent installation before proceeding
- **JSON validation**: Ensures configuration file integrity
- **Service handling**: Safely restarts agent services

### Error Handling
- **Graceful failures**: Clear error messages with suggested solutions
- **Rollback capability**: Restore previous configuration if needed
- **Dry-run mode**: Preview changes without applying them

## 🛠 **Requirements**

### System Requirements
- **Linux Distribution**: CentOS, Ubuntu, RHEL, Debian
- **Privileges**: Root/sudo access
- **DesktopCentral**: UEMS Agent must be installed
- **Dependencies**: None (pure bash script)

### Optional Enhancements
- **jq**: For pretty JSON formatting (auto-detected, not required)
- **systemctl**: For automatic service restart (fallback available)

### File System Requirements
- **Write access**: `/usr/local/manageengine/uems_agent/data/`
- **Disk space**: Minimal (configuration files are < 1KB)

## 🔍 **Troubleshooting**

### Common Issues

#### "Script must be run as root"
```bash
# Solution: Use sudo
sudo ./pm-agent-config.sh --mode high
```

#### "UEMS Agent directory not found"
```bash
# Check if agent is installed
ls -la /usr/local/manageengine/uems_agent/

# If not found, install DesktopCentral UEMS Agent first
```

#### "No known UEMS Agent services found"
```bash
# Check service status manually
systemctl status uems_agent
systemctl status dcagent
systemctl status manageengine-uems-agent

# Manual restart if needed
sudo systemctl restart [service_name]
```

#### "Configuration file contains invalid JSON"
```bash
# Restore from backup
sudo ./pm-agent-config.sh --restore

# Or recreate configuration
sudo ./pm-agent-config.sh --mode high
```

### Validation Commands
```bash
# Check current configuration
sudo ./pm-agent-config.sh --status

# Verify JSON syntax (if jq available)
jq . /usr/local/manageengine/uems_agent/data/PerformanceSettings.json

# Check service status
systemctl status uems_agent
```

### Log Analysis
```bash
# Check system logs for agent activity
journalctl -u uems_agent -f

# Check agent logs (if available)
tail -f /usr/local/manageengine/uems_agent/logs/*.log
```

## 🚀 **Deployment**

### Single Server Deployment
```bash
# Copy script to server
scp pm-agent-config.sh user@server:/tmp/

# Connect and run
ssh user@server
sudo /tmp/pm-agent-config.sh --mode high
```

### Bulk Deployment
```bash
# For multiple servers
for server in server1 server2 server3; do
    echo "Configuring $server..."
    scp pm-agent-config.sh root@$server:/tmp/
    ssh root@$server "/tmp/pm-agent-config.sh --mode high"
done
```

### Configuration Management
```bash
# Ansible example
- name: Configure PM+ Agent performance
  script: pm-agent-config.sh --mode high
  become: yes

# Puppet/Chef: Use exec resource to run script
```

## 📈 **Monitoring**

### Verify Configuration Applied
```bash
# Check configuration file
sudo cat /usr/local/manageengine/uems_agent/data/PerformanceSettings.json

# Monitor CPU usage
top -p $(pgrep -f "dcconfig|dcservice|dcfilescan")

# Check process limits
ps aux | grep -E "dcconfig|dcservice|dcfilescan"
```

### Performance Monitoring
```bash
# Watch agent processes
watch "ps aux | grep -E 'dc(config|service|filescan|inventory|patchscan)'"

# Monitor resource usage
htop -p $(pgrep -f "dc")
```

## 🔄 **Comparison with Windows**

| Feature | Linux | Windows |
|---------|-------|---------|
| **Configuration Method** | JSON file | Registry keys |
| **File Location** | `/usr/local/manageengine/uems_agent/data/PerformanceSettings.json` | Registry: `HKLM\SOFTWARE\AdventNet\...` |
| **Performance Modes** | Low (15%), Medium (20%), High (30%), Ultra (40%) | Low (15%), Medium (20%), High (30%), Ultra (40%) |
| **Backup Method** | File backup | Registry export |
| **Service Restart** | systemctl | Windows services |
| **Privileges Required** | sudo/root | Administrator |
| **Dependencies** | None (bash only) | None (batch only) |

Both platforms provide identical functionality with platform-appropriate implementation methods.

## 📚 **Additional Resources**

- [Main Project Documentation](../../README.md)
- [Windows Configuration Guide](../windows/README.md)
- [Contributing Guidelines](../../CONTRIBUTING.md)
- [Security Policy](../../SECURITY.md)

---

**Need help?** Check the [troubleshooting section](#-troubleshooting) or create an issue in the project repository.
