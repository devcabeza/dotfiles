-- Configuración principal de Hyprland (formato Lua)
-- Entry point que carga los módulos en orden

local modules = {
    "lua.variables",
    "lua.monitors",
    "lua.input",
    "lua.general",
    "lua.animations",
    "lua.autostart",
    "lua.binds",
}

for _, module in ipairs(modules) do
    local ok, err = pcall(require, module)
    if not ok then
        print("[Hyprland] Error cargando " .. module .. ": " .. err)
    end
end
