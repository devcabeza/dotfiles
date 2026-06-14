-- Autostart
-- Scripts y servicios que inician con Hyprland

hl.on("hyprland.start", function()
    -- D-Bus environment setup (must run first before other services)
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- Systemd env imports (fix slow app launch)
    hl.exec_cmd("systemctl --user import-environment $(env | cut -d'=' -f 1)")
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")

    -- Launcher daemon (small delay for faster first launch)
    hl.exec_cmd("sleep 2 && /home/alejandrocabeza/.nix-profile/bin/hyprlauncher -d")

    local nix_bin = "/home/alejandrocabeza/.nix-profile/bin/"
    hl.exec_cmd(nix_bin .. "swaybg -i /home/alejandrocabeza/.dotfiles/wallpapers/$(ls /home/alejandrocabeza/.dotfiles/wallpapers/ | head -1) -m fill")
    hl.exec_cmd("/home/alejandrocabeza/.dotfiles/scripts/wallpaper_carousel.sh")
    hl.exec_cmd("waybar --config /home/alejandrocabeza/.dotfiles/waybar/config.jsonc --style /home/alejandrocabeza/.dotfiles/waybar/styles.css")
    hl.exec_cmd("env PATH=/home/alejandrocabeza/.nix-profile/bin:$PATH handy --start-hidden")
    hl.exec_cmd(nix_bin .. "dunst")

    -- Agente de autenticación Polkit (Requerido para conectar WiFi y Bluetooth)
    hl.exec_cmd("/usr/lib/hyprpolkitagent")

    -- Kanshi: perfiles automáticos de monitor (detecta plug/unplug y tapa cerrada)
    hl.exec_cmd(nix_bin .. "kanshi")

    -- hl.exec_cmd(nix_bin .. "blueman-applet")
    -- hl.exec_cmd(nix_bin .. "nm-applet")
end)
