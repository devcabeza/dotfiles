-- Configuración de entrada (teclado, mouse, touchpad)

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "altgr-intl",
        kb_options = "compose:menu,terminate:ctrl_alt_bksp",
        follow_mouse = 1,
        sensitivity = 0,
        repeat_rate = 40,
        repeat_delay = 250,
        numlock_by_default = true,
        touchpad = {
            natural_scroll = false,
            clickfinger_behavior = true,
            scroll_factor = 0.4,
        },
    },
})
