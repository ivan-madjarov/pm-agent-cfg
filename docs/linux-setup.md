# Linux Setup Guide

## Prerequisites
- Linux distribution (CentOS 7+, Ubuntu 18.04+, RHEL 7+)
- Python 3.8+
- sudo privileges

## Installation
1. Clone the repository
2. Run the installation script: `sudo ./scripts/linux/install.sh`
3. Configure the agent: `./config/linux/agent.conf`

## Configuration
Edit `/etc/pm-agent/config.conf` for system-wide settings.

## Service Management
- Start: `sudo systemctl start pm-agent`
- Stop: `sudo systemctl stop pm-agent`
- Status: `sudo systemctl status pm-agent`

