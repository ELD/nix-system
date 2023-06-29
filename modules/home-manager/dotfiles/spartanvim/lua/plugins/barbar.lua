return {
	"romgrk/barbar.nvim",
	config = function()
		local barbar = require("barbar")
		barbar.setup({
			exclude_ft = { "alpha" },
		})
	end,
}
