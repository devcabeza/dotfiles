#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# 🚀 Omarchy Dotfiles — Bootstrap & Setup Script
# ============================================================
# Este script instala todo lo necesario para desplegar esta
# configuración en una máquina nueva con Nix + Home Manager.
#
# Uso:
#   ./setup.sh              # Setup completo
#   ./setup.sh --quick      # Solo uhm (si ya tienes Nix+HM)
#   ./setup.sh --help       # Esta ayuda
# ============================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

DOTFILES_DIR="$HOME/.dotfiles"
FLAKE_DIR="$DOTFILES_DIR/home-manager"
FLAKE_NAME="alejandrocabeza"

log()   { echo -e "${GREEN}[✓]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1"; }
info()  { echo -e "${CYAN}[→]${NC} $1"; }
header() { echo -e "\n${CYAN}═══════════════════════════════════════${NC}"; echo -e "${CYAN}  $1${NC}"; echo -e "${CYAN}═══════════════════════════════════════${NC}\n"; }

show_help() {
    cat <<EOF
Uso: ./setup.sh [opciones]

Opciones:
  --quick       Solo ejecuta 'uhm' (home-manager switch)
                Asume que Nix y Home Manager ya están instalados
  --help        Muestra esta ayuda

Sin opciones, realiza el setup completo:
  1. Instala Nix (si no está presente)
  2. Configura Home Manager
  3. Clona/vincula los dotfiles
  4. Ejecuta 'uhm' para desplegar todo
EOF
    exit 0
}

# --- Parse arguments ---
QUICK_MODE=false
for arg in "$@"; do
    case "$arg" in
        --quick) QUICK_MODE=true ;;
        --help)  show_help ;;
        *)       warn "Argumento ignorado: $arg" ;;
    esac
done

# ============================================================
# PREREQUISITES
# ============================================================

check_nix() {
    if command -v nix &>/dev/null; then
        log "Nix ya está instalado: $(nix --version 2>/dev/null || echo 'versión desconocida')"
        return 0
    else
        return 1
    fi
}

install_nix() {
    header "Instalando Nix"
    info "Nix no está instalado. Instalando..."
    sh <(curl -L https://nixos.org/nix/install) --daemon
    log "Nix instalado. Recarga tu terminal o ejecuta: source ~/.nix-profile/etc/profile.d/nix.sh"
}

check_home_manager() {
    if command -v home-manager &>/dev/null; then
        log "Home Manager ya está instalado"
        return 0
    else
        return 1
    fi
}

setup_home_manager() {
    header "Configurando Home Manager"
    
    info "Añadiendo canal nixpkgs-unstable..."
    nix-channel --add https://nixos.org/channels/nixpkgs-unstable
    nix-channel --update
    
    info "Instalando Home Manager..."
    nix-shell '<nixpkgs>' -A home-manager --run "home-manager init"
    log "Home Manager instalado"
}

# ============================================================
# DOTFILES SETUP
# ============================================================

setup_dotfiles() {
    header "Configurando Dotfiles"
    
    if [[ -d $DOTFILES_DIR ]]; then
        log "Dotfiles ya existen en $DOTFILES_DIR"
        
        if [[ -d $DOTFILES_DIR/.git ]]; then
            info "Actualizando repositorio..."
            cd "$DOTFILES_DIR"
            git pull origin main 2>/dev/null || warn "No se pudo hacer pull (red? permisos?)"
            cd "$OLDPWD"
        fi
    else
        info "Clonando dotfiles..."
        git clone https://github.com/alejandrocabeza400-glitch/dotfiles.git "$DOTFILES_DIR"
        log "Dotfiles clonados en $DOTFILES_DIR"
    fi
}

# ============================================================
# UHM (Home Manager Switch)
# ============================================================

run_uhm() {
    header "Desplegando configuración (uhm)"
    
    if [[ ! -f $FLAKE_DIR/home.nix ]]; then
        error "No se encuentra home.nix en $FLAKE_DIR"
        error "Asegúrate de que los dotfiles estén en $DOTFILES_DIR"
        exit 1
    fi
    
    info "Ejecutando: home-manager switch --flake $FLAKE_DIR#$FLAKE_NAME"
    
    cd "$DOTFILES_DIR"
    
    # El alias 'uhm' definido en .bashrc
    home-manager switch -b backup --impure --flake "$FLAKE_DIR#$FLAKE_NAME"
    
    log "Configuración desplegada correctamente"
    log "Es posible que necesites reiniciar sesión para algunos cambios"
}

# ============================================================
# POST-INSTALL NOTES
# ============================================================

show_post_install() {
    header "🎉 Setup completado"
    
    cat <<EOF
${GREEN}Tu configuración Omarchy está lista.${NC}

${CYAN}Atajos principales:${NC}
  SUPER + Return   → Terminal (Alacritty + tmux)
  ALT + Space      → Lanzador (hyprlauncher)
  SUPER + N        → WiFi
  SUPER + B        → Bluetooth
  SUPER + Shift + S → Captura de pantalla
  SUPER + Escape     → Menú de sistema

${CYAN}Importante:${NC}
  • Recarga Hyprland: SUPER + Shift + R
  • Para recargar waybar: killall waybar && waybar &
  • Si algo no funciona, ejecuta: ${YELLOW}uhm${NC}
  
${CYAN}Estructura:${NC}
  ~/.dotfiles/hypr/       → Configuración de Hyprland
  ~/.dotfiles/waybar/     → Barra de estado
  ~/.dotfiles/scripts/    → Scripts útiles
  ~/.dotfiles/home-manager/ → Paquetes Nix

${YELLOW}Nota:${NC} Los scripts de batería (battery_*.sh) necesitan upower.
      Para monitor_watch.sh, necesitas socat:
      → Añadir pkgs.socat a home.nix y ejecutar uhm
EOF
}

# ============================================================
# MAIN
# ============================================================

main() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║     🚀 Omarchy Dotfiles — Setup             ║"
    echo "║     Configuración completa de escritorio     ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"

    if [[ $QUICK_MODE == true ]]; then
        run_uhm
        show_post_install
        exit 0
    fi

    # Paso 1: Nix
    if ! check_nix; then
        install_nix
        warn "Después de instalar Nix, recarga tu terminal y ejecuta: ./setup.sh --quick"
        exit 0
    fi

    # Paso 2: Home Manager
    if ! check_home_manager; then
        setup_home_manager
    fi

    # Paso 3: Dotfiles
    setup_dotfiles

    # Paso 4: Deploy
    run_uhm

    # Paso 5: Post-install
    show_post_install
}

main "$@"
