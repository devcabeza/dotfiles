#!/usr/bin/env bash
set -euo pipefail

# Ensure Nix and local bin directories are in the PATH
export PATH="/home/alejandrocabeza/.nix-profile/bin:/home/alejandrocabeza/.local/bin:$PATH"

# Wallpaper carousel — rota wallpapers cada 30 min con swaybg

WALLPAPER_DIR="/home/alejandrocabeza/.dotfiles/wallpapers"
CURRENT_LINK="$HOME/.cache/current_wallpaper"

if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Wallpaper directory not found: $WALLPAPER_DIR" >&2
    exit 1
fi

get_wallpapers() {
    find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) 2>/dev/null
}

wallpapers=($(get_wallpapers))
if [ ${#wallpapers[@]} -eq 0 ]; then
    echo "No wallpapers found." >&2
    exit 1
fi

apply_wallpaper() {
    local path="$1"
    pkill -x swaybg 2>/dev/null || true
    sleep 0.2
    setsid swaybg -i "$path" -m fill >/dev/null 2>&1 &
    ln -nsf "$path" "$CURRENT_LINK"
}

pick_random() {
    local current=""
    [ -L "$CURRENT_LINK" ] && current=$(readlink -f "$CURRENT_LINK" 2>/dev/null || true)

    local available=()
    for w in "${wallpapers[@]}"; do
        [ "$w" != "$current" ] && available+=("$w")
    done
    [ ${#available[@]} -eq 0 ] && available=("${wallpapers[@]}")
    printf '%s\n' "${available[@]}" | shuf -n 1
}

# Set initial
apply_wallpaper "$(pick_random)"

# Loop every 30 min
while true; do
    sleep 1800
    apply_wallpaper "$(pick_random)"
done