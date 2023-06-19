return {
	"iamcco/markdown-preview.nvim",
	dependencies = {
		"ekickx/clipboard-image.nvim",
	},
	build = "cd app && pnpm install",
	ft = { "markdown" },
	config = function()
		vim.cmd([[
      let g:mkdp_theme = 'light'
      let g:mkdp_auto_start=0
      let g:mkdp_auto_close=0
      let g:mkdp_refresh_slow=0
    ]])
		require("clipboard-image").setup({
			default = {
				img_dir = "images",
				img_name = function()
					return os.date("%Y-%m-%d-%H-%M-%S")
				end,
				affix = "<\n  %s\n>",
			},
			markdown = {
				img_dir = { "%:p:h", "images" },
				img_dir_txt = "images",
			},
		})
	end,
}
