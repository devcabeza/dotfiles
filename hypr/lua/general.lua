-- Configuración general (gaps, bordes, layout)

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 10,
        border_size = 2,
        col = {
            active_border   = "rgba(7daea3ff)",
            inactive_border = "rgba(504945aa)",
        },
        allow_tearing = false,
        resize_on_border = false,
        layout = "dwindle",
    },
    dwindle = {
        preserve_split = true,
        force_split = 2,
    },
})
