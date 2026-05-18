#!/bin/bash

# Initialize swww if not running
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon &
    sleep 1 # Wait for daemon to start
fi

WALLPAPER_DIR="/home/alejandrocabeza/.dotfiles/wallpapers"

# Set a random wallpaper on start
random_wall=$(ls "$WALLPAPER_DIR" | grep -E ".jpg$|.png$|.jpeg$" | shuf -n 1)
swww img "$WALLPAPER_DIR/$random_wall" --transition-type fade

# Loop to change wallpaper every 30 minutes
while true; do
    sleep 1800
    random_wall=$(ls "$WALLPAPER_DIR" | grep -E ".jpg$|.png$|.jpeg$" | shuf -n 1)
    swww img "$WALLPAPER_DIR/$random_wall" --transition-type fade --transition-duration 3
done
