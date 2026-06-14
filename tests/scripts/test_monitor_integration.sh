#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Test 4: Integration Smoke Test
# ============================================================
# Verifica que las herramientas requeridas están disponibles
# y que hyprctl responde con JSON válido. Estas pruebas
# validan el entorno de ejecución, no la implementación.
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

PASS_COUNT=0
FAIL_COUNT=0
SKIP_COUNT=0

pass() {
    printf '\033[32m  PASS\033[0m: %s\n' "$1"
    PASS_COUNT=$((PASS_COUNT + 1))
}

fail() {
    printf '\033[31m  FAIL\033[0m: %s\n' "$1"
    FAIL_COUNT=$((FAIL_COUNT + 1))
}

skip() {
    printf '\033[33m  SKIP\033[0m: %s\n' "$1"
    SKIP_COUNT=$((SKIP_COUNT + 1))
}

printf '\n╔══════════════════════════════════════════════════════╗\n'
printf '║  Test 4: Integration Smoke Test                      ║\n'
printf '╚══════════════════════════════════════════════════════╝\n\n'

# ─── Test 4.1: hyprctl está disponible ───
if command -v hyprctl >/dev/null 2>&1; then
    pass "hyprctl está disponible en PATH"
else
    fail "hyprctl NO está disponible en PATH"
fi

# ─── Test 4.2: hyprctl monitors -j devuelve JSON válido ───
if command -v hyprctl >/dev/null 2>&1; then
    monitors_json=$(hyprctl monitors -j 2>/dev/null || true)
    if [[ -n "$monitors_json" ]] && echo "$monitors_json" | jq type >/dev/null 2>&1; then
        pass "hyprctl monitors -j devuelve JSON válido"
    else
        fail "hyprctl monitors -j NO devuelve JSON válido (o hyprctl no está corriendo)"
    fi
else
    skip "hyprctl monitors -j — hyprctl no disponible"
fi

# ─── Test 4.3: jq está disponible ───
if command -v jq >/dev/null 2>&1; then
    pass "jq está disponible en PATH"
else
    fail "jq NO está disponible en PATH (requerido para parsear hyprctl JSON)"
fi

# ─── Test 4.4: fzf está disponible ───
if command -v fzf >/dev/null 2>&1; then
    pass "fzf está disponible en PATH"
else
    fail "fzf NO está disponible en PATH (requerido para el menú TUI)"
fi

# ─── Test 4.5: kanshi está disponible ───
if command -v kanshi >/dev/null 2>&1; then
    pass "kanshi está disponible en PATH"
else
    fail "kanshi NO está disponible en PATH (requerido para perfiles automáticos — ejecutar uhm)"
fi

# ─── Test 4.6: alacritty está disponible ───
if command -v alacritty >/dev/null 2>&1; then
    pass "alacritty está disponible en PATH"
else
    fail "alacritty NO está disponible en PATH (requerido como terminal Omarchy)"
fi

# ─── Test 4.7: notify-send está disponible ───
if command -v notify-send >/dev/null 2>&1; then
    pass "notify-send está disponible en PATH"
else
    fail "notify-send NO está disponible en PATH (requerido para notificaciones dunst)"
fi

# ─── Test 4.8: HYPRLAND_INSTANCE_SIGNATURE está definido (sesión Hyprland activa) ───
if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
    pass "HYPRLAND_INSTANCE_SIGNATURE está definido (sesión Hyprland activa)"
else
    skip "HYPRLAND_INSTANCE_SIGNATURE no definido (no estamos en sesión Hyprland)"
fi

# ─── Test 4.9: El script monitor_menu.sh existe y es ejecutable ───
SCRIPT_PATH="$PROJECT_ROOT/scripts/monitor_menu.sh"
if [[ -f "$SCRIPT_PATH" ]] && [[ -x "$SCRIPT_PATH" ]]; then
    pass "scripts/monitor_menu.sh existe y es ejecutable"
else
    fail "scripts/monitor_menu.sh no existe o no es ejecutable"
fi

# ─── Test 4.10: kanshi/config existe y no está vacío ───
KANSHI_CONFIG="$PROJECT_ROOT/kanshi/config"
if [[ -f "$KANSHI_CONFIG" ]] && [[ -s "$KANSHI_CONFIG" ]]; then
    pass "kanshi/config existe y no está vacío"
else
    fail "kanshi/config no existe o está vacío"
fi

# ─── Resumen ───
printf '\n──────────────────────────────────────────────────────\n'
printf "  Resultados: \033[32m${PASS_COUNT} pasaron\033[0m | \033[31m${FAIL_COUNT} fallaron\033[0m | \033[33m${SKIP_COUNT} omitidos\033[0m\n"
printf '──────────────────────────────────────────────────────\n\n'

if [[ "$FAIL_COUNT" -gt 0 ]]; then
    exit 1
fi
exit 0
