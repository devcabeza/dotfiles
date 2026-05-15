#!/usr/bin/env bash
# Bluetooth menu using bluetoothctl and wofi
# Shows paired devices first, with option to scan for new devices

# Function to get connected devices
get_connected_devices() {
    bluetoothctl devices Connected 2>/dev/null | grep "Device" | cut -d' ' -f2-
}

# Function to get paired devices
get_paired_devices() {
    bluetoothctl paired-devices 2>/dev/null | grep "Device" | cut -d' ' -f2-
}

# Function to get device name from MAC
get_device_name() {
    local mac="$1"
    bluetoothctl device "$mac" 2>/dev/null | grep "Device" | cut -d' ' -f3-
}

# Function to check if device is connected
is_connected() {
    local mac="$1"
    bluetoothctl devices Connected 2>/dev/null | grep -q "$mac"
}

# Function to format menu items for paired devices
format_paired_devices() {
    local menu_items=""
    local devices=$(get_paired_devices)

    if [ -n "$devices" ]; then
        while IFS= read -r line; do
            [ -z "$line" ] && continue
            local mac=$(echo "$line" | cut -d' ' -f2)
            local name=$(echo "$line" | cut -d' ' -f3-)

            if [ -z "$name" ]; then
                name=$(get_device_name "$mac")
            fi

            if is_connected "$mac"; then
                menu_items="${menu_items}󰂡 ${name}\n"
            else
                menu_items="${menu_items}󰟀 ${name}\n"
            fi
        done <<< "$devices"
    fi

    echo "$menu_items"
}

# Function to format discovered devices
format_discovered_devices() {
    local menu_items=""
    local devices=$(bluetoothctl devices 2>/dev/null | grep "Device")

    if [ -n "$devices" ]; then
        # Get paired device MACs
        local paired_macs=$(get_paired_devices | cut -d' ' -f2)

        while IFS= read -r line; do
            [ -z "$line" ] && continue
            local mac=$(echo "$line" | cut -d' ' -f2)
            local name=$(echo "$line" | cut -d' ' -f3-)

            # Skip if already paired (shown in paired section)
            if echo "$paired_macs" | grep -q "^${mac}$"; then
                continue
            fi

            if [ -z "$name" ]; then
                name=$(get_device_name "$mac")
            fi

            menu_items="${menu_items}󰤇 ${name}\n"
        done <<< "$devices"
    fi

    echo "$menu_items"
}

# Check Bluetooth power state
if ! bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
    # Bluetooth is off, offer to turn it on
    selected=$(echo -e "󰂲 Turn On Bluetooth" | wofi --dmenu -i -p "Bluetooth")
    if [[ "$selected" == "󰂲 Turn On Bluetooth" ]]; then
        bluetoothctl power on 2>/dev/null
        sleep 1
        notify-send "Bluetooth" "Turned on" -i bluetooth
    fi
    exit 0
fi

# Bluetooth is on - build main menu
menu_items="󰂯 Bluetooth On\n---\n"

# Add paired devices section
paired=$(format_paired_devices)
if [ -n "$paired" ]; then
    menu_items="${menu_items}Paired Devices:\n${paired}---\n"
fi

# Add scan option
menu_items="${menu_items}󰤇 Scan for devices"

# Show main menu
selected=$(echo -e "$menu_items" | wofi --dmenu -i -p "Bluetooth" --normal-window)

# Handle selection
case "$selected" in
    "󰂯 Bluetooth On")
        # Already on, do nothing
        ;;
    "󰤇 Scan for devices")
        # Start scanning in background
        bluetoothctl scan on >/dev/null 2>&1 &
        scan_pid=$!

        # Show scanning menu with real-time updates
        while true; do
            # Get discovered devices (not paired)
            paired_macs=$(get_paired_devices | cut -d' ' -f2)
            discovered=""

            # Get all known devices and filter out paired ones
            while IFS= read -r line; do
                [ -z "$line" ] && continue
                mac=$(echo "$line" | cut -d' ' -f2)
                name=$(echo "$line" | cut -d' ' -f3-)

                # Skip if paired
                if echo "$paired_macs" | grep -q "^${mac}$"; then
                    continue
                fi

                if [ -z "$name" ]; then
                    name=$(get_device_name "$mac")
                fi

                discovered="${discovered}󰤇 ${name}\n"
            done < <(bluetoothctl devices 2>/dev/null | grep "Device")

            # Build scan menu
            if [ -n "$discovered" ]; then
                scan_menu="󰤇 Scanning for devices...\n---\n${discovered}---\n󰂱 Stop Scanning"
            else
                scan_menu="󰤇 Scanning for devices...\n---\n󰤇 (No new devices found)\n---\n󰂱 Stop Scanning"
            fi

            # Show wofi with timeout to allow refresh
            selected=$(echo -e "$scan_menu" | wofi --dmenu -i -p "Bluetooth Scan" -t 5 --normal-window 2>/dev/null)

            # If wofi timed out or user pressed escape, continue scanning
            if [ -z "$selected" ]; then
                continue
            fi

            # Handle scan menu options
            if [[ "$selected" == "󰂱 Stop Scanning" ]]; then
                kill $scan_pid 2>/dev/null
                bluetoothctl scan off >/dev/null 2>&1
                break
            elif [[ "$selected" == "󰤇 Scanning for devices..." ]]; then
                # Do nothing, continue scanning
                continue
            elif [[ "$selected" == *"󰤇"* ]]; then
                # User selected a discovered device to connect
                device_name=$(echo "$selected" | sed 's/^󰤇 //')

                # Find MAC address
                device_mac=$(bluetoothctl devices 2>/dev/null | grep "$device_name" | cut -d' ' -f2)

                if [ -n "$device_mac" ]; then
                    # Stop scanning before connecting
                    kill $scan_pid 2>/dev/null
                    bluetoothctl scan off >/dev/null 2>&1

                    # Try to pair and connect
                    notify-send "Bluetooth" "Connecting to $device_name..." -i bluetooth

                    # First try to pair
                    bluetoothctl pair "$device_mac" 2>/dev/null

                    # Then connect
                    if bluetoothctl connect "$device_mac" 2>/dev/null; then
                        notify-send "Bluetooth" "Connected to $device_name" -i bluetooth
                    else
                        notify-send "Bluetooth" "Failed to connect to $device_name" -i bluetooth
                    fi
                fi
                break
            fi
        done
        ;;
    "")
        # User pressed escape, do nothing
        exit 0
        ;;
    *)
        # User selected a paired device
        # Extract device name (remove icon)
        device_name=$(echo "$selected" | sed 's/^󰂡 //; s/^󰟀 //')

        # Find MAC address
        device_mac=$(bluetoothctl paired-devices 2>/dev/null | grep "$device_name" | cut -d' ' -f2)

        if [ -n "$device_mac" ]; then
            if is_connected "$device_mac"; then
                # Disconnect
                bluetoothctl disconnect "$device_mac" 2>/dev/null
                notify-send "Bluetooth" "Disconnected from $device_name" -i bluetooth
            else
                # Connect
                notify-send "Bluetooth" "Connecting to $device_name..." -i bluetooth
                if bluetoothctl connect "$device_mac" 2>/dev/null; then
                    notify-send "Bluetooth" "Connected to $device_name" -i bluetooth
                else
                    notify-send "Bluetooth" "Failed to connect to $device_name" -i bluetooth
                fi
            fi
        fi
        ;;
esac