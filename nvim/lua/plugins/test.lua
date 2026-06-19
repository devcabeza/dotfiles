-- ══════════════════════════════════════════════════════
-- neotest + neotest-phpunit — Testing de PHPUnit
-- ══════════════════════════════════════════════════════
-- Compatible con Laravel y Symfony (ambos usan PHPUnit)
-- Requiere `lazyvim.plugins.extras.test.core` en lazy.lua
-- Los keymaps vienen de LazyVim extras.test.core:
--   tt = run nearest, tr = run file, ts = toggle summary
--   to = output, tS = stop, td = debug
-- ══════════════════════════════════════════════════════
return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "olimorris/neotest-phpunit",
    },
    opts = {
      adapters = {
        require("neotest-phpunit"),
      },
    },
  },
}
