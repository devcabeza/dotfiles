#!/usr/bin/env bash
set -euo pipefail

# Watch Hyprland monitor events and notify on changes (estilo Omarchy)
# Útil para detectar conexión/desconexión de monitores
# Ejecutar en segundo plano: monitor_watch.sh &

export PATH="$HOME/.nix-profile/bin:$PATH"

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

if [[ ! -S $SOCKET ]]; then
    echo "Error: Hyprland socket not found at $SOCKET"
    exit 1
fi

# Monitor connected/disconnected events (needs socat)
if command -v socat &>/dev/null; then
    socat -U - "UNIX-CONNECT:$SOCKET" | while read -r event; do
        case "$event" in
            monitoradded\>\>*|monitoraddedv2\>\>*)
                notify-send "Monitor" "Nuevo monitor conectado" -u low
                ;;
            monitorremoved\>\>*|monitorremovedv2\>\>*)
                notify-send "Monitor" "Monitor desconectado" -u normal
                ;;
        esac
    done
else
    # Fallback: poll every 2 seconds
    echo "monitor_watch: socat not found, using polling mode"
    prev_monitors=$(hyprctl monitors -j | jq -c '[.[].name] | sort')
    while true; do
        sleep 2
        curr_monitors=$(hyprctl monitors -j | jq -c '[.[].name] | sort')
        if [[ "$curr_monitors" != "$prev_monitors" ]]; then
            notify-send "Monitor" "Cambio en la configuración de monitores detectado" -u normal
            prev_monitors="$curr_monitors"
        fi
    done
fi
