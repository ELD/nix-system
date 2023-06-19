return {
	"kylechui/nvim-surround",
	config = function()
		local surround = require("nvim-surround")

		surround.setup({
			keymaps = {
				insert = "<C-g>s",
				normal = "ys",
				visual = "S",
				visual_line = "gS",
				delete = "ds",
				change = "cs",
			},
			aliases = {
				["a"] = ">",
				["b"] = ")",
				["B"] = "}",
				["r"] = "]",
				["q"] = { '"', "'", "`" },
			},
		})
	end,
}
