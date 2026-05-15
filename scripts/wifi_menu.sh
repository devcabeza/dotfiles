#!/usr/bin/env bash
# WiFi connection menu using nmcli and wofi

# Get list of available WiFi networks (excluding currently connected)
networks=$(nmcli -t -f SSID,SIGNAL,SECURITY dev wifi list | grep -v '^$' | sort -t: -k2 -rn | head -20)

if [ -z "$networks" ]; then
    notify-send "WiFi" "No networks found"
    exit 1
fi

# Format for wofi menu
menu_items=""
while IFS=: read -r ssid signal security; do
    [ -z "$ssid" ] && continue
    # Check if already connected
    connected=$(nmcli -t -f NAME con show --active 2>/dev/null | grep -q "^${ssid}$" && echo " (connected)" || echo "")
    # Add signal icon
    if [ "$signal" -ge 75 ]; then
        icon="󰤨"
    elif [ "$signal" -ge 50 ]; then
        icon="󰤢"
    elif [ "$signal" -ge 25 ]; then
        icon="󰤟"
    else
        icon="󰤯"
    fi
    menu_items="${menu_items}${icon} ${ssid}${connected}\n"
done <<< "$networks"

# Show wofi menu
selected=$(echo -e "${menu_items}---\n󰤭 Disconnect" | wofi --dmenu -i -p "WiFi Networks")

if [ -z "$selected" ]; then
    exit 0
fi

# Handle disconnect option
if [[ "$selected" == "---" ]] || [[ "$selected" == *"Disconnect"* ]]; then
    nmcli con down id "$(nmcli -t -f NAME con show --active | head -1)" 2>/dev/null
    notify-send "WiFi" "Disconnected"
    exit 0
fi

# Extract SSID (remove icon and any connected indicator)
ssid=$(echo "$selected" | sed 's/^.*) //; s/^󰤨 //; s/^󰤢 //; s/^󰤟 //; s/^󰤯 //')

# Check if we already have a saved connection
if nmcli -t -f NAME con show | grep -q "^${ssid}$"; then
    nmcli con up id "$ssid" 2>/dev/null
    notify-send "WiFi" "Connected to $ssid"
else
    # Need to connect - show password dialog if needed
    password=$(echo "" | wofi --dmenu -p "Password for $ssid")
    if [ -n "$password" ]; then
        nmcli dev wifi connect "$ssid" password "$password" 2>/dev/null
        if [ $? -eq 0 ]; then
            notify-send "WiFi" "Connected to $ssid"
        else
            notify-send "WiFi" "Failed to connect to $ssid"
        fi
    fi
fi