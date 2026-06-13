-- Configuración miscelánea (VFR, VRR, DPMS, logo, etc.)

hl.config({
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        vfr = true,
        vrr = 0,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
        enable_swallow = false,
        swallow_regex = "",
        force_default_wallpaper = 0,
        no_direct_scanout = false,
        close_special_on_empty = true,
        focus_on_activate = false,
        render_ahead_of_time = false,
        background_color = "rgb(1D2021)",
        new_window_takes_over_fullscreen = 2,
        exit_window_retain_aspect_ratio = false,
        initial_workspace_tracking = 1,
        middle_click_paste = false,
        disable_autoreload = false,
    },
})
