return {
	"lukas-reineke/indent-blankline.nvim", -- Indent line
	event = { "BufReadPost", "BufNewFile" },
	main = "ibl",
	config = function()
		local macchiato_theme = require("catppuccin.palettes").get_palette("macchiato")
		local hooks = require("ibl.hooks")

		local highlight = {
			"RainbowRed",
			"RainbowYellow",
			"RainbowBlue",
			"RainbowOrange",
			"RainbowGreen",
			"RainbowViolet",
			"RainbowCyan",
		}

		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			vim.api.nvim_set_hl(0, "RainbowRed", { fg = macchiato_theme.red })
			vim.api.nvim_set_hl(0, "RainbowYellow", { fg = macchiato_theme.yellow })
			vim.api.nvim_set_hl(0, "RainbowBlue", { fg = macchiato_theme.blue })
			vim.api.nvim_set_hl(0, "RainbowOrange", { fg = macchiato_theme.peach })
			vim.api.nvim_set_hl(0, "RainbowGreen", { fg = macchiato_theme.green })
			vim.api.nvim_set_hl(0, "RainbowViolet", { fg = macchiato_theme.lavender })
			vim.api.nvim_set_hl(0, "RainbowCyan", { fg = macchiato_theme.teal })
		end)

		vim.g.rainbow_delimeters = { highlight = highlight }

		require("ibl").setup({
			scope = { enabled = true, highlight = highlight },
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
		})

		hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
	end,
}
