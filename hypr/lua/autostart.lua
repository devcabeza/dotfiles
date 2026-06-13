-- Autostart
-- Scripts y servicios que inician con Hyprland

hl.on("hyprland.start", function()
    -- D-Bus environment setup (must run first before other services)
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    
    -- Launcher daemon (start silently, no window)
    hl.exec_cmd("/home/alejandrocabeza/.nix-profile/bin/hyprlauncher -d")
    
    local nix_bin = "/home/alejandrocabeza/.nix-profile/bin/"
    hl.exec_cmd(nix_bin .. "swaybg -i /home/alejandrocabeza/.dotfiles/wallpapers/$(ls /home/alejandrocabeza/.dotfiles/wallpapers/ | head -1) -m fill")
    hl.exec_cmd("/home/alejandrocabeza/.dotfiles/scripts/wallpaper_carousel.sh")
    hl.exec_cmd("waybar --config /home/alejandrocabeza/.dotfiles/waybar/config.jsonc --style /home/alejandrocabeza/.dotfiles/waybar/styles.css")
    hl.exec_cmd("env PATH=/home/alejandrocabeza/.nix-profile/bin:$PATH handy --start-hidden")
    hl.exec_cmd(nix_bin .. "dunst")
    
    -- Agente de autenticación Polkit (Requerido para conectar WiFi y Bluetooth)
    hl.exec_cmd("/usr/lib/hyprpolkitagent")
    
    -- hl.exec_cmd(nix_bin .. "blueman-applet")
    -- hl.exec_cmd(nix_bin .. "nm-applet")
end)
