#!/bin/bash
# Wallpaper carousel using swww (omakub/omarchy style)

export PATH="$HOME/.nix-profile/bin:$PATH"

# 1. Validar que estamos en la familia Arch
if ! grep -qE "^(ID|ID_LIKE)=.*arch" /etc/os-release; then
    echo "Distro no detectada como familia Arch. Saliendo..."
    exit 0
fi

# 2. Función para instalar swww si no existe
install_swww() {
    if ! command -v swww &> /dev/null; then
        echo ">>> swww no encontrado. Intentando instalar..."
        
        if command -v yay &> /dev/null; then
            yay -S --noconfirm swww
        elif command -v paru &> /dev/null; then
            paru -S --noconfirm swww
        elif command -v pacman &> /dev/null; then
            sudo pacman -S --noconfirm swww
        else
            echo ">>> No se encontró ningún package manager..."
            exit 1
        fi
    fi
}

# Ejecutar instalación
install_swww

# 3. Configuración del carrusel
DIR="$HOME/Pictures/Wallpapers"
INTERVAL=300  # 5 minutos

# Asegurar que el directorio existe
mkdir -p "$DIR"

# Inicializar swww (el daemon)
swww query || swww init

echo ">>> Wallpaper carousel started (interval: ${INTERVAL}s)"
echo ">>> Wallpapers directory: $DIR"

# 4. Bucle infinito
while true; do
    if [ -d "$DIR" ] && [ "$(ls -A "$DIR")" ]; then
        RANDOM_PIC=$(find "$DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.webp" \) | shuf -n 1)

        if [ -n "$RANDOM_PIC" ]; then
            echo ">>> Setting wallpaper: $(basename "$RANDOM_PIC")"
            swww img "$RANDOM_PIC" \
                --transition-type random \
                --transition-fps 60 \
                --transition-step 30
        fi
    else
        echo ">>> No wallpapers found in $DIR"
    fi

    sleep $INTERVAL
done
