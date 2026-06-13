#!/usr/bin/env bash
set -euo pipefail

# Detect whether the computer has an Intel CPU (estilo Omarchy)

[[ $(grep -m1 "vendor_id" /proc/cpuinfo 2>/dev/null | cut -d: -f2 | tr -d ' ') == "GenuineIntel" ]]
