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

-- Groupbar (tabs visuales para ventanas agrupadas)
-- Colores Gruvbox Material
hl.config({
    group = {
        col = {
            border_active = "rgba(7daea3ff)",
            border_inactive = "rgba(504945aa)",
        },
        groupbar = {
            font_size = 10,
            font_family = "monospace",
            height = 20,
            gaps_in = 3,
            gaps_out = 0,
            text_color = "rgba(ddc7a1ff)",
            text_color_inactive = "rgba(ddc7a190)",
            col = {
                active = "rgba(282828ee)",
                inactive = "rgba(28282866)",
            },
            gradients = true,
            indicator_height = 0,
            indicator_gap = 5,
        },
    },
})
