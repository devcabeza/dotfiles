#!/usr/bin/env bash
# ============================================================
# 🖥️  Monitor Qtile — Omarchy-style
# ============================================================
# Menú interactivo para gestionar monitores en Qtile.
# Usa wlr-randr en Wayland, xrandr en X11.
# ============================================================

set -euo pipefail
export PATH="$HOME/.nix-profile/bin:/usr/bin:/usr/local/bin:$PATH"

APP_ID="org.omarchy.monitor-menu"

# Ensure we're running inside a terminal
if [ ! -t 0 ]; then
    exec alacritty --class "$APP_ID" -e "$0" "$@"
fi

# ─── Detectar backend ───
detect_backend() {
    if [ "${XDG_SESSION_TYPE:-}" = "wayland" ]; then
        if command -v wlr-randr &>/dev/null; then
            echo "wayland-wlr"
        else
            echo "wayland"
        fi
    else
        if command -v xrandr &>/dev/null; then
            echo "x11"
        else
            echo "unknown"
        fi
    fi
}

BACKEND=$(detect_backend)

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

# ─── Helpers ───
notify() {
    local urgency="${1:-normal}"
    local title="${2:-Monitor}"
    local message="$3"
    if command -v notify-send &>/dev/null; then
        notify-send -u "$urgency" "$title" "$message"
    else
        printf '%s: %s\n' "$title" "$message" >&2
    fi
}

get_outputs_wlr() {
    wlr-randr 2>/dev/null | grep -E '^[A-Z]' | awk '{print $1}'
}

get_outputs_xrandr() {
    xrandr 2>/dev/null | grep ' connected' | awk '{print $1}'
}

# Obtiene el modo actual (resolución@refresco) para un output en wlr-randr.
# Usa grep -oE con POSIX regex en vez de -P, que falla en algunos sistemas.
get_mode_wlr() {
    local output="$1"
    wlr-randr 2>/dev/null | grep -A10 "^${output}" | grep -oE '[0-9]+x[0-9]+@[0-9]+' | head -1
}

get_external() {
    case "$BACKEND" in
        wayland-wlr)
            get_outputs_wlr | grep -v -i 'eDP' | head -1 || echo ""
            ;;
        x11)
            get_outputs_xrandr | grep -v -i 'eDP' | head -1 || echo ""
            ;;
        *)
            echo ""
            ;;
    esac
}

error_no_external() {
    notify "critical" "Monitor" "❌ No se detectó ningún monitor externo"
    printf '\n❌ Error: No se detectó ningún monitor externo conectado.\n'
    printf 'Conecta un monitor externo e inténtalo de nuevo.\n\n'
    read -rp 'Presiona Enter para continuar... '
}

# ─── Perfiles ───
apply_solo_laptop() {
    case "$BACKEND" in
        wayland-wlr)
            for out in $(get_outputs_wlr); do
                if ! echo "$out" | grep -qi 'eDP'; then
                    wlr-randr --output "$out" --off 2>/dev/null || true
                fi
            done
            local laptop mode
            laptop=$(get_outputs_wlr | grep -i 'eDP' | head -1)
            if [ -n "$laptop" ]; then
                mode=$(get_mode_wlr "$laptop")
                [ -z "$mode" ] && mode="1920x1080@60"
                wlr-randr --output "$laptop" --on --mode "$mode" 2>/dev/null || true
            fi
            ;;
        x11)
            for out in $(get_outputs_xrandr); do
                if ! echo "$out" | grep -qi 'eDP'; then
                    xrandr --output "$out" --off 2>/dev/null || true
                fi
            done
            local laptop
            laptop=$(get_outputs_xrandr | grep -i 'eDP' | head -1)
            if [ -n "$laptop" ]; then
                xrandr --output "$laptop" --auto --primary 2>/dev/null || true
            fi
            ;;
        *)
            notify "critical" "Monitor" "❌ Backend no soportado: $BACKEND"
            return 1
            ;;
    esac
    notify "low" "Monitor" "🖥️  Modo: Solo laptop"
}

apply_solo_externo() {
    case "$BACKEND" in
        wayland-wlr)
            external=$(get_external)
            if [ -z "$external" ]; then
                error_no_external
                return 1
            fi
            # Capturar modo del externo ANTES de apagar el laptop
            local mode
            mode=$(get_mode_wlr "$external")
            if [ -z "$mode" ]; then
                # Intentar con modo por defecto
                mode="1920x1080@60"
                notify "low" "Monitor" "⚠️ Usando modo por defecto ${mode} para ${external}"
            fi
            # Apagar laptop
            local laptop
            laptop=$(get_outputs_wlr | grep -i 'eDP' | head -1)
            if [ -n "$laptop" ]; then
                wlr-randr --output "$laptop" --off 2>/dev/null || true
            fi
            # Encender externo
            wlr-randr --output "$external" --on --mode "$mode" 2>/dev/null || {
                notify "critical" "Monitor" "❌ Error al configurar $external con modo $mode"
                return 1
            }
            ;;
        x11)
            external=$(get_external)
            if [ -z "$external" ]; then
                error_no_external
                return 1
            fi
            local laptop
            laptop=$(get_outputs_xrandr | grep -i 'eDP' | head -1)
            if [ -n "$laptop" ]; then
                xrandr --output "$laptop" --off 2>/dev/null || true
            fi
            xrandr --output "$external" --auto --primary 2>/dev/null || {
                notify "critical" "Monitor" "❌ Error al configurar $external"
                return 1
            }
            ;;
        *)
            notify "critical" "Monitor" "❌ Backend no soportado"
            return 1
            ;;
    esac
    notify "low" "Monitor" "📺 Modo: Solo externo ($external)"
}

apply_extendido() {
    case "$BACKEND" in
        wayland-wlr)
            local laptop external mode_lap mode_ext
            laptop=$(get_outputs_wlr | grep -i 'eDP' | head -1)
            external=$(get_external)
            if [ -z "$external" ]; then
                error_no_external
                return 1
            fi
            # Obtener modos
            mode_lap=$(get_mode_wlr "$laptop")
            [ -z "$mode_lap" ] && mode_lap="1920x1080@60"
            mode_ext=$(get_mode_wlr "$external")
            [ -z "$mode_ext" ] && mode_ext="1920x1080@60"

            # Obtener ancho del laptop para posicionar externo a la derecha
            local lap_width
            lap_width=$(wlr-randr 2>/dev/null | grep -A10 "^${laptop}" | grep -oP '\d+(?=x\d+@)' | head -1)
            [ -z "$lap_width" ] && lap_width=1920

            wlr-randr --output "$laptop" --on --mode "$mode_lap" --pos 0,0 2>/dev/null || true
            wlr-randr --output "$external" --on --mode "$mode_ext" --pos "${lap_width},0" 2>/dev/null || {
                notify "critical" "Monitor" "❌ Error al configurar $external"
                return 1
            }
            ;;
        x11)
            local laptop external
            laptop=$(get_outputs_xrandr | grep -i 'eDP' | head -1)
            external=$(get_external)
            if [ -z "$external" ]; then
                error_no_external
                return 1
            fi
            xrandr --output "$laptop" --auto --pos 0x0 --primary 2>/dev/null || true
            xrandr --output "$external" --auto --right-of "$laptop" 2>/dev/null || {
                notify "critical" "Monitor" "❌ Error al configurar $external"
                return 1
            }
            ;;
        *)
            notify "critical" "Monitor" "❌ Backend no soportado"
            return 1
            ;;
    esac
    notify "low" "Monitor" "↔️  Modo: Extendido (laptop izquierda + externo derecha)"
}

apply_mirror() {
    case "$BACKEND" in
        wayland-wlr)
            local laptop external mode
            laptop=$(get_outputs_wlr | grep -i 'eDP' | head -1)
            external=$(get_external)
            if [ -z "$external" ]; then
                error_no_external
                return 1
            fi
            # Usar el modo del laptop para ambos (misma resolución = espejo)
            mode=$(get_mode_wlr "$laptop")
            [ -z "$mode" ] && mode="1920x1080@60"
            wlr-randr --output "$laptop" --on --mode "$mode" --pos 0,0 2>/dev/null || true
            wlr-randr --output "$external" --on --mode "$mode" --pos 0,0 2>/dev/null || {
                notify "critical" "Monitor" "❌ Error al configurar mirror"
                return 1
            }
            ;;
        x11)
            local laptop external
            laptop=$(get_outputs_xrandr | grep -i 'eDP' | head -1)
            external=$(get_external)
            if [ -z "$external" ]; then
                error_no_external
                return 1
            fi
            xrandr --output "$external" --same-as "$laptop" --auto 2>/dev/null || {
                notify "critical" "Monitor" "❌ Error al configurar mirror"
                return 1
            }
            ;;
        *)
            notify "critical" "Monitor" "❌ Backend no soportado"
            return 1
            ;;
    esac
    notify "low" "Monitor" "🪞 Modo: Espejo"
}

# ─── Estado actual ───
show_status() {
    clear
    printf '\n╔══════════════════════════════════════════════════╗\n'
    printf '║           📋 Estado Actual de Monitores          ║\n'
    printf '╚══════════════════════════════════════════════════╝\n\n'

    case "$BACKEND" in
        wayland-wlr)
            wlr-randr 2>/dev/null || printf 'Error al leer estado.\n'
            ;;
        x11)
            xrandr --current 2>/dev/null | head -30 || printf 'Error al leer estado.\n'
            ;;
        *)
            printf 'Backend no detectado.\n'
            ;;
    esac

    local external
    external=$(get_external)
    if [ -z "$external" ]; then
        printf '\n⚠️  No hay monitor externo conectado.\n\n'
    fi

    printf '\nPresiona Enter para volver al menú...'
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
        "📋 Estado actual" \
        "❌ Salir" \
        | fzf \
            --prompt="Monitor > " \
            --header="Gestión de Monitores (backend: $BACKEND)" \
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
        "📋 Estado actual")
            show_status
            ;;
        "❌ Salir"|"")
            exit 0
            ;;
    esac
done
