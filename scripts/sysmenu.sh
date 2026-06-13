#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# 🔘 System Menu — Omarchy-style
# ============================================================
# Menú de sistema para apagar, reiniciar, suspender, bloquear
# y cerrar sesión. Usa fzf con colores Gruvbox.
# ============================================================

# Ensure we're running inside a terminal
if [ ! -t 0 ]; then
    exec alacritty --class "org.omarchy.sysmenu" -e "$0" "$@"
fi

export PATH="$HOME/.nix-profile/bin:$PATH"

# ─── Colors (Gruvbox Material) ───
COLOR_FG="#ddc7a1"
COLOR_BG="#282828"
COLOR_BG_HOVER="#3c3836"
COLOR_ACCENT="#7daea3"
COLOR_RED="#ea6962"
COLOR_GREEN="#a9b665"
COLOR_YELLOW="#d8a657"
COLOR_PURPLE="#d3869b"
COLOR_GRAY="#928374"
COLOR_WHITE="#ebdbb2"

FZF_OPTS=(
    --border
    --height=100%
    --layout=reverse
    --prompt="⚡ "
    --color="fg:${COLOR_FG},bg:${COLOR_BG},hl:${COLOR_ACCENT}"
    --color="fg+:${COLOR_WHITE},bg+:${COLOR_BG_HOVER},hl+:${COLOR_ACCENT}"
    --color="info:${COLOR_GRAY},prompt:${COLOR_ACCENT},pointer:${COLOR_PURPLE}"
    --color="marker:${COLOR_GREEN},spinner:${COLOR_YELLOW},header:${COLOR_GRAY}"
)

confirm_action() {
    local action="$1"
    local message="$2"
    
    echo -e "\n${message}"
    echo ""
    local choice=$(printf "No\nSi" | fzf \
        --prompt="¿Confirmar? " \
        --header="$action" \
        "${FZF_OPTS[@]}" \
        2>/dev/null)
    
    [[ $choice == "Si" ]]
}

# ─── Main Menu ───
while true; do
    chosen=$(printf "
🔒  Bloquear pantalla
💤  Suspender
🚪  Cerrar sesión
🔄  Reiniciar
⏻  Apagar
" | fzf \
    --header="  Menú del Sistema" \
    "${FZF_OPTS[@]}" \
    2>/dev/null) || exit 0

    # Remove icon prefix for matching
    action=$(echo "$chosen" | sed 's/^[^ ]*  //')

    case "$action" in
        "Bloquear pantalla")
            hyprlock 2>/dev/null || hyprctl dispatch dpms off
            exit 0
            ;;
        "Suspender")
            hyprlock 2>/dev/null &
            sleep 0.5
            systemctl suspend
            exit 0
            ;;
        "Cerrar sesión")
            if confirm_action "Cerrar Sesión" "¿Cerrar sesión? Se perderán los cambios no guardados."; then
                hyprctl dispatch exit
            fi
            ;;
        "Reiniciar")
            if confirm_action "Reiniciar" "¿Reiniciar el sistema?"; then
                systemctl reboot
            fi
            ;;
        "Apagar")
            if confirm_action "Apagar" "¿Apagar el equipo?"; then
                systemctl poweroff
            fi
            ;;
    esac
done
