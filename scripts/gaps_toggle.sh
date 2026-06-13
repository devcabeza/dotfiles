#!/usr/bin/env bash
set -euo pipefail

# Toggle gaps (quitar/poner espacios entre ventanas)
# Alterna entre gaps normales (5/10) y sin gaps (0/0)

# Ensure Nix profile is in PATH
export PATH="$HOME/.nix-profile/bin:$PATH"

APP_ID="org.omarchy.gaps-toggle"

STATE_FILE="/tmp/omarchy-gaps-state"

if [[ -f $STATE_FILE ]]; then
  # Restaurar gaps
  hyprctl keyword general:gaps_in 5
  hyprctl keyword general:gaps_out 10
  rm -f "$STATE_FILE"
  notify-send "Gaps" "Espacios restaurados (5/10)" -u low
else
  # Quitar gaps
  hyprctl keyword general:gaps_in 0
  hyprctl keyword general:gaps_out 0
  touch "$STATE_FILE"
  notify-send "Gaps" "Espacios eliminados (0/0)" -u low
fi
