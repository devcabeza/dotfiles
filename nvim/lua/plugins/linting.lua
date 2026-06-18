-- Linters personalizados (overrides sobre el nvim-lint de LazyVim)
return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        markdown = { "markdownlint" },
        sql = { "sqlfluff" },
        lua = { "luacheck" },
        php = { "phpstan" },
        typescript = { "biomejs", "eslint_d" },
        typescriptreact = { "biomejs", "eslint_d" },
        javascript = { "biomejs", "eslint_d" },
        javascriptreact = { "biomejs", "eslint_d" },
        vue = { "eslint_d" },
        svelte = { "eslint_d" },
        astro = { "eslint_d" },
        dockerfile = { "hadolint" },
        json = { "biomejs" },
        nix = { "nix" },
        python = { "ruff" },
        go = { "golangci-lint" },
      },
      linters = {
        eslint_d = {
          condition = function(ctx)
            if vim.fn.executable("eslint_d") == 0 then
              return false
            end
            local patterns = {
              ".eslintrc", ".eslintrc.js", ".eslintrc.cjs",
              ".eslintrc.json", ".eslintrc.yml", ".eslintrc.yaml",
            }
            for _, p in ipairs(patterns) do
              if vim.loop.fs_stat(ctx.dirname .. "/" .. p) then
                return true
              end
            end
            local pkg = ctx.dirname .. "/package.json"
            local f = io.open(pkg, "r")
            if f then
              local content = f:read("*a")
              f:close()
              if content:match('"eslintConfig"') or content:match('"eslint"') then
                return true
              end
            end
            return false
          end,
        },
      },
    },
  },
}
