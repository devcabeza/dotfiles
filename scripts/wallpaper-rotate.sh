#!/usr/bin/env bash
# Rotación de wallpapers con swww (transiciones suaves)
# Alternativa al swaybg estático
set -euo pipefail

# Kill swaybg if running (both can't coexist)
pkill swaybg 2>/dev/null || true

WALLPAPER_DIR="/home/alejandrocabeza/.dotfiles/wallpapers"
INTERVAL="${1:-600}"  # Default: 10 minutos

if ! command -v swww &>/dev/null; then
  echo "Error: swww no está instalado"
  exit 1
fi

# Iniciar swww si no está corriendo
swww query 2>/dev/null || swww init

while true; do
  # Seleccionar wallpaper aleatorio
  WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name '*.jpg' -o -name '*.jpeg' -o -name '*.png' \) | shuf -n 1)
  
  if [[ -n "$WALLPAPER" ]]; then
    swww img "$WALLPAPER" \
      --transition-type random \
      --transition-duration 2 \
      --transition-fps 60
  fi
  
  sleep "$INTERVAL"
done
