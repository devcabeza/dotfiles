-- Configuración de entrada (teclado, mouse, touchpad)

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "altgr-intl",
        kb_options = "compose:menu,terminate:ctrl_alt_bksp",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = false,
        },
    },
})