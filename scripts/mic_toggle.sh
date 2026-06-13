#!/usr/bin/env bash
set -euo pipefail

# Toggle mute del micrófono (estilo Omarchy)
# Notifica con dunst el estado actual

export PATH="$HOME/.nix-profile/bin:$PATH"

wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle >/dev/null

if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | rg -q 'MUTED'; then
  notify-send "Micrófono" "Silenciado" -u low -i microphone-sensitivity-muted
else
  notify-send "Micrófono" "Activado" -u low -i audio-input-microphone
fi
