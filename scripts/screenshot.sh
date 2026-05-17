#!/usr/bin/env bash
export PATH="$HOME/.nix-profile/bin:$PATH"
grim -g "$(slurp)" - | wl-copy
