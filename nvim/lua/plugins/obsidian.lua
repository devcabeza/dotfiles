return {
  {
    dir = vim.fn.stdpath("config"),
    name = "obsidian.nvim",
    lazy = true,
    ft = { "markdown" },

    keys = {
      { "<leader>on", "<cmd>ObsidianOpen<cr>", desc = "Obsidian: abrir nota" },
      { "<leader>oo", "<cmd>ObsidianVault<cr>", desc = "Obsidian: abrir vault" },
      { "<leader>oc", "<cmd>ObsidianNew<cr>", desc = "Obsidian: crear nota" },
    },

    config = function()
      local vault_path = vim.fn.expand("~/Documents/Alejandro Cabeza Vault/")

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

      function M.new_note()
        vim.ui.input({ prompt = "Nombre de la nueva nota: " }, function(input)
          if not input or input == "" then
            return
          end

          local filename = input
          if not filename:match("%.md$") then
            filename = filename .. ".md"
          end

          local full_path = vault_path .. "/" .. filename

          if vim.fn.filereadable(full_path) == 1 then
            vim.notify("La nota ya existe: " .. filename, vim.log.levels.WARN)
            vim.cmd("e " .. vim.fn.fnameescape(full_path))
            return
          end

          local dir = vim.fn.fnamemodify(full_path, ":h")
          if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, "p")
          end

          vim.cmd("e " .. vim.fn.fnameescape(full_path))
          
          local title = vim.fn.fnamemodify(filename, ":t:r")
          vim.api.nvim_buf_set_lines(0, 0, -1, false, {
            "# " .. title,
            "",
          })
          vim.cmd("w")
        end)
      end

      vim.api.nvim_create_user_command("ObsidianOpen",   M.pick_note, {})
      vim.api.nvim_create_user_command("ObsidianVault",  M.open_vault, {})
      vim.api.nvim_create_user_command("ObsidianNew",    M.new_note, {})
    end,
  },
}
