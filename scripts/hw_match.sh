#!/usr/bin/env bash
set -euo pipefail

# Match against the computer's DMI product name or family (estilo Omarchy)
# Uso: hw_match.sh "Framework" && echo "Es un Framework"

grep -qi "$1" /sys/class/dmi/id/product_name 2>/dev/null ||
grep -qi "$1" /sys/class/dmi/id/product_family 2>/dev/null
