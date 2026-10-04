#!/usr/bin/env bash

# Toggle: si ya está abierto wofi, lo cerramos
if pgrep -x wofi > /dev/null; then
    pkill -x wofi
    exit 0
fi

# Opciones del menú de apagado
shutdown="⏻  Apagar"
reboot="  Reiniciar"
suspend="󰤄  Suspender"
logout="󰍃  Cerrar sesión"

chosen=$(printf "%s\n%s\n%s\n%s" "$shutdown" "$reboot" "$suspend" "$logout" | wofi \
    --dmenu \
    --prompt "Sistema" \
    --width 320 \
    --height 250 \
    --location center \
    --hide-scroll \
    --insensitive)

case "$chosen" in
    "$shutdown")
        systemctl poweroff
        ;;
    "$reboot")
        systemctl reboot
        ;;
    "$suspend")
        systemctl suspend
        ;;
    "$logout")
        hyprctl dispatch 'hl.dsp.exit()' || loginctl terminate-user "$USER"
        ;;
esac
