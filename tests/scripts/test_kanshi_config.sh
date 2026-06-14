#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Test 3: Validación de configuración de kanshi
# ============================================================
# Verifica que kanshi/config existe, tiene los 3 perfiles
# requeridos, y que autostart.lua inicia el daemon.
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
KANSHI_CONFIG="$PROJECT_ROOT/kanshi/config"
AUTOSTART="$PROJECT_ROOT/hypr/lua/autostart.lua"

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
printf '║  Test 3: Configuración de kanshi                     ║\n'
printf '╚══════════════════════════════════════════════════════╝\n\n'

# ─── Test 3.1: kanshi/config existe ───
if [[ -f "$KANSHI_CONFIG" ]]; then
    pass "kanshi/config existe"
else
    fail "kanshi/config NO existe (ruta esperada: $KANSHI_CONFIG)"
fi

# ─── Test 3.2: Perfil "solo_laptop" existe ───
if [[ -f "$KANSHI_CONFIG" ]]; then
    if grep -q 'profile solo_laptop' "$KANSHI_CONFIG"; then
        pass 'Perfil "solo_laptop" definido en kanshi/config'
    else
        fail 'Perfil "solo_laptop" NO encontrado en kanshi/config'
    fi
else
    fail 'No se puede verificar perfil solo_laptop (archivo no existe)'
fi

# ─── Test 3.3: Perfil "extendido" existe ───
if [[ -f "$KANSHI_CONFIG" ]]; then
    if grep -q 'profile extendido' "$KANSHI_CONFIG"; then
        pass 'Perfil "extendido" definido en kanshi/config'
    else
        fail 'Perfil "extendido" NO encontrado en kanshi/config'
    fi
else
    fail 'No se puede verificar perfil extendido (archivo no existe)'
fi

# ─── Test 3.4: Perfil "solo_externo" existe ───
if [[ -f "$KANSHI_CONFIG" ]]; then
    if grep -q 'profile solo_externo' "$KANSHI_CONFIG"; then
        pass 'Perfil "solo_externo" definido en kanshi/config'
    else
        fail 'Perfil "solo_externo" NO encontrado en kanshi/config'
    fi
else
    fail 'No se puede verificar perfil solo_externo (archivo no existe)'
fi

# ─── Test 3.5: Perfil extendido configura eDP-1 ───
if [[ -f "$KANSHI_CONFIG" ]]; then
    if grep -A5 'profile extendido' "$KANSHI_CONFIG" | grep -q 'output eDP-1 enable'; then
        pass 'Perfil extendido habilita eDP-1'
    else
        fail 'Perfil extendido NO habilita eDP-1'
    fi
else
    fail 'No se puede verificar eDP-1 en extendido (archivo no existe)'
fi

# ─── Test 3.6: Perfil extendido configura HDMI-A-1 ───
if [[ -f "$KANSHI_CONFIG" ]]; then
    if grep -A5 'profile extendido' "$KANSHI_CONFIG" | grep -q 'output HDMI-A-1 enable'; then
        pass 'Perfil extendido habilita HDMI-A-1'
    else
        fail 'Perfil extendido NO habilita HDMI-A-1'
    fi
else
    fail 'No se puede verificar HDMI-A-1 en extendido (archivo no existe)'
fi

# ─── Test 3.7: Perfil solo_externo deshabilita eDP-1 ───
if [[ -f "$KANSHI_CONFIG" ]]; then
    if grep -A5 'profile solo_externo' "$KANSHI_CONFIG" | grep -q 'output eDP-1 disable'; then
        pass 'Perfil solo_externo deshabilita eDP-1'
    else
        fail 'Perfil solo_externo NO deshabilita eDP-1'
    fi
else
    fail 'No se puede verificar eDP-1 disable en solo_externo (archivo no existe)'
fi

# ─── Test 3.8: Perfil solo_laptop habilita eDP-1 ───
if [[ -f "$KANSHI_CONFIG" ]]; then
    if grep -A5 'profile solo_laptop' "$KANSHI_CONFIG" | grep -q 'output eDP-1 enable'; then
        pass 'Perfil solo_laptop habilita eDP-1'
    else
        fail 'Perfil solo_laptop NO habilita eDP-1'
    fi
else
    fail 'No se puede verificar eDP-1 enable en solo_laptop (archivo no existe)'
fi

# ─── Test 3.9: autostart.lua existe ───
if [[ -f "$AUTOSTART" ]]; then
    pass "hypr/lua/autostart.lua existe"
else
    fail "hypr/lua/autostart.lua NO existe (ruta: $AUTOSTART)"
fi

# ─── Test 3.10: autostart.lua inicia kanshi ───
if [[ -f "$AUTOSTART" ]]; then
    if grep -q 'kanshi' "$AUTOSTART"; then
        pass "autostart.lua contiene inicio de kanshi"
    else
        fail "autostart.lua NO contiene inicio de kanshi"
    fi
else
    fail "No se puede verificar kanshi en autostart (archivo no existe)"
fi

# ─── Test 3.11: autostart.lua usa exec_cmd para kanshi ───
if [[ -f "$AUTOSTART" ]]; then
    if grep -q 'exec_cmd.*kanshi' "$AUTOSTART"; then
        pass "autostart.lua usa hl.exec_cmd para iniciar kanshi"
    else
        fail "autostart.lua NO usa hl.exec_cmd para kanshi"
    fi
else
    fail "No se puede verificar exec_cmd kanshi (archivo no existe)"
fi

# ─── Test 3.12: kanshi/config tiene bloques profile válidos (sintaxis básica) ───
if [[ -f "$KANSHI_CONFIG" ]]; then
    # Verificar que cada profile { tiene su cierre }
    open_braces=$(grep -c 'profile.*{' "$KANSHI_CONFIG" || true)
    close_braces=$(grep -c '^}' "$KANSHI_CONFIG" || true)
    if [[ "$open_braces" -eq "$close_braces" ]] && [[ "$open_braces" -ge 3 ]]; then
        pass "kanshi/config tiene $open_braces bloques profile con sintaxis válida"
    else
        fail "kanshi/config tiene $open_braces perfiles pero $close_braces cierres de bloque (esperados: ≥3 iguales)"
    fi
else
    fail "No se puede verificar sintaxis de bloques (archivo no existe)"
fi

# ─── Resumen ───
printf '\n──────────────────────────────────────────────────────\n'
printf "  Resultados: \033[32m${PASS_COUNT} pasaron\033[0m | \033[31m${FAIL_COUNT} fallaron\033[0m\n"
printf '──────────────────────────────────────────────────────\n\n'

if [[ "$FAIL_COUNT" -gt 0 ]]; then
    exit 1
fi
exit 0
