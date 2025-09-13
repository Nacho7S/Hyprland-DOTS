# ~/.config/hypr/scripts/socket_listener.sh
#!/bin/bash
socat -u UNIX-CONNECT:/tmp/hypr/.socket2.sock - | while read -r line; do
    if [[ "$line" == *"monitoradded"* || "$line" == *"monitorremoved"* ]]; then
        ~/.config/hypr/toggle_monitors.sh
    fi
done