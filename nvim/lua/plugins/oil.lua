-- oil.nvim - Editor de archivos como buffer (alternativa a neo-tree)
return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "Oil" },
    keys = {
      { "<leader>-", "<cmd>Oil<cr>", desc = "Open parent directory (oil)" },
      { "<leader>o", "<cmd>Oil --float<cr>", desc = "Oil (float)" },
    },
    opts = {
      default_file_explorer = false,
      watch_for_events = { "BufEnter" },
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-r>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["g."] = "actions.toggle_hidden",
      },
      view_options = {
        show_hidden = true,
      },
      float = {
        max_width = 90,
        max_height = 40,
      },
    },
  },
}
