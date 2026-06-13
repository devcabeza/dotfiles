#!/usr/bin/env bash
set -euo pipefail

# Print the monitor scale of the internal monitor or first monitor (estilo Omarchy)

export PATH="$HOME/.nix-profile/bin:$PATH"

hyprctl monitors -j | jq -r '([.[] | select(.name | contains("eDP"))][0] // .[0]).scale // empty | tonumber | if . == floor then floor else . end'
