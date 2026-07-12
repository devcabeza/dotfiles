-- ══════════════════════════════════════════════════════
-- Deshabilitar Mason (usamos binarios de Nix en PATH)
-- ══════════════════════════════════════════════════════
vim.g.lazyvim_mason = false

-- ══════════════════════════════════════════════════════
-- PHP: usar intelephense como LSP (mejor para Laravel/Symfony)
-- ══════════════════════════════════════════════════════
vim.g.lazyvim_php_lsp = "intelephense"

-- ══════════════════════════════════════════════════════
-- Overrides sobre los defaults de LazyVim
-- ══════════════════════════════════════════════════════
local opt = vim.opt

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- Indentación: 4 espacios (LazyVim default es 2)
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true

-- Scroll más generoso
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Wrap
opt.wrap = true
opt.linebreak = true
opt.breakindent = true

-- UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.showmode = false
opt.laststatus = 3
opt.termguicolors = true
opt.list = true
opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" }
opt.pumblend = 10
opt.pumheight = 10

-- Búsqueda
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"

-- Clipboard
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"

-- Sin swap/backup
opt.swapfile = false
opt.backup = false

-- Timings
opt.updatetime = 250
opt.timeoutlen = 300

-- Splits
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"

-- Mouse
opt.mouse = "a"

-- Completado
opt.completeopt = { "menu", "menuone", "noselect" }
opt.shortmess:append("c")

-- Performance
opt.redrawtime = 1500
opt.ttimeoutlen = 50
opt.synmaxcol = 240

-- Undo
opt.undofile = true

-- Deshabilitar providers innecesarios
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- Filetypes personalizados
vim.cmd([[au BufNewFile,BufRead *.astro setf astro]])
vim.cmd([[au BufNewFile,BufRead Podfile setf ruby]])
vim.cmd([[au BufNewFile,BufRead .env* setf sh]])

-- Usar Snacks como picker (compatible con laravel.nvim)
vim.g.lazyvim_picker = "snacks"

-- ══════════════════════════════════════════════════════
-- intelephense: configuración específica
-- ══════════════════════════════════════════════════════
-- Aumentar maxSize para proyectos grandes con muchos modelos
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "php" },
  desc = "Intelephense: max file size for large projects",
  group = vim.api.nvim_create_augroup("intelephense-settings", { clear = true }),
  callback = function()
    vim.lsp.config("intelephense", {
      settings = {
        intelephense = {
          files = { maxSize = 2000000 },
        },
      },
    })
  end,
})

-- ══════════════════════════════════════════════════════
-- Filetypes adicionales para frameworks PHP
-- ══════════════════════════════════════════════════════
vim.filetype.add({
  extension = {
    twig = "twig",
  },
  pattern = {
    [".*%.blade%.php"] = "blade",
  },
  filename = {
    ["composer.json"] = "json",
    ["artisan"] = "php",
  },
})
