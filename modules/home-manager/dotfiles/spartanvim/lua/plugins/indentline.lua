return {
	"lukas-reineke/indent-blankline.nvim", -- Indent line
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		indent = {
			char = "|",
			tab_char = "|",
		},
		scope = { enabled = false },
		exclude = {
			buftypes = {
				"terminal",
				"nofile",
			},
			filetypes = {
				"help",
				"startify",
				"aerial",
				"alpha",
				"dashboard",
				"packer",
				"neogitstatus",
				"NvimTree",
				"neo-tree",
				"Trouble",
			},
		},
	},
	main = "ibl",
}
