#!/bin/bash

# Get monitor info (proper variable assignment)
Internal_monitor=$(hyprctl monitors | grep -A 10 "eDP-1")
External_monitor=$(hyprctl monitors | grep -A 10 "HDMI-A-1")
External_ver_monitor=$(hyprctl monitors | grep -A 10 "HDMI-A-1" && hyprctl monitors all | grep -A 10 "transform: 3")

# Check conditions properly
if [[ -n "$Internal_monitor" && -n "$External_monitor" && -n "$External_ver_monitor" ]]; then
    # Both monitors exist - disable internal
    hyprctl keyword monitor "eDP-1, disabled"
    notify-send "Display Config" "Disabled built-in display (HDMI connected)"
elif [[ ! -n "$Internal_monitor" && -n "$External_ver_monitor" ]]; then
    hyprctl keyword monitor "eDP-1, 2880x1800@90,1800x0,2, bitdepth, 10"
    notify-send "Display Config" "Enable built-in display (HDMI connected)"
elif [[ -n "$External_monitor" && ! -n "$Internal_monitor" ]]; then
    hyprctl keyword monitor "eDP-1, 2880x1800@90,auto,2, bitdepth, 10"
    notify-send "Display Config" "Enable built-in display (HDMI connected)"
elif [[ ! -n "$Internal_monitor" && ! -n "$External_monitor" ]]; then
    # No external monitor - enable internal with default settings
    hyprctl keyword monitor "eDP-1, 2880x1800@90, auto, 2, bitdepth, 10"
    notify-send "Display Config" "Using built-in display"
fi