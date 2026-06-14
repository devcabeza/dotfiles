#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Test: Validación de configuración de Rofi
# ============================================================
# Verifica que rofi/config.rasi existe, tiene el tema
# gruvbox-material con los colores correctos, que home.nix
# lo linkea, y que qtile tiene el keybind configurado.
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
ROFI_CONFIG="$PROJECT_ROOT/rofi/config.rasi"
ROFI_THEME="$PROJECT_ROOT/rofi/themes/gruvbox-material.rasi"
HOME_NIX="$PROJECT_ROOT/home-manager/home.nix"
QTILE_CONFIG="$PROJECT_ROOT/qtile/config.py"

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
printf '║  Test: Configuración de Rofi                         ║\n'
printf '╚══════════════════════════════════════════════════════╝\n\n'

# ─── Test 1: rofi/config.rasi existe ───
if [[ -f "$ROFI_CONFIG" ]]; then
    pass "rofi/config.rasi existe"
else
    fail "rofi/config.rasi NO existe (ruta esperada: $ROFI_CONFIG)"
fi

# ─── Test 2: rofi/themes/gruvbox-material.rasi existe ───
if [[ -f "$ROFI_THEME" ]]; then
    pass "rofi/themes/gruvbox-material.rasi existe"
else
    fail "rofi/themes/gruvbox-material.rasi NO existe (ruta esperada: $ROFI_THEME)"
fi

# ─── Test 3: config.rasi contiene bloque configuration válido ───
if [[ -f "$ROFI_CONFIG" ]]; then
    if grep -q 'configuration\s*{' "$ROFI_CONFIG"; then
        pass "config.rasi contiene bloque 'configuration { ... }'"
    else
        fail "config.rasi NO contiene bloque 'configuration { ... }'"
    fi
else
    fail "No se puede verificar bloque configuration (archivo no existe)"
fi

# ─── Test 4: El tema contiene color bg (#282828) ───
if [[ -f "$ROFI_THEME" ]]; then
    if grep -q '#282828' "$ROFI_THEME"; then
        pass "Tema contiene color bg #282828"
    else
        fail "Tema NO contiene color bg #282828"
    fi
else
    fail "No se puede verificar color #282828 (archivo no existe)"
fi

# ─── Test 5: El tema contiene color fg (#ddc7a1) ───
if [[ -f "$ROFI_THEME" ]]; then
    if grep -q '#ddc7a1' "$ROFI_THEME"; then
        pass "Tema contiene color fg #ddc7a1"
    else
        fail "Tema NO contiene color fg #ddc7a1"
    fi
else
    fail "No se puede verificar color #ddc7a1 (archivo no existe)"
fi

# ─── Test 6: El tema contiene color accent (#7daea3) ───
if [[ -f "$ROFI_THEME" ]]; then
    if grep -q '#7daea3' "$ROFI_THEME"; then
        pass "Tema contiene color accent #7daea3"
    else
        fail "Tema NO contiene color accent #7daea3"
    fi
else
    fail "No se puede verificar color #7daea3 (archivo no existe)"
fi

# ─── Test 7: El tema contiene color bg-alt (#32302f) ───
if [[ -f "$ROFI_THEME" ]]; then
    if grep -q '#32302f' "$ROFI_THEME"; then
        pass "Tema contiene color bg-alt #32302f"
    else
        fail "Tema NO contiene color bg-alt #32302f"
    fi
else
    fail "No se puede verificar color #32302f (archivo no existe)"
fi

# ─── Test 8: El tema contiene color bg-dark (#1d2021) ───
if [[ -f "$ROFI_THEME" ]]; then
    if grep -q '#1d2021' "$ROFI_THEME"; then
        pass "Tema contiene color bg-dark #1d2021"
    else
        fail "Tema NO contiene color bg-dark #1d2021"
    fi
else
    fail "No se puede verificar color #1d2021 (archivo no existe)"
fi

# ─── Test 9: home.nix contiene link para rofi ───
if [[ -f "$HOME_NIX" ]]; then
    if grep -q '".config/rofi"' "$HOME_NIX"; then
        pass "home.nix contiene link para rofi"
    else
        fail "home.nix NO contiene link para rofi"
    fi
else
    fail "No se puede verificar link de rofi en home.nix (archivo no existe)"
fi

# ─── Test 10: qtile/config.py contiene keybind para rofi con tema gruvbox-material ───
if [[ -f "$QTILE_CONFIG" ]]; then
    if grep -q '\-theme gruvbox-material' "$QTILE_CONFIG"; then
        pass "qtile/config.py contiene keybind para rofi con '-theme gruvbox-material'"
    else
        fail "qtile/config.py NO contiene keybind para rofi con '-theme gruvbox-material'"
    fi
else
    fail "No se puede verificar keybind de rofi en qtile (archivo no existe)"
fi

# ─── Resumen ───
printf '\n──────────────────────────────────────────────────────\n'
printf "  Resultados: \033[32m${PASS_COUNT} pasaron\033[0m | \033[31m${FAIL_COUNT} fallaron\033[0m\n"
printf '──────────────────────────────────────────────────────\n\n'

if [[ "$FAIL_COUNT" -gt 0 ]]; then
    exit 1
fi
exit 0
