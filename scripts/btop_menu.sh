#!/usr/bin/env bash
set -euo pipefail

# Btop menu estilo Omarchy — abre btop en terminal flotante

APP_ID="org.omarchy.btop"
TUI="btop"
TERMINAL="${BTOP_MENU_TERMINAL:-alacritty}"
LOG_DIR="${XDG_CACHE_HOME:-$HOME/.cache}"
LOG_FILE="$LOG_DIR/btop_menu.log"

mkdir -p "$LOG_DIR"
: >"$LOG_FILE" 2>/dev/null || LOG_FILE="/tmp/btop_menu.log"

notify_error() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -u normal "Btop" "$1"
    else
        printf 'Btop: %s\n' "$1" >&2
    fi
}

if ! command -v "$TUI" >/dev/null 2>&1; then
    notify_error "No se encontró btop. Instalalo con: sudo pacman -S btop"
    exit 1
fi

if ! command -v "$TERMINAL" >/dev/null 2>&1; then
    notify_error "No se encontró la terminal '$TERMINAL'."
    exit 1
fi

# Check if btop is already running and focus it
if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ] && command -v hyprctl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
    clients_json="$(hyprctl clients -j 2>>"$LOG_FILE" || true)"

    if printf '%s' "$clients_json" | jq -e type >/dev/null 2>&1; then
        window_address=$(
            printf '%s' "$clients_json" |
            jq -r --arg app_id "$APP_ID" '
                .[]
                | select(.class == $app_id or .initialClass == $app_id)
                | .address
            ' |
            head -n1
        )

        if [ -n "$window_address" ]; then
            hyprctl dispatch focuswindow "address:$window_address" >/dev/null
            exit 0
        fi
    fi
fi

# Launch btop in terminal
"$TERMINAL" --class "$APP_ID" -e "$TUI" >>"$LOG_FILE" 2>&1 &
disown