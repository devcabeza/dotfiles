#!/usr/bin/env bash
set -euo pipefail

# Keybinds menu con fzf en terminal flotante

# Ensure we're running inside a terminal
if [ ! -t 0 ]; then
    exec alacritty --class "org.omarchy.keybinds-menu" -e "$0" "$@"
fi

# Ensure Nix profile is in PATH
export PATH="$HOME/.nix-profile/bin:$PATH"

BINDS_FILE="$HOME/.config/hypr/lua/binds.lua"

if [ ! -f "$BINDS_FILE" ]; then
    echo "No se encontró el archivo de keybinds: $BINDS_FILE"
    exit 1
fi

# Parsear keybinds del archivo Lua
# Extrae líneas como: hl.bind(m.mainMod .. " + N", hl.dsp.exec_cmd("/path/to/script"))
# y las formatea como: SUPER + N  →  wifi_menu.sh
parse_keybinds() {
    # Extract hl.bind lines and format them
    grep -E '^\s*hl\.bind\(' "$BINDS_FILE" | while IFS= read -r line; do
        # Extract the key combination (between first pair of quotes)
        key=$(echo "$line" | sed -n 's/.*"\([^"]*\)".*/\1/p' | head -1)

        # Extract the command (second string argument)
        cmd=$(echo "$line" | sed -n 's/.*exec_cmd("\([^"]*\)".*/\1/p')

        # If no exec_cmd, try to get the dispatcher name
        if [ -z "$cmd" ]; then
            cmd=$(echo "$line" | sed -n 's/.*hl\.dsp\.\([a-zA-Z_]*\).*/\1/p')
        fi

        # Get basename if it's a path
        if [ -n "$cmd" ]; then
            cmd=$(basename "$cmd" 2>/dev/null || echo "$cmd")
        fi

        # Format: key → cmd
        if [ -n "$key" ] && [ -n "$cmd" ]; then
            printf "%-30s →  %s\n" "$key" "$cmd"
        fi
    done
}

# Generate the list
keybinds=$(parse_keybinds)

if [ -z "$keybinds" ]; then
    echo "No se encontraron keybinds."
    exit 1
fi

# Display in fzf
chosen=$(echo "$keybinds" | fzf \
  --prompt "Buscar atajo... " \
  --header="[Enter] copiar al clipboard  [Esc] salir" \
  --color "pointer:green,marker:green" \
  --border \
  --height 100% \
  --layout=reverse \
  --bind 'enter:execute(echo {} | wl-copy)+abort' \
  2>/dev/null)

if [ -n "$chosen" ]; then
    echo "$chosen" | wl-copy
    notify-send "Atajo copiado" "$chosen" -u low
fi
