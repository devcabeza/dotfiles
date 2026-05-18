#!/usr/bin/env bash
# Screenshot tool using fzf + grim (omakub/omarchy style)

export PATH="$HOME/.nix-profile/bin:$PATH"

# Menú de opciones
choice=$(echo -e "󰊮 Capture Region\n󰊰 Capture Screen\n󰔟 Cancel" | fzf --height=15 --border=rounded --margin=5% \
    --header='  📸 SCREENSHOT ' --header-border=bottom \
    --color=bg+:#1a1b26,bg:#1a1b26,fg:#a9b1d6,hl:#7aa2f7,fg+:#c0caf5 \
    --color=prompt:#bb9af7,pointer:#7dcfff,marker:#9ece6a,header:#565f89 \
    --highlight-line \
    --pointer='❯' \
    --marker=' ')

case "$choice" in
    "󰊮 Capture Region")
        grim -g "$(slurp)" - | wl-copy
        notify-send "Screenshot" "Region copied to clipboard" -i screen
        ;;
    "󰊰 Capture Screen")
        grim - | wl-copy
        notify-send "Screenshot" "Screen copied to clipboard" -i screen
        ;;
    *)
        exit 0
        ;;
esac
