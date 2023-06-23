local M = {}

M.debugger = function()
	local install_root_dir = vim.fn.stdpath("data") .. "/mason"
	local extension_path = install_root_dir .. "/packages/codelldb/extension/"
	local codelldb_path = extension_path .. "adapter/codelldb"
	local this_os = vim.loop.os_uname().sysname
	local liblldb_path = extension_path .. "lldb/lib/liblldb" .. (this_os == "Linux" and ".so" or ".dylib")

	return {
		codelldb_path = codelldb_path,
		liblldb_path = liblldb_path,
	}
end

M.setup = function()
	local rust_tools = require("rust-tools")
	local debugger = M.debugger()

	rust_tools.setup({
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
		server = {
			standalone = true,
			on_attach = function(client, bufnr)
				vim.keymap.set("n", "<leader>ca", rust_tools.hover_actions.hover_actions, { buffer = bufnr })
			end,
			settings = {
				["rust-analyzer"] = {
					cargo = {
						features = "all",
						autoReload = true,
					},
					check = {
						command = "clippy",
						extraArgs = "-Dwarnings",
					},
				},
			},
		},
		dap = {
			adapter = require("rust-tools.dap").get_codelldb_adapter(debugger.codelldb_path, debugger.liblldb_path),
		},
	})
end

return M
