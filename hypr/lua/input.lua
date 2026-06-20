-- Configuración de entrada (Omarchy-style)
hl.config({
    input = {
        kb_layout     = "us",
        kb_variant    = "",
        kb_model      = "",
        kb_options    = "compose:caps",
        kb_rules      = "",
        repeat_rate   = 40,
        repeat_delay  = 250,
        follow_mouse  = 1,
        numlock_by_default = true,
        sensitivity   = 0,
        touchpad = {
            natural_scroll      = false,
            clickfinger_behavior = true,
            scroll_factor       = 0.4,
            disable_while_typing = true,
        },
    },
})

-- Scroll en terminal
-- Nota: si la API no soporta o.window(), comenta estas líneas
-- hl.window_rule({
--     name  = "scroll-touchpad-alacritty",
--     match = { class = "(Alacritty|kitty|foot)" },
--     scroll_touchpad = 1.5,
-- })

-- Gestos táctiles
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})
