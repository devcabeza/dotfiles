#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# 🎨 Theme Switcher — Omarchy-style (Nix + Home Manager compatible)
# ============================================================
# Selector interactivo de temas con fzf.
# Cambia: GTK, Waybar, Alacritty, Hyprland borders, wallpaper, Dunst.
#
# Funciona con Nix + Home Manager:
#   • Modifica los archivos fuente en ~/.dotfiles/ (persistente)
#   • Aplica cambios en runtime (gsettings, hyprctl, swaybg)
#   • Para waybar/dunst: usa rutas absolutas a ~/.dotfiles/
#   • Ejecuta 'uhm' para desplegar los cambios permanentemente
# ============================================================

export PATH="$HOME/.nix-profile/bin:$PATH"

APP_ID="org.omarchy.theme-switch"
DOTFILES="$HOME/.dotfiles"
THEMES_FILE="$DOTFILES/themes/themes.json"
STATE_FILE="/tmp/omarchy-theme-current"

# Source files (en ~/.dotfiles/ — SIEMPRE editables)
WAYBAR_SRC="$DOTFILES/waybar/styles.css"
WAYBAR_CONFIG="$DOTFILES/waybar/config.jsonc"
ALACRITTY_SRC="$DOTFILES/alacritty/alacritty.toml"
DUNST_SRC="$DOTFILES/dunst/dunstrc"
GTK_SRC="$DOTFILES/gtk-3.0/settings.ini"

# Verificar dependencias
if [[ ! -f $THEMES_FILE ]]; then
    notify-send "Theme Switcher" "No se encuentra themes.json" -u critical
    exit 1
fi

if ! command -v fzf &>/dev/null; then
    notify-send "Theme Switcher" "fzf no está instalado" -u critical
    exit 1
fi

# Obtener lista de temas del JSON
get_theme_list() {
    jq -r 'to_entries[] | "\(.key)│\(.value.name)│\(.value.type)"' "$THEMES_FILE" |
        column -t -s '│' -o '  '
}

# Aplicar un tema
apply_theme() {
    local theme_id="$1"
    local theme_data

    theme_data=$(jq -r --arg id "$theme_id" '.[$id]' "$THEMES_FILE")

    if [[ -z $theme_data || $theme_data == "null" ]]; then
        notify-send "Theme Switcher" "Tema '$theme_id' no encontrado" -u critical
        exit 1
    fi

    local theme_name
    theme_name=$(echo "$theme_data" | jq -r '.name')

    notify-send "Theme Switcher" "Aplicando tema: $theme_name..." -u low

    # ============================================================
    # 1. GTK Theme (gsettings — funciona siempre, runtime)
    # ============================================================
    local gtk_theme
    gtk_theme=$(echo "$theme_data" | jq -r '."gtk-theme"')
    local prefer_dark
    prefer_dark=$(echo "$theme_data" | jq -r '."gtk-prefer-dark"')

    if [[ -n $gtk_theme && $gtk_theme != "null" ]]; then
        gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme" 2>/dev/null || true
        if [[ $prefer_dark == "true" ]]; then
            gsettings set org.gnome.desktop.interface color-scheme "prefer-dark" 2>/dev/null || true
        else
            gsettings set org.gnome.desktop.interface color-scheme "default" 2>/dev/null || true
        fi
    fi

    # ============================================================
    # 2. GTK settings.ini — modificar fuente en ~/.dotfiles/
    # ============================================================
    if [[ -f $GTK_SRC ]]; then
        sed -i "s/gtk-theme-name = .*/gtk-theme-name = $gtk_theme/" "$GTK_SRC"
        if [[ $prefer_dark == "true" ]]; then
            sed -i "s/gtk-application-prefer-dark-theme = .*/gtk-application-prefer-dark-theme = 1/" "$GTK_SRC"
        else
            sed -i "s/gtk-application-prefer-dark-theme = .*/gtk-application-prefer-dark-theme = 0/" "$GTK_SRC"
        fi
        # Si ~/.config/gtk-3.0/settings.ini es editable, actualizarlo también
        local deployed_gtk="$HOME/.config/gtk-3.0/settings.ini"
        if [[ -f $deployed_gtk && -w $deployed_gtk ]]; then
            sed -i "s/gtk-theme-name = .*/gtk-theme-name = $gtk_theme/" "$deployed_gtk" 2>/dev/null || true
            if [[ $prefer_dark == "true" ]]; then
                sed -i "s/gtk-application-prefer-dark-theme = .*/gtk-application-prefer-dark-theme = 1/" "$deployed_gtk" 2>/dev/null || true
            else
                sed -i "s/gtk-application-prefer-dark-theme = .*/gtk-application-prefer-dark-theme = 0/" "$deployed_gtk" 2>/dev/null || true
            fi
        fi
    fi

    # ============================================================
    # 3. Hyprland borders (hyprctl — funciona siempre, runtime)
    # ============================================================
    local active_border inactive_border
    active_border=$(echo "$theme_data" | jq -r '.hyprland.active_border')
    inactive_border=$(echo "$theme_data" | jq -r '.hyprland.inactive_border')

    hyprctl keyword general:col.active_border "$active_border" 2>/dev/null || true
    hyprctl keyword general:col.inactive_border "$inactive_border" 2>/dev/null || true

    # ============================================================
    # 4. Waybar — modificar fuente ~/.dotfiles/ y recargar
    # ============================================================
    if [[ -f $WAYBAR_SRC ]]; then
        echo "$theme_data" | jq -r '.waybar | to_entries[] | 
            "@define-color \(.key) \(.value)"' | while IFS= read -r line; do
            local color_name color_value
            color_name=$(echo "$line" | sed 's/@define-color \([^ ]*\) .*/\1/')
            color_value=$(echo "$line" | sed 's/@define-color [^ ]* \(.*\)/\1/')
            if [[ -n $color_name && -n $color_value ]]; then
                sed -i "s/@define-color $color_name .*/@define-color $color_name $color_value/" "$WAYBAR_SRC"
            fi
        done

        # Recargar waybar usando la fuente (autostart ya usa rutas absolutas a ~/.dotfiles/)
        killall waybar 2>/dev/null || true
        waybar --config "$WAYBAR_CONFIG" --style "$WAYBAR_SRC" &>/dev/null &
    fi

    # ============================================================
    # 5. Alacritty — modificar fuente en ~/.dotfiles/
    # ============================================================
    if [[ -f $ALACRITTY_SRC ]]; then
        local val

        # Reemplazar colores primary
        sed -i "s/background = \"#.*\"/background = \"$(echo "$theme_data" | jq -r '.alacritty.background')\"/" "$ALACRITTY_SRC"
        sed -i "s/foreground = \"#.*\"/foreground = \"$(echo "$theme_data" | jq -r '.alacritty.foreground')\"/" "$ALACRITTY_SRC"
        sed -i "s/dim_foreground = \"#.*\"/dim_foreground = \"$(echo "$theme_data" | jq -r '.alacritty.dim_foreground')\"/" "$ALACRITTY_SRC"
        sed -i "s/bright_foreground = \"#.*\"/bright_foreground = \"$(echo "$theme_data" | jq -r '.alacritty.bright_foreground')\"/" "$ALACRITTY_SRC"

        # Reemplazar colores normales
        for color in black red green yellow blue magenta cyan white; do
            val=$(echo "$theme_data" | jq -r ".alacritty.$color")
            sed -i "s/^$color = \"#.*\"/$color = \"$val\"/" "$ALACRITTY_SRC"
        done

        # Reemplazar colores bright
        for color in black red green yellow blue magenta cyan white; do
            val=$(echo "$theme_data" | jq -r ".alacritty.\"bright-$color\"")
            sed -i "s/^$color = \"#.*\"/$color = \"$val\"/" "$ALACRITTY_SRC"
        done

        # Reemplazar cursor
        sed -i "s/cursor = \"#.*\"/cursor = \"$(echo "$theme_data" | jq -r '.alacritty.cursor')\"/" "$ALACRITTY_SRC"
        sed -i "s/text = \"#.*\"/text = \"$(echo "$theme_data" | jq -r '.alacritty."cursor-text"')\"/" "$ALACRITTY_SRC"

        # Si ~/.config/alacritty/alacritty.toml es editable, actualizarlo también
        local deployed_alacritty="$HOME/.config/alacritty/alacritty.toml"
        if [[ -f $deployed_alacritty && -w $deployed_alacritty ]]; then
            cp "$ALACRITTY_SRC" "$deployed_alacritty"
        fi
    fi

    # ============================================================
    # 6. Dunst — modificar fuente en ~/.dotfiles/ y recargar
    # ============================================================
    if [[ -f $DUNST_SRC ]]; then
        sed -i "s/background = \"#.*\"/background = \"$(echo "$theme_data" | jq -r '.dunst.background')\"/" "$DUNST_SRC"
        sed -i "s/foreground = \"#.*\"/foreground = \"$(echo "$theme_data" | jq -r '.dunst.foreground')\"/" "$DUNST_SRC"
        sed -i "s/frame_color = \"#.*\"/frame_color = \"$(echo "$theme_data" | jq -r '.dunst.frame')\"/" "$DUNST_SRC"

        # Recargar dunst desde la fuente
        killall dunst 2>/dev/null || true
        dunst -config "$DUNST_SRC" &>/dev/null &
    fi

    # ============================================================
    # 7. Wallpaper — cambiar fondo
    # ============================================================
    local wallpaper_pattern
    wallpaper_pattern=$(echo "$theme_data" | jq -r '."wallpaper-pattern"')
    local wallpaper_dir="$DOTFILES/wallpapers"

    if [[ -d $wallpaper_dir ]]; then
        local wallpaper
        wallpaper=$(ls "$wallpaper_dir"/*.{jpg,jpeg,png} 2>/dev/null |
            grep -i "$wallpaper_pattern" 2>/dev/null | shuf -n 1 2>/dev/null || true)

        if [[ -z $wallpaper ]]; then
            wallpaper=$(ls "$wallpaper_dir"/*.{jpg,jpeg,png} 2>/dev/null | shuf -n 1)
        fi

        if [[ -n $wallpaper ]]; then
            killall swaybg 2>/dev/null || true
            swaybg -i "$wallpaper" -m fill &>/dev/null &
        fi
    fi

    # ============================================================
    # 8. Guardar estado y notificar
    # ============================================================
    echo "$theme_id" > "$STATE_FILE"

    notify-send "Theme Switcher" "✓ Tema aplicado: $theme_name

Los cambios ya están activos. Para hacerlos permanentes tras reinicio, ejecuta: uhm" -u low
}

# --- Main ---

if [[ -n ${1:-} ]]; then
    apply_theme "$1"
else
    THEME_ID=$(get_theme_list | fzf \
        --prompt="🎨 Select theme > " \
        --height=15 \
        --with-nth=2.. \
        --border \
        --color='fg:#ddc7a1,bg:#282828,hl:#7daea3' \
        --color='fg+:#ddc7a1,bg+:#3c3836,hl+:#7daea3' \
        --color='info:#a89984,prompt:#7daea3,pointer:#d3869b' \
        --color='marker:#d3869b,spinner:#a9b665,header:#7daea3' \
        | awk '{print $1}')

    if [[ -n $THEME_ID ]]; then
        apply_theme "$THEME_ID"
    fi
fi
