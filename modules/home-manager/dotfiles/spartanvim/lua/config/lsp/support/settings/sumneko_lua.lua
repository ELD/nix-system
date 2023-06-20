return {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = "$VIMRUNTIME/lua",
			},
			diagnostics = {
				globals = { "vim" },
				neededFileStatus = {
					["codestyle-check"] = "Any",
				},
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
			format = {
				enable = true,
				defaultConfig = {
					indent_style = "space",
					indent_size = "2",
					quote_style = "double",
					max_line_length = "unset",
				},
			},
		},
	},
}
