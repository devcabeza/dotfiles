vim.filetype.add({
	pattern = {
		["/ghostty/config"] = "ghostty",
		["/ghostty/.*%.conf"] = "ghostty",
		["/.*prisma/.*schema%.prisma$"] = "prisma",
		["/prisma/.*schema%.prisma$"] = "prisma",
		["schema%.prisma$"] = "prisma",
	},
})
