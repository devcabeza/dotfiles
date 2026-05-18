-- Autostart
-- Scripts y servicios que inician con Hyprland

hl.on("hyprland.start", function()
    hl.exec_cmd("~/.dotfiles/scripts/wallpaper_carousel.sh")
    hl.exec_cmd("waybar --config /home/alejandrocabeza/.dotfiles/waybar/config.jsonc --style /home/alejandrocabeza/.dotfiles/waybar/styles.css")
    hl.exec_cmd("dunst")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("nm-applet")
end)