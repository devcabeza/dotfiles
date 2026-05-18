#!/bin/bash

WALLPAPER_DIR="/home/alejandrocabeza/.dotfiles/wallpapers"

# Get list of wallpapers
files=$(ls "$WALLPAPER_DIR" | grep -E ".jpg$|.png$|.jpeg$")

# Use wofi to select one
chosen=$(echo -e "$files" | wofi --dmenu --prompt "Select Wallpaper: " --cache-file /dev/null)

if [ -n "$chosen" ]; then
    # Set wallpaper using swww
    swww img "$WALLPAPER_DIR/$chosen" --transition-type grow --transition-pos "$(hyprctl cursorpos)" --transition-duration 2
    
    # Optional: Update a current wallpaper symlink or config if needed
    # echo "$chosen" > ~/.cache/current_wallpaper
fi
