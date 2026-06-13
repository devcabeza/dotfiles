require("nixCatsUtils").setup({
	non_nix_value = true,
})

require("config")

local function getlockfilepath()
	if require("nixCatsUtils").isNixCats and type(require("nixCats").settings.unwrappedCfgPath) == "string" then
		return require("nixCats").settings.unwrappedCfgPath .. "/lazy-lock.json"
	else
		local dotfiles_path = vim.fn.expand("~/") .. ".dotfiles/nvim"
		if vim.fn.isdirectory(dotfiles_path) == 1 then
			return dotfiles_path .. "/lazy-lock.json"
		end
		return vim.fn.stdpath("config") .. "/lazy-lock.json"
	end
end

local lazyOptions = {
	lockfile = getlockfilepath(),
}

require("nixCatsUtils.lazyCat").setup(nixCats.pawsible({ "allPlugins", "start", "lazy.nvim" }), {
	{ import = "plugins" },
}, lazyOptions)
