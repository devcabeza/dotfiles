#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# 🎨 Theme Switcher — Omarchy-style
# ============================================================
# Selector interactivo de temas con fzf.
# Cambia: GTK, Waybar, Alacritty, Hyprland borders, wallpaper.
# ============================================================

export PATH="$HOME/.nix-profile/bin:$PATH"

APP_ID="org.omarchy.theme-switch"
THEMES_FILE="$HOME/.dotfiles/themes/themes.json"
STATE_FILE="/tmp/omarchy-theme-current"

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
    
    # 1. GTK Theme
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
    
    # 2. Hyprland border colors
    local active_border inactive_border
    active_border=$(echo "$theme_data" | jq -r '.hyprland.active_border')
    inactive_border=$(echo "$theme_data" | jq -r '.hyprland.inactive_border')
    
    hyprctl keyword general:col.active_border "$active_border" 2>/dev/null || true
    hyprctl keyword general:col.inactive_border "$inactive_border" 2>/dev/null || true
    
    # 3. Waybar colors (replace @define-color in styles.css)
    local waybar_css="$HOME/.config/waybar/styles.css"
    if [[ -f $waybar_css ]]; then
        echo "$theme_data" | jq -r '.waybar | to_entries[] | 
            "@define-color \(.key) \(.value)"' | while IFS= read -r line; do
            local color_name color_value
            color_name=$(echo "$line" | sed 's/@define-color \([^ ]*\) .*/\1/')
            color_value=$(echo "$line" | sed 's/@define-color [^ ]* \(.*\)/\1/')
            if [[ -n $color_name && -n $color_value ]]; then
                sed -i "s/@define-color $color_name .*/@define-color $color_name $color_value/" "$waybar_css"
            fi
        done
        
        # Reload waybar
        killall waybar 2>/dev/null || true
        waybar --config "$HOME/.config/waybar/config.jsonc" --style "$waybar_css" &>/dev/null &
    fi
    
    # 4. Alacritty colors
    local alacritty_conf="$HOME/.config/alacritty/alacritty.toml"
    if [[ -f $alacritty_conf ]]; then
        # Replace primary colors
        sed -i "s/background = \"#.*\"/background = \"$(echo "$theme_data" | jq -r '.alacritty.background')\"/" "$alacritty_conf"
        sed -i "s/foreground = \"#.*\"/foreground = \"$(echo "$theme_data" | jq -r '.alacritty.foreground')\"/" "$alacritty_conf"
        sed -i "s/dim_foreground = \"#.*\"/dim_foreground = \"$(echo "$theme_data" | jq -r '.alacritty.dim_foreground')\"/" "$alacritty_conf"
        sed -i "s/bright_foreground = \"#.*\"/bright_foreground = \"$(echo "$theme_data" | jq -r '.alacritty.bright_foreground')\"/" "$alacritty_conf"
        
        # Replace normal colors
        for color in black red green yellow blue magenta cyan white; do
            local val
            val=$(echo "$theme_data" | jq -r ".alacritty.$color")
            sed -i "s/^$color = \"#.*\"/$color = \"$val\"/" "$alacritty_conf"
        done
        
        # Replace bright colors
        for color in black red green yellow blue magenta cyan white; do
            local val
            val=$(echo "$theme_data" | jq -r ".alacritty.\"bright-$color\"")
            sed -i "s/^$color = \"#.*\"/$color = \"$val\"/" "$alacritty_conf"
        done
        
        # Replace cursor
        sed -i "s/cursor = \"#.*\"/cursor = \"$(echo "$theme_data" | jq -r '.alacritty.cursor')\"/" "$alacritty_conf"
        sed -i "s/text = \"#.*\"/text = \"$(echo "$theme_data" | jq -r '.alacritty.cursor-text')\"/" "$alacritty_conf"
    fi
    
    # 5. Dunst colors
    local dunst_conf="$HOME/.config/dunst/dunstrc"
    if [[ -f $dunst_conf ]]; then
        sed -i "s/background = \"#.*\"/background = \"$(echo "$theme_data" | jq -r '.dunst.background')\"/" "$dunst_conf"
        sed -i "s/foreground = \"#.*\"/foreground = \"$(echo "$theme_data" | jq -r '.dunst.foreground')\"/" "$dunst_conf"
        sed -i "s/frame_color = \"#.*\"/frame_color = \"$(echo "$theme_data" | jq -r '.dunst.frame')\"/" "$dunst_conf"
        killall dunst 2>/dev/null || true
        dunst &>/dev/null &
    fi
    
    # 6. Wallpaper (pick a random one matching the theme pattern)
    local wallpaper_pattern
    wallpaper_pattern=$(echo "$theme_data" | jq -r '."wallpaper-pattern"')
    local wallpaper_dir="$HOME/.dotfiles/wallpapers"
    
    if [[ -d $wallpaper_dir ]]; then
        # Try to find a wallpaper matching the pattern
        local wallpaper
        wallpaper=$(ls "$wallpaper_dir"/*.{jpg,jpeg,png} 2>/dev/null | 
            grep -i "$wallpaper_pattern" 2>/dev/null | shuf -n 1 2>/dev/null || true)
        
        # Fallback: any random wallpaper
        if [[ -z $wallpaper ]]; then
            wallpaper=$(ls "$wallpaper_dir"/*.{jpg,jpeg,png} 2>/dev/null | shuf -n 1)
        fi
        
        if [[ -n $wallpaper ]]; then
            killall swaybg 2>/dev/null || true
            swaybg -i "$wallpaper" -m fill &>/dev/null &
        fi
    fi
    
    # Save current theme
    echo "$theme_id" > "$STATE_FILE"
    
    # Update GTK settings.ini
    local gtk_settings="$HOME/.config/gtk-3.0/settings.ini"
    if [[ -f $gtk_settings ]]; then
        sed -i "s/gtk-theme-name = .*/gtk-theme-name = $gtk_theme/" "$gtk_settings"
        if [[ $prefer_dark == "true" ]]; then
            sed -i "s/gtk-application-prefer-dark-theme = .*/gtk-application-prefer-dark-theme = 1/" "$gtk_settings"
        else
            sed -i "s/gtk-application-prefer-dark-theme = .*/gtk-application-prefer-dark-theme = 0/" "$gtk_settings"
        fi
    fi
    
    notify-send "Theme Switcher" "Tema aplicado: $theme_name" -u low
}

# --- Main ---

if [[ -n ${1:-} ]]; then
    # Apply theme by ID (for toggle script)
    apply_theme "$1"
else
    # Show fzf selector
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
