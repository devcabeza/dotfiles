-- Reglas de ventanas flotantes para WiFi y Bluetooth
-- Usa hl.window_rule() como Omarchy (NO hl.config con windowrulev2)

hl.window_rule({
    match = { class = "^org\\.omarchy\\.wifi$" },
    float = true,
    size = { 700, 450 },
    center = true,
})

hl.window_rule({
    match = { class = "^org\\.omarchy\\.bluetui$" },
    float = true,
    size = { 700, 450 },
    center = true,
})

hl.window_rule({
    match = { class = "^org\\.omarchy\\.package-manager$" },
    float = true,
    size = { 900, 600 },
    center = true,
})

hl.window_rule({
    match = { class = "^org\\.omarchy\\.keybinds-menu$" },
    float = true,
    size = { 700, 500 },
    center = true,
})

hl.window_rule({
    match = { class = "^org\\.omarchy\\.screenshot$" },
    float = true,
    size = { 700, 450 },
    center = true,
})

hl.window_rule({
    match = { class = "^org\\.omarchy\\.wallpaper-picker$" },
    float = true,
    size = { 800, 600 },
    center = true,
})

hl.window_rule({
    match = { class = "^org\\.omarchy\\.btop$" },
    float = true,
    size = { 900, 600 },
    center = true,
})

hl.window_rule({
    match = { class = "^org\\.omarchy\\.sysmenu$" },
    float = true,
    size = { 350, 220 },
    center = true,
})