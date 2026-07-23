return {
  "xiyaowong/transparent.nvim",
  lazy = false, -- Carga el plugin al iniciar Neovim
  opts = {
    extra_groups = {
      "NvimTreeNormal", -- Mantener transparente NvimTree si lo usas
      "NeoTreeNormal",  -- Mantener transparente Neo-tree
      "TelescopeNormal",
      "WhichKeyNormal",
    },
  },
  config = function(_, opts)
    local transparent = require("transparent")
    transparent.setup(opts)
    transparent.clear_prefix("BufferLine") -- Opcional: elimina fondo en pestañas
    
    -- Fuerza la activación automática
    require("transparent").clear_prefix("NeoTree")
    vim.g.transparent_enabled = true
  end,
}
