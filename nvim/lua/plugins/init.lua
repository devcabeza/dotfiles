return {
	"tpope/vim-sleuth",
	{
		"swaits/universal-clipboard.nvim",
		event = "VimEnter",
		opts = {
			verbose = false,
			use_wl_copy = false,
		},
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = (require("nixCats").nixCatsPath or "") .. "/lua", words = { "nixCats" } },
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				"snacks.nvim",
			},
		},
	},
	{
		"tribela/transparent.nvim",
		event = "VimEnter",
		config = true,
	},
	"nvim-lua/plenary.nvim",
	"MunifTanjim/nui.nvim",
	{
		"declancm/maximize.nvim",
		config = true,
	},
	"tpope/vim-surround",
	"tpope/vim-repeat",
	"NMAC427/guess-indent.nvim",
}
