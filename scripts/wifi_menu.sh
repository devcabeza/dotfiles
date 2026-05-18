#!/usr/bin/env bash
# WiFi connection menu using fzf + Alacritty (omakub/omarchy style)

FZF_OPTS="--height=20 --border=rounded --margin=5% --padding=1 --info=hidden --header=' 󰤨 WIFI NETWORKS ' --header-border=bottom"
FZF_COLORS="--color=bg+:#1a1b26,bg:#1a1b26,fg:#a9b1d6,hl:#7aa2f7,fg+:#c0caf5 --color=prompt:#bb9af7,pointer:#7dcfff,marker:#9ece6a,header:#565f89"

# Obtener redes disponibles
get_networks() {
    nmcli -t -f SSID,SIGNAL,SECURITY dev wifi list | grep -v '^$' | sort -t: -k2 -rn | head -20
}

# Verificar si hay conexión activa
get_active_ssid() {
    nmcli -t -f NAME con show --active 2>/dev/null | head -1
}

# Obtener icono según señal
get_signal_icon() {
    local signal=$1
    if [ "$signal" -ge 75 ]; then
        echo "󰤨"  # full
    elif [ "$signal" -ge 50 ]; then
        echo "󰤢"  # good
    elif [ "$signal" -ge 25 ]; then
        echo "󰤟"  # fair
    else
        echo "󰤯"  # weak
    fi
}

# Verificar si la red tiene contraseña
has_password() {
    local ssid="$1"
    local security=$(nmcli -t -f SSID,SECURITY dev wifi list | grep "^$ssid:" | cut -d: -f3)
    [ -n "$security" ] && [ "$security" != "WPA2" ] || [ "$security" != "WPA3" ] || [ "$security" != "WEP" ]
}

# Obtener redes
networks=$(get_networks)

if [ -z "$networks" ]; then
    notify-send "WiFi" "No networks found"
    exit 1
fi

# Construir menú
menu_items=""
while IFS=: read -r ssid signal security; do
    [ -z "$ssid" ] && continue
    
    # Verificar si es la red activa
    active_ssid=$(get_active_ssid)
    if [ "$ssid" = "$active_ssid" ]; then
        icon=$(get_signal_icon "$signal")
        menu_items="${menu_items}${icon} ${ssid} (connected)\n"
    else
        icon=$(get_signal_icon "$signal")
        menu_items="${menu_items}${icon} ${ssid}\n"
    fi
done <<< "$networks"

# Añadir opciones adicionales
menu_items="${menu_items}---\n"
active_ssid=$(get_active_ssid)
if [ -n "$active_ssid" ]; then
    menu_items="${menu_items}󰤭 Disconnect from ${active_ssid}\n"
fi
menu_items="${menu_items}󰍃 Exit"

# Mostrar menú
selected=$(echo -e "$menu_items" | fzf $FZF_OPTS $FZF_COLORS --highlight-line --pointer='❯' --marker=' ')

if [ -z "$selected" ]; then
    exit 0
fi

# Procesar selección
if [[ "$selected" == "󰤭 Disconnect"* ]]; then
    active_ssid=$(get_active_ssid)
    if [ -n "$active_ssid" ]; then
        nmcli con down id "$active_ssid" 2>/dev/null
        notify-send "WiFi" "Disconnected from $active_ssid"
    fi
    exit 0
fi

# Extraer SSID (quitar icono y "connected")
ssid=$(echo "$selected" | sed 's/^.*) //; s/^󰤨 //; s/^󰤢 //; s/^󰤟 //; s/^󰤯 //')

if [ -z "$ssid" ]; then
    exit 0
fi

# Verificar si ya está conectada la red
active_ssid=$(get_active_ssid)
if [ "$ssid" = "$active_ssid" ]; then
    notify-send "WiFi" "Already connected to $ssid"
    exit 0
fi

# Verificar si ya tenemos la red guardada
if nmcli -t -f NAME con show | grep -q "^${ssid}$"; then
    # Ya está guardada, conectar directamente
    if nmcli con up id "$ssid" 2>/dev/null; then
        notify-send "WiFi" "Connected to $ssid"
    else
        notify-send "WiFi" "Failed to connect to $ssid"
    fi
else
    # Necesita contraseña - abrir terminal flotante
    alacritty -t "WiFi: $ssid" -e bash -c "
        echo ''
        echo '╔═══════════════════════════════════════════════════╗'
        echo '║  󰤨 Connecting to: $ssid                         ║'
        echo '╚═══════════════════════════════════════════════════╝'
        echo ''
        read -sp 'Password: ' password
        echo ''
        
        if nmcli dev wifi connect '$ssid' password \"\$password\" 2>&1; then
            echo ''
            echo '╔═══════════════════════════════════════════════════╗'
            echo '║  ✅ Connected to: $ssid                         ║'
            echo '╚═══════════════════════════════════════════════════╝'
        else
            echo ''
            echo '╔═══════════════════════════════════════════════════╗'
            echo '║  ❌ Failed to connect to: $ssid                  ║'
            echo '╚═══════════════════════════════════════════════════╝'
        fi
        
        echo ''
        read -p 'Press Enter to exit...'
    " &
    
    # Hacer flotante
    sleep 0.5
    hyprctl dispatch setfloating forwindow "title:WiFi: $ssid"
fi
