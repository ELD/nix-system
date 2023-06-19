local M = {}

M.setup = function()
	local null_ls = require("null-ls")
	local mason_null_ls = require("mason-null-ls")

	local formatting = null_ls.builtins.formatting
	local diagnostics = null_ls.builtins.diagnostics
	local code_actions = null_ls.builtins.code_actions

	null_ls.setup({
		debug = false,
		sources = {
			diagnostics.deadnix,
			diagnostics.statix,

			formatting.taplo,
			formatting.nixfmt,

			code_actions.statix,
		},
		should_attach = function(bufnr)
			if vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr)) > 100000 then
				print("(null-ls) DISABLED, file too large")
				return false
			else
				return true
			end
		end,
		--[[ on_attach = require("plugins.lsp-support.handlers").on_attach, ]]
	})

	mason_null_ls.setup({
		ensure_installed = {
			-- Formatters
			"gofumpt",
			"goimports",
			"golines",
			"jq",
			"latexindent",
			"prettier",
			"shfmt",
			"yamlfmt",

			-- Linters
			"eslint_d",
			"gitlint",
			"golangci-lint",
			"jsonlint",
			"luacheck",
			"markdownlint",
			"shellcheck",
		},
		automatic_installation = false,
		handlers = {},
	})
end

return M
