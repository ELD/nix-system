return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"theHamsta/nvim-dap-virtual-text",
		"rcarriga/nvim-dap-ui",
		"jay-babu/mason-nvim-dap.nvim",
	},
	config = function()
		local dap = require("dap")
		local mason_nvim_dap = require("mason-nvim-dap")

		local dap_virtual_text_status = require("nvim-dap-virtual-text")

		local dapui = require("dapui")

		dap_virtual_text_status.setup({
			enabled = true,
			enabled_commands = true,
			highlight_changed_variables = true,
			highlight_new_as_changed = true,
			show_stop_reason = true,
			commented = true,
			only_first_definition = true,
			all_references = false,
			filter_references_patter = "<module",
			virt_text_pos = "eol",
			all_frames = false,
			virt_lines = false,
			virt_text_win_col = nil,
		})

		dapui.setup({
			layouts = {
				{
					elements = {
						"watches",
					},
					size = 0.2,
					position = "left",
				},
			},
			controls = {
				enabled = false,
			},
			render = {
				max_value_lines = 3,
			},
			floating = {
				max_height = nil,
				max_width = nil,
				border = "single",
				mappings = {
					close = { "q", "<Esc>" },
				},
			},
		})

		local icons = require("config.icons")
		vim.api.nvim_set_hl(0, "DapStoppedLinehl", { bg = "#555530" })
		vim.fn.sign_define(
			"DapBreakpoint",
			{ text = icons.ui.TinyCircle, texthl = "DapBreakpoint", linehl = "", numhl = "" }
		)
		vim.fn.sign_define(
			"DapBreakpointCondition",
			{ text = icons.ui.CircleWithGap, texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
		)
		vim.fn.sign_define("DapLogPoint", { text = icons.ui.LogPoint, texthl = "DapLogPoint", linehl = "", numhl = "" })
		vim.fn.sign_define(
			"DapStopped",
			{ text = icons.ui.ChevronRight, texthl = "Error", linehl = "DapStoppedLinehl", numhl = "" }
		)
		vim.fn.sign_define(
			"DapBreakpointRejected",
			{ text = icons.diagnostics.Error, texthl = "Error", linehl = "", numhl = "" }
		)

		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end

		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end

		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		mason_nvim_dap.setup({
			ensure_installed = {
				"delve",
				"codelldb",
			},
		})
	end,
}
