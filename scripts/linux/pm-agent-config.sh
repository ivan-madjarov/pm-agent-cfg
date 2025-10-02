#!/bin/bash
# PM+ Agent Configuration Tool - Linux Version
# Copyright (c) 2024-2025 Mitel Networks Corporation - Proprietary Software
# Authorized for use by Mitel personnel and designated partners only
# Configures DesktopCentral UEMS Agent performance settings via JSON configuration

set -e

# Configuration constants
readonly SCRIPT_NAME="$(basename "$0")"
readonly CONFIG_DIR="/usr/local/manageengine/uems_agent/data"
readonly CONFIG_FILE="$CONFIG_DIR/PerformanceSettings.json"
readonly BACKUP_FILE="$CONFIG_DIR/PerformanceSettings.json.backup"

# Performance mode configurations
declare -A PERFORMANCE_MODES
PERFORMANCE_MODES["low"]='{"cpu":{"dcservice":15,"dcfilescan":15,"dcconfig":15,"dcinventory":15,"dcpatchscan":15}}'
PERFORMANCE_MODES["medium"]='{"cpu":{"dcservice":20,"dcfilescan":20,"dcconfig":20,"dcinventory":20,"dcpatchscan":20}}'
PERFORMANCE_MODES["high"]='{"cpu":{"dcservice":30,"dcfilescan":30,"dcconfig":30,"dcinventory":30,"dcpatchscan":30}}'
PERFORMANCE_MODES["ultra"]='{"cpu":{"dcservice":40,"dcfilescan":40,"dcconfig":40,"dcinventory":40,"dcpatchscan":40}}'

# Mode descriptions
declare -A MODE_DESCRIPTIONS
MODE_DESCRIPTIONS["low"]="Conservative (15% CPU limit - recommended for production servers)"
MODE_DESCRIPTIONS["medium"]="Balanced (20% CPU limit - good for mixed workloads)"
MODE_DESCRIPTIONS["high"]="Aggressive (30% CPU limit - recommended for workstations)"
MODE_DESCRIPTIONS["ultra"]="Maximum (40% CPU limit - use with caution)"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# Global flags
VERBOSE=false
DRY_RUN=false
RESTART_SERVICE=false
NO_RESTART=false

# Logging functions
log_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

log_verbose() {
    if [[ "$VERBOSE" == "true" ]]; then
        echo -e "${BLUE}[VERBOSE]${NC} $1"
    fi
}

# Check if running as root
check_privileges() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root (sudo)"
        log_info "Usage: sudo $SCRIPT_NAME [options]"
        exit 1
    fi
    log_verbose "Root privileges confirmed"
}

# Show script header
show_header() {
    echo "================================================================"
    echo "PM+ Agent Configuration Tool - Linux Version"
    echo "================================================================"
    echo ""
}

# Show help information
show_help() {
    cat << EOF
PM+ Agent Configuration Tool for Linux

DESCRIPTION:
    Configures DesktopCentral UEMS Agent CPU performance settings via JSON configuration.
    Manages PerformanceSettings.json file in the agent data directory.

USAGE:
    sudo $SCRIPT_NAME [OPTIONS]

OPTIONS:
    --mode <mode>       Set performance mode (low, medium, high, ultra, unset)
    --status            Show current performance settings
    --backup            Create backup of current settings
    --restore           Restore from backup
    --menu              Interactive menu mode
    (No arguments)      Launch interactive menu mode
    --dry-run           Show what would be changed without applying
    --restart           Force service restart after configuration
    --no-restart        Skip service restart prompt
    --unset             (Legacy alias) Remove configured limits (same as --mode unset)
    --verbose           Enable verbose output
    --help              Show this help message

PERFORMANCE MODES:
    low     - 15% CPU limit (recommended for production servers)
    medium  - 20% CPU limit (good for mixed workloads)  
    high    - 30% CPU limit (recommended for workstations)
    ultra   - 40% CPU limit (use with caution)
    unset   - Remove configured limits (set to unlimited)

EXAMPLES:
    sudo $SCRIPT_NAME --mode low           Configure for low performance
    sudo $SCRIPT_NAME --mode medium        Configure for medium performance
    sudo $SCRIPT_NAME --mode high          Configure for high performance
    sudo $SCRIPT_NAME --mode ultra         Configure for ultra performance
    sudo $SCRIPT_NAME --mode unset         Remove configured limits (set to unlimited)
    sudo $SCRIPT_NAME --status             Show current settings
    sudo $SCRIPT_NAME --menu               Show interactive menu
    sudo $SCRIPT_NAME --backup             Create backup of current settings
    sudo $SCRIPT_NAME --unset              (Legacy) Remove configured limits (same as --mode unset)

REQUIREMENTS:
    - Root/sudo privileges
    - DesktopCentral UEMS Agent installed
    - Write access to $CONFIG_DIR

FILES:
    Config: $CONFIG_FILE
    Backup: $BACKUP_FILE

For more information, see the documentation at:
https://github.com/ivan-madjarov/pm-agent-cfg
EOF
}

# Unset performance limits: remove PerformanceSettings.json (after backup)
unset_performance_limits() {
    echo ""
    log_info "Unsetting PM+ Agent performance limits (set to UNLIMITED)..."

    if [[ ! -f "$CONFIG_FILE" ]]; then
        log_warning "No performance config file found to unset: $CONFIG_FILE"
        return 0
    fi

    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY RUN] Would remove configuration file: $CONFIG_FILE"
        return 0
    fi

    # Create backup if not already present
    create_backup

    if rm -f "$CONFIG_FILE"; then
        log_success "Performance configuration removed: $CONFIG_FILE"

        if [[ "$RESTART_SERVICE" == "true" ]]; then
            restart_agent_services
        elif [[ "$NO_RESTART" == "false" ]]; then
            prompt_service_restart
        else
            log_info "Service restart skipped (--no-restart specified)"
        fi
    else
        log_error "Failed to remove configuration file: $CONFIG_FILE"
        return 1
    fi
}

# Check if UEMS agent directory exists
check_uems_agent() {
    if [[ ! -d "$CONFIG_DIR" ]]; then
        log_error "UEMS Agent directory not found: $CONFIG_DIR"
        log_info "Please ensure DesktopCentral UEMS Agent is installed"
        exit 1
    fi
    log_verbose "UEMS Agent directory found: $CONFIG_DIR"
}

# Create backup of current configuration
create_backup() {
    if [[ -f "$CONFIG_FILE" ]]; then
        if [[ "$DRY_RUN" == "true" ]]; then
            log_info "[DRY RUN] Would backup: $CONFIG_FILE → $BACKUP_FILE"
        else
            cp "$CONFIG_FILE" "$BACKUP_FILE"
            log_success "Configuration backed up to: $BACKUP_FILE"
        fi
    else
        log_warning "No existing configuration file to backup"
    fi
}

# Restore from backup
restore_backup() {
    if [[ ! -f "$BACKUP_FILE" ]]; then
        log_error "No backup file found: $BACKUP_FILE"
        exit 1
    fi
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY RUN] Would restore: $BACKUP_FILE → $CONFIG_FILE"
    else
        cp "$BACKUP_FILE" "$CONFIG_FILE"
        log_success "Configuration restored from backup"
        if [[ "$RESTART_SERVICE" == "true" ]]; then
            restart_agent_services
        elif [[ "$NO_RESTART" == "false" ]]; then
            prompt_service_restart
        else
            log_info "Service restart skipped (--no-restart specified)"
        fi
    fi
}

# Enhanced service status display
show_service_status() {
    local services=("dcservice" "uems_agent" "dcagent" "manageengine-uems-agent")
    local found_service=false
    
    for service in "${services[@]}"; do
        if systemctl list-unit-files --no-legend --no-pager 2>/dev/null | grep -q "^$service.service"; then
            local status=$(systemctl is-active "$service" 2>/dev/null || echo "inactive")
            local detailed_status=$(systemctl status "$service" --no-pager -l 2>/dev/null | grep "Active:" | awk '{print $2, $3}' || echo "unknown")
            
            case "$status" in
                "active")
                    echo "Service Status ($service): [OK] RUNNING"
                    ;;
                "inactive")
                    echo "Service Status ($service): [X] STOPPED"
                    ;;
                "activating")
                    echo "Service Status ($service): [~] STARTING..."
                    ;;
                "deactivating")
                    echo "Service Status ($service): [~] STOPPING..."
                    ;;
                "failed")
                    echo "Service Status ($service): [!] FAILED"
                    ;;
                "reloading")
                    echo "Service Status ($service): [~] RELOADING..."
                    ;;
                *)
                    echo "Service Status ($service): $status"
                    ;;
            esac
            found_service=true
            break
        fi
    done
    
    if [[ "$found_service" == "false" ]]; then
        echo "Service Status: [X] NO KNOWN SERVICES FOUND"
        log_info "Searched for: ${services[*]}"
    fi
}

# Show current performance settings
show_current_settings() {
    echo "Current PM+ Agent Performance Settings:"
    echo "====================================="
    echo ""
    
    if [[ -f "$CONFIG_FILE" ]]; then
        log_info "Configuration file: $CONFIG_FILE"
        echo ""
        
        if command -v jq >/dev/null 2>&1; then
            # Pretty print with jq if available
            echo "Performance Settings:"
            jq . "$CONFIG_FILE" 2>/dev/null || {
                log_warning "Configuration file exists but contains invalid JSON"
                echo "Raw content:"
                cat "$CONFIG_FILE"
            }
        else
            # Fallback to cat if jq not available
            echo "Raw configuration content:"
            cat "$CONFIG_FILE"
        fi
        
        echo ""
        log_info "File size: $(du -h "$CONFIG_FILE" | cut -f1)"
        log_info "Last modified: $(stat -c %y "$CONFIG_FILE")"
        
        # Show service status
        echo ""
        echo "PM+ Agent Service Status:"
        echo "========================"
        show_service_status
    else
        log_warning "No performance configuration file found"
        log_info "Expected location: $CONFIG_FILE"
        echo ""
        log_info "Available performance modes:"
        for mode in "${!MODE_DESCRIPTIONS[@]}"; do
            echo "  $mode: ${MODE_DESCRIPTIONS[$mode]}"
        done
    fi
}

# Apply performance mode configuration
set_performance_mode() {
    local mode="$1"
    
    # Ticket #202510024200014: support direct "--mode unset" (previously required --unset)
    if [[ "$mode" == "unset" ]]; then
        unset_performance_limits
        return $?
    fi
    
    if [[ -z "${PERFORMANCE_MODES[$mode]}" ]]; then
        log_error "Invalid performance mode: $mode"
        log_info "Available modes: ${!PERFORMANCE_MODES[*]} unset"
        exit 1
    fi
    
    local config_json="${PERFORMANCE_MODES[$mode]}"
    local description="${MODE_DESCRIPTIONS[$mode]}"
    
    echo ""
    log_info "Configuring PM+ Agent for $mode performance mode..."
    log_info "Description: $description"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY RUN] Would write configuration:"
        echo "$config_json" | jq . 2>/dev/null || echo "$config_json"
        return 0
    fi
    
    # Create backup before making changes
    create_backup
    
    # Write new configuration
    log_verbose "Writing configuration to: $CONFIG_FILE"
    echo "$config_json" | jq . > "$CONFIG_FILE" 2>/dev/null || {
        # Fallback if jq not available
        echo "$config_json" > "$CONFIG_FILE"
    }
    
    # Verify the file was written correctly
    if [[ -f "$CONFIG_FILE" ]]; then
        log_success "Performance configuration applied successfully"
        log_info "Configuration file: $CONFIG_FILE"
        
        # Show what was written
        if command -v jq >/dev/null 2>&1; then
            echo ""
            echo "Applied configuration:"
            jq . "$CONFIG_FILE"
        fi
        
        # Restart services to apply changes
        if [[ "$RESTART_SERVICE" == "true" ]]; then
            restart_agent_services
        elif [[ "$NO_RESTART" == "false" ]]; then
            prompt_service_restart
        else
            log_info "Service restart skipped (--no-restart specified)"
        fi
    else
        log_error "Failed to write configuration file"
        exit 1
    fi
}

# Restart UEMS agent services with enhanced state checking
restart_agent_services() {
    log_info "Restarting UEMS Agent services to apply changes..."
    
    local services=("dcservice" "uems_agent" "dcagent" "manageengine-uems-agent")
    local restarted=false
    local active_service=""
    
    # Find the active service first
    for service in "${services[@]}"; do
        if systemctl is-active --quiet "$service" 2>/dev/null; then
            active_service="$service"
            break
        fi
    done
    
    if [[ -z "$active_service" ]]; then
        log_warning "No active UEMS Agent services found"
        # Try to find any service that exists (even if stopped)
        for service in "${services[@]}"; do
            if systemctl list-unit-files --no-legend --no-pager 2>/dev/null | grep -q "^$service.service"; then
                active_service="$service"
                log_info "Found service (currently stopped): $service"
                break
            fi
        done
        
        if [[ -z "$active_service" ]]; then
            log_error "No known UEMS Agent services found to restart"
            log_info "Available services: ${services[*]}"
            return 1
        fi
    fi
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY RUN] Would restart service: $active_service"
        return 0
    fi
    
    # Check current service state
    local current_status=$(systemctl is-active "$active_service" 2>/dev/null || echo "inactive")
    
    case "$current_status" in
        "inactive")
            log_info "Service is already stopped, proceeding to start..."
            ;;
        "activating")
            log_info "Service is currently starting, waiting for it to complete..."
            sleep 5
            current_status=$(systemctl is-active "$active_service" 2>/dev/null || echo "inactive")
            if [[ "$current_status" == "active" ]]; then
                log_info "Service started successfully, will now restart it..."
            else
                log_warning "Service start appears to have failed, attempting restart..."
            fi
            ;;
        "deactivating")
            log_info "Service is currently stopping, waiting for it to complete..."
            sleep 5
            ;;
    esac
    
    log_verbose "Restarting service: $active_service"
    if systemctl restart "$active_service"; then
        log_success "Service restarted: $active_service"
        
        # Wait a moment and verify it's running
        sleep 2
        if systemctl is-active --quiet "$active_service"; then
            log_success "Service is running and configuration changes are now active"
        else
            log_warning "Service restart completed but may not be fully active yet"
        fi
        restarted=true
    else
        log_error "Failed to restart service: $active_service"
        log_info "You may need to manually restart the service:"
        log_info "  sudo systemctl restart $active_service"
        return 1
    fi
    
    return 0
}

# Prompt user for service restart
prompt_service_restart() {
    echo ""
    log_info "IMPORTANT: Service restart required for changes to take effect"
    
    local services=("dcservice" "uems_agent" "dcagent" "manageengine-uems-agent")
    local active_service=""
    
    # Find active service
    for service in "${services[@]}"; do
        if systemctl is-active --quiet "$service" 2>/dev/null; then
            active_service="$service"
            break
        fi
    done
    
    if [[ -n "$active_service" ]]; then
        log_info "Found active service: $active_service"
        echo ""
        read -p "Restart PM+ Agent service now? [y/N]: " -n 1 -r
        echo ""
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log_info "Restarting service: $active_service"
            systemctl restart "$active_service" && {
                log_success "Service restarted successfully - configuration changes are now active"
            } || {
                log_error "Failed to restart service"
            }
        else
            log_info "Service restart skipped. To apply changes manually:"
            log_info "  sudo systemctl restart $active_service"
        fi
    else
        log_warning "No active UEMS Agent services found"
        log_info "Please restart the agent service manually"
    fi
}

# Interactive menu
show_menu() {
    while true; do
        clear
        show_header
        echo "Select Performance Mode:"
        echo ""
        echo "0) Show Menu Options (refresh)"
        echo "1) Low Performance Mode    (CPU Usage: 15%, Scan Timeout: 200s)"
        echo "2) Medium Performance Mode (CPU Usage: 20%, Scan Timeout: 200s)"
        echo "3) High Performance Mode   (CPU Usage: 30%, Scan Timeout: 200s)"
        echo "4) Ultra Performance Mode  (CPU Usage: 40%, Scan Timeout: 200s)"
        echo "5) Show Current Settings and Service Status"
        echo "6) Restart PM+ Agent Service"
        echo "7) Unset Performance Limits (set to UNLIMITED)"
        echo "8) Exit"
        echo ""
        read -p "Enter your choice (0-8, 0 for menu): " choice
        
        case $choice in
            0) continue;; # Refresh menu
            1) set_performance_mode "low"; read -p "Press Enter to continue..."; ;;
            2) set_performance_mode "medium"; read -p "Press Enter to continue..."; ;;
            3) set_performance_mode "high"; read -p "Press Enter to continue..."; ;;
            4) set_performance_mode "ultra"; read -p "Press Enter to continue..."; ;;
            5) show_current_settings; read -p "Press Enter to continue..."; ;;
            6) restart_agent_services; read -p "Press Enter to continue..."; ;;
            7) unset_performance_limits; read -p "Press Enter to continue..."; ;;
            8) log_info "Exiting..."; exit 0; ;;
            *) log_error "Invalid choice. Please enter a number between 0 and 8."; sleep 2; ;;
        esac
    done
}

# Parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --mode)
                shift
                if [[ -n "$1" ]]; then
                    MODE="$1"
                else
                    log_error "Performance mode not specified"
                    exit 1
                fi
                ;;
            --status)
                STATUS=true
                ;;
            --backup)
                BACKUP=true
                ;;
            --restore)
                RESTORE=true
                ;;
            --menu)
                MENU=true
                ;;
            --dry-run)
                DRY_RUN=true
                ;;
            --restart)
                RESTART_SERVICE=true
                ;;
            --no-restart)
                NO_RESTART=true
                ;;
            --unset)
                UNSET=true
                ;;
            --verbose)
                VERBOSE=true
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
        shift
    done
}

# Main execution
main() {
    # Parse command line arguments
    parse_arguments "$@"
    
    # Show header
    show_header
    
    # Check prerequisites
    check_privileges
    check_uems_agent
    
    # Handle different modes of operation
    if [[ "$STATUS" == "true" ]]; then
        show_current_settings
    elif [[ "$BACKUP" == "true" ]]; then
        create_backup
    elif [[ "$RESTORE" == "true" ]]; then
        restore_backup
    elif [[ "$UNSET" == "true" ]]; then
        unset_performance_limits
    elif [[ -n "$MODE" ]]; then
        set_performance_mode "$MODE"
    elif [[ "$MENU" == "true" ]]; then
        show_menu
    else
        # Default to menu mode if no specific action
        show_menu
    fi
}

# Run main function with all arguments
main "$@"
