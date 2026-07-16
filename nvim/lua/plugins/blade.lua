-- ══════════════════════════════════════════════════════
-- Blade (Laravel) — Soporte completo para templates Blade
-- ══════════════════════════════════════════════════════
-- Proporciona: parser tree-sitter, resaltado de sintaxis,
-- formateo con blade-formatter, inyecciones para Livewire,
-- AlpineJS y componentes Blade
-- ══════════════════════════════════════════════════════

-- ──────────────────────────────────────────────────────
-- Registrar parser tree-sitter custom para Blade
-- Usa detección de API con pcall para compatibilidad
-- entre versiones de nvim-treesitter
-- ──────────────────────────────────────────────────────
local parser_config
local ok, ts = pcall(require, "nvim-treesitter")
if ok and ts.get_parser_configs then
  parser_config = ts.get_parser_configs()
else
  local ok2, parsers = pcall(require, "nvim-treesitter.parsers")
  if ok2 and parsers.get_parser_configs then
    parser_config = parsers.get_parser_configs()
  end
end

if parser_config then
  parser_config.blade = {
    install_info = {
      url = "https://github.com/phalcon/tree-sitter-blade",
      files = { "src/parser.c" },
      branch = "master",
    },
    filetype = "blade",
  }
end

-- ──────────────────────────────────────────────────────
-- Registrar filetype para archivos *.blade.php
-- Usamos pattern en lugar de extension para capturar
-- correctamente la doble extensión .blade.php
-- ──────────────────────────────────────────────────────
vim.filetype.add({
  pattern = {
    [".*%.blade%.php"] = "blade",
  },
})

-- ──────────────────────────────────────────────────────
-- Autocomandos para filetype blade
-- ──────────────────────────────────────────────────────
vim.api.nvim_create_augroup("blade-settings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "blade",
  group = "blade-settings",
  desc = "Blade: configurar opciones del buffer",
  callback = function()
    -- Activar tree-sitter (fallback si nvim-treesitter no lo hace automáticamente)
    pcall(vim.treesitter.start, 0)

    -- Indentación 4 espacios (estilo Laravel)
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4

    -- Commentstring para comentarios Blade
    vim.bo.commentstring = "{{-- %s --}}"

    -- Wrap de línea
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})

-- ──────────────────────────────────────────────────────
return {
  -- Añadir blade a ensure_installed de nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "blade" } },
  },

  -- Configurar formateo via conform.nvim con blade-formatter
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters = {
        ["blade-formatter"] = {
          command = "blade-formatter",
          args = { "--write", "--indent-size", "4" },
        },
      },
      formatters_by_ft = {
        blade = { "blade-formatter" },
      },
    },
  },

  -- Grupo Blade en which-key (prefijo <leader>B, mayúscula)
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>B", group = "Blade" },
      },
    },
  },
}

-- Nota: Después del primer despliegue con uhm, ejecutar:
--   nvim --headless "+TSInstallSync blade" +qa
-- Esto compila e instala el parser tree-sitter para Blade.
