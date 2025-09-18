#!/usr/bin/env bash

source ./scripts/functions.sh


prevent_sudo_or_root

export base="$(pwd)"

user="$(whoami)"

start_stack() {

# First, execute the dots-hyprland installation script
echo "Executing dots-hyprland installation script..."
bash ./dots-hyprland/install.sh




# Check if the previous command succeeded
if [ $? -ne 0 ]; then
    echo "Error: dots-hyprland installation failed. Aborting."
    exit 1
fi

echo "dots-hyprland installation completed successfully."


if [ -d "/home/$user/.config/hypr" ]; then
    echo "Hyprland config directory already exists at /home/$user/.config/hypr"
    echo "Contents:"
    ls "/home/$user/.config/hypr"
    echo ""
    
    # Ask for user confirmation
    read -p "Do you want to backup the existing hypr config and continue? (y/N): " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping backup and installation of new config."
    else
    backup_hypr_config "$user"
    fi
    
fi
echo ""
if ./scripts/test_asus_detection.sh | grep -q "ASUS" && ./scripts/test_battery_scripts.sh | grep -q "DETECTED"; then
echo "Asus Laptop with Battery detected Installing asusctl package..."
  yay -S asusctl --noconfirm
  
fi

if [ $? -ne 0 ]; then
    echo "Error: dots-hyprland installation failed. Aborting."
    exit 1
fi

bash ./scripts/installPackage.sh

if [ $? -ne 0 ]; then
    echo "Error: dots-hyprland installation failed. Aborting."
    exit 1
fi

echo ""
# Copy Hyprland configuration
echo "Copying Hyprland configuration..."
mkdir -p "$HOME/.config/hypr"
cp -r ./config/hypr/* "$HOME/.config/hypr/"

if [ -d "/home/$user/.config/ags" ]; then
    echo "Ags config directory already exists at /home/$user/.config/ags"
    echo "Contents:"
    ls "/home/$user/.config/ags"
    echo ""
    
    read -p "Do you want to backup the existing ags config and continue? (y/N): " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping backup and installation of new config."
    else
    backup_ags_config "$user"
    fi
    
fi

echo ""
# Copy AGS configuration
echo "Copying AGS configuration..."
mkdir -p "$HOME/.config/ags"
cp -r ./config/ags/* "$HOME/.config/ags/"

    echo ""

    #Cursor hyprcursor
    echo "copy Manhattan Cafe Cursor into $HOME/.local/share/icons"
    cp -r ./assets/Manhattan-Cafe "$HOME/.local/share/icons"

    run_with_privileges cp -r ./assets/Manhattan\ Cafe/ /usr/share/icons/
    bash ./scripts/changecursor.sh "Manhattan Cafe" 32
    echo ""

    echo "Apply Manhattan Cafe Cursor"
    hyprctl setcursor Manhattan-Cafe 32

    echo ""
    cp -r ./config/fastfetch "$HOME/.config/fastfetch"
    mv "$HOME/.config/fastfetch/fish.conf" "$HOME/.local/fish"
    
echo ""

bash ./scripts/changewallcolor.sh

echo ""

echo "Configuration files copied successfully."

echo ""

echo "Main installation script completed."

echo ""

prompt_reboot

}

logic_script() {
  echo ""

  read -p "WARNING !!! This script only works on ARCH LINUX Distribution do you still want to continue? (y/n): " -n 1 -r
  echo ""

  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo "Setup Aborted by user"
      exit 1
  else
      start_stack
  fi
}

logic_script