#!/bin/bash
# PM+ Agent Configuration Tool - Linux Version
# Configures DesktopCentral UEMS Agent performance settings via JSON configuration

set -e

# Configuration constants
readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_VERSION="1.0.0"
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
    --mode <mode>       Set performance mode (low, medium, high, ultra)
    --status           Show current performance settings
    --backup           Create backup of current settings
    --restore          Restore from backup
    --menu             Interactive menu mode
    --dry-run          Show what would be changed without applying
    --restart          Force service restart after configuration
    --no-restart       Skip service restart prompt
    --verbose          Enable verbose output
    --help             Show this help message

PERFORMANCE MODES:
    low     - 15% CPU limit (recommended for production servers)
    medium  - 20% CPU limit (good for mixed workloads)  
    high    - 30% CPU limit (recommended for workstations)
    ultra   - 40% CPU limit (use with caution)

EXAMPLES:
    sudo $SCRIPT_NAME --mode high
    sudo $SCRIPT_NAME --mode low --restart
    sudo $SCRIPT_NAME --status
    sudo $SCRIPT_NAME --menu
    sudo $SCRIPT_NAME --backup
    sudo $SCRIPT_NAME --dry-run --mode low --no-restart

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
        local services=("dcservice" "uems_agent" "dcagent" "manageengine-uems-agent")
        local found_service=false
        
        for service in "${services[@]}"; do
            if systemctl list-unit-files --no-legend --no-pager | grep -q "^$service.service"; then
                local status=$(systemctl is-active "$service" 2>/dev/null || echo "inactive")
                if [[ "$status" == "active" ]]; then
                    echo "Service Status ($service): ✓ RUNNING"
                elif [[ "$status" == "inactive" ]]; then
                    echo "Service Status ($service): ✗ STOPPED"
                else
                    echo "Service Status ($service): $status"
                fi
                found_service=true
                break
            fi
        done
        
        if [[ "$found_service" == "false" ]]; then
            echo "Service Status: ✗ NO KNOWN SERVICES FOUND"
        fi
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
    
    if [[ -z "${PERFORMANCE_MODES[$mode]}" ]]; then
        log_error "Invalid performance mode: $mode"
        log_info "Available modes: ${!PERFORMANCE_MODES[*]}"
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

# Restart UEMS agent services
restart_agent_services() {
    log_info "Restarting UEMS Agent services to apply changes..."
    
    local services=("dcservice" "uems_agent" "dcagent" "manageengine-uems-agent")
    local restarted=false
    
    for service in "${services[@]}"; do
        if systemctl is-active --quiet "$service" 2>/dev/null; then
            if [[ "$DRY_RUN" == "true" ]]; then
                log_info "[DRY RUN] Would restart service: $service"
            else
                log_verbose "Restarting service: $service"
                systemctl restart "$service" && {
                    log_success "Service restarted: $service"
                    restarted=true
                } || {
                    log_warning "Failed to restart service: $service"
                }
            fi
        fi
    done
    
    if [[ "$restarted" == "false" && "$DRY_RUN" == "false" ]]; then
        log_warning "No known UEMS Agent services found to restart"
        log_info "You may need to manually restart the agent service"
    fi
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
        echo "Select an option:"
        echo ""
        echo "Performance Modes:"
        echo "  1) Low Performance (15% CPU limit)"
        echo "  2) Medium Performance (20% CPU limit)"
        echo "  3) High Performance (30% CPU limit)"
        echo "  4) Ultra Performance (40% CPU limit)"
        echo ""
        echo "Other Options:"
        echo "  5) Show Current Settings and Service Status"
        echo "  6) Create Backup"
        echo "  7) Restore from Backup"
        echo "  8) Restart PM+ Agent Service"
        echo "  9) Help"
        echo "  10) Exit"
        echo ""
        read -p "Enter your choice (1-10): " choice
        
        case $choice in
            1) set_performance_mode "low"; read -p "Press Enter to continue..."; ;;
            2) set_performance_mode "medium"; read -p "Press Enter to continue..."; ;;
            3) set_performance_mode "high"; read -p "Press Enter to continue..."; ;;
            4) set_performance_mode "ultra"; read -p "Press Enter to continue..."; ;;
            5) show_current_settings; read -p "Press Enter to continue..."; ;;
            6) create_backup; read -p "Press Enter to continue..."; ;;
            7) restore_backup; read -p "Press Enter to continue..."; ;;
            8) restart_agent_services; read -p "Press Enter to continue..."; ;;
            9) show_help; read -p "Press Enter to continue..."; ;;
            10) log_info "Exiting..."; exit 0; ;;
            *) log_error "Invalid choice. Please select 1-10."; sleep 2; ;;
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
