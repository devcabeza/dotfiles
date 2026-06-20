#!/usr/bin/env bash
# Crea los symlinks para la configuración estilo Omarchy
set -euo pipefail

DOTFILES="/home/alejandrocabeza/.dotfiles"
CONFIG="$HOME/.config"

echo "🔗 Creando symlinks de configuración..."

# hypr (directorio completo)
ln -sfn "$DOTFILES/hypr" "$CONFIG/hypr"
echo "  ✅ $CONFIG/hypr → $DOTFILES/hypr"

# waybar (directorio completo)
ln -sfn "$DOTFILES/waybar" "$CONFIG/waybar"
echo "  ✅ $CONFIG/waybar → $DOTFILES/waybar"

# walker (directorio completo)
ln -sfn "$DOTFILES/walker" "$CONFIG/walker"
echo "  ✅ $CONFIG/walker → $DOTFILES/walker"

# mako (directorio completo)
ln -sfn "$DOTFILES/mako" "$CONFIG/mako"
echo "  ✅ $CONFIG/mako → $DOTFILES/mako"

echo ""
echo "✅ Todos los symlinks creados correctamente."
