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

-- ============================
-- Apps comunes que deben flotar
-- ============================
hl.window_rule({
    match = { class = "^pavucontrol$" },
    float = true,
    size = { 800, 600 },
    center = true,
})

hl.window_rule({
    match = { class = "^org\\.gnome\\.Calculator$" },
    float = true,
    size = { 400, 500 },
    center = true,
})

hl.window_rule({
    match = { class = "^org\\.pwmt\\.zathura$" },
    float = true,
    size = { 900, 650 },
    center = true,
})

hl.window_rule({
    match = { class = "^mpv$" },
    float = true,
    center = true,
})

hl.window_rule({
    match = { class = "^imv$" },
    float = true,
    center = true,
})

hl.window_rule({
    match = { class = "^org\\.keepassxc\\.KeePassXC$" },
    float = true,
    size = { 900, 600 },
    center = true,
})

hl.window_rule({
    match = { title = "^Picture-in-Picture$" },
    float = true,
    size = { 480, 270 },
    pin = true,
})

-- ============================
-- Asignaciones a workspaces por clase
-- ============================
hl.window_rule({
    match = { class = "^firefox$", title = "^(?!.*Picture-in-Picture).*$" },
    workspace = 1,
})

hl.window_rule({
    match = { class = "^Alacritty$" },
    workspace = 2,
})

hl.window_rule({
    match = { class = "^code-oss$" },
    workspace = 3,
})

hl.window_rule({
    match = { class = "^Code$" },
    workspace = 3,
})

-- ============================
-- Reglas de sistema (estilo Omarchy)
-- ============================

-- Suprimir maximize event para evitar comportamientos erráticos en apps
hl.window_rule({
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix XWayland: evitar foco en ventanas sin clase/título (ventanas fantasma)
hl.window_rule({
    match = {
        class = "^$",
        title = "^$",
        xwayland = 1,
        floating = 1,
        fullscreen = 0,
        pinned = 0,
    },
    no_focus = true,
})
