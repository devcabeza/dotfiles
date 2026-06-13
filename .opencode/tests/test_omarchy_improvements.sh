#!/usr/bin/env bash
# ==================================================
# Test: Mejoras Omarchy en Hyprland (RED phase)
# ==================================================
# Antes de @Build: TODOS los tests deben FALLAR
# Después de @Build: TODOS deben PASAR
# ==================================================

HYPR_DIR="/home/alejandrocabeza/.dotfiles/hypr/lua"
PASS=0
FAIL=0
TOTAL=0

red()   { echo -e "\033[31m✗ FAIL\033[0m $1"; }
green() { echo -e "\033[32m✓ PASS\033[0m $1"; }

check_no_pattern() {
    TOTAL=$((TOTAL + 1))
    if grep -q "$1" "$2" 2>/dev/null; then
        green "$3"
        PASS=$((PASS + 1))
    else
        red "$3"
        FAIL=$((FAIL + 1))
    fi
}

echo ""
echo "===== FASE RED: Verificando que las mejoras NO existan aún ====="
echo ""

# Test 1: Groupbar NO debe existir en decorations.lua
check_no_pattern "groupbar" "$HYPR_DIR/decorations.lua" "groupbar config en decorations.lua"

# Test 2: repeat_rate NO debe existir en input.lua
check_no_pattern "repeat_rate" "$HYPR_DIR/input.lua" "repeat_rate en input.lua"

# Test 3: repeat_delay NO debe existir en input.lua
check_no_pattern "repeat_delay" "$HYPR_DIR/input.lua" "repeat_delay en input.lua"

# Test 4: numlock_by_default NO debe existir en input.lua
check_no_pattern "numlock_by_default" "$HYPR_DIR/input.lua" "numlock_by_default en input.lua"

# Test 5: clickfinger_behavior NO debe existir en input.lua
check_no_pattern "clickfinger_behavior" "$HYPR_DIR/input.lua" "clickfinger_behavior en input.lua"

# Test 6: scroll_factor NO debe existir en input.lua
check_no_pattern "scroll_factor" "$HYPR_DIR/input.lua" "scroll_factor en input.lua"

# Test 7: hide_on_key_press NO debe existir en cursor.lua
check_no_pattern "hide_on_key_press" "$HYPR_DIR/cursor.lua" "hide_on_key_press en cursor.lua"

# Test 8: resize_on_border NO debe existir en general.lua
check_no_pattern "resize_on_border" "$HYPR_DIR/general.lua" "resize_on_border en general.lua"

# Test 9: force_split NO debe existir en general.lua
check_no_pattern "force_split" "$HYPR_DIR/general.lua" "force_split en general.lua"

# Test 10: disable_scale_notification NO debe existir en misc.lua
check_no_pattern "disable_scale_notification" "$HYPR_DIR/misc.lua" "disable_scale_notification en misc.lua"

# Test 11: anr_missed_pings NO debe existir en misc.lua
check_no_pattern "anr_missed_pings" "$HYPR_DIR/misc.lua" "anr_missed_pings en misc.lua"

# Test 12: hide_special_on_workspace_change NO debe existir en misc.lua
check_no_pattern "hide_special_on_workspace_change" "$HYPR_DIR/misc.lua" "hide_special_on_workspace_change en misc.lua"

# Test 13: suppress_event NO debe existir en windowrules.lua
check_no_pattern "suppress_event" "$HYPR_DIR/windowrules.lua" "suppress_event en windowrules.lua"

# Test 14: XWayland no_focus fix NO debe existir en windowrules.lua
check_no_pattern "xwayland = 1" "$HYPR_DIR/windowrules.lua" "XWayland fix en windowrules.lua"

# Test 15: systemctl import-environment NO debe existir en autostart.lua
check_no_pattern "systemctl --user import-environment" "$HYPR_DIR/autostart.lua" "systemd env import en autostart.lua"

echo ""
echo "===== RESULTADOS ====="
echo "Total: $TOTAL | PASS: $PASS | FAIL: $FAIL"
echo ""

if [ "$FAIL" -eq "$TOTAL" ]; then
    echo -e "\033[32m✓ FASE RED CORRECTA: Todos los tests fallan (0/$TOTAL pasan)\033[0m"
    echo "  Las mejoras aún no existen — listas para @Build."
    exit 0
elif [ "$FAIL" -gt 0 ]; then
    echo -e "\033[33m⚠ FASE RED PARCIAL: $PASS tests ya existen, $FAIL no existen.\033[0m"
    echo "  Algunas mejoras ya están implementadas."
    exit 1
else
    echo -e "\033[31m✗ FASE RED FALLIDA: Todos los tests pasan — las mejoras ya existen.\033[0m"
    echo "  No hay nada que implementar."
    exit 2
fi
