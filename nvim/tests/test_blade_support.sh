#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "Comprobando que ftplugin/blade.lua existe..."
if [ ! -f "$ROOT_DIR/ftplugin/blade.lua" ]; then
  echo "ERROR: ftplugin/blade.lua no existe"
  exit 1
fi

echo "Comprobando que lua/config/snippets/blade.lua existe..."
if [ ! -f "$ROOT_DIR/lua/config/snippets/blade.lua" ]; then
  echo "ERROR: lua/config/snippets/blade.lua no existe"
  exit 1
fi

echo "Comprobando que treesitter.lua use URL HTTPS para tree-sitter-blade..."
if ! grep -q 'https://github.com/EmranMR/tree-sitter-blade' "$ROOT_DIR/lua/plugins/treesitter.lua"; then
  echo "ERROR: treesitter.lua no contiene la URL HTTPS de tree-sitter-blade"
  exit 1
fi

echo "Comprobando que blink.lua referencie los snippets blade..."
if ! grep -q 'blade' "$ROOT_DIR/lua/plugins/blink.lua"; then
  echo "ERROR: lua/plugins/blink.lua no referencia snippets blade"
  exit 1
fi

echo "Comprobando que blade.lua contenga snippets basicos..."
if ! grep -q '@if' "$ROOT_DIR/lua/config/snippets/blade.lua"; then
  echo "ERROR: lua/config/snippets/blade.lua no contiene @if"
  exit 1
fi
if ! grep -q '@foreach' "$ROOT_DIR/lua/config/snippets/blade.lua"; then
  echo "ERROR: lua/config/snippets/blade.lua no contiene @foreach"
  exit 1
fi
if ! grep -q '@section' "$ROOT_DIR/lua/config/snippets/blade.lua"; then
  echo "ERROR: lua/config/snippets/blade.lua no contiene @section"
  exit 1
fi

echo "OK: Pruebas de soporte Blade PASARON"
