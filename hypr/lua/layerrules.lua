-- Reglas para capas (blur en waybar, notificaciones, etc.)

hl.layer_rule({
    match = { namespace = "^waybar$" },
    blur = true,
    blur_popups = true,
    ignorezero = true,
    xray = false,
})

hl.layer_rule({
    match = { namespace = "^notifications$" },
    blur = true,
    ignorezero = true,
})

hl.layer_rule({
    match = { namespace = "^gtk-layer-shell$" },
    blur = true,
    ignorezero = true,
})

-- Sin blur para el launcher para máxima legibilidad
hl.layer_rule({
    match = { namespace = "^launcher$" },
    blur = false,
})
