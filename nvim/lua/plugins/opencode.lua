return {
	"sudo-tee/opencode.nvim",
	event = "VeryLazy",
	opts = {
		keymap_prefix = "<leader>a", -- Usar '<leader>a' para evitar conflictos con el plugin Obsidian (<leader>o)
	},
	config = function(_, opts)
		require("opencode").setup(opts)
	end,
}
