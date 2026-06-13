#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# 🌗 Theme Dark/Light Toggle — Omarchy-style
# ============================================================
# Alterna entre el tema oscuro actual y el tema claro más cercano.
# Útil para un atajo de teclado rápido (SUPER+Alt+T).
# ============================================================

export PATH="$HOME/.nix-profile/bin:$PATH"

APP_ID="org.omarchy.theme-toggle"
THEMES_FILE="$HOME/.dotfiles/themes/themes.json"
STATE_FILE="/tmp/omarchy-theme-current"

# Leer tema actual
CURRENT_THEME=""
if [[ -f $STATE_FILE ]]; then
    CURRENT_THEME=$(cat "$STATE_FILE")
fi

# Si no hay tema actual, detectar por GTK
if [[ -z $CURRENT_THEME ]]; then
    CURRENT_GTK=$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null | tr -d "'" || echo "")
    case "$CURRENT_GTK" in
        *adw-gtk3-dark*|*gruvbox*|*catppuccin*|*tokyo*night*) 
            CURRENT_THEME="gruvbox-material" ;;
        *adw-gtk3*|*flexoki*|*light*) 
            CURRENT_THEME="flexoki-light" ;;
        *) CURRENT_THEME="gruvbox-material" ;;
    esac
fi

# Obtener el tipo del tema actual (dark/light)
CURRENT_TYPE=$(jq -r --arg id "$CURRENT_THEME" '.[$id].type // "dark"' "$THEMES_FILE")

# Encontrar un tema del tipo opuesto
if [[ $CURRENT_TYPE == "dark" ]]; then
    # Buscar primer tema light
    TARGET_THEME=$(jq -r 'to_entries[] | select(.value.type == "light") | .key' "$THEMES_FILE" | head -1)
    [[ -z $TARGET_THEME ]] && TARGET_THEME="flexoki-light"
else
    # Buscar primer tema dark (distinto al actual)
    TARGET_THEME=$(jq -r --arg current "$CURRENT_THEME" \
        'to_entries[] | select(.value.type == "dark" and .key != $current) | .key' "$THEMES_FILE" | head -1)
    [[ -z $TARGET_THEME ]] && TARGET_THEME="gruvbox-material"
fi

# Aplicar el tema encontrado
if [[ -n $TARGET_THEME ]]; then
    exec "$HOME/.dotfiles/scripts/theme_switch.sh" "$TARGET_THEME"
else
    notify-send "Theme Toggle" "No se encontró un tema para alternar" -u normal
    exit 1
fi
