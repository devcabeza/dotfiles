#!/bin/bash

# Get a list of available wifi networks
wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/^  //' | awk -F'  +' '{if (NR!=1) {print $2}}' | sort -u)

# Use wofi to select a network
chosen_network=$(echo -e "$wifi_list" | wofi --dmenu --prompt "Select WiFi Network: " --cache-file /dev/null)

if [ -n "$chosen_network" ]; then
    # Check if network is already known/saved
    if nmcli connection show | grep -q "$chosen_network"; then
        nmcli device wifi connect "$chosen_network"
    else
        # If new, ask for password using wofi
        password=$(wofi --dmenu --prompt "Password for $chosen_network: " --password --cache-file /dev/null)
        if [ -n "$password" ]; then
            nmcli device wifi connect "$chosen_network" password "$password"
        fi
    fi
fi
