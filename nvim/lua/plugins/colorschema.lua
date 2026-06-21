return {
  {
    "RRethy/base16-nvim",
    name = "base16-nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- Add Noctalia output path (~/.local/state/nvim/) to Lua's search path
      local state_path = vim.fn.stdpath("state")
      package.path = package.path .. ";" .. state_path .. "/?.lua"

      -- Try to load Noctalia-generated colors if available
      local ok, matugen = pcall(require, "matugen")
      if ok and matugen.setup then
        -- Defer to UIEnter to run AFTER LazyVim applies opts.colorscheme
        vim.api.nvim_create_autocmd("UIEnter", {
          once = true,
          callback = function()
            matugen.setup()
          end,
        })
      end
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "base16-gruvbox-material-dark-medium",
    },
  },
}
