#!/usr/bin/env bash
# Diagnóstico de monitores para Qtile Wayland

export PATH="$HOME/.nix-profile/bin:/usr/bin:/usr/local/bin:$PATH"

echo "=== 1. wlr-randr (texto) ==="
wlr-randr 2>&1
echo ""

echo "=== 2. wlr-randr (json) ==="
wlr-randr --json 2>&1
echo ""

echo "=== 3. wlr-randr --json | jq ==="
wlr-randr --json 2>/dev/null | jq '.' 2>&1 || echo "jq no disponible"
echo ""

echo "=== 4. Probando --off en externo ==="
external=$(wlr-randr 2>/dev/null | grep -E '^[A-Z]' | awk '{print $1}' | grep -v -i 'eDP' | head -1)
echo "Externo detectado: '$external'"
if [ -n "$external" ]; then
    echo ""
    echo "=== 5. Probando wlr-randr --output $external --off ==="
    wlr-randr --output "$external" --off 2>&1
    echo "Exit code: $?"
    sleep 1
    
    echo ""
    echo "=== 6. Probando wlr-randr --output $external --on ==="
    wlr-randr --output "$external" --on 2>&1
    echo "Exit code: $?"
    sleep 1
    
    echo ""
    echo "=== 7. Probando wlr-randr --output $external --mode 1920x1080 ==="
    wlr-randr --output "$external" --mode 1920x1080 2>&1
    echo "Exit code: $?"
    sleep 1
    
    echo ""
    echo "=== 8. Probando wlr-randr --output $external --custom-mode 1920x1080@60000 ==="
    wlr-randr --output "$external" --custom-mode 1920x1080@60000 2>&1
    echo "Exit code: $?"
fi

echo ""
echo "=== 9. Estado final ==="
wlr-randr 2>&1
