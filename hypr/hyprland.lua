-- Configuración principal de Hyprland (formato Lua)
-- Entry point que carga los módulos en orden
-- Orden: primero entorno, luego configuración, finalmente acciones

local modules = {
    -- Variables de entorno (DEBE IR PRIMERO)
    "lua.env",
    -- Variables y helpers
    "lua.variables",
    "lua.helpers",
    -- Hardware y pantalla
    "lua.monitors",
    "lua.input",
    -- Apariencia visual
    "lua.general",
    "lua.decorations",
    "lua.animations",
    "lua.cursor",
    -- Gestos y comportamiento
    "lua.gestures",
    "lua.misc",
    -- Render y GPU
    "lua.render",
    "lua.opengl",
    -- Compatibilidad y ecosistema
    "lua.xwayland",
    "lua.ecosystem",
    -- Reglas
    "lua.windowrules",
    "lua.layerrules",
    -- Servicios y binds
    "lua.autostart",
    "lua.binds",
}

for _, module in ipairs(modules) do
    local ok, err = pcall(require, module)
    if not ok then
        print("[Hyprland] Error cargando " .. module .. ": " .. err)
    end
end
