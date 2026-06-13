-- Decoraciones: redondeo, blur, sombras, opacidad
-- Paleta Gruvbox Material

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

        drop_shadow = true,
        shadow_range = 4,
        shadow_render_power = 3,
        shadow_offset = { 3, 3 },
        ["col.shadow"] = "rgba(1a1a1aee)",
        shadow_ignore_window = true,
    },
})
