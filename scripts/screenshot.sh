#!/bin/bash
# Script para capturas de pantalla usando grim y slurp

DIR="$HOME/Imágenes/Capturas"
mkdir -p "$DIR"
NAME="screenshot_$(date +%Y%m%d_%H%M%S).png"
FILE="$DIR/$NAME"

grim -g "$(slurp)" "$FILE" && wl-copy < "$FILE" && notify-send "Captura Guardada" "Guardada en $DIR y copiada al portapapeles"
