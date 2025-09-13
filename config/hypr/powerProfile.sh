#!/bin/bash

# Power Profile Manager
# Uses powerprofilesctl and cpupower to manage power profiles

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
AUTH_SCRIPT="$SCRIPT_DIR/auth_powerprofile.sh"

# Function to get minimum CPU frequency in MHz
get_min_frequency() {
    # Extract the minimum frequency value and unit
    local min_freq_line=$(cpupower frequency-info | grep "hardware limits")
    local min_freq_value=$(echo "$min_freq_line" | awk '{print $4}')
    local min_freq_unit=$(echo "$min_freq_line" | awk '{print $5}')
    
    # Check if frequency is in GHz or MHz and convert to MHz
    if [[ $min_freq_unit == "GHz" ]]; then
        # Convert GHz to MHz
        echo $(echo "$min_freq_value * 1000" | bc | awk '{print int($1)}')
    elif [[ $min_freq_unit == "MHz" ]]; then
        # Return MHz value as is
        echo $(echo "$min_freq_value" | awk '{print int($1)}')
    else
        # Default fallback
        echo "400"
    fi
}

# Function to format frequency for cpupower (convert MHz to appropriate unit)
format_frequency() {
    local freq_mhz=$1
    if [ "$freq_mhz" -ge 1000 ]; then
        # For frequencies >= 1000 MHz, convert to GHz with 2 decimal places
        local freq_ghz=$(echo "scale=2; $freq_mhz/1000" | bc)
        # Remove trailing zeros and decimal point if not needed
        local formatted_ghz=$(echo $freq_ghz | sed 's/\.00$//' | sed 's/0$//')
        echo "${formatted_ghz}GHz"
    else
        echo "${freq_mhz}MHz"
    fi
}

# Function to display current power profile
show_current_profile() {
    echo "Current power profile: $(powerprofilesctl get)"
    echo "Current CPU governor: $(cpupower frequency-info --policy | grep governor | awk '{print $3}')"
}

# High Performance Mode
# - Uses performance profile from powerprofilesctl
# - Sets CPU governor to performance
# - Sets EPP to performance
# - -d: 1.5x minimum frequency
# - -u: Maximum frequency
high_performance() {
    echo "Setting High Performance Mode..."
    powerprofilesctl set performance
    
    # Get minimum frequency in MHz
    local min_freq=$(get_min_frequency)
    
    # Calculate frequencies based on requirements
    local min_freq_performance=$(echo "$min_freq * 1.5" | bc | awk '{print int($1)}')
    local max_freq=4470  # 4.47GHz in MHz
    
    # Format frequencies for cpupower
    local min_freq_formatted=$(format_frequency $min_freq_performance)
    local max_freq_formatted=$(format_frequency $max_freq)
    
    echo "Setting CPU frequency range: ${min_freq_formatted} - ${max_freq_formatted}"
    "$AUTH_SCRIPT" cpupower frequency-set -d "$min_freq_formatted"
    "$AUTH_SCRIPT" cpupower frequency-set -u "$max_freq_formatted"
    
    # "$AUTH_SCRIPT" cpupower set -b 0  # Performance bias
    echo "High Performance Mode activated!"
    show_current_profile
}

# Cool CPU Mode
# - Uses balanced profile from powerprofilesctl
# - Sets CPU governor to powersave for cooler operation
# - Sets EPP to balance_performance
# - -d: minimum frequency
# - -u: 3x to 4x minimum frequency
cool_cpu() {
    echo "Setting Cool CPU Mode..."
    powerprofilesctl set balanced
    
    # Get minimum frequency in MHz
    local min_freq=$(get_min_frequency)
    
    # Calculate frequencies based on requirements
    local min_freq_cool=$min_freq
    local max_freq_cool=$(echo "$min_freq * 3.5" | bc | awk '{print int($1)}')  # Using 3.5x as midpoint of 3x-4x
    
    # Format frequencies for cpupower
    local min_freq_formatted=$(format_frequency $min_freq_cool)
    local max_freq_formatted=$(format_frequency $max_freq_cool)
    
    echo "Setting CPU frequency range: ${min_freq_formatted} - ${max_freq_formatted}"
    "$AUTH_SCRIPT" cpupower frequency-set -d "$min_freq_formatted"
    "$AUTH_SCRIPT" cpupower frequency-set -u "$max_freq_formatted"
    
    # "$AUTH_SCRIPT" cpupower set -b 4  # Balance performance
    echo "Cool CPU Mode activated!"
    show_current_profile
}

# Power Saver Mode
# - Uses power-saver profile from powerprofilesctl
# - Sets CPU governor to powersave
# - Sets EPP to power
# - -d: minimum frequency
# - -u: 1.5x to 2x minimum frequency
power_saver() {
    echo "Setting Power Saver Mode..."
    powerprofilesctl set power-saver
    
    # Get minimum frequency in MHz
    local min_freq=$(get_min_frequency)
    
    # Calculate frequencies based on requirements
    local min_freq_saver=$min_freq
    local max_freq_saver=$(echo "$min_freq * 2" | bc | awk '{print int($1)}')  # Using 1.75x as midpoint of 1.5x-2x
    
    # Format frequencies for cpupower
    local min_freq_formatted=$(format_frequency $min_freq_saver)
    local max_freq_formatted=$(format_frequency $max_freq_saver)
    
    echo "Setting CPU frequency range: ${min_freq_formatted} - ${max_freq_formatted}"
    "$AUTH_SCRIPT" cpupower frequency-set -d "$min_freq_formatted"
    "$AUTH_SCRIPT" cpupower frequency-set -u "$max_freq_formatted"
    
    # "$AUTH_SCRIPT" cpupower set -b 15  # Power saving bias
    echo "Power Saver Mode activated!"
    show_current_profile
}

# Main script logic
case "$1" in
    high-performance|performance)
        high_performance
        ;;
    cool-cpu|cool)
        cool_cpu
        ;;
    power-saver|saver)
        power_saver
        ;;
    status)
        show_current_profile
        ;;
    *)
        echo "Power Profile Manager"
        echo "Usage: $0 [high-performance|cool-cpu|power-saver|status]"
        echo ""
        echo "Modes:"
        echo "  high-performance  - Maximum performance mode"
        echo "  cool-cpu         - Balanced performance with cooler temperatures"
        echo "  power-saver      - Maximum power saving mode"
        echo "  status           - Show current power profile"
        echo ""
        show_current_profile
        ;;
esac