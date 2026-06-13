-- Configuración del cursor
-- Basado en la API Lua de Hyprland (wiki.hypr.land)

hl.config({
    cursor = {
        no_hardware_cursors = 2,
        no_warps = false,
        inactive_timeout = 5,
        hotspot_padding = 2,
        min_refresh_rate = 24,
        sync_gsettings_theme = true,
    },
})
