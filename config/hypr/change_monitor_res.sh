#!/bin/bash

Internal_monitor=$(hyprctl monitors | grep -A 10 "eDP-1")
Default_res=$(hyprctl monitors all | grep -A 10 "2880x1800@90.00100")
External_ver_monitor=$(hyprctl monitors | grep -A 10 "HDMI-A-1" && hyprctl monitors all | grep -A 10 "transform: 3")


if [[-n "$Internal_monitor" && -n "$Default_res" && -n "$External_ver_monitor" ]]; then
    hyprctl keyword monitor "eDP-1, 1680x1050@90,1050x0,1, bitdepth, 10"
    notify-send "Display Config" "Change Resolution to 1050p Happy Gaming :)"
elif [[ -n "$Internal_monitor" && -n "$Default_res" ]]; then
    hyprctl keyword monitor "eDP-1, 1680x1050@90,auto,1, bitdepth, 10"
    notify-send "Display Config" "Change Resolution to 1050p Happy Gaming :)"
else
    hyprctl keyword monitor "eDP-1, 2880x1800@90,auto,2, bitdepth, 10"
    notify-send "Display Config" "Change Resolution to 2.8k Happy Gaming :)"
fi