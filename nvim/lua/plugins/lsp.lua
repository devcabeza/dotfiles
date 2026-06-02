return {
	{
		"neovim/nvim-lspconfig",
		url = "git@github.com:neovim/nvim-lspconfig.git",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "j-hui/fidget.nvim", url = "git@github.com:j-hui/fidget.nvim.git" },
			{ "folke/neodev.nvim", url = "git@github.com:folke/neodev.nvim.git" },
			{ "saghen/blink.cmp", url = "git@github.com:saghen/blink.cmp.git" },
		},
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.publishDiagnostics.annotations = false
			capabilities.textDocument.publishDiagnostics.tagSupport = false

			local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = true })

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
				callback = function(event)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event.buf })
				end,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
					end
					map("gn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("ga", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
					map("<leader>ca", vim.lsp.buf.code_action, "Quick Fix (Code Action)", { "n", "x" })
					map("grr", require("snacks").picker.lsp_references, "[G]oto [R]eferences")
					map("gi", require("snacks").picker.lsp_implementations, "[G]oto [I]mplementations")
					map("gd", require("snacks").picker.lsp_definitions, "[G]oto [D]efinition")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("grD", require("snacks").picker.lsp_symbols, "Goto Document Symbol")
					map("grW", require("snacks").picker.lsp_workspace_symbols, "Goto [W]orkspace Symbol")
					map("grt", require("snacks").picker.lsp_type_definitions, "Goto [T]ype Definition")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})
					end

					if client and client.server_capabilities.inlayHintProvider then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local servers = require("setup.lsp.servers")

			-- Nix-only setup (clean)
			for server_name, server_config in pairs(servers) do
				if type(server_config) == "function" then
					server_config = server_config()
				end

				if server_config then
					server_config.capabilities =
						vim.tbl_deep_extend("force", server_config.capabilities or {}, capabilities)
					if vim.lsp.config then
						vim.lsp.config(server_name, server_config)
						vim.lsp.enable(server_name)
					else
						local lspconfig = require("lspconfig")
						local ok, config = pcall(function()
							return lspconfig[server_name]
						end)
						if ok and config then
							config.setup(server_config)
						end
					end
				end
			end
		end,
	},
}
