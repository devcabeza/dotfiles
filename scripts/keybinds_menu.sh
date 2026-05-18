#!/bin/bash
# Script para mostrar keybinds usando wofi

KEYBINDS=$(grep -E '^bind[e]? =' ~/.config/hypr/hyprland.conf | sed 's/bind[e]* = //g')
echo "$KEYBINDS" | wofi --dmenu --prompt "Atajos de Teclado" --width 800 --height 600
