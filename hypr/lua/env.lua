-- Variables de entorno para Wayland
-- Este módulo debe cargarse PRIMERO

hl.config({
    env = {
        XCURSOR_SIZE = "24",
        XCURSOR_THEME = "Bibata-Modern-Classic",
        GDK_BACKEND = "wayland,x11",
        QT_QPA_PLATFORM = "wayland;xcb",
        QT_QPA_PLATFORMTHEME = "qt5ct",
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1",
        MOZ_ENABLE_WAYLAND = "1",
        SDL_VIDEODRIVER = "wayland",
        _JAVA_AWT_WM_NONREPARENTING = "1",
        CLUTTER_BACKEND = "wayland",
        ELECTRON_OZONE_PLATFORM_HINT = "wayland",
    },
})
