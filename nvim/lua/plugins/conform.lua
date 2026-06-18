-- Formateadores personalizados (overrides sobre el conform de LazyVim)
return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        blade = { "blade-formatter" },
        php = function(bufnr)
          local fname = vim.uri_from_bufnr(bufnr)
          if fname:match("views") then
            return { "blade-formatter" }
          end
          if vim.fn.filereadable(vim.fn.getcwd() .. "/mago.toml") == 1 then
            return { "mago" }
          end
          return { "php_cs_fixer" }
        end,
        javascript = { "biome", "prettierd", stop_after_first = true },
        typescript = { "biome", "prettierd", stop_after_first = true },
        javascriptreact = { "biome", "prettierd", stop_after_first = true },
        typescriptreact = { "biome", "prettierd", stop_after_first = true },
        vue = { "prettierd", stop_after_first = true },
        svelte = { "prettierd", stop_after_first = true },
        astro = { "prettierd", stop_after_first = true },
        json = { "biome", "prettierd", stop_after_first = true },
        jsonc = { "biome", "prettierd", stop_after_first = true },
        html = { "prettierd", stop_after_first = true },
        css = { "prettierd", stop_after_first = true },
        scss = { "prettierd", stop_after_first = true },
        nix = { "nixfmt" },
        python = { "ruff_format" },
        go = { "goimports", "gofumpt" },
        rust = { "rustfmt" },
        sh = { "shfmt" },
      },
      formatters = {
        ["blade-formatter"] = { command = "blade-formatter" },
      },
    },
  },
}
