#!/usr/bin/env bash
# DEPRECATED: usa feh (X11) - no funcionará en Hyprland (Wayland)
# Usar swww-random.sh o wallpaper-rotate.sh en su lugar
# Carrusel de wallpapers - cambia el fondo cada 10 minutos
# Usa imágenes del directorio wallpapers/

WALLPAPER_DIR="$HOME/.dotfiles/wallpapers"
INTERVALO=600  # 10 minutos en segundos

while true; do
    # Buscar archivos de imagen (jpg, jpeg, png) y elegir uno al azar
    feh --randomize --bg-fill "$WALLPAPER_DIR"/*.{jpg,jpeg,png} 2>/dev/null
    sleep "$INTERVALO"
done
