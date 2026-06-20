-- Reglas de ventanas (Omarchy-style)

-- Suprimir eventos de maximizar
hl.window_rule({
    name  = "suppress-maximize",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix XWayland arrastrar
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- Opacidad por defecto (0.97 activa, 0.90 inactiva)
-- Nota: si no soporta 'tag', comentar
-- hl.window_rule({
--     name  = "default-opacity",
--     match = { class = ".*" },
--     opacity = "0.97 0.9",
-- })

-- Hyprland-run flotante
hl.window_rule({
    name  = "hyprland-run-float",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})
