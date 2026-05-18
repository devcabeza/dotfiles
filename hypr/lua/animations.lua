-- Animaciones

hl.config({
    animations = {
        enabled = true,
    },
})

-- Curva bezier personalizada
hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })

-- Animaciones
hl.animation({ leaf = "windows",    enabled = true, speed = 8,    bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 8,    bezier = "linear", style = "popin 80%" })
hl.animation({ leaf = "border",     enabled = true, speed = 10,   bezier = "linear" })
hl.animation({ leaf = "fade",       enabled = true, speed = 6,    bezier = "linear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6,    bezier = "linear" })