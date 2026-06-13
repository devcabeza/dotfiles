-- Configuración miscelánea (VFR, VRR, DPMS, logo, etc.)
-- Basado en la API Lua de Hyprland (wiki.hypr.land)

hl.config({
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        disable_scale_notification = true,
        vrr = 0,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
        enable_swallow = false,
        swallow_regex = "",
        force_default_wallpaper = 0,
        close_special_on_empty = true,
        focus_on_activate = true,
        background_color = "rgb(1D2021)",
        on_focus_under_fullscreen = 1,
        anr_missed_pings = 3,
        exit_window_retains_fullscreen = false,
        initial_workspace_tracking = 1,
        middle_click_paste = false,
        disable_autoreload = false,
    },
})

-- Ocultar scratchpad al cambiar de workspace
hl.config({
    binds = {
        hide_special_on_workspace_change = true,
    },
})
