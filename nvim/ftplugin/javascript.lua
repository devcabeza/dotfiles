vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true
vim.opt_local.formatoptions = vim.opt_local.formatoptions + "t"
vim.opt_local.wrap = false

-- Configuración de completado
vim.b.completion_chain_complete = {
	complete = {
		{ mode = "|<c-d>" },
	},
}


-- ============================================
-- Utilidades JavaScript (usando LSP nativo)
-- ============================================
vim.keymap.set("n", "<leader>coi", function()
	vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } } })
end, { buffer = true, desc = "JavaScript: Organize Imports" })

vim.keymap.set("n", "<leader>crf", function()
	vim.lsp.buf.rename()
end, { buffer = true, desc = "JavaScript: Rename Symbol" })

vim.keymap.set("n", "<leader>cfa", function()
	vim.lsp.buf.code_action({ context = { only = { "quickfix", "source.fixAll" } } })
end, { buffer = true, desc = "JavaScript: Fix All" })