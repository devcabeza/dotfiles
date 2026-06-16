-- Blade (Laravel) filetype settings
-- Cargado automáticamente por Neovim al detectar filetype = "blade"

-- Comentarios de Blade: {{-- --}}
vim.opt_local.commentstring = "{{-- %s --}}"

-- Indentación: 4 espacios (estándar Laravel)
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
vim.opt_local.softtabstop = 4

-- Spell checking para texto en templates
vim.opt_local.spelllang = { "en", "es" }
vim.opt_local.spell = true

-- Keywords: guiones y guiones bajos son parte de palabras
vim.opt_local.iskeyword:append("-")
vim.opt_local.iskeyword:append("_")

-- Path de inclusión para navegación entre vistas
vim.opt_local.include = "view()"
vim.opt_local.includeexpr = "substitute(v:fname, '\\.', '/', 'g')"
vim.opt_local.path:append("resources/views")
vim.opt_local.path:append("resources/views/**")

-- Folding con treesitter (pero desactivado por defecto)
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt_local.foldenable = false

-- Wrap lines para templates largos
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
