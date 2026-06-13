-- Reglas para capas (blur en waybar, notificaciones, etc.)
-- Basado en la API Lua de Hyprland (wiki.hypr.land)

hl.layer_rule({
    match = { namespace = "^waybar$" },
    blur = true,
    blur_popups = true,
    ignore_alpha = 0.2,
    xray = false,
})

hl.layer_rule({
    match = { namespace = "^notifications$" },
    blur = true,
    ignore_alpha = 0.2,
})

hl.layer_rule({
    match = { namespace = "^gtk-layer-shell$" },
    blur = true,
    ignore_alpha = 0.2,
})

-- Sin blur para el launcher para máxima legibilidad
hl.layer_rule({
    match = { namespace = "^launcher$" },
    blur = false,
})
