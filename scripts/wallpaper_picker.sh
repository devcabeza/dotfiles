#!/usr/bin/env bash
set -euo pipefail

# Wallpaper picker estilo Omarchy — usa swaybg
# swaybg es más simple y confiable que swww (no requiere daemon)

APP_ID="org.omarchy.wallpaper-picker"
TERMINAL="${WALLPAPER_TERMINAL:-alacritty}"
LOG_DIR="${XDG_CACHE_HOME:-$HOME/.cache}"
LOG_FILE="$LOG_DIR/wallpaper_picker.log"
WALLPAPER_DIR="/home/alejandrocabeza/.dotfiles/wallpapers"
CURRENT_LINK="$HOME/.cache/current_wallpaper"

mkdir -p "$LOG_DIR"
: >"$LOG_FILE" 2>/dev/null || LOG_FILE="/tmp/wallpaper_picker.log"

notify_error() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -u normal "Wallpaper" "$1"
    else
        printf 'Wallpaper: %s\n' "$1" >&2
    fi
}

# Ensure Nix profile is in PATH
export PATH="$HOME/.nix-profile/bin:$PATH"

if [ ! -d "$WALLPAPER_DIR" ]; then
    notify_error "Directorio de wallpapers no encontrado: $WALLPAPER_DIR"
    exit 1
fi

# If not in a terminal, launch in one
if [ ! -t 0 ]; then
    if ! command -v "$TERMINAL" >/dev/null 2>&1; then
        notify_error "No se encontró la terminal '$TERMINAL'."
        exit 1
    fi
    setsid "$TERMINAL" --class "$APP_ID" -e "$0" >>"$LOG_FILE" 2>&1 &
    exit 0
fi

# --- Below runs inside the terminal ---

get_wallpapers() {
    find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -printf '%f\n' 2>/dev/null | sort
}

wallpapers=$(get_wallpapers)
if [ -z "$wallpapers" ]; then
    echo "No wallpapers found." >&2
    exit 1
fi

# fzf selection
chosen=$(echo "$wallpapers" | fzf \
  --prompt "Seleccionar wallpaper... " \
  --header="[Enter] aplicar  [Esc] salir" \
  --color "pointer:green,marker:green" \
  --border \
  --height 100% \
  --layout=reverse \
  2>/dev/null) || true

if [ -z "$chosen" ]; then
    exit 0
fi

wallpaper_path="$WALLPAPER_DIR/$chosen"

if [ -f "$wallpaper_path" ]; then
    # Apply wallpaper using swaybg (Omarchy style)
    pkill -x swaybg 2>/dev/null || true
    sleep 0.2
    setsid swaybg -i "$wallpaper_path" -m fill >/dev/null 2>&1 &

    # Update symlink
    ln -nsf "$wallpaper_path" "$CURRENT_LINK"

    echo "Wallpaper aplicado: $chosen"
    notify-send "Wallpaper aplicado" "$chosen" -u low
    sleep 1
else
    echo "File not found: $wallpaper_path" >&2
    exit 1
fi
