-- Auto-arranque de servicios (Omarchy-style)
hl.config({
    ["exec-once"] = {
        "waybar",
        "mako",
        "/home/alejandrocabeza/.dotfiles/scripts/swww-random.sh",
        "hypridle",
        "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1",
        "systemctl --user import-environment",
        "dbus-update-activation-environment --systemd --all",
    },
})
