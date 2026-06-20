#!/usr/bin/env bash
# Cambia el wallpaper a uno aleatorio con swww
set -euo pipefail

# Kill swaybg if running (both can't coexist)
pkill swaybg 2>/dev/null || true

WALLPAPER_DIR="/home/alejandrocabeza/.dotfiles/wallpapers"

swww query 2>/dev/null || swww init

WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name '*.jpg' -o -name '*.jpeg' -o -name '*.png' \) | shuf -n 1)

if [[ -n "$WALLPAPER" ]]; then
  swww img "$WALLPAPER" \
    --transition-type random \
    --transition-duration 2 \
    --transition-fps 60
  notify-send "Wallpaper" "Cambiado a: $(basename "$WALLPAPER")" -t 2000
fi
