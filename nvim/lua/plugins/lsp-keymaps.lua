-- Tus keymaps de LSP (los defaults de LazyVim son distintos)
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            -- Tus keymaps
            { "gn", vim.lsp.buf.rename, desc = "Rename" },
            { "ga", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "x" } },
            { "grr", function() require("snacks").picker.lsp_references() end, desc = "References" },
            { "gi", function() require("snacks").picker.lsp_implementations() end, desc = "Implementations" },
            { "gd", function() require("snacks").picker.lsp_definitions() end, desc = "Definition" },
            { "gD", vim.lsp.buf.declaration, desc = "Declaration" },
            { "grD", function() require("snacks").picker.lsp_symbols() end, desc = "Document Symbol" },
            { "grW", function() require("snacks").picker.lsp_workspace_symbols() end, desc = "Workspace Symbol" },
            { "grt", function() require("snacks").picker.lsp_type_definitions() end, desc = "Type Definition" },

            -- Deshabilitar defaults de LazyVim que no usás
            { "K", false },
            { "gK", false },
            { "<leader>ca", false },
          },
        },
      },
    },
  },
}
