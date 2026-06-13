#!/usr/bin/env bash
set -euo pipefail

# Screen recording script (estilo Omarchy)
# Usa wf-recorder para grabación de pantalla
# Modo: select (default, elige área con slurp) | fullscreen
# Opciones: --with-audio (graba audio de escritorio)

# Ensure Nix profile is in PATH
export PATH="$HOME/.nix-profile/bin:$PATH"

APP_ID="org.omarchy.screenrecord"
DIR="${XDG_VIDEOS_DIR:-$HOME/Vídeos}/Grabaciones"
mkdir -p "$DIR"

RECORDING_FILE="/tmp/omarchy-screenrecord-filename"
PID_FILE="/tmp/omarchy-screenrecord-pid"

MODE="${1:-select}"
WITH_AUDIO="${2:-no}"

# Cleanup function
cleanup() {
  rm -f "$PID_FILE" "$RECORDING_FILE"
}
trap cleanup EXIT

# Check if already recording
if [[ -f $PID_FILE ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
  # Stop recording
  kill -INT "$(cat "$PID_FILE")" 2>/dev/null
  notify-send "Grabación finalizada" "Guardada en $DIR" -u low
  exit 0
fi

# Get selection area
case "$MODE" in
  fullscreen)
    SELECTION=""
    ;;
  select|*)
    hyprpicker -r -z >/dev/null 2>&1 &
    PID=$!
    sleep .1
    SELECTION=$(slurp 2>/dev/null) || exit 0
    kill $PID 2>/dev/null
    ;;
esac

FILENAME="screenrecord-$(date +'%Y-%m-%d_%H-%M-%S').mp4"
FILEPATH="$DIR/$FILENAME"

# Build wf-recorder arguments
ARGS=()
if [[ -n $SELECTION ]]; then
  ARGS+=(-g "$SELECTION")
fi
if [[ $WITH_AUDIO == "yes" || $WITH_AUDIO == "--with-audio" ]]; then
  ARGS+=(-c libx265 -b 10M --audio")
fi

# Start recording
wf-recorder "${ARGS[@]}" -f "$FILEPATH" &
echo $! > "$PID_FILE"
echo "$FILEPATH" > "$RECORDING_FILE"

notify-send "Grabando pantalla" "Selecciona región para detener" -u low
