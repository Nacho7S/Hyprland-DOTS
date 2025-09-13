#!/bin/bash

THEME_NAME="$1"
SIZE="${2:-24}"

if [ -z "$THEME_NAME" ]; then
    echo "Usage: $0 <theme-name> [size]"
    echo "Available cursor themes:"
    find /usr/share/icons ~/.icons -mindepth 1 -maxdepth 1 -type d -o -name "*Cursor*" 2>/dev/null
    exit 1
fi


if [ ! -d "/usr/share/icons/$THEME_NAME" ] && [ ! -d "$HOME/.icons/$THEME_NAME" ]; then
    echo "Error: Cursor theme '$THEME_NAME' not found!"
    exit 1
fi


if command -v gsettings &> /dev/null; then
    gsettings set org.gnome.desktop.interface cursor-theme "$THEME_NAME"
    gsettings set org.gnome.desktop.interface cursor-size "$SIZE"
    echo "GNOME cursor theme set to $THEME_NAME (size: $SIZE)"
fi

if command -v xfconf-query &> /dev/null; then
    xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "$THEME_NAME"
    xfconf-query -c xsettings -p /Gtk/CursorThemeSize -s "$SIZE"
    echo "Xfce cursor theme set to $THEME_NAME (size: $SIZE)"
fi

mkdir -p ~/.config/gtk-3.0
if [ -f ~/.config/gtk-3.0/settings.ini ]; then
    sed -i '/^gtk-cursor-theme-name/d' ~/.config/gtk-3.0/settings.ini
    sed -i '/^gtk-cursor-theme-size/d' ~/.config/gtk-3.0/settings.ini
fi

echo "gtk-cursor-theme-name=$THEME_NAME" >> ~/.config/gtk-3.0/settings.ini
echo "gtk-cursor-theme-size=$SIZE" >> ~/.config/gtk-3.0/settings.ini

sed -i '/^gtk-cursor-theme-name/d' ~/.gtkrc-2.0 2>/dev/null
echo "gtk-cursor-theme-name=\"$THEME_NAME\"" >> ~/.gtkrc-2.0

echo "Cursor theme changed to $THEME_NAME. You may need to restart applications or log out/in to see changes."