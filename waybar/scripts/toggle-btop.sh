#!/usr/bin/env bash

# Si la ventana flotante de btop ya está abierta, la cerramos (toggle)
if pgrep -f "^kitty --class btop-floating" > /dev/null 2>&1; then
    pkill -f "^kitty --class btop-floating"
else
    kitty --class btop-floating -e btop
fi
