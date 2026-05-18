#!/usr/bin/env bash
# Package installer using fzf + Alacritty floating (omakub/omarchy style)

# Obtener lista de paquetes
get_packages() {
    # Paquetes de pacman
    pacman -Ss 2>/dev/null | grep -E "^[^/]+/" | awk '{print $1}' | sort -u
    
    # Paquetes de AUR (si paru está disponible)
    if command -v paru &>/dev/null; then
        paru -Ss 2>/dev/null | grep -E "^aur/" | awk '{print $2}' | sort -u
    fi
}

# Verificar si ya está instalado
is_installed() {
    pacman -Qi "$1" &>/dev/null
}

# Menú de selección
selected=$(get_packages | fzf --height=20 --border=rounded --margin=5% \
    --header='  📦 INSTALL PACKAGE ' --header-border=bottom \
    --color=bg+:#1a1b26,bg:#1a1b26,fg:#a9b1d6,hl:#7aa2f7,fg+:#c0caf5 \
    --color=prompt:#bb9af7,pointer:#7dcfff,marker:#9ece6a,header:#565f89 \
    --bind=tab:down,bspace:up,ctrl-c:abort \
    --highlight-line \
    --pointer='❯' \
    --marker=' ' \
    --preview='pacman -Si {} 2>/dev/null | head -20' \
    --preview-window=up:3:hidden:wrap)

if [ -z "$selected" ]; then
    exit 0
fi

package="$selected"

# Verificar si ya está instalado
if is_installed "$package"; then
    notify-send "Package Manager" "⚠️ '$package' already installed"
    exit 0
fi

# Abrir terminal flotante para instalación
alacritty -t "Installing: $package" -e bash -c "
    echo ''
    echo '╔═══════════════════════════════════════════════════╗'
    echo '║  📦 Installing: $package                         ║'
    echo '╚═══════════════════════════════════════════════════╝'
    echo ''
    
    # Intentar con pacman primero, luego paru
    if sudo pacman -S --noconfirm '$package' 2>&1; then
        echo ''
        echo '╔═══════════════════════════════════════════════════╗'
        echo '║  ✅ Successfully installed: $package             ║'
        echo '╚═══════════════════════════════════════════════════╝'
    else
        # Intentar con paru (AUR)
        if command -v paru &>/dev/null; then
            echo 'Trying with paru (AUR)...'
            if paru -S --noconfirm '$package' 2>&1; then
                echo ''
                echo '╔═══════════════════════════════════════════════════╗'
                echo '║  ✅ Successfully installed from AUR: $package   ║'
                echo '╚═══════════════════════════════════════════════════╝'
            else
                echo ''
                echo '╔═══════════════════════════════════════════════════╗'
                echo '║  ❌ Failed to install: $package                   ║'
                echo '╚═══════════════════════════════════════════════════╝'
            fi
        else
            echo ''
            echo '╔═══════════════════════════════════════════════════╗'
            echo '║  ❌ Failed to install: $package                   ║'
            echo '╚═══════════════════════════════════════════════════╝'
        fi
    fi
    
    echo ''
    read -p 'Press Enter to exit...'
" &

# Hacer flotante la ventana
sleep 0.5
hyprctl dispatch setfloating forwindow "title:Installing: $package"
