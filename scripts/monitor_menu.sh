#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# 🖥️  Monitor Menu — Omarchy-style
# ============================================================
# Menú interactivo para gestionar monitores:
# perfiles predefinidos, escala, resolución y estado actual.
# Usa fzf + hyprctl keyword monitor para cambios en caliente.
# ============================================================

export PATH="$HOME/.nix-profile/bin:$PATH"

APP_ID="org.omarchy.monitor-menu"

# Ensure we're running inside a terminal
if [ ! -t 0 ]; then
    exec alacritty --class "$APP_ID" -e "$0" "$@"
fi

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
    --prompt="🖥️  "
    --color="fg:${COLOR_FG},bg:${COLOR_BG},hl:${COLOR_ACCENT}"
    --color="fg+:${COLOR_WHITE},bg+:${COLOR_BG_HOVER},hl+:${COLOR_ACCENT}"
    --color="info:${COLOR_GRAY},prompt:${COLOR_ACCENT},pointer:${COLOR_PURPLE}"
    --color="marker:${COLOR_GREEN},spinner:${COLOR_YELLOW},header:${COLOR_GRAY}"
)

# ─── Helper: obtener monitor externo (orden de prioridad) ───
get_external() {
    for name in HDMI-A-1 DP-1 DP-2 DP-3; do
        if hyprctl monitors -j | jq -e --arg name "$name" \
            '.[] | select(.name == $name and .disabled == false)' >/dev/null 2>&1; then
            echo "$name"
            return 0
        fi
    done
    echo ""
}

# ─── Helper: notificar con dunst ───
notify() {
    local urgency="${1:-normal}"
    local title="${2:-Monitor}"
    local message="$3"
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -u "$urgency" "$title" "$message"
    else
        printf '%s: %s\n' "$title" "$message" >&2
    fi
}

# ─── Helper: error sin monitor externo ───
error_no_external() {
    notify "critical" "Monitor" "❌ No se detectó ningún monitor externo"
    printf '\n❌ Error: No se detectó ningún monitor externo conectado.\n'
    printf 'Conecta un monitor externo e inténtalo de nuevo.\n\n'
    read -rp 'Presiona Enter para continuar... '
}

# ─── Perfil: Solo laptop ───
apply_solo_laptop() {
    # Deshabilitar todos los monitores externos
    local external
    while IFS= read -r external; do
        [[ -z "$external" ]] && continue
        if ! hyprctl keyword monitor "$external,disable" >/dev/null 2>&1; then
            notify "critical" "Monitor" "❌ Error al deshabilitar $external"
        fi
    done < <(hyprctl monitors -j | jq -r '.[] | select(.name != "eDP-1") | .name')

    # Habilitar eDP-1 con modo preferido
    if ! hyprctl keyword monitor "eDP-1,preferred,0x0,1" >/dev/null 2>&1; then
        notify "critical" "Monitor" "❌ Error al aplicar: Solo laptop"
        read -rp 'Presiona Enter para continuar... '
        return 1
    fi

    notify "low" "Monitor" "🖥️  Modo: Solo laptop"
}

# ─── Perfil: Solo externo ───
apply_solo_externo() {
    local external
    external=$(get_external)
    if [[ -z "$external" ]]; then
        error_no_external
        return 1
    fi

    if ! hyprctl keyword monitor "eDP-1,disable" >/dev/null 2>&1; then
        notify "critical" "Monitor" "❌ Error al deshabilitar eDP-1"
    fi

    if ! hyprctl keyword monitor "$external,preferred,0x0,1" >/dev/null 2>&1; then
        notify "critical" "Monitor" "❌ Error al aplicar: Solo externo ($external)"
        read -rp 'Presiona Enter para continuar... '
        return 1
    fi

    local desc
    desc=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$external\") | .description // .make + \" \" + .model") || { notify "critical" "Monitor" "❌ Error al leer monitores"; return 1; }
    notify "low" "Monitor" "📺 Modo: Solo externo ($desc)"
}

# ─── Perfil: Extendido derecha ───
apply_extendido() {
    local external
    external=$(get_external)
    if [[ -z "$external" ]]; then
        error_no_external
        return 1
    fi

    # Obtener ancho de eDP-1 para posicionar el externo a la derecha
    local edp_width
    edp_width=$(hyprctl monitors -j | jq -r '.[] | select(.name == "eDP-1") | .width') || { notify "critical" "Monitor" "❌ Error al leer monitores"; return 1; }

    if ! hyprctl keyword monitor "eDP-1,preferred,0x0,1" >/dev/null 2>&1; then
        notify "critical" "Monitor" "❌ Error al aplicar: Extendido - laptop"
        read -rp 'Presiona Enter para continuar... '
        return 1
    fi
    if ! hyprctl keyword monitor "$external,preferred,${edp_width}x0,1" >/dev/null 2>&1; then
        notify "critical" "Monitor" "❌ Error al aplicar: Extendido ($external)"
        read -rp 'Presiona Enter para continuar... '
        return 1
    fi

    notify "low" "Monitor" "↔️  Modo: Extendido (laptop izquierda + externo derecha)"
}

# ─── Perfil: Espejo ───
apply_mirror() {
    local external
    external=$(get_external)
    if [[ -z "$external" ]]; then
        error_no_external
        return 1
    fi

    # Usar el modo de eDP-1 para ambos monitores (posición 0x0 = espejo)
    local edp_mode
    edp_mode=$(hyprctl monitors -j | jq -r '.[] | select(.name == "eDP-1") | "\(.width)x\(.height)@\(.refreshRate | floor)"') || { notify "critical" "Monitor" "❌ Error al leer monitores"; return 1; }

    if ! hyprctl keyword monitor "eDP-1,${edp_mode},0x0,1" >/dev/null 2>&1; then
        notify "critical" "Monitor" "❌ Error al aplicar: Espejo - laptop"
        read -rp 'Presiona Enter para continuar... '
        return 1
    fi
    if ! hyprctl keyword monitor "$external,${edp_mode},0x0,1" >/dev/null 2>&1; then
        notify "critical" "Monitor" "❌ Error al aplicar: Espejo ($external)"
        read -rp 'Presiona Enter para continuar... '
        return 1
    fi

    notify "low" "Monitor" "🪞 Modo: Espejo"
}

# ─── Submenú: Ajustar escala ───
submenu_scale() {
    # Seleccionar monitor
    local monitor
    monitor=$(hyprctl monitors -j | jq -r '.[] | select(.disabled == false) | "\(.name)  (\(.width)x\(.height) @ \(.scale)x)"' | \
        fzf --prompt="Selecciona monitor > " \
            --header="🔍 Ajustar Escala — Selecciona el monitor" \
            "${FZF_OPTS[@]}" 2>/dev/null | awk '{print $1}')

    [[ -z "$monitor" ]] && return 0

    # Seleccionar escala
    local scale
    scale=$(printf "1.0\n1.25\n1.5\n2.0" | \
        fzf --prompt="Escala para $monitor > " \
            --header="🔍 Ajustar Escala — $monitor" \
            "${FZF_OPTS[@]}" 2>/dev/null)

    [[ -z "$scale" ]] && return 0

    local mode pos old_scale
    mode=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$monitor\") | \"\(.width)x\(.height)@\(.refreshRate | floor)\"") || { notify "critical" "Monitor" "❌ Error al leer configuración"; return 1; }
    pos=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$monitor\") | \"\(.x)x\(.y)\"") || { notify "critical" "Monitor" "❌ Error al leer configuración"; return 1; }
    old_scale=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$monitor\") | .scale") || { notify "critical" "Monitor" "❌ Error al leer configuración"; return 1; }

    if hyprctl keyword monitor "$monitor,${mode},${pos},${scale}" >/dev/null 2>&1; then
        notify "low" "Monitor" "🔍 $monitor: escala ${old_scale} → ${scale}"
    else
        notify "critical" "Monitor" "❌ No se pudo aplicar escala ${scale} a $monitor"
        printf '\n❌ Error: Fallo al aplicar escala.\n\n'
        read -rp 'Presiona Enter para continuar... '
    fi
}

# ─── Submenú: Cambiar resolución ───
submenu_resolution() {
    # Seleccionar monitor
    local monitor
    monitor=$(hyprctl monitors -j | jq -r '.[] | select(.disabled == false) | "\(.name)  (\(.width)x\(.height) @ \(.scale)x)"' | \
        fzf --prompt="Selecciona monitor > " \
            --header="📐 Cambiar Resolución — Selecciona el monitor" \
            "${FZF_OPTS[@]}" 2>/dev/null | awk '{print $1}')

    [[ -z "$monitor" ]] && return 0

    # Obtener modos disponibles y limpiarlos para fzf
    local selected_mode
    selected_mode=$(hyprctl monitors -j | jq -r "
        .[] | select(.name == \"$monitor\") | .availableModes[] |
        sub(\"\\\\.00Hz\"; \"\") | sub(\"Hz\"; \"\")
    " | sort -t'@' -k2 -nr | \
        fzf --prompt="Resolución para $monitor > " \
            --header="📐 Cambiar Resolución — $monitor" \
            "${FZF_OPTS[@]}" 2>/dev/null)

    [[ -z "$selected_mode" ]] && return 0

    local pos scale
    pos=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$monitor\") | \"\(.x)x\(.y)\"") || { notify "critical" "Monitor" "❌ Error al leer configuración"; return 1; }
    scale=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$monitor\") | .scale") || { notify "critical" "Monitor" "❌ Error al leer configuración"; return 1; }

    if hyprctl keyword monitor "$monitor,${selected_mode},${pos},${scale}" >/dev/null 2>&1; then
        notify "low" "Monitor" "📐 $monitor: resolución → ${selected_mode}"
    else
        notify "critical" "Monitor" "❌ No se pudo aplicar resolución ${selected_mode} a $monitor"
        printf '\n❌ Error: Fallo al aplicar resolución.\n\n'
        read -rp 'Presiona Enter para continuar... '
    fi
}

# ─── Mostrar estado actual ───
show_status() {
    clear
    printf '\n╔══════════════════════════════════════════════════╗\n'
    printf '║           📋 Estado Actual de Monitores          ║\n'
    printf '╚══════════════════════════════════════════════════╝\n\n'

    hyprctl monitors -j | jq -r '
        .[] | select(.disabled == false) |
        "🖥️  \(.name)\n" +
        "   Fabricante: \(.make // "N/A") | Modelo: \(.model // "N/A")\n" +
        "   Resolución: \(.width)x\(.height) @ \(.refreshRate)Hz\n" +
        "   Posición:   \(.x),\(.y)\n" +
        "   Escala:     \(.scale)\n" +
        "   Modo actual: \(.width)x\(.height)@\(.refreshRate | floor)\n" +
        (if .vrr then "   VRR:        Activado\n" else "" end) +
        "\n"
    '

    local external
    external=$(get_external)
    if [[ -z "$external" ]]; then
        printf '⚠️  No hay monitor externo conectado.\n\n'
    fi

    printf 'Presiona Enter para volver al menú...'
    read -r
}

# ─── Main Menu ───
while true; do
    clear
    choice=$(printf '%s\n' \
        "🖥️  Solo laptop" \
        "📺 Solo externo" \
        "↔️  Extendido derecha" \
        "🪞  Espejo" \
        "🔍 Ajustar escala" \
        "📐 Cambiar resolución" \
        "📋 Estado actual" \
        "❌ Salir" \
        | fzf \
            --prompt="Monitor > " \
            --header="Gestión de Monitores" \
            "${FZF_OPTS[@]}" 2>/dev/null) || exit 0

    case "$choice" in
        "🖥️  Solo laptop")
            apply_solo_laptop && notify "low" "Monitor" "✅ Cambio aplicado" && exit 0
            ;;
        "📺 Solo externo")
            apply_solo_externo && exit 0
            ;;
        "↔️  Extendido derecha")
            apply_extendido && exit 0
            ;;
        "🪞  Espejo")
            apply_mirror && exit 0
            ;;
        "🔍 Ajustar escala")
            submenu_scale
            ;;
        "📐 Cambiar resolución")
            submenu_resolution
            ;;
        "📋 Estado actual")
            show_status
            ;;
        "❌ Salir"|"")
            exit 0
            ;;
    esac
done
