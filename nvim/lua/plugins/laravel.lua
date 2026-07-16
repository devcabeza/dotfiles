-- ══════════════════════════════════════════════════════
-- laravel.nvim — Integración de primer nivel con Laravel
-- ══════════════════════════════════════════════════════
-- Proporciona: pickers (artisan, routes, make, resources),
-- virtual info (modelos, rutas, composer), code actions,
-- Tinker REPL, Artisan Hub, smart gf, completion
-- ══════════════════════════════════════════════════════
return {
  {
    "adalessa/laravel.nvim",
    version = "^4.0.0",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
    },
    ft = { "php", "blade" },
    event = { "BufEnter composer.json" },
    keys = {
      { "<leader>la", function() require("laravel").pickers.artisan() end, desc = "Laravel: Artisan" },
      { "<leader>lr", function() require("laravel").pickers.routes() end, desc = "Laravel: Routes" },
      { "<leader>lm", function() require("laravel").pickers.make() end, desc = "Laravel: Make" },
      { "<leader>lc", function() require("laravel").pickers.commands() end, desc = "Laravel: Custom Commands" },
      { "<leader>lo", function() require("laravel").pickers.resources() end, desc = "Laravel: Resources" },
      { "<leader>lh", function() require("laravel").run("artisan docs") end, desc = "Laravel: Documentation" },
      { "<leader>lt", function() require("laravel").commands.run("actions") end, desc = "Laravel: Code Actions" },
      { "<leader>lu", function() require("laravel").commands.run("hub") end, desc = "Laravel: Artisan Hub" },
      { "<leader>lp", function() require("laravel").commands.run("command_center") end, desc = "Laravel: Command Center" },
      { "<c-g>", function() require("laravel").commands.run("view:finder") end, desc = "Laravel: View Finder" },
      {
        "gf",
        function()
          if require("laravel").app("gf").cursorOnResource() then
            return "<cmd>lua require('laravel').commands.run('gf')<cr>"
          end
          return "gf"
        end,
        expr = true,
        noremap = true,
        desc = "Laravel: Smart gf to resource",
      },
    },
    opts = {
      features = {
        pickers = {
          provider = "snacks", -- Usamos Snacks (ya configurado como picker default)
        },
      },
      -- Genera doc-blocks en vendor/ para que intelephense entienda Eloquent
      eloquent_generate_doc_blocks = true,
    },
  },

  -- Snippets de Blade
  {
    "L3MON4D3/LuaSnip",
    optional = true,
    opts = function()
      local ls = require("luasnip")
      ls.add_snippets("blade", {
        ls.parser.parse_snippet("if", "@if (\n\n)\n    $1\n@endif"),
        ls.parser.parse_snippet("foreach", "@foreach ($1 as $2)\n    $3\n@endforeach"),
        ls.parser.parse_snippet("section", "@section('$1')\n    $2\n@endsection"),
        ls.parser.parse_snippet("extends", "@extends('$1')"),
        ls.parser.parse_snippet("component", "<x-$1 />"),
        ls.parser.parse_snippet("props", "@props([\n    '$1' => '$2',\n])"),
      })
    end,
  },
}
