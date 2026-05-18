#!/usr/bin/env bash
# Bluetooth menu using fzf + Alacritty (omakub/omarchy style)

# Terminal para fzf
FZF_TERM="alacritty"
FZF_OPTS="--height=20 --border=rounded --margin=5% --padding=1 --info=hidden --header=' 󰂯 BLUETOOTH ' --header-border=bottom"

# Función para abrir menú flotante con fzf
run_fzf() {
    $FZF_TERM -t float -e -o floating --title "Bluetooth" -e bash -c "
        export FZF_DEFAULT_OPTS='
            --color=bg+:#1a1b26,bg:#1a1b26,fg:#a9b1d6,hl:#7aa2f7,fg+:#c0caf5
            --color=prompt:#bb9af7,pointer:#7dcfff,marker:#9ece6a,header:#565f89
            --bind=tab:down,bspace:up,ctrl-c:abort
            --highlight-line
            --pointer='❯'
            --marker=' '
        '
        $1
    "
}

# Función para verificar si está conectado
is_connected() {
    local mac="$1"
    bluetoothctl devices Connected 2>/dev/null | grep -q "$mac"
}

# Obtener dispositivos emparejados
get_paired() {
    bluetoothctl paired-devices 2>/dev/null | grep "Device" | cut -d' ' -f2-
}

# Obtener dispositivos conectados
get_connected() {
    bluetoothctl devices Connected 2>/dev/null | grep "Device" | cut -d' ' -f2-
}

# Verificar si bluetooth está activo
if ! bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
    choice=$(echo -e "󰂲 Turn On Bluetooth\n󰍃 Exit" | fzf $FZF_OPTS --header=' 󰂯 BLUETOOTH OFF ')
    if [[ "$choice" == "󰂲 Turn On Bluetooth" ]]; then
        bluetoothctl power on 2>/dev/null
        sleep 1
        notify-send "Bluetooth" "Turned on" -i bluetooth
    fi
    exit 0
fi

# Construir menú
menu_items=""

# Añadir dispositivos conectados
connected_devices=$(get_connected)
if [ -n "$connected_devices" ]; then
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        mac=$(echo "$line" | cut -d' ' -f2)
        name=$(echo "$line" | cut -d' ' -f3-)
        menu_items="${menu_items}󰂡 ${name} (connected)\n"
    done <<< "$connected_devices"
fi

# Añadir dispositivos emparejados no conectados
paired_devices=$(get_paired)
if [ -n "$paired_devices" ]; then
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        mac=$(echo "$line" | cut -d' ' -f2)
        name=$(echo "$line" | cut -d' ' -f3-)
        
        # Skip si ya está conectado
        if is_connected "$mac"; then
            continue
        fi
        menu_items="${menu_items}󰟀 ${name}\n"
    done <<< "$paired_devices"
fi

# Añadir opciones
menu_items="${menu_items}---\n"
menu_items="${menu_items}󰤇 Scan for devices\n"
menu_items="${menu_items}󰂱 Turn Off Bluetooth\n"
menu_items="${menu_items}󰍃 Exit"

# Mostrar menú
selected=$(echo -e "$menu_items" | fzf $FZF_OPTS)

# Procesar selección
case "$selected" in
    "󰤇 Scan for devices")
        bluetoothctl scan on >/dev/null 2>&1 &
        scan_pid=$!
        
        # Menú de escaneo
        while true; do
            discovered=$(bluetoothctl devices 2>/dev/null | grep "Device")
            paired_macs=$(get_paired | cut -d' ' -f2)
            scan_menu="󰤇 Scanning for devices...\n---\n"
            
            found=false
            while IFS= read -r line; do
                [ -z "$line" ] && continue
                mac=$(echo "$line" | cut -d' ' -f2)
                name=$(echo "$line" | cut -d' ' -f3-)
                
                # Skip paired
                if echo "$paired_macs" | grep -q "^${mac}$"; then
                    continue
                fi
                
                scan_menu="${scan_menu}󰤇 ${name}\n"
                found=true
            done <<< "$discovered"
            
            if [ "$found" = false ]; then
                scan_menu="${scan_menu}󰤇 (No new devices found)\n"
            fi
            
            scan_menu="${scan_menu}---\n󰂱 Stop Scanning"
            
            sel=$(echo -e "$scan_menu" | fzf $FZF_OPTS --header=' 󰤇 SCANNING ' --timeout=3000)
            
            if [ -z "$sel" ] || [[ "$sel" == "󰂱 Stop Scanning" ]]; then
                kill $scan_pid 2>/dev/null
                bluetoothctl scan off >/dev/null 2>&1
                break
            elif [[ "$sel" == "󰤇"* ]] && [[ "$sel" != "󰤇 Scanning"* ]]; then
                device_name=$(echo "$sel" | sed 's/^󰤇 //')
                device_mac=$(bluetoothctl devices 2>/dev/null | grep "$device_name" | cut -d' ' -f2)
                
                if [ -n "$device_mac" ]; then
                    kill $scan_pid 2>/dev/null
                    bluetoothctl scan off >/dev/null 2>&1
                    
                    notify-send "Bluetooth" "Connecting to $device_name..." -i bluetooth
                    bluetoothctl pair "$device_mac" 2>/dev/null
                    
                    if bluetoothctl connect "$device_mac" 2>/dev/null; then
                        notify-send "Bluetooth" "Connected to $device_name" -i bluetooth
                    else
                        notify-send "Bluetooth" "Failed to connect" -i bluetooth
                    fi
                fi
                break
            fi
        done
        ;;
    "󰂱 Turn Off Bluetooth")
        bluetoothctl power off 2>/dev/null
        notify-send "Bluetooth" "Turned off" -i bluetooth
        ;;
    "")
        exit 0
        ;;
    *)
        # Conectar/desconectar dispositivo
        device_name=$(echo "$selected" | sed 's/ (connected)//; s/^󰂡 //; s/^󰟀 //')
        device_mac=$(bluetoothctl paired-devices 2>/dev/null | grep "$device_name" | cut -d' ' -f2)
        
        if [ -n "$device_mac" ]; then
            if is_connected "$device_mac"; then
                bluetoothctl disconnect "$device_mac" 2>/dev/null
                notify-send "Bluetooth" "Disconnected from $device_name" -i bluetooth
            else
                notify-send "Bluetooth" "Connecting to $device_name..." -i bluetooth
                if bluetoothctl connect "$device_mac" 2>/dev/null; then
                    notify-send "Bluetooth" "Connected to $device_name" -i bluetooth
                else
                    notify-send "Bluetooth" "Failed to connect" -i bluetooth
                fi
            fi
        fi
        ;;
esac
