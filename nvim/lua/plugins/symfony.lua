-- ══════════════════════════════════════════════════════
-- Symfony — Comandos personalizados e integración
-- ══════════════════════════════════════════════════════
-- Se apoya en laravel.nvim para los user_commands.
-- No existe un plugin symfony.nvim. Se compensa con:
--   1) user_commands (symfony console)
--   2) environment symfony-cli (usar symfony php)
--   3) neotest-phpunit para PHPUnit
--   4) intelephense LSP para servicios/rutas/doctrine
-- ══════════════════════════════════════════════════════
return {
  {
    "adalessa/laravel.nvim",
    optional = true,
    opts = {
      user_commands = {
        symfony = {
          -- Comandos Symfony CLI directos (sin console)
          ["serve"] = { cmd = { "serve" }, desc = "Symfony: Start dev server" },
          ["server:start"] = { cmd = { "server:start" }, desc = "Symfony: Start server (bg)" },
          ["server:stop"] = { cmd = { "server:stop" }, desc = "Symfony: Stop server" },
          -- Comandos que requieren `bin/console` (prefijo "console")
          ["cache:clear"] = { cmd = { "console", "cache:clear" }, desc = "Symfony: Clear cache" },
          ["cache:warmup"] = { cmd = { "console", "cache:warmup" }, desc = "Symfony: Warm up cache" },
          ["make:entity"] = { cmd = { "console", "make:entity" }, desc = "Symfony: Create Doctrine entity" },
          ["make:controller"] = { cmd = { "console", "make:controller" }, desc = "Symfony: Create controller" },
          ["make:command"] = { cmd = { "console", "make:command" }, desc = "Symfony: Create console command" },
          ["make:form"] = { cmd = { "console", "make:form" }, desc = "Symfony: Create form type" },
          ["debug:router"] = { cmd = { "console", "debug:router" }, desc = "Symfony: List all routes" },
          ["debug:autowiring"] = { cmd = { "console", "debug:autowiring" }, desc = "Symfony: List autowiring" },
          ["doctrine:migrations:migrate"] = { cmd = { "console", "doctrine:migrations:migrate" }, desc = "Symfony: Run migrations" },
          ["doctrine:schema:update"] = { cmd = { "console", "doctrine:schema:update", "--force" }, desc = "Symfony: Update schema" },
          ["lint:container"] = { cmd = { "console", "lint:container" }, desc = "Symfony: Lint container" },
        },
        composer = {
          autoload = { cmd = { "dump-autoload" }, desc = "Regenerate autoloader" },
        },
      },
    },
  },
}
