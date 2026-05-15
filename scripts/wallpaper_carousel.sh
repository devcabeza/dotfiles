#!/bin/bash

# 1. Validar que estamos en la familia Arch (Arch, CachyOS, Endeavour, etc.)
if ! grep -qE "^(ID|ID_LIKE)=.*arch" /etc/os-release; then
    echo "Distro no detectada como familia Arch. Saliendo..."
    exit 0
fi

# 2. Función para instalar swww si no existe
install_swww() {
    if ! command -v swww &> /dev/null; then
        echo ">>> swww no encontrado. Intentando instalar..."
        
        # Detectar el helper disponible (preferimos yay, luego paru, luego pacman)
        if command -v yay &> /dev/null; then
            yay -S --noconfirm swww
        elif command -v paru &> /dev/null; then
            paru -S --noconfirm swww
        else
            echo ">>> No se encontró yay o paru. Usando pacman (requiere sudo)..."
            sudo pacman -S --noconfirm swww
        fi
    fi
}

# Ejecutar instalación
install_swww

# 3. Configuración del carrusel
DIR="$HOME/Pictures/Wallpapers"
INTERVAL=300

# Asegurar que el directorio existe
mkdir -p "$DIR"

# Inicializar swww (el daemon)
swww query || swww init

# 4. Bucle infinito
while true; do
    # Solo actuar si hay archivos en la carpeta
    if [ -d "$DIR" ] && [ "$(ls -A "$DIR")" ]; then
        # shuf es excelente para elegir uno al azar
        RANDOM_PIC=$(find "$DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.webp" \) | shuf -n 1)

        if [ -n "$RANDOM_PIC" ]; then
            swww img "$RANDOM_PIC" \
                --transition-type random \
                --transition-fps 60 \
                --transition-step 30
        fi
    else
        echo ">>> Esperando a que añadas wallpapers en $DIR..."
    fi

    sleep $INTERVAL
done
