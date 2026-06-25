return {
  {
    dir = vim.fn.stdpath("config"),
    name = "obsidian.nvim",
    lazy = true,
    ft = { "markdown" },

    keys = {
      { "<leader>on", "<cmd>ObsidianOpen<cr>", desc = "Obsidian: abrir nota" },
      { "<leader>oo", "<cmd>ObsidianVault<cr>", desc = "Obsidian: abrir vault" },
    },

    config = function()
      local vault_path = vim.fn.expand("~/ObsidianVault")

      local M = {}

      function M.open_vault()
        vim.cmd("e " .. vim.fn.fnameescape(vault_path))
      end

      function M.pick_note()
        local scan = vim.fn.globpath(vault_path, "**/*.md", false, true)
        if #scan == 0 then
          vim.notify("No se encontraron notas en el vault", vim.log.levels.WARN)
          return
        end

        local items = {}
        for _, f in ipairs(scan) do
          local rel = f:sub(#vault_path + 2)
          table.insert(items, rel)
        end

        Snacks.picker.smart({
          prompt = "Obsidian – notas",
          items = items,
          on_select = function(idx)
            local rel = items[idx]
            if rel then
              local full = vault_path .. "/" .. rel
              vim.cmd("e " .. vim.fn.fnameescape(full))
            end
          end,
        })
      end

      vim.api.nvim_create_user_command("ObsidianOpen",   M.pick_note, {})
      vim.api.nvim_create_user_command("ObsidianVault",  M.open_vault, {})
    end,
  },
}
