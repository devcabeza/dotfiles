#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Test 1: Validación de sintaxis de monitor_menu.sh
# ============================================================
# Verifica que el script existe, tiene sintaxis bash válida,
# y contiene las dependencias y constantes requeridas.
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SCRIPT_PATH="$PROJECT_ROOT/scripts/monitor_menu.sh"

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
printf '║  Test 1: Validación de sintaxis — monitor_menu.sh   ║\n'
printf '╚══════════════════════════════════════════════════════╝\n\n'

# ─── Test 1.1: El archivo existe ───
if [[ -f "$SCRIPT_PATH" ]]; then
    pass "scripts/monitor_menu.sh existe"
else
    fail "scripts/monitor_menu.sh NO existe (ruta esperada: $SCRIPT_PATH)"
fi

# ─── Test 1.2: Sintaxis bash válida (bash -n) ───
if [[ -f "$SCRIPT_PATH" ]]; then
    if bash -n "$SCRIPT_PATH" 2>/dev/null; then
        pass "bash -n scripts/monitor_menu.sh — sintaxis válida"
    else
        fail "bash -n scripts/monitor_menu.sh — errores de sintaxis detectados"
    fi
else
    fail "bash -n scripts/monitor_menu.sh — no se puede verificar (archivo no existe)"
fi

# ─── Test 1.3: Contiene APP_ID="org.omarchy.monitor-menu" ───
if [[ -f "$SCRIPT_PATH" ]]; then
    if grep -q 'APP_ID="org.omarchy.monitor-menu"' "$SCRIPT_PATH"; then
        pass 'Contiene APP_ID="org.omarchy.monitor-menu"'
    else
        fail 'No contiene APP_ID="org.omarchy.monitor-menu"'
    fi
else
    fail 'No se puede verificar APP_ID (archivo no existe)'
fi

# ─── Test 1.4: Usa hyprctl ───
if [[ -f "$SCRIPT_PATH" ]]; then
    if grep -q 'hyprctl' "$SCRIPT_PATH"; then
        pass "Contiene uso de hyprctl"
    else
        fail "No contiene uso de hyprctl"
    fi
else
    fail "No se puede verificar hyprctl (archivo no existe)"
fi

# ─── Test 1.5: Usa fzf ───
if [[ -f "$SCRIPT_PATH" ]]; then
    if grep -q 'fzf' "$SCRIPT_PATH"; then
        pass "Contiene uso de fzf"
    else
        fail "No contiene uso de fzf"
    fi
else
    fail "No se puede verificar fzf (archivo no existe)"
fi

# ─── Test 1.6: El script es ejecutable ───
if [[ -f "$SCRIPT_PATH" ]]; then
    if [[ -x "$SCRIPT_PATH" ]]; then
        pass "scripts/monitor_menu.sh tiene permisos de ejecución"
    else
        fail "scripts/monitor_menu.sh NO tiene permisos de ejecución (se requiere chmod +x)"
    fi
else
    fail "No se puede verificar permisos (archivo no existe)"
fi

# ─── Test 1.7: Usa jq para parsear JSON de hyprctl ───
if [[ -f "$SCRIPT_PATH" ]]; then
    if grep -q 'jq' "$SCRIPT_PATH"; then
        pass "Contiene uso de jq (parseo JSON de hyprctl)"
    else
        fail "No contiene uso de jq"
    fi
else
    fail "No se puede verificar jq (archivo no existe)"
fi

# ─── Test 1.8: Usa notify-send para notificaciones dunst ───
if [[ -f "$SCRIPT_PATH" ]]; then
    if grep -q 'notify-send' "$SCRIPT_PATH"; then
        pass "Contiene uso de notify-send (notificaciones dunst)"
    else
        fail "No contiene uso de notify-send"
    fi
else
    fail "No se puede verificar notify-send (archivo no existe)"
fi

# ─── Resumen ───
printf '\n──────────────────────────────────────────────────────\n'
printf "  Resultados: \033[32m${PASS_COUNT} pasaron\033[0m | \033[31m${FAIL_COUNT} fallaron\033[0m\n"
printf '──────────────────────────────────────────────────────\n\n'

if [[ "$FAIL_COUNT" -gt 0 ]]; then
    exit 1
fi
exit 0
