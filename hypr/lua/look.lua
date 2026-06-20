-- Apariencia: bordes, sombras, blur, animaciones (estilo Omarchy)
-- Referencia: https://github.com/basecamp/omarchy

local active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 }
local inactive_border = "rgba(595959aa)"

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 10,
        border_size = 2,
        col = {
            active_border   = active_border,
            inactive_border = inactive_border,
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding = 8,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 2,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        blur = {
            enabled    = true,
            size       = 2,
            passes     = 2,
            special    = true,
            brightness = 0.60,
            contrast   = 0.75,
        },
    },

    group = {
        col = {
            border_active   = active_border,
            border_inactive = inactive_border,
        },
        groupbar = {
            font_size   = 12,
            font_family = "monospace",
            font_weight_active   = "ultraheavy",
            font_weight_inactive = "normal",
            indicator_height     = 0,
            indicator_gap        = 5,
            height               = 22,
            gaps_in              = 5,
            gaps_out             = 0,
            text_color           = "rgb(ffffff)",
            text_color_inactive  = "rgba(ffffff90)",
            col = {
                active   = "rgba(00000040)",
                inactive = "rgba(00000020)",
            },
            gradients        = true,
            gradient_rounding = 0,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Curvas
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

-- Animaciones
hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 3.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = false, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3, bezier = "easeOutQuint", style = "slidevert" })

-- Dwindle layout
hl.config({
    dwindle = {
        preserve_split = true,
        force_split = 2,
    },
})

-- Master layout
hl.config({
    master = {
        new_status = "master",
    },
})

-- Scrolling layout backup
hl.config({
    scrolling = {
        column_width = 0.49,
    },
})
