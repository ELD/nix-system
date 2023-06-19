local M = {}

M.setup = function()
	local null_ls = require("null-ls")
	local formatting = null_ls.builtins.formatting
	local diagnostics = null_ls.builtins.diagnostics

	null_ls.setup({
		debug = false,
		should_attach = function(bufnr)
			if vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr)) > 100000 then
				print("(null-ls) DISABLED, file too large")
				return false
			else
				return true
			end
		end,
		sources = {
			formatting.prettier,
			formatting.black.with({ extra_args = { "--fast" } }),
			diagnostics.flake8,
			diagnostics.jsonlint,
			formatting.jq,
			formatting.latexindent,
			diagnostics.chktex,
		},
		on_attach = require("plugins.lsp.support.handlers").on_attach,
	})
end

return M
