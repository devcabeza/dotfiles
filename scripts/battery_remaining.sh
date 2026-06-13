#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.nix-profile/bin:$PATH"

upower -i "$(upower -e | grep BAT)" | awk '/percentage/ {
    print int($2)
    exit
}'
