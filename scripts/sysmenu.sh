#!/usr/bin/env bash
set -euo pipefail

# Ensure we're running inside a terminal
if [ ! -t 0 ]; then
    exec alacritty --class "org.omarchy.sysmenu" -e "$0" "$@"
fi

# Ensure Nix profile is in PATH
export PATH="$HOME/.nix-profile/bin:$PATH"

# Options for the menu
OPTIONS="🔒 Bloquear
💤 Suspender
🚪 Cerrar Sesión
🔄 Reiniciar
⏻ Apagar"

chosen=$(echo "$OPTIONS" | fzf \
  --prompt "Sistema: " \
  --header="[Enter] seleccionar  [Esc] salir" \
  --color "pointer:green,marker:green" \
  --border \
  --height 100% \
  --layout=reverse \
  2>/dev/null)

case "$chosen" in
    *"Bloquear"*)
        hyprlock || hyprctl dispatch dpms off
        ;;
    *"Suspender"*)
        systemctl suspend
        ;;
    *"Cerrar Sesión"*)
        hyprctl dispatch exit
        ;;
    *"Reiniciar"*)
        systemctl reboot
        ;;
    *"Apagar"*)
        systemctl poweroff
        ;;
esac
