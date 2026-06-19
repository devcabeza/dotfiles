return {
  {
    "nvim-lualine/lualine.nvim",
    enabled = false,
  },
  {
    "nvim-mini/mini.statusline",
    config = function()
      require("mini.statusline").setup()
    end,
  },
}
