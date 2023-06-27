return {
	"nvim-lualine/lualine.nvim",
	config = function()
		local lualine = require("lualine")

		local config = {
			options = {
				icons_enabled = true,
				always_divide_middle = true,
				theme = "catppuccin",
			},
		}
		-- Now don't forget to initialize lualine
		lualine.setup(config)
	end,
}
