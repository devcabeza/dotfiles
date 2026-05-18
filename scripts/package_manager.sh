#!/bin/bash
# Script simple para buscar paquetes con fzf (ejemplo)

QUERY=$(echo "" | wofi --dmenu --prompt "Buscar paquete en Nix")
if [ -n "$QUERY" ]; then
    nix search nixpkgs "$QUERY" | wofi --dmenu --prompt "Resultados"
fi
