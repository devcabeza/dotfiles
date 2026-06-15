return { -- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
	build = require("nixCatsUtils").lazyAdd(":TSUpdate"),
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	lazy = false,
	cmd = {
		"TSInstall",
		"TSInstallSync",
		"TSUpdate",
		"TSBufEnable",
		"TSBufDisable",
	},
	opts = {
		ensure_installed = require("nixCatsUtils").lazyAdd({
			"bash",
			"lua",
			"vimdoc",
			"vim",
			-- Lenguajes principales
			"javascript",
			"typescript",
			"tsx",
			"json",
			"html",
			"css",
			"python",
		}),
		auto_install = require("nixCatsUtils").lazyAdd(true, false),

		-- PERFORMANCE: Configuraciones de highlight optimizadas
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false, -- Disable for performance
			-- Disable some expensive features
			disable = function(_, buf)
				local buf_size = vim.api.nvim_buf_line_count(buf)
				-- Disable for files > 100k lines
				if buf_size > 100000 then
					return true
				end
			end,
		},
		indent = { enable = true, disable = { "ruby" } },

		-- PERFORMANCE: Increment sync mode
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<CR>",
				node_incremental = "<CR>",
				scope_incremental = "<S-CR>",
				node_decremental = "<BS>",
			},
		},

		-- textobjects solo cuando sea necesario
		textobjects = {
			select = {
				enable = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
				},
			},
		},
	},
	config = function(_, opts)
		local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
		parser_config.blade = {
			install_info = {
				url = "git@github.com:EmranMR/tree-sitter-blade",
				files = { "src/parser.c" },
				branch = "main",
			},
			filetype = "blade",
		}
		-- Configuración de Prisma parser
		parser_config.prisma = {
			install_info = {
				url = "git@github.com:victorhqc/tree-sitter-prisma",
				files = { "src/parser.c" },
				branch = "main",
			},
			filetype = "prisma",
		}
		vim.filetype.add({
			pattern = {
				[".*%.blade%.php"] = {
					function(path, bufnr, ext)
						local firstLine = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""
						if vim.startswith(firstLine, "<?php") then
							return "php"
						end

						return "blade"
					end,
					{ priority = math.huge, name = "blade" },
				},
			},
		})

		require("nvim-treesitter.install").prefer_git = true

		-- Envolver setup en pcall para evitar que errores de parsers rompan la UI
		local setup_ok, setup_err = pcall(function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup(opts)
		end)
		if not setup_ok then
			vim.notify(
				"nvim-treesitter: Error en setup - " .. tostring(setup_err),
				vim.log.levels.WARN
			)
		end

		-- Neovim 0.12+: Registrar parsers explícitamente para evitar errores de ABI
		-- Los parsers vienen de nixpkgs via nvim-treesitter.withPlugins
		vim.schedule(function()
			local parsers_installed = {
				"bash", "lua", "vimdoc", "vim",
				"javascript", "typescript", "tsx",
				"json", "html", "css", "python",
				"markdown", "markdown_inline", "php",
				"regex", "toml", "yaml", "xml",
				"dockerfile", "diff", "sql",
				"astro", "vue", "svelte", "prisma",
				"query", "luadoc", "luap", "c",
			}

			-- Si existe el módulo language.add, registrar parsers
			local language_ok, language = pcall(require, "vim.treesitter.language")
			if language_ok and language.add then
				for _, parser_name in ipairs(parsers_installed) do
					pcall(language.add, parser_name)
				end
			end
		end)

		-- No instalar automáticamente blade y prisma, ya están instalados manualmente
		-- require("nvim-treesitter.install").ensure_installed({ "blade", "prisma" })
	end,
}
