#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Test 5: Cumplimiento de home-manager/home.nix
# ============================================================
# Verifica que home.nix contiene el paquete kanshi
# y linkea kanshi/config bajo home.file.
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
HOME_NIX="$PROJECT_ROOT/home-manager/home.nix"

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
printf '║  Test 5: home-manager/home.nix                       ║\n'
printf '╚══════════════════════════════════════════════════════╝\n\n'

# ─── Test 5.1: home.nix existe ───
if [[ -f "$HOME_NIX" ]]; then
    pass "home-manager/home.nix existe"
else
    fail "home-manager/home.nix NO existe (ruta: $HOME_NIX)"
fi

# ─── Test 5.2: home.nix contiene pkgs.kanshi ───
if [[ -f "$HOME_NIX" ]]; then
    if grep -q 'pkgs\.kanshi' "$HOME_NIX"; then
        pass "home.nix contiene pkgs.kanshi en home.packages"
    else
        fail "home.nix NO contiene pkgs.kanshi en home.packages"
    fi
else
    fail "No se puede verificar pkgs.kanshi (archivo no existe)"
fi

# ─── Test 5.3: home.nix linkea kanshi/config ───
if [[ -f "$HOME_NIX" ]]; then
    if grep -q 'kanshi/config' "$HOME_NIX"; then
        pass "home.nix contiene referencia a kanshi/config"
    else
        fail "home.nix NO contiene referencia a kanshi/config en home.file"
    fi
else
    fail "No se puede verificar link kanshi/config (archivo no existe)"
fi

# ─── Test 5.4: El link apunta a .config/kanshi/config ───
if [[ -f "$HOME_NIX" ]]; then
    if grep -q '\.config/kanshi/config' "$HOME_NIX"; then
        pass "home.nix linkea kanshi/config a ~/.config/kanshi/config"
    else
        fail "home.nix NO linkea a ~/.config/kanshi/config (ruta destino incorrecta)"
    fi
else
    fail "No se puede verificar ruta destino (archivo no existe)"
fi

# ─── Test 5.5: El link usa .source = ../kanshi/config ───
if [[ -f "$HOME_NIX" ]]; then
    if grep -q '\.\./kanshi/config' "$HOME_NIX"; then
        pass "home.nix usa source = ../kanshi/config (ruta relativa correcta)"
    else
        fail "home.nix NO usa ../kanshi/config como source (ruta relativa incorrecta)"
    fi
else
    fail "No se puede verificar source (archivo no existe)"
fi

# ─── Test 5.6: kanshi está en la sección Hyprland ecosystem (contexto correcto) ───
if [[ -f "$HOME_NIX" ]]; then
    # Verificar que kanshi está cerca de otros paquetes Hyprland
    if grep -B5 'pkgs\.kanshi' "$HOME_NIX" | grep -q 'hyprlock\|hypridle\|hyprpicker\|swappy\|cliphist'; then
        pass "pkgs.kanshi está en la sección Hyprland ecosystem (contexto correcto)"
    else
        fail "pkgs.kanshi NO está cerca de otros paquetes Hyprland (podría estar en sección incorrecta)"
    fi
else
    fail "No se puede verificar contexto (archivo no existe)"
fi

# ─── Test 5.7: El link de kanshi está dentro del bloque home.file ───
if [[ -f "$HOME_NIX" ]]; then
    # Verificar que la línea de kanshi/config está entre home.file = { y el }; de cierre
    # Estrategia: verificar que existe la línea y que home.file existe
    if grep -q 'home\.file' "$HOME_NIX" && grep -q 'kanshi/config.*source' "$HOME_NIX"; then
        pass "kanshi/config source está definido dentro de home.file"
    else
        fail "kanshi/config source NO está correctamente definido en home.file"
    fi
else
    fail "No se puede verificar home.file (archivo no existe)"
fi

# ─── Test 5.8: kanshi/config source no tiene errores de sintaxis Nix ───
if [[ -f "$HOME_NIX" ]]; then
    # Verificación básica: la línea debe terminar con ;
    kanshi_line=$(grep 'kanshi/config.*source' "$HOME_NIX" || true)
    if [[ -n "$kanshi_line" ]] && [[ "$kanshi_line" == *";"* ]]; then
        pass "Línea de kanshi/config en home.nix termina con ; (sintaxis Nix básica)"
    else
        fail "Línea de kanshi/config en home.nix NO termina con ; (posible error de sintaxis Nix)"
    fi
else
    fail "No se puede verificar sintaxis Nix (archivo no existe)"
fi

# ─── Resumen ───
printf '\n──────────────────────────────────────────────────────\n'
printf "  Resultados: \033[32m${PASS_COUNT} pasaron\033[0m | \033[31m${FAIL_COUNT} fallaron\033[0m\n"
printf '──────────────────────────────────────────────────────\n\n'

if [[ "$FAIL_COUNT" -gt 0 ]]; then
    exit 1
fi
exit 0
