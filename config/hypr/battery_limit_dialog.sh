#!/bin/bash

# Battery charge limit script with GTK dialog for ASUS laptops

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
    if ! is_asus; then
        zenity --error --text="This system is not an ASUS laptop" --title="Battery Charge Limit"
        return 1
    fi
    
    if ! command -v asusctl &> /dev/null; then
        zenity --error --text="asusctl is not installed" --title="Battery Charge Limit"
        return 1
    fi
    
    return 0
}

# Get current charge limit
get_current_limit() {
    cat /sys/class/power_supply/BAT*/charge_control_end_threshold 2>/dev/null | head -n1
}

# Set new charge limit
set_charge_limit() {
    local limit=$1
    
    # Validate input
    if [[ ! $limit =~ ^[0-9]+$ ]] || [ $limit -lt 20 ] || [ $limit -gt 100 ]; then
        zenity --error --text="Please provide a valid charge limit between 20-100" --title="Battery Charge Limit"
        return 1
    fi
    
    # Set the charge limit using asusctl
    asusctl -c $limit
    
    # Verify the change
    local new_limit=$(get_current_limit)
    if [ "$new_limit" = "$limit" ]; then
        zenity --info --text="Battery charge limit set to $limit%" --title="Battery Charge Limit"
    else
        zenity --error --text="Failed to set battery charge limit" --title="Battery Charge Limit"
        return 1
    fi
}

# Show GTK dialog to set charge limit
show_charge_limit_dialog() {
    local current=$(get_current_limit)
    
    # Show dialog with current value as default
    local new_limit=$(zenity --scale --text="Set battery charge limit" --title="Battery Charge Limit" \
        --value=$current --min-value=20 --max-value=100 --step=5)
    
    # Check if user pressed OK
    if [ $? -eq 0 ] && [ -n "$new_limit" ]; then
        set_charge_limit $new_limit
    fi
}

# Main script logic
if ! check_prerequisites; then
    exit 1
fi

case "$1" in
    "")
        show_charge_limit_dialog
        ;;
    *)
        set_charge_limit $1
        ;;
esac