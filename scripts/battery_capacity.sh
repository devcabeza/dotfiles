#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.nix-profile/bin:$PATH"

battery_info=$(upower -i "$(upower -e | grep BAT)")

echo "$battery_info" | awk '/energy-full:/ {
    printf "%d", $2
    exit
}'
