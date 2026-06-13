#!/usr/bin/env bash
set -euo pipefail

# Print the detected touchpad or trackpad device name (estilo Omarchy)

export PATH="$HOME/.nix-profile/bin:$PATH"

device=$(hyprctl devices -j | jq -r '[.mice[] | .name | select(test("touchpad|trackpad"; "i"))] | first // empty')
[[ -n $device ]] && echo "$device"
