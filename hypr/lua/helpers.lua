-- Shared helpers for Hyprland Lua configuration (estilo Omarchy)

o = o or {}

function o.bind(keys, description, dispatcher, options)
    local opts = options or {}

    if description then
        opts.description = description
    end

    -- If dispatcher is a string, wrap it in hl.dsp.exec_cmd()
    if type(dispatcher) == "string" then
        dispatcher = hl.dsp.exec_cmd(dispatcher)
    end

    hl.bind(keys, dispatcher, opts)
end