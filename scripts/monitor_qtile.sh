#!/usr/bin/env bash
# ============================================================
# 🖥️  Monitor Qtile — Omarchy-style
# ============================================================
# Menú interactivo para gestionar monitores en Qtile.
# Usa wlr-randr (Wayland) o xrandr (X11).
# ============================================================

set -euo pipefail

# ─── Auto-detectar WAYLAND_DISPLAY ───
# Si wlr-randr no encuentra el display, buscar el socket manualmente
if [ "${XDG_SESSION_TYPE:-}" = "wayland" ] && [ -z "${WAYLAND_DISPLAY:-}" ]; then
    for sock in "$XDG_RUNTIME_DIR"/wayland-* "$XDG_RUNTIME_DIR"/*wayland*; do
        if [ -S "$sock" ] 2>/dev/null; then
            export WAYLAND_DISPLAY="$(basename "$sock")"
            break
        fi
    done
fi

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

# ─── Configurar output con wlr-randr (Wayland) ───
# Usa wlr-randr --json + jq para obtener modos exactos,
# y prueba varios formatos hasta que uno funcione.
configure_output_wlr() {
    local output="$1"   # nombre del output (ej: HDMI-A-1)
    local action="$2"   # "on", "off", o "auto"
    local pos_x="${3:-0}"
    local pos_y="${4:-0}"

    case "$action" in
        "off")
            wlr-randr --output "$output" --off 2>/dev/null
            return $?
            ;;
        "on"|"auto")
            # Obtener modo desde JSON (formato nativo de wlr-randr)
            local width height refresh json_mode
            if command -v jq &>/dev/null; then
                width=$(wlr-randr --json 2>/dev/null | jq -r ".[] | select(.name == \"$output\") | .modes[0].width" 2>/dev/null || echo "")
                height=$(wlr-randr --json 2>/dev/null | jq -r ".[] | select(.name == \"$output\") | .modes[0].height" 2>/dev/null || echo "")
                refresh=$(wlr-randr --json 2>/dev/null | jq -r ".[] | select(.name == \"$output\") | .modes[0].refresh" 2>/dev/null || echo "")
            else
                # Fallback sin jq: parsear de wlr-randr texto
                local mode_line
                mode_line=$(wlr-randr 2>/dev/null | grep -A10 "^${output}" | grep -m1 'preferred\|current')
                width=$(echo "$mode_line" | grep -oE '^[[:space:]]*[0-9]+' | tr -d ' ')
                height=$(echo "$mode_line" | grep -oE 'x[0-9]+' | head -1 | tr -d 'x')
                refresh=$(echo "$mode_line" | grep -oE '@[0-9]+' | tr -d '@')
            fi

            # Fallback si no se pudo detectar
            [ -z "$width" ] && width=1920
            [ -z "$height" ] && height=1080
            [ -z "$refresh" ] && refresh=60000

            # Construir modos a probar (de más específico a menos)
            local modes_to_try=()
            modes_to_try+=("${width}x${height}@${refresh}")        # formato milliHz: 1920x1080@60000
            modes_to_try+=("${width}x${height}@$((refresh/1000))") # formato Hz: 1920x1080@60
            modes_to_try+=("${width}x${height}@$((refresh/1000))Hz") # formato Hz con sufijo: 1920x1080@60Hz
            modes_to_try+=("${width}x${height}")                    # solo resolución: 1920x1080
            modes_to_try+=("preferred")                             # modo preferido del monitor

            local mode
            for mode in "${modes_to_try[@]}"; do
                # Intentar con --custom-mode primero, luego --mode
                if wlr-randr --output "$output" --custom-mode "${mode}" 2>/dev/null; then
                    # Si especificamos posición, aplicarla
                    if [ "$pos_x" -ne 0 ] || [ "$pos_y" -ne 0 ]; then
                        wlr-randr --output "$output" --pos "${pos_x},${pos_y}" 2>/dev/null || true
                    fi
                    return 0
                fi
                if wlr-randr --output "$output" --mode "${mode}" 2>/dev/null; then
                    if [ "$pos_x" -ne 0 ] || [ "$pos_y" -ne 0 ]; then
                        wlr-randr --output "$output" --pos "${pos_x},${pos_y}" 2>/dev/null || true
                    fi
                    return 0
                fi
            done

            # Último recurso: intentar solo --on sin modo
            wlr-randr --output "$output" --on 2>/dev/null && return 0

            return 1
            ;;
    esac
}

# ─── Perfiles ───
apply_solo_laptop() {
    case "$BACKEND" in
        wayland-wlr)
            for out in $(get_outputs_wlr); do
                if ! echo "$out" | grep -qi 'eDP'; then
                    configure_output_wlr "$out" "off" || true
                fi
            done
            local laptop
            laptop=$(get_outputs_wlr | grep -i 'eDP' | head -1)
            if [ -n "$laptop" ]; then
                configure_output_wlr "$laptop" "on" || true
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
            local external
            external=$(get_external)
            if [ -z "$external" ]; then
                error_no_external
                return 1
            fi
            # PRIMERO encender externo (laptop aún encendido como respaldo)
            if ! configure_output_wlr "$external" "on"; then
                notify "critical" "Monitor" "❌ Error al configurar $external"
                return 1
            fi
            # LUEGO apagar laptop
            local laptop
            laptop=$(get_outputs_wlr | grep -i 'eDP' | head -1)
            if [ -n "$laptop" ]; then
                configure_output_wlr "$laptop" "off" || true
            fi
            ;;
        x11)
            local external
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
            local laptop external
            laptop=$(get_outputs_wlr | grep -i 'eDP' | head -1)
            external=$(get_external)
            if [ -z "$external" ]; then
                error_no_external
                return 1
            fi
            # Obtener ancho del laptop desde JSON
            local lap_width
            lap_width=$(wlr-randr --json 2>/dev/null | jq -r ".[] | select(.name == \"$laptop\") | .modes[0].width" 2>/dev/null || echo "1920")

            configure_output_wlr "$laptop" "on" 0 0 || true
            configure_output_wlr "$external" "on" "$lap_width" 0 || {
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
            local laptop external
            laptop=$(get_outputs_wlr | grep -i 'eDP' | head -1)
            external=$(get_external)
            if [ -z "$external" ]; then
                error_no_external
                return 1
            fi
            # Misma posición 0,0 para ambos = espejo
            configure_output_wlr "$laptop" "on" 0 0 || true
            configure_output_wlr "$external" "on" 0 0 || {
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
            printf '=== wlr-randr (raw) ===\n'
            wlr-randr 2>/dev/null || printf 'Error al leer estado.\n'
            printf '\n=== wlr-randr (JSON) ===\n'
            wlr-randr --json 2>/dev/null | jq '.' 2>/dev/null || printf '(jq no disponible)\n'
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
        "📋 Estado actual (debug)" \
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
        "📋 Estado actual (debug)")
            show_status
            ;;
        "❌ Salir"|"")
            exit 0
            ;;
    esac
done
