#!/usr/bin/env bash
set -euo pipefail

# Cambiar entre salidas de audio (estilo Omarchy)
# Alterna entre dispositivos de audio disponibles preservando el volumen y mute

# Ensure Nix profile is in PATH
export PATH="$HOME/.nix-profile/bin:$PATH"

APP_ID="org.omarchy.audio-output"

# Obtener sinks (salidas de audio) disponibles
sinks=$(pactl -f json list sinks | jq '[.[] | select((.ports | length == 0) or ([.ports[]? | .availability != "not available"] | any))]')
sinks_count=$(echo "$sinks" | jq '. | length')

if (( sinks_count == 0 )); then
  notify-send "Audio" "No se encontraron dispositivos de audio" -u normal
  exit 1
fi

current_sink_name=$(pactl get-default-sink)
current_sink_index=$(echo "$sinks" | jq -r --arg name "$current_sink_name" 'map(.name) | index($name)')

if [[ $current_sink_index != "null" ]]; then
  next_sink_index=$(((current_sink_index + 1) % sinks_count))
else
  next_sink_index=0
fi

next_sink=$(echo "$sinks" | jq -r ".[$next_sink_index]")
next_sink_name=$(echo "$next_sink" | jq -r '.name')
next_sink_description=$(echo "$next_sink" | jq -r '.description')

# Si no hay descripción, intentar obtenerla de wpctl
if [[ $next_sink_description == "null" ]] || [[ -z $next_sink_description ]]; then
  next_sink_description=$(wpctl status | grep -E "$next_sink_name" | head -1 | sed -E 's/^.*[0-9]+\.\s+//' | sed -E 's/\s+\[.*$//')
fi

next_sink_wpid=$(echo "$next_sink" | jq -r '.properties."object.id"')
wpctl set-default "$next_sink_wpid"

# Notificar
notify-send "Audio" "Salida cambiada a: $next_sink_description" -u low
