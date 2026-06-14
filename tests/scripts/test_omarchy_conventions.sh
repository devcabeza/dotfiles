#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Test 2: Cumplimiento de convenciones Omarchy
# ============================================================
# Verifica que el script sigue el patrón Omarchy:
# shebang, set -euo pipefail, APP_ID, window rule, keybind.
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SCRIPT_PATH="$PROJECT_ROOT/scripts/monitor_menu.sh"
WINDOWRULES="$PROJECT_ROOT/hypr/lua/windowrules.lua"
BINDS="$PROJECT_ROOT/hypr/lua/binds.lua"

PASS_COUNT=0
FAIL_COUNT=0

pass() {
    printf '\033[32m  PASS\033[0m: %s\n' "$1"
    PASS_COUNT=$((PASS_COUNT + 1))
}

fail() {
    printf '\033[31m  FAIL\033[0m: %s\n' "$1"
    FAIL_COUNT=$((FAIL_COUNT + 1))
}

printf '\n╔══════════════════════════════════════════════════════╗\n'
printf '║  Test 2: Convenciones Omarchy                        ║\n'
printf '╚══════════════════════════════════════════════════════╝\n\n'

# ─── Test 2.1: Shebang #!/usr/bin/env bash ───
if [[ -f "$SCRIPT_PATH" ]]; then
    local_first_line=$(head -n1 "$SCRIPT_PATH")
    if [[ "$local_first_line" == "#!/usr/bin/env bash" ]]; then
        pass 'Shebang es #!/usr/bin/env bash'
    else
        fail "Shebang incorrecto: '$local_first_line' (esperado: '#!/usr/bin/env bash')"
    fi
else
    fail "No se puede verificar shebang (archivo no existe)"
fi

# ─── Test 2.2: set -euo pipefail ───
if [[ -f "$SCRIPT_PATH" ]]; then
    if grep -q 'set -euo pipefail' "$SCRIPT_PATH"; then
        pass 'Contiene "set -euo pipefail"'
    else
        fail 'No contiene "set -euo pipefail" (requerido por convención Omarchy)'
    fi
else
    fail 'No se puede verificar set -euo pipefail (archivo no existe)'
fi

# ─── Test 2.3: APP_ID definido ───
if [[ -f "$SCRIPT_PATH" ]]; then
    if grep -q '^APP_ID=' "$SCRIPT_PATH"; then
        pass "APP_ID está definido como variable global"
    else
        fail "APP_ID no está definido como variable global (esperado: APP_ID=...)"
    fi
else
    fail "No se puede verificar APP_ID (archivo no existe)"
fi

# ─── Test 2.4: APP_ID sigue convención org.omarchy.* ───
if [[ -f "$SCRIPT_PATH" ]]; then
    if grep -q 'APP_ID="org\.omarchy\.' "$SCRIPT_PATH"; then
        pass 'APP_ID sigue convención org.omarchy.<nombre>'
    else
        fail 'APP_ID no sigue convención org.omarchy.<nombre>'
    fi
else
    fail "No se puede verificar convención APP_ID (archivo no existe)"
fi

# ─── Test 2.5: Window rule existe en windowrules.lua ───
if [[ -f "$WINDOWRULES" ]]; then
    if grep -q 'org\\.omarchy\\.monitor-menu' "$WINDOWRULES"; then
        pass "Window rule para org.omarchy.monitor-menu existe en windowrules.lua"
    else
        fail "Window rule para org.omarchy.monitor-menu NO existe en windowrules.lua"
    fi
else
    fail "windowrules.lua no existe (ruta: $WINDOWRULES)"
fi

# ─── Test 2.6: Window rule tiene float = true ───
if [[ -f "$WINDOWRULES" ]]; then
    # Buscar el bloque de monitor-menu y verificar que contiene float = true
    if grep -A5 'org\\.omarchy\\.monitor-menu' "$WINDOWRULES" | grep -q 'float.*=.*true'; then
        pass "Window rule para monitor-menu tiene float = true"
    else
        fail "Window rule para monitor-menu NO tiene float = true"
    fi
else
    fail "No se puede verificar float (windowrules.lua no existe)"
fi

# ─── Test 2.7: Window rule tiene size 900x650 ───
if [[ -f "$WINDOWRULES" ]]; then
    if grep -A5 'org\\.omarchy\\.monitor-menu' "$WINDOWRULES" | grep -q '900.*650'; then
        pass "Window rule para monitor-menu tiene tamaño 900x650"
    else
        fail "Window rule para monitor-menu NO tiene tamaño 900x650"
    fi
else
    fail "No se puede verificar size (windowrules.lua no existe)"
fi

# ─── Test 2.8: Window rule tiene center = true ───
if [[ -f "$WINDOWRULES" ]]; then
    if grep -A5 'org\\.omarchy\\.monitor-menu' "$WINDOWRULES" | grep -q 'center.*=.*true'; then
        pass "Window rule para monitor-menu tiene center = true"
    else
        fail "Window rule para monitor-menu NO tiene center = true"
    fi
else
    fail "No se puede verificar center (windowrules.lua no existe)"
fi

# ─── Test 2.9: Keybind SUPER + O existe en binds.lua ───
if [[ -f "$BINDS" ]]; then
    if grep -q 'mainMod.*+.*O' "$BINDS" && grep -q 'monitor_menu' "$BINDS"; then
        pass "Keybind SUPER + O → monitor_menu.sh existe en binds.lua"
    else
        fail "Keybind SUPER + O → monitor_menu.sh NO existe en binds.lua"
    fi
else
    fail "binds.lua no existe (ruta: $BINDS)"
fi

# ─── Test 2.10: Keybind apunta a la ruta correcta del script ───
if [[ -f "$BINDS" ]]; then
    if grep -q 'scripts/monitor_menu.sh' "$BINDS"; then
        pass "Keybind apunta a scripts/monitor_menu.sh"
    else
        fail "Keybind NO apunta a scripts/monitor_menu.sh"
    fi
else
    fail "No se puede verificar ruta del keybind (binds.lua no existe)"
fi

# ─── Test 2.11: Script usa Alacritty para re-lanzarse ───
if [[ -f "$SCRIPT_PATH" ]]; then
    if grep -q 'alacritty' "$SCRIPT_PATH"; then
        pass "Script se re-lanza en Alacritty (patrón Omarchy)"
    else
        fail "Script NO se re-lanza en Alacritty (patrón Omarchy requerido)"
    fi
else
    fail "No se puede verificar Alacritty (archivo no existe)"
fi

# ─── Test 2.12: Script exporta PATH con .nix-profile ───
if [[ -f "$SCRIPT_PATH" ]]; then
    if grep -q 'export PATH=.*\.nix-profile' "$SCRIPT_PATH"; then
        pass 'Script exporta PATH con $HOME/.nix-profile'
    else
        fail 'Script NO exporta PATH con $HOME/.nix-profile'
    fi
else
    fail "No se puede verificar PATH (archivo no existe)"
fi

# ─── Resumen ───
printf '\n──────────────────────────────────────────────────────\n'
printf "  Resultados: \033[32m${PASS_COUNT} pasaron\033[0m | \033[31m${FAIL_COUNT} fallaron\033[0m\n"
printf '──────────────────────────────────────────────────────\n\n'

if [[ "$FAIL_COUNT" -gt 0 ]]; then
    exit 1
fi
exit 0
