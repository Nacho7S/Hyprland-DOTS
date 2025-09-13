#!/usr/bin/env bash

echo "copy Wallpaper to $HOME/Pictures"
cp -r ./assets/Wallpapers "$HOME/Pictures"

echo "apply Wallpaper"
swww img "$HOME/Pictures/Wallpapers/298a85cbe15f9fa39ee8b94349490773.jpg"


colormode_file="$HOME/.local/state/ags/user/colormode.txt"

if [ -f "$colormode_file" ]; then
   
    sed -i 's/neutral\|tonalspot\|fruitsalad\|fidelity\|rainbow\|expressive\|vibrant\|morevibrant/monochrome/g' "$colormode_file"
    echo "Updated color modes to monochrome in colormode.txt"
else
    echo "colormode.txt not found at $colormode_file"
fi

echo "apply wallpaper colortone" 
bash "$HOME/.config/ags/scripts/color_generation/colorgen.sh" "$HOME/Pictures/Wallpapers/298a85cbe15f9fa39ee8b94349490773.jpg" --apply 

exit 1