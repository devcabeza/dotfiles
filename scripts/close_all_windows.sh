#!/usr/bin/env bash
set -euo pipefail

# Cerrar todas las ventanas del workspace actual (estilo Omarchy)
# Primero envía las no flotantes al special workspace, luego las cierra

# Ensure Nix profile is in PATH
export PATH="$HOME/.nix-profile/bin:$PATH"

APP_ID="org.omarchy.close-all"

# Obtener ventanas del workspace actual (excluyendo special)
hyprctl clients -j | jq -r '
  .[] | 
  select(.workspace.name != "special:magic") |
  select(.workspace.name | startswith("special") | not) |
  .address
' | while read -r addr; do
  hyprctl dispatch closewindow "address:$addr"
done

notify-send "Ventanas cerradas" "Todas las ventanas del workspace actual" -u low
