-- ══════════════════════════════════════════════════════
-- nvim-dap + php-debug-adapter — Debugging PHP con XDebug
-- ══════════════════════════════════════════════════════
-- Requiere `php-debug-adapter` en PATH (provisto por Nix)
-- y `lazyvim.plugins.extras.dap.core` en lazy.lua
-- ══════════════════════════════════════════════════════
return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    config = function()
      local dap = require("dap")
      dap.adapters.php = {
        type = "executable",
        command = "php-debug-adapter",
        args = {},
      }
      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "Listen for XDebug",
          port = 9003,
          stopOnEntry = false,
          pathMappings = {
            ["/var/www/html"] = "${workspaceFolder}",
          },
          xdebugSettings = {
            max_children = 512,
            max_data = 1024,
            max_depth = 4,
          },
        },
      }
    end,
  },
}
