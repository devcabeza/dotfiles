#!/usr/bin/env bash
set -euo pipefail

# Screenshot script estilo Omarchy (mejorado)
# Modo: smart (default) | region | window | fullscreen
# Procesamiento: slurp (default) | copy | save
# Soporta --editor=swappy (usa swappy que ya está instalado)

# Ensure Nix profile is in PATH
export PATH="$HOME/.nix-profile/bin:$PATH"

APP_ID="org.omarchy.screenshot"

DIR="${XDG_PICTURES_DIR:-$HOME/Imágenes}/Capturas"
mkdir -p "$DIR"

SCREENSHOT_EDITOR="${OMARCHY_SCREENSHOT_EDITOR:-swappy}"

# Parse --editor flag from any position
ARGS=()
for arg in "$@"; do
  if [[ $arg == --editor=* ]]; then
    SCREENSHOT_EDITOR="${arg#--editor=}"
  else
    ARGS+=("$arg")
  fi
done
set -- "${ARGS[@]}"

open_editor() {
  local filepath="$1"
  if [[ $SCREENSHOT_EDITOR == "swappy" ]]; then
    swappy -f "$filepath" -o "$filepath"
  else
    $SCREENSHOT_EDITOR "$filepath"
  fi
}

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

MODE="${1:-smart}"
PROCESSING="${2:-slurp}"

# Keep hyprpicker alive until after grim captures so the screenshot sees the
# frozen overlay rather than live content shifting during teardown.
cleanup_freeze() {
  [[ -n $PID ]] && kill $PID 2>/dev/null
}
trap cleanup_freeze EXIT

# Select based on mode
case "$MODE" in
  region)
    hyprpicker -r -z >/dev/null 2>&1 &
    PID=$!
    sleep .1
    SELECTION=$(slurp 2>/dev/null) || exit 0
    ;;
  window)
    hyprpicker -r -z >/dev/null 2>&1 &
    PID=$!
    sleep .1
    SELECTION=$(get_rectangles | slurp -r 2>/dev/null) || exit 0
    ;;
  fullscreen)
    SELECTION=$(hyprctl monitors -j | jq -r "${JQ_MONITOR_GEO} .[] | select(.focused == true) | format_geo")
    ;;
  smart | *)
    RECTS=$(get_rectangles)
    hyprpicker -r -z >/dev/null 2>&1 &
    PID=$!
    sleep .1
    SELECTION=$(echo "$RECTS" | slurp 2>/dev/null) || exit 0

    # If the selection area is L * W < 20, snap to whichever window/monitor was clicked
    if [[ $SELECTION =~ ^([0-9]+),([0-9]+)[[:space:]]([0-9]+)x([0-9]+)$ ]]; then
      if ((${BASH_REMATCH[3]} * ${BASH_REMATCH[4]} < 20)); then
        click_x="${BASH_REMATCH[1]}"
        click_y="${BASH_REMATCH[2]}"

        while IFS= read -r rect; do
          if [[ $rect =~ ^([0-9]+),([0-9]+)[[:space:]]([0-9]+)x([0-9]+) ]]; then
            rect_x="${BASH_REMATCH[1]}"
            rect_y="${BASH_REMATCH[2]}"
            rect_width="${BASH_REMATCH[3]}"
            rect_height="${BASH_REMATCH[4]}"

            if ((click_x >= rect_x && click_x < rect_x + rect_width && click_y >= rect_y && click_y < rect_y + rect_height)); then
              SELECTION="${rect_x},${rect_y} ${rect_width}x${rect_height}"
              break
            fi
          fi
        done <<< "$RECTS"
      fi
    fi
    ;;
  *)
    notify-send "Screenshot" "Uso: screenshot [smart|region|window|fullscreen] [slurp|copy|save]" -u normal
    exit 1
    ;;
esac

[[ -z "$SELECTION" ]] && exit 0

FILENAME="screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png"
FILEPATH="$DIR/$FILENAME"

case "$PROCESSING" in
  slurp)
    grim -g "$SELECTION" "$FILEPATH" || exit 1
    wl-copy < "$FILEPATH"
    notify-send "Captura guardada" "$FILENAME" -u low -i "$FILEPATH" \
      -A "default=Editar con $SCREENSHOT_EDITOR"
    ;;
  copy)
    grim -g "$SELECTION" - | wl-copy
    notify-send "Captura copiada" "Guardada en el portapapeles" -u low
    ;;
  save)
    grim -g "$SELECTION" "$FILEPATH" || exit 1
    echo "$FILEPATH"
    notify-send "Captura guardada" "$FILEPATH" -u low
    ;;
esac
