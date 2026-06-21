return {
  {
    "RRethy/base16-nvim",
    name = "base16-nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- Try to load Noctalia-generated colors if available
      local ok, matugen = pcall(require, "matugen")
      if ok and matugen.setup then
        matugen.setup()
      end
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "base16-nvim",
    },
  },
}
