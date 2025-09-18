#!/bin/bash

# Battery charge limit script for ASUS and other laptops
# Usage: battery_limit.sh [limit] where limit is between 20-100
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUTH_SCRIPT="$SCRIPT_DIR/auth_powerprofile.sh"

# Check if system is ASUS
is_asus() {
    if [ -f "/sys/class/dmi/id/sys_vendor" ]; then
        local vendor=$(cat /sys/class/dmi/id/sys_vendor)
        if [[ "$vendor" == *"ASUS"* ]] || [[ "$vendor" == *"ASUSTeK"* ]]; then
            return 0
        fi
    fi
    return 1
}

# Check prerequisites
check_prerequisites() {
    if is_asus; then
        if ! command -v asusctl &> /dev/null; then
            echo "Error: asusctl is not installed"
            notify-send "Battery" "asusctl is not installed" -u critical
            return 1
        fi
    else
        # For non-ASUS devices, check if the sysfs path exists
        if [ ! -f "/sys/class/power_supply/BAT0/charge_control_end_threshold" ]; then
            echo "Error: Battery charge control not supported on this device"
            notify-send "Battery" "Battery charge control not supported on this device" -u critical
            return 1
        fi
    fi
    
    # Check if auth script exists
    if [ ! -f "$AUTH_SCRIPT" ]; then
        echo "Error: Authentication script not found"
        notify-send "Battery" "Authentication script not found" -u critical
        return 1
    fi
    
    return 0
}

# Get current charge limit
get_current_limit() {
    if is_asus; then
        # For ASUS devices, try to use asusctl first
        if command -v asusctl &> /dev/null; then
            asusctl -c | grep -o '[0-9]*%' | tr -d '%'
        else
            # Fallback to sysfs if asusctl is not available
            cat /sys/class/power_supply/BAT*/charge_control_end_threshold 2>/dev/null | head -n1
        fi
    else
        # For non-ASUS devices, use sysfs
        cat /sys/class/power_supply/BAT*/charge_control_end_threshold 2>/dev/null | head -n1
    fi
}

# Set new charge limit
set_charge_limit() {
    local limit=$1
    
    # Validate input
    if [[ ! $limit =~ ^[0-9]+$ ]] || [ $limit -lt 20 ] || [ $limit -gt 100 ]; then
        echo "Error: Please provide a valid charge limit between 20-100"
        return 1
    fi
    
    if is_asus; then
        echo "execute with asusctl"
        asusctl -c $limit
    else
        echo "execute with change value on /sys/class/power_supply/BAT0/charge_control_end_threshold"
        "$AUTH_SCRIPT" sh -c "echo $limit >> /sys/class/power_supply/BAT0/charge_control_end_threshold"
    fi

    # Verify the change
    # local new_limit=$(get_current_limit)

    # if [ "$new_limit" = "$limit" ]; then
    #     echo "Battery charge limit set to $limit%"
        notify-send "Battery" "Charge limit set to $limit%" -u normal
    # else
    #     echo "Failed to set battery charge limit"
    #     notify-send "Battery" "Failed to set charge limit" -u critical
    #     return 1
    # fi
}

# Toggle between common charge limits
toggle_charge_limit() {
    local current=$(get_current_limit)
    
    case $current in
        80)
            set_charge_limit 90
            ;;
        90)
            set_charge_limit 100
            ;;
        100)
            set_charge_limit 80
            ;;
        *)
            set_charge_limit 80
            ;;
    esac
}

# Main script logic
if ! check_prerequisites; then
    exit 1
fi

case "$1" in
    "")
        echo "Current battery charge limit: $(get_current_limit)%"
        echo "Usage: $0 [limit|toggle]"
        echo "  limit: Set charge limit (20-100)"
        echo "  toggle: Cycle between 80%, 90%, and 100%"
        ;;
    toggle)
        toggle_charge_limit
        ;;
    *)
        set_charge_limit $1
        ;;
esac