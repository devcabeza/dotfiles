#!/bin/bash

# Function to get bluetooth status
get_status() {
    if bluetoothctl show | grep -q "Powered: yes"; then
        echo "on"
    else
        echo "off"
    fi
}

# Main menu options
options="Toggle Power\nScan for Devices\nConnect to Paired Device\nDisconnect Device"

chosen=$(echo -e "$options" | wofi --dmenu --prompt "Bluetooth Manager: " --cache-file /dev/null)

case $chosen in
    "Toggle Power")
        status=$(get_status)
        if [ "$status" == "on" ]; then
            bluetoothctl power off
        else
            bluetoothctl power on
        fi
        ;;
    "Scan for Devices")
        notify-send "Bluetooth" "Scanning for 15 seconds..."
        bluetoothctl scan on &
        sleep 15
        bluetoothctl scan off
        notify-send "Bluetooth" "Scan complete."
        ;;
    "Connect to Paired Device")
        devices=$(bluetoothctl devices | awk '{print $3 " (" $2 ")" }')
        device_chosen=$(echo -e "$devices" | wofi --dmenu --prompt "Select Device: " --cache-file /dev/null)
        if [ -n "$device_chosen" ]; then
            mac=$(echo "$device_chosen" | grep -oE '([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}')
            bluetoothctl connect "$mac"
        fi
        ;;
    "Disconnect Device")
        connected=$(bluetoothctl info | grep "Device" | awk '{print $2}')
        if [ -n "$connected" ]; then
            bluetoothctl disconnect "$connected"
        else
            notify-send "Bluetooth" "No device connected."
        fi
        ;;
esac
