-- Stack PHP/Laravel completo
return {
  -- LSP: phpactor se configura vía lazyvim_php_lsp en options.lua

  -- Laravel integration
  {
    "adalessa/laravel.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "tpope/vim-dotenv",
      "MunifTanjim/nui.nvim",
    },
    cmd = { "Laravel" },
    keys = {
      { "<leader>la", "<cmd>Laravel artisan<cr>", desc = "Laravel Artisan" },
      { "<leader>lr", "<cmd>Laravel routes<cr>", desc = "Laravel Routes" },
      { "<leader>lm", "<cmd>Laravel related<cr>", desc = "Laravel Models" },
    },
    config = true,
  },

  -- Blade treesitter
  {
    "EmranMR/tree-sitter-blade",
    build = "make",
    config = function()
      vim.treesitter.language.register("blade", "blade")
      vim.filetype.add({
        pattern = {
          { ".*%.blade%.php", "blade" },
        },
      })
    end,
  },

  -- Neotest para Pest (testing)
  {
    "V13Axel/neotest-pest",
    dependencies = { "nvim-neotest/neotest" },
    ft = "php",
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-pest")({
            pest_cmd = { "php", "artisan", "test" },
          }),
        },
      })
    end,
  },

  -- PHP DAP (debug)
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
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
          name = "Listen for Xdebug",
          port = 9003,
        },
      }
    end,
  },
}
