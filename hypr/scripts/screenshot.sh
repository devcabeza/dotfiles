#!/usr/bin/env bash

# Directorio de capturas
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"

# Nombre de archivo con marca de tiempo
FILE="$DIR/screenshot_$(date +'%Y%m%d_%H%M%S').png"

case "$1" in
    area)
        # Seleccionar área con slurp
        GEOM=$(slurp)
        # Si el usuario canceló (presionó Escape), salir limpiamente
        [ -z "$GEOM" ] && exit 0
        grim -g "$GEOM" "$FILE"
        ;;
    full)
        sleep 0.1
        grim "$FILE"
        ;;
    *)
        echo "Uso: $0 [area|full]"
        exit 1
        ;;
esac

# Si la captura se generó con éxito, copiar al portapapeles y notificar
if [ -f "$FILE" ]; then
    wl-copy -t image/png < "$FILE"
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -a "grim" -i "$FILE" "Captura de pantalla" "Copiada al portapapeles y guardada en:\n$FILE"
    fi
fi
