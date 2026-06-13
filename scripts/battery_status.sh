#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.nix-profile/bin:$PATH"

battery_info=$(upower -i "$(upower -e | grep BAT)")

percentage=$(echo "$battery_info" | awk '/percentage/ {
    print int($2)
    exit
}')

power_rate=$(echo "$battery_info" | awk '/energy-rate/ {
    rounded = sprintf("%.1f", $2)
    sub(/\.0$/, "", rounded)
    print rounded
    exit
}')

state=$(echo "$battery_info" | awk '/state/ { print $2; exit }')
time_remaining=$(/home/alejandrocabeza/.dotfiles/scripts/battery_remaining_time.sh)
capacity=$(/home/alejandrocabeza/.dotfiles/scripts/battery_capacity.sh)

if [[ $state == "charging" ]]; then
    echo "Battery ${percentage}%  ·  ${time_remaining} to full  ·  +${power_rate}W / ${capacity}Wh"
else
    echo "Battery ${percentage}%  ·  ${time_remaining} left  ·  -${power_rate}W / ${capacity}Wh"
fi
