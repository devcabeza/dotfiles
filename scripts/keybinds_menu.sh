#!/usr/bin/env bash
# Keyboard shortcuts menu using fzf + Alacritty (omakub/omarchy style)

CONF_FILE="$HOME/.dotfiles/hypr/hyprland.conf"

# Verificar que existe el archivo de configuración
if [ ! -f "$CONF_FILE" ]; then
    notify-send "Keybinds" "Config file not found: $CONF_FILE"
    exit 1
fi

# Extraer y formatear atajos
binds=$(grep -E "^(bind|binde|bindl|bindel|bindm)" "$CONF_FILE" | \
    sed -E 's/[[:space:]]+/ /g' | \
    while read -r line; do
        parts=($line)
        type="${parts[0]}"
        mods="${parts[1]}"
        key="${parts[2]}"
        action="${parts[3]}"
        args="${parts[@]:4}"

        # Reemplazar variables
        mods="${mods//\$mainMod/Super}"
        mods="${mods//\$altMod/Alt}"
        mods="${mods//SHIFT/⇧}"
        mods="${mods//CTRL/⌃}"
        mods="${mods//ALT/⌥}"

        # Formatear acción
        case "$action" in
            exec)
                desc="${args//\$filemanager/nautilus}"
                desc="${desc//\$terminal/ghostty}"
                desc="${desc//\$menu/hyprlauncher}"
                desc="${desc//\$browser/firefox}"
                desc="Run: $desc"
                ;;
            workspace) desc="Workspace $args" ;;
            movetoworkspace) desc="Move to workspace $args" ;;
            togglespecialworkspace) desc="Toggle special workspace" ;;
            movefocus)
                case "$args" in
                    l) dir="←" ;;
                    r) dir="→" ;;
                    u) dir="↑" ;;
                    d) dir="↓" ;;
                esac
                desc="Focus $dir"
                ;;
            swapwindow)
                case "$args" in
                    l) dir="←" ;;
                    r) dir="→" ;;
                    u) dir="↑" ;;
                    d) dir="↓" ;;
                esac
                desc="Swap window $dir"
                ;;
            resizeactive) desc="Resize $args" ;;
            killactive) desc="Close window" ;;
            exit) desc="Exit Hyprland" ;;
            fullscreen) desc="Fullscreen" ;;
            togglefloating) desc="Toggle floating" ;;
            submap) desc="Submap: $args" ;;
            *) desc="$action $args" ;;
        esac

        # Formato: "key  →  action"
        printf "%-12s → %s\n" "$mods $key" "$desc"
    done)

if [ -z "$binds" ]; then
    notify-send "Keybinds" "No binds found in config"
    exit 1
fi

# Menú con fzf
selected=$(echo "$binds" | fzf --height=25 --border=rounded --margin=5% --padding=1 \
    --header=' ⌨  KEYBOARD SHORTCUTS ' --header-border=bottom \
    --color=bg+:#1a1b26,bg:#1a1b26,fg:#a9b1d6,hl:#7aa2f7,fg+:#c0caf5 \
    --color=prompt:#bb9af7,pointer:#7dcfff,marker:#9ece6a,header:#565f89 \
    --bind=tab:down,bspace:up,ctrl-c:abort \
    --highlight-line \
    --pointer='❯' \
    --marker=' ')

# Mostrar notificación con el atajo seleccionado
if [ -n "$selected" ]; then
    notify-send "⌨  $selected" -i keyboard
fi
