return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	config = function()
		local configs = require("nvim-treesitter.configs")

		if vim.fn.has("macunix") == 1 then
			require("nvim-treesitter.install").compilers = { "clang" }
		else
			require("nvim-treesitter.install").compilers = { "gcc" }
		end

		require("ts_context_commentstring").setup({})

		configs.setup({
			-- A list of parser names, or "all"
			ensure_installed = {
				"c",
				"lua",
				"cpp",
				"bash",
				"bibtex",
				"clojure",
				"cmake",
				"css",
				"gitignore",
				"gitcommit",
				"git_rebase",
				"gitattributes",
				"json",
				"nix",
				"perl",
				"python",
				"scss",
				"scheme",
				"sql",
				"toml",
				"typescript",
				"yaml",
				"rust",
				"vue",
				"vimdoc",
				"vim",
				"javascript",
				"markdown",
				"markdown_inline",
			},
			auto_install = true,
			sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
			ignore_install = { "hack", "rnoweb" }, -- List of parsers to ignore installing
			autopairs = {
				enable = true,
			},
			highlight = {
				enable = true, -- false will disable the whole extension
				disable = { "" }, -- list of language that will be disabled
				additional_vim_regex_highlighting = true,
			},
			indent = { enable = true, disable = { "yaml" } },
			playground = {
				enable = true,
				disable = {},
				updatetime = 25,
				persist_queries = false,
				keybindings = {
					toggle_query_editor = "o",
					toggle_hl_groups = "i",
					toggle_injected_languages = "t",
					toggle_anonymous_nodes = "a",
					toggle_language_display = "I",
					focus_language = "f",
					unfocus_language = "F",
					update = "R",
					goto_node = "<cr>",
					show_help = "?",
				},
			},
		})
	end,
}
