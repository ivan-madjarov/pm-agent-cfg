# Windows Setup Guide

## Prerequisites  
- Windows Server 2019+ or Windows 10+
- PowerShell 5.1+
- Administrator privileges

## Installation
1. Clone the repository
2. Run the installation script as Administrator: `.\scripts\windows\install.ps1`
3. Configure the agent: `.\config\windows\agent.conf`

## Configuration
Edit `C:\ProgramData\pm-agent\config.conf` for system-wide settings.

## Service Management
- Install service: `.\scripts\windows\install-service.ps1`
- Start: `Start-Service pm-agent`
- Stop: `Stop-Service pm-agent`
- Status: `Get-Service pm-agent`

