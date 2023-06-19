return {
	setup = function()
		require("plugins.lsp.support.configs")
		require("plugins.lsp.support.handlers").setup()
	end,
}
