#!/bin/bash
# auth_powerprofile.sh - Simple boot-based authentication

CACHE_FILE="/tmp/powerprofile_auth_cache"
BOOT_ID_FILE="/tmp/powerprofile_boot_id"

# Function to get current boot ID
get_boot_id() {
    echo $(cat /proc/sys/kernel/random/boot_id 2>/dev/null || date +%s)
}

# Function to check if we need to re-authenticate after boot
check_boot_authentication() {
    local current_boot_id=$(get_boot_id)
    
    if [ -f "$BOOT_ID_FILE" ] && [ -f "$CACHE_FILE" ]; then
        local cached_boot_id=$(cat "$BOOT_ID_FILE")
        if [ "$cached_boot_id" = "$current_boot_id" ]; then
            # Same boot session, authentication is still valid
            return 0
        fi
    fi
    
    # System was rebooted or first run, need to re-authenticate
    rm -f "$CACHE_FILE"
    echo "$current_boot_id" > "$BOOT_ID_FILE"
    return 1
}

# Function to get sudo password with zenity dialog
get_sudo_password() {
    local message="Please enter your password to change power profile:"
    
    # Different message if it's the first time after boot
    if ! check_boot_authentication; then
        message="First authentication after boot. $message"
    fi
    
    zenity --password --title="Authentication Required" --text="$message"
}
g
# Check if we have valid cached authentication from current boot session
if check_boot_authentication; then
    # Use cached authentication
    sudo -n true 2>/dev/null
    if [ $? -eq 0 ]; then
        # sudo still valid, execute command
        sudo "$@"
        exit $?
    else
        # sudo session expired, remove cache
        rm -f "$CACHE_FILE"
    fi
fi

# Get password from user
PASSWORD=$(get_sudo_password)

# Check if user cancelled the dialog
if [ $? -ne 0 ]; then
    notify-send "Cancelled" "Power profile change cancelled." -u normal
    exit 1
fi

# If password is empty, show error
if [ -z "$PASSWORD" ]; then
    notify-send "Error" "Password cannot be empty." -u critical
    exit 1
fi

# Test the password and create cache if valid
if echo "$PASSWORD" | sudo -S -v 2>/dev/null; then
    # Password is valid, create cache file
    touch "$CACHE_FILE"
    chmod 600 "$CACHE_FILE"
    
    # Ensure boot ID is current
    get_boot_id > "$BOOT_ID_FILE"
    
    # Execute the command
    echo "$PASSWORD" | sudo -S "$@"
    exit $?
else
    notify-send "Error" "Invalid password. Please try again." -u critical
    exit 1
fi