local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- ai
    { import = "lazyvim.plugins.extras.ai.copilot" },
    -- conding
    { import = "lazyvim.plugins.extras.coding.mini-surround" },
    -- editor
    { import = "lazyvim.plugins.extras.editor.harpoon2" },
    { import = "lazyvim.plugins.extras.editor.inc-rename" },
    { import = "lazyvim.plugins.extras.editor.mini-diff" },
    { import = "lazyvim.plugins.extras.editor.mini-move" },
    { import = "lazyvim.plugins.extras.editor.outline" },
    -- formatting
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    -- langs
    { import = "lazyvim.plugins.extras.lang.astro" },
    { import = "lazyvim.plugins.extras.lang.docker" },
    { import = "lazyvim.plugins.extras.lang.git" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.extras.lang.nix" },
    { import = "lazyvim.plugins.extras.lang.php" },
    { import = "lazyvim.plugins.extras.lang.prisma" },
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.lang.sql" },
    { import = "lazyvim.plugins.extras.lang.svelte" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },
    { import = "lazyvim.plugins.extras.lang.toml" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.typescript.biome" },
    { import = "lazyvim.plugins.extras.lang.typescript.vtsls" },
    { import = "lazyvim.plugins.extras.lang.vue" },
    -- linting
    { import = "lazyvim.plugins.extras.linting.eslint" },
    -- test
    { import = "lazyvim.plugins.extras.test.core" },
    -- dap
    { import = "lazyvim.plugins.extras.dap.core" },
    --  ui
    { import = "lazyvim.plugins.extras.ui.smear-cursor" },
    { import = "lazyvim.plugins.extras.ui.treesitter-context" },
    -- utils
    { import = "lazyvim.plugins.extras.util.mini-hipatterns" },
    { import = "lazyvim.plugins.extras.util.startuptime" },
    -- custom plugins
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
