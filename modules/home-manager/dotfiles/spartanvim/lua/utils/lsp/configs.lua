local lspconfig = require("lspconfig")

local lsp_servers = require("utils.lsp-servers")

local on_attach = require("plugins.lsp.handlers").on_attach
local capabilities = require("plugins.lsp.handlers").capabilities

lspconfig.lua_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = require("plugins.lsp.settings.sumneko_lua").settings,
})

for _, server in ipairs(lsp_servers.regular_servers) do
	lspconfig[server].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

local codelldb = require("utils.codelldb")

require("rust-tools").setup({
	tools = {
		autoSetHints = true,
		hover_with_actions = false,
		executor = require("rust-tools/executors").termopen,
		on_initialized = nil,
		inlay_hints = {
			only_current_line = false,
			only_current_line_autocmd = "CursorHold",
			show_parameter_hints = true,
			show_variable_name = true,
			parameter_hints_prefix = "<- ",
			other_hints_prefix = "=> ",
			max_len_align = false,
			max_len_align_padding = 1,
			right_align = false,
			right_align_padding = 7,
			highlight = "Comment",
		},

		hover_actions = {
			border = {
				{ "┌", "FloatBorder" },
				{ "─", "FloatBorder" },
				{ "┐", "FloatBorder" },
				{ "│", "FloatBorder" },
				{ "┘", "FloatBorder" },
				{ "─", "FloatBorder" },
				{ "└", "FloatBorder" },
				{ "│", "FloatBorder" },
			},

			auto_focus = true,
		},

		crate_graph = {
			backend = "x11",
			output = nil,
			full = true,
			enabled_graphviz_backends = {
				"bmp",
				"cgimage",
				"canon",
				"dot",
				"gv",
				"xdot",
				"xdot1.2",
				"xdot1.4",
				"eps",
				"exr",
				"fig",
				"gd",
				"gd2",
				"gif",
				"gtk",
				"ico",
				"cmap",
				"ismap",
				"imap",
				"cmapx",
				"imap_np",
				"cmapx_np",
				"jpg",
				"jpeg",
				"jpe",
				"jp2",
				"json",
				"json0",
				"dot_json",
				"xdot_json",
				"pdf",
				"pic",
				"pct",
				"pict",
				"plain",
				"plain-ext",
				"png",
				"pov",
				"ps",
				"ps2",
				"psd",
				"sgi",
				"svg",
				"svgz",
				"tga",
				"tiff",
				"tif",
				"tk",
				"vml",
				"vmlz",
				"wbmp",
				"webp",
				"xlib",
				"x11",
			},
		},
	},

	server = {
		standalone = true,
		on_attach = on_attach,
		settings = {
			["rust-analyzer"] = {
				cargo = {
					autoReload = true,
				},
			},
		},
	},

	dap = {
		adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb.codelldb_path, codelldb.liblldb_path),
	},
})
