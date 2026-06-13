-- Todos los keybinds
-- Usa hl.bind() con hl.dsp.exec_cmd() y rutas absolutas

local m = _G.hypr

-- ============================
-- Aplicaciones básicas
-- ============================
hl.bind(m.mainMod .. " + F",        hl.dsp.exec_cmd(m.filemanager))
hl.bind(m.altMod .. " + SPACE",     hl.dsp.exec_cmd("hyprlauncher --dmenu"))
hl.bind(m.altMod .. " + I",         hl.dsp.exec_cmd("/home/alejandrocabeza/.dotfiles/scripts/handy_voice_setup.sh normal"))
hl.bind(m.altMod .. " + SHIFT + I", hl.dsp.exec_cmd("/home/alejandrocabeza/.dotfiles/scripts/handy_voice_setup.sh ai"))
hl.bind(m.mainMod .. " + RETURN",   hl.dsp.exec_cmd(m.terminal))
hl.bind(m.mainMod .. " + SHIFT + Q", hl.dsp.exit())
hl.bind(m.mainMod .. " + W",        hl.dsp.window.close())
hl.bind(m.mainMod .. " + SHIFT + M", hl.dsp.window.float({ action = "toggle" }))
hl.bind(m.mainMod .. " + M",        hl.dsp.window.fullscreen({ action = "toggle" }))

-- ============================
-- Movimiento de foco (Vim)
-- ============================
hl.bind(m.mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(m.mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(m.mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(m.mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- ============================
-- Workspaces (1-4)
-- ============================
for i = 1, 4 do
    hl.bind(m.mainMod .. " + " .. i,             hl.dsp.focus({ workspace = i }))
    hl.bind(m.mainMod .. " + SHIFT + " .. i,     hl.dsp.window.move({ workspace = i }))
end

-- ============================
-- Redimensionar ventanas
-- ============================
hl.bind(m.mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }))
hl.bind(m.mainMod .. " + SHIFT + left",  hl.dsp.window.resize({ x = -10, y = 0, relative = true }))
hl.bind(m.mainMod .. " + SHIFT + up",    hl.dsp.window.resize({ x = 0, y = -10, relative = true }))
hl.bind(m.mainMod .. " + SHIFT + down",  hl.dsp.window.resize({ x = 0, y = 10, relative = true }))

-- ============================
-- Mouse binds
-- ============================
hl.bind(m.mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(m.mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ============================
-- WiFi, Bluetooth, Notificaciones
-- ============================
hl.bind(m.mainMod .. " + N", hl.dsp.exec_cmd("/home/alejandrocabeza/.dotfiles/scripts/wifi_menu.sh"))
hl.bind(m.mainMod .. " + B", hl.dsp.exec_cmd("/home/alejandrocabeza/.dotfiles/scripts/bluetooth_menu.sh"))
hl.bind(m.mainMod .. " + P", hl.dsp.exec_cmd("/home/alejandrocabeza/.dotfiles/scripts/wallpaper_picker.sh"))
hl.bind("Print",             hl.dsp.exec_cmd("dunstctl history-pop"),     { locked = true })
hl.bind("Scroll_Lock",       hl.dsp.exec_cmd("dunstctl close"),           { locked = true })
hl.bind(m.mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("dunstctl history"))

-- ============================
-- Screenshots
-- ============================
hl.bind(m.mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("/home/alejandrocabeza/.dotfiles/scripts/screenshot.sh"))

-- ============================
-- Screen recording & OCR
-- ============================
hl.bind(m.mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("/home/alejandrocabeza/.dotfiles/scripts/screenrecord.sh"))
hl.bind(m.mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("/home/alejandrocabeza/.dotfiles/scripts/text_extraction.sh"))

-- ============================
-- Audio & Ventanas
-- ============================
hl.bind(m.mainMod .. " + SHIFT + A", hl.dsp.exec_cmd("/home/alejandrocabeza/.dotfiles/scripts/audio_output_switch.sh"))
hl.bind(m.mainMod .. " + ALT + G",   hl.dsp.exec_cmd("/home/alejandrocabeza/.dotfiles/scripts/gaps_toggle.sh"))
hl.bind(m.mainMod .. " + ALT + W",   hl.dsp.exec_cmd("/home/alejandrocabeza/.dotfiles/scripts/close_all_windows.sh"))

-- ============================
-- Multimedia (Audio)
-- ============================
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind(m.mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("/home/alejandrocabeza/.dotfiles/scripts/mic_toggle.sh"))

-- ============================
-- Brillo de pantalla
-- ============================
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })

-- ============================
-- Mover ventanas (estilo Vim)
-- ============================
hl.bind(m.mainMod .. " + SHIFT + H", hl.dsp.window.swap({ direction = "left" }))
hl.bind(m.mainMod .. " + SHIFT + L", hl.dsp.window.swap({ direction = "right" }))
hl.bind(m.mainMod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "up" }))
hl.bind(m.mainMod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "down" }))

-- ============================
-- Sistema y Sesión
-- ============================
hl.bind(m.mainMod .. " + Escape",    hl.dsp.exec_cmd("sudo /home/alejandrocabeza/.dotfiles/scripts/sysmenu.sh"))
hl.bind(m.mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))

-- ============================
-- Atajos adicionales
-- ============================
hl.bind(m.mainMod .. " + slash",    hl.dsp.exec_cmd("/home/alejandrocabeza/.dotfiles/scripts/keybinds_menu.sh"))
hl.bind(m.mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("/home/alejandrocabeza/.dotfiles/scripts/package_manager.sh"))
hl.bind(m.mainMod .. " + C",         hl.dsp.exec_cmd("/home/alejandrocabeza/.dotfiles/scripts/voice_control.sh start"))
hl.bind(m.mainMod .. " + C",         hl.dsp.exec_cmd("/home/alejandrocabeza/.dotfiles/scripts/voice_control.sh stop"), { release = true })

-- ============================
-- Scratchpad
-- ============================
hl.bind(m.mainMod .. " + SHIFT + minus", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(m.mainMod .. " + minus",         hl.dsp.workspace.toggle_special("magic"))

-- ============================
-- Navegación rápida entre workspaces
-- ============================
hl.bind(m.mainMod .. " + bracketright",    hl.dsp.focus({ workspace = "e+1" }))
hl.bind(m.mainMod .. " + bracketleft",     hl.dsp.focus({ workspace = "e-1" }))
hl.bind(m.mainMod .. " + SHIFT + bracketright", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind(m.mainMod .. " + SHIFT + bracketleft",  hl.dsp.window.move({ workspace = "r-1" }))

-- ============================
-- Lock de pantalla (requiere hyprlock)
-- ============================
hl.bind(m.mainMod .. " + SHIFT + Escape",  hl.dsp.exec_cmd("hyprlock"))

-- ============================
-- Grupos de ventanas (tabs)
-- ============================
hl.bind(m.mainMod .. " + G",              hl.dsp.group.toggle())
hl.bind(m.mainMod .. " + SHIFT + G",      hl.dsp.group.lock({ action = "toggle" }))
hl.bind(m.mainMod .. " + TAB",            hl.dsp.group.next())
hl.bind(m.mainMod .. " + SHIFT + TAB",    hl.dsp.group.prev())

-- ============================
-- Modo no molestar (dunst)
-- ============================
hl.bind(m.mainMod .. " + SHIFT + D",      hl.dsp.exec_cmd("dunstctl set-paused toggle"))

-- ============================
-- Temas (theme switcher)
-- ============================
hl.bind(m.mainMod .. " + ALT + T", hl.dsp.exec_cmd("/home/alejandrocabeza/.dotfiles/scripts/theme_toggle.sh"))
hl.bind(m.mainMod .. " + ALT + S", hl.dsp.exec_cmd("/home/alejandrocabeza/.dotfiles/scripts/theme_switch.sh"))
