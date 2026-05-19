#!/usr/bin/env bash
set -euo pipefail

# Screenshot script estilo Omarchy
# Modo: region (default) | window | fullscreen
# Procesamiento: save (default) | copy

# Ensure Nix profile is in PATH
export PATH="$HOME/.nix-profile/bin:$PATH"

DIR="${XDG_PICTURES_DIR:-$HOME/Imágenes}/Capturas"
mkdir -p "$DIR"

# accounting for portrait/transformed displays
JQ_MONITOR_GEO='
  def format_geo:
    .x as $x | .y as $y |
    (.width / .scale | floor) as $w |
    (.height / .scale | floor) as $h |
    .transform as $t |
    if $t == 1 or $t == 3 then
      "\($x),\($y) \($h)x\($w)"
    else
      "\($x),\($y) \($w)x\($h)"
    end;
'

get_rectangles() {
  local active_workspace
  active_workspace=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .activeWorkspace.id')
  hyprctl monitors -j | jq -r --arg ws "$active_workspace" "${JQ_MONITOR_GEO} .[] | select(.activeWorkspace.id == (\$ws | tonumber)) | format_geo"
  hyprctl clients -j | jq -r --arg ws "$active_workspace" '.[] | select(.workspace.id == ($ws | tonumber)) | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"'
}

MODE="${1:-region}"
PROCESSING="${2:-save}"

case "$MODE" in
  region)
    SELECTION=$(slurp 2>/dev/null) || exit 0
    ;;
  window)
    SELECTION=$(get_rectangles | slurp -r 2>/dev/null) || exit 0
    ;;
  fullscreen)
    SELECTION=$(hyprctl monitors -j | jq -r "${JQ_MONITOR_GEO} .[] | select(.focused == true) | format_geo")
    ;;
  *)
    notify-send "Screenshot" "Uso: screenshot [region|window|fullscreen] [copy|save]" -u normal
    exit 1
    ;;
esac

[[ -z "$SELECTION" ]] && exit 0

FILENAME="screenshot_$(date +%Y%m%d_%H%M%S).png"
FILEPATH="$DIR/$FILENAME"

case "$PROCESSING" in
  copy)
    grim -g "$SELECTION" - | wl-copy
    notify-send "Captura copiada" "Guardada en el portapapeles" -u low
    ;;
  save)
    grim -g "$SELECTION" "$FILEPATH" || exit 1
    wl-copy < "$FILEPATH"
    notify-send "Captura guardada" "$FILEPATH" -u low
    ;;
esac