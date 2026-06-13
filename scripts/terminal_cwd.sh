#!/usr/bin/env bash
set -euo pipefail

# Print the current working directory of the active terminal window (estilo Omarchy)
# Útil para lanzar nuevas terminales en el mismo directorio

export PATH="$HOME/.nix-profile/bin:$PATH"

terminal_pid=$(hyprctl activewindow | awk '/pid:/ {print $2}')

if [[ -z $terminal_pid ]]; then
  echo "$HOME"
  exit 0
fi

# Obtener el proceso shell hijo del terminal
shell_pid=$(pgrep -P "$terminal_pid" | tail -n1)

if [[ -n $shell_pid ]]; then
  cwd=$(readlink -f "/proc/$shell_pid/cwd" 2>/dev/null)

  if [[ -d $cwd ]]; then
    echo "$cwd"
  else
    echo "$HOME"
  fi
else
  echo "$HOME"
fi
