#!/bin/bash

# Test script for ASUS detection

is_asus() {
    if [ -f "/sys/class/dmi/id/sys_vendor" ]; then
        local vendor=$(cat /sys/class/dmi/id/sys_vendor)
        echo "Detected vendor: $vendor"
        if [[ "$vendor" == *"ASUS"* ]] || [[ "$vendor" == *"ASUSTeK"* ]]; then
            echo "This is an ASUS system"
            return 0
        fi
    fi
    echo "This is not an ASUS system"
    return 1
}

# Run the test
if is_asus; then
    echo "Test PASSED: ASUS detection works correctly"
    exit 0
else
    echo "Test FAILED: ASUS detection failed"
    exit 1
fi