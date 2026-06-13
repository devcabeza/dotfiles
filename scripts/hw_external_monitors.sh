#!/usr/bin/env bash
set -euo pipefail

# Returns true when an external monitor is physically connected (estilo Omarchy)

for status in /sys/class/drm/card*-*/status; do
  [[ "$status" == *-eDP-*/status ]] && continue
  [[ "$(<"$status")" == "connected" ]] && exit 0
done
exit 1
