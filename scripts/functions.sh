function prevent_sudo_or_root() {
    if [ "$EUID" -eq 0 ] || [ "$(id -u)" -eq 0 ]; then
        echo "Error: This script should not be run as root or with sudo."
        exit 1
    fi
}

function backup_hypr_config() {
    local user="$1"
    local backup_dir="$HOME/.config/hypr/backups/hypr-backup-$(date +%Y%m%d-%H%M%S)"
    
    echo "Creating backup of existing hyprland config..."
    mkdir -p "$backup_dir"
    
    # Just copy and don't check exit status
    cp -r "$HOME/.config/hypr/"* "$backup_dir/" 2>/dev/null || true
    
    echo "Backup created at: $backup_dir"
}

function backup_ags_config(){
    local user="$1"
    local backup_ags_dir="$HOME/.config/ags/backups/ags-backup-$(date +%Y%m%d-%H%M%S)"
    
    echo "Creating backup of existing ags config..."
    mkdir -p "$backup_dir"

    cp -r "$HOME/.config/ags/"* "$backup_dir/" 2>/dev/null || true

    echo "Backup Created at : $backup_dir"
    
}

function ask_confirmation() {
  local prompt="$1"
  read -p "$prompt (y/N): " -n 1 -r
  echo
  [[ $REPLY =~ ^[Yy]$ ]]
}

function run_with_privileges() {
    if command -v pkexec >/dev/null 2>&1; then
        pkexec "$@"
    else
        echo "Please enter your password to continue:"
        sudo "$@"
    fi
}

function prompt_reboot() {
    echo ""
    echo "================================================"
    echo "INSTALLATION COMPLETED SUCCESSFULLY!"
    echo "================================================"
    echo ""
    echo "Some changes may require a reboot to take effect."
    echo ""
    
    local timeout=10
    local response=""
    
    while [[ $timeout -gt 0 ]]; do
        echo -ne "\rDo you want to reboot now? (y/N) - Auto-reboot in $timeout seconds... "
        read -t 1 -n 1 response 2>/dev/null
        
        # If user pressed a key, break out of the loop
        if [[ $? -eq 0 ]]; then
            echo ""
            break
        fi
        
        ((timeout--))
    done
    
    # If timer expired without user input, default to no
    if [[ $timeout -eq 0 ]]; then
        echo -e "\nNo response received. Not rebooting."
        response="n"
    fi
    
    case "$response" in
        [Yy]* )
            echo "System will reboot in 5 seconds... Press Ctrl+C to cancel."
            sleep 5
            run_with_privileges reboot
            ;;
        * )
            echo "Reboot skipped. Please reboot manually when convenient."
            echo "You can reboot with: reboot"
            ;;
    esac
}