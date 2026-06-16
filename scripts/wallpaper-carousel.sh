#!/usr/bin/env bash
# Carrusel de wallpapers - cambia el fondo cada 10 minutos
# Usa imágenes del directorio wallpapers/

WALLPAPER_DIR="$HOME/.dotfiles/wallpapers"
INTERVALO=600  # 10 minutos en segundos

while true; do
    # Buscar archivos de imagen (jpg, jpeg, png) y elegir uno al azar
    feh --randomize --bg-fill "$WALLPAPER_DIR"/*.{jpg,jpeg,png} 2>/dev/null
    sleep "$INTERVALO"
done
