#!/usr/bin/env bash
# Script de capturas de pantalla para Wayland (grim + slurp)
# Uso: screenshot.sh [full|area]

set -euo pipefail

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
FILENAME="$SCREENSHOT_DIR/screenshot-$TIMESTAMP.png"

# Crear directorio si no existe
mkdir -p "$SCREENSHOT_DIR"

case "${1:-full}" in
    full)
        # Captura completa
        grim "$FILENAME"
        ;;
    area)
        # Captura de área seleccionada
        grim -g "$(slurp)" "$FILENAME"
        ;;
    *)
        echo "Uso: screenshot.sh [full|area]"
        exit 1
        ;;
esac

# Copiar al portapapeles (si wl-copy está disponible)
if command -v wl-copy &> /dev/null; then
    wl-copy < "$FILENAME"
fi

# Notificación
notify-send "Captura de pantalla" "Guardada: $FILENAME" \
    --icon=image-x-generic \
    --hint=int:transient:1

echo "Captura guardada: $FILENAME"
