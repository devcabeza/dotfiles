#!/usr/bin/env bash
# Ensure Nix profile is in PATH (needed when launched from Hyprland)
export PATH="$HOME/.nix-profile/bin:$PATH"

set -euo pipefail

APP_ID="org.omarchy.wifi"
TUI="nmtui"
TERMINAL="${WIFI_MENU_TERMINAL:-alacritty}"
LOG_DIR="${XDG_CACHE_HOME:-$HOME/.cache}"
LOG_FILE="$LOG_DIR/wifi_menu.log"

mkdir -p "$LOG_DIR"
: >"$LOG_FILE" 2>/dev/null || LOG_FILE="/tmp/wifi_menu.log"

notify_error() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -u normal "WiFi" "$1"
    else
        printf 'WiFi: %s\n' "$1" >&2
    fi
}

if ! command -v "$TUI" >/dev/null 2>&1; then
    notify_error "No encontré nmtui. Asegurate de tener NetworkManager instalado."
    exit 1
fi

if ! command -v "$TERMINAL" >/dev/null 2>&1; then
    notify_error "No encontré la terminal '$TERMINAL'."
    exit 1
fi

rfkill unblock wifi >/dev/null 2>&1 || true

# Check if nmtui is already running and focus it
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

# Launch nmtui in terminal
"$TERMINAL" --class "$APP_ID" -e "$TUI" >>"$LOG_FILE" 2>&1 &
disown