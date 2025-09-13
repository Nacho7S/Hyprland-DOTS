#!/bin/bash

# Get the current wallpaper path
# WALLPAPER=$(swww query | grep -oP '/$HOME/Pictures/Wallpapers\S+\.(jpg|png|jpeg|webp)')
WALLPAPER=$(find "${XDG_CONFIG_HOME:-$HOME/Pictures}/Wallpapers/" -name "*.jpg" | sort -R | head -1)

CONF="$HOME/.config/hypr/hyprlock.conf"

if [ -n "$WALLPAPER" ]; then
    # Escape special characters for sed
    ESCAPED_WALLPAPER=$(printf '%s\n' "$WALLPAPER" | sed 's/[\/&]/\\&/g')
    
    # Use sed to replace the path line
    sed -i "s|^[[:space:]]*path[[:space:]]*=.*|    path = $ESCAPED_WALLPAPER|" "$CONF"
    
    echo "Updated hyprlock background to: $WALLPAPER"
    cat ~/.config/hypr/hyprlock.conf
else
    echo "No wallpaper found from swww query"
    # Debug: see what swww query outputs
    # echo "swww query output:"
    # swww query
fi

hyprlock