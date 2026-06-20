#!/usr/bin/env bash
# Screenshot tool for Hyprland/Wayland (Omarchy-inspired)
# Uso: screenshot.sh [smart|region|fullscreen] [copy|save]
set -euo pipefail

SCREENSHOT_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
FILENAME="$SCREENSHOT_DIR/screenshot-$TIMESTAMP.png"
PROCESSING="${2:-slurp}"  # slurp = copy+notify, copy = solo clipboard, save = solo archivo

mkdir -p "$SCREENSHOT_DIR"

# Limpiar hyprpicker al salir
cleanup() { [[ -n $PICKER_PID ]] && kill $PICKER_PID 2>/dev/null || true; }
trap cleanup EXIT

MODE="${1:-smart}"
SELECTION=""

case "$MODE" in
  region)
    hyprpicker -r -z >/dev/null 2>&1 &
    PICKER_PID=$!
    sleep 0.1
    SELECTION=$(slurp 2>/dev/null)
    ;;
  fullscreen)
    SELECTION=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | "\(.x),\(.y) \(.width/.scale | floor)x\(.height/.scale | floor)"')
    ;;
  smart|*)
    hyprpicker -r -z >/dev/null 2>&1 &
    PICKER_PID=$!
    sleep 0.1
    SELECTION=$(slurp 2>/dev/null)
    ;;
esac

[[ -z $SELECTION ]] && exit 0

case "$PROCESSING" in
  copy)
    grim -g "$SELECTION" - | wl-copy
    notify-send "Screenshot" "Copiada al portapapeles" -t 2000
    ;;
  save)
    grim -g "$SELECTION" "$FILENAME"
    echo "$FILENAME"
    notify-send "Screenshot" "Guardada: $FILENAME" -t 3000
    ;;
  slurp|*)
    grim -g "$SELECTION" "$FILENAME"
    wl-copy < "$FILENAME"
    notify-send "Screenshot" "Guardada y copiada" \
      -i "$FILENAME" -t 5000 \
      --action=default="Abrir con editor"
    echo "$FILENAME"
    ;;
esac
