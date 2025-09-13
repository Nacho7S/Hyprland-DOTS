#!/bin/bash

# Test script for battery limit scripts

echo "Testing ASUS detection..."
if /sys/class/power_supply/BAT*/charge_control_end_threshold 2>/dev/null | head -n1; then
    echo "✓ ASUS LAPTOP WITH BATTERY DETECTED"
else
    echo "✗ ASUS LAPTOP WITH NOT BATTERY NOT DETECTED"
fi

echo "All tests completed."