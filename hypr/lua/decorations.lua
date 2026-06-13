-- Decoraciones: redondeo, blur, sombras, opacidad
-- Paleta Gruvbox Material
-- Basado en la API Lua de Hyprland (wiki.hypr.land)

hl.config({
    decoration = {
        rounding = 10,
        active_opacity = 1.0,
        inactive_opacity = 0.92,
        fullscreen_opacity = 1.0,
        dim_inactive = false,
        dim_strength = 0.15,
        dim_special = 0.2,

        blur = {
            enabled = true,
            size = 5,
            passes = 2,
            new_optimizations = true,
            xray = false,
            noise = 0.0117,
            contrast = 0.8916,
            brightness = 0.8172,
            vibrancy = 0.1696,
            vibrancy_darkness = 0.0,
            special = false,
        },

        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            offset = { 3, 3 },
            color = "rgba(1a1a1aee)",
            scale = 1.0,
        },
    },
})
