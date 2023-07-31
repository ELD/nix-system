return {
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		lazy = true,
		config = function()
			-- This is where you modify the settings for lsp-zero
			-- Note: autocompletion settings will not take effect

			require("lsp-zero.settings").preset({})
		end,
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{ "L3MON4D3/LuaSnip" },
			"hrsh7th/cmp-buffer", -- buffer completions
			"hrsh7th/cmp-path", -- path completions
			"hrsh7th/cmp-cmdline", -- cmdline completions
			"saadparwaiz1/cmp_luasnip", -- snippet completions
			"hrsh7th/cmp-nvim-lsp",
			-- snippets
			"L3MON4D3/LuaSnip", --snippet engine
			"rafamadriz/friendly-snippets", -- a bunch of snippets to use
			"rcarriga/cmp-dap",
		},
		config = function()
			-- Here is where you configure the autocompletion settings.
			-- The arguments for .extend() have the same shape as `manage_nvim_cmp`:
			-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#manage_nvim_cmp

			require("lsp-zero.cmp").extend()

			-- And you can configure cmp even more, if you want to.
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local kind_icons = require("config.icons").kind

			local check_backspace = function()
				local col = vim.fn.col(".") - 1
				return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
			end

			local winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel"

			cmp.setup({
				enabled = function()
					return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
				end,
				view = {
					entries = "custom",
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = {
					["<C-k>"] = cmp.mapping.select_prev_item(),
					["<C-j>"] = cmp.mapping.select_next_item(),
					["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
					["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
					["<C-e>"] = cmp.mapping({
						i = cmp.mapping.abort(),
						c = cmp.mapping.close(),
					}),
					-- Accept currently selected item. If none selected, `select` first item.
					-- Set `select` to `false` to only confirm explicitly selected items.
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if luasnip.expandable() then
							cmp.close()
							luasnip.expand()
						elseif luasnip.expand_or_jumpable() then
							cmp.close()
							luasnip.expand_or_jump()
						elseif cmp.visible() then
							cmp.select_next_item()
						elseif check_backspace() then
							fallback()
						else
							fallback()
						end
					end, {
						"i",
						"s",
					}),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, {
						"i",
						"s",
					}),
				},
				formatting = {
					fields = { "kind", "abbr", "menu" },
					max_width = 0,
					format = function(entry, vim_item)
						vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
						vim_item.menu = ({
							nvim_lsp = "[LSP]",
							luasnip = "[Snippet]",
							buffer = "[Buffer]",
							path = "[Path]",
						})[entry.source.name]
						return vim_item
					end,
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "cpilot" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
					{ name = "crates" },
				},
				confirm_opts = {
					behavior = cmp.ConfirmBehavior.Replace,
					select = false,
				},
				window = {
					completion = cmp.config.window.bordered({
						winhighlight = winhighlight,
						scrollbar = false,
					}),
					documentation = cmp.config.window.bordered({ winhighlight = winhighlight }),
				},
			})
			-- Set configuration for git
			cmp.setup.filetype("gitcommit", {
				sources = cmp.config.sources({
					{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
				}, {
					{ name = "buffer" },
				}),
			})

			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})

			cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
				sources = {
					{ name = "dap" },
				},
			})
		end,
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		cmd = "LspInfo",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "williamboman/mason-lspconfig.nvim" },
			{
				"williamboman/mason.nvim",
				build = function()
					pcall(vim.cmd, "MasonUpdate")
				end,
			},
			{ "simrat39/rust-tools.nvim" },
			{ "jose-elias-alvarez/null-ls.nvim" },
			{ "jay-babu/mason-null-ls.nvim" },
		},
		config = function()
			-- This is where all the LSP shenanigans will live
			local lsp = require("lsp-zero")
			local keymaps = require("plugins.lsp-support.keymaps")
			keymaps.setup()

			lsp.on_attach(function(client, bufnr)
				keymaps.on_attach(client, bufnr)
			end)

			local lsp_servers = require("utils.lsp-servers")
			lsp.ensure_installed(lsp_servers.all_servers)
			lsp.skip_server_setup({ "rust_analyzer" })

			-- Configure LSP server capabilities
			local lspconfig = require("lspconfig")
			local capabilities = require("plugins.lsp-support.capabilities")
			for _, servername in ipairs(lsp_servers.regular_servers) do
				lspconfig[servername].setup({
					capabilities = capabilities.capabilities,
				})
			end

			-- (Optional) Configure lua language server for neovim
			lspconfig.lua_ls.setup(lsp.nvim_lua_ls())
			-- Set up lsp
			lsp.setup()

			-- Other config can go here now
			require("plugins.lsp-support.rust").setup()
			require("plugins.lsp-support.null-ls-integration").setup()
		end,
	},
	-- lspsaga
	{
		"glepnir/lspsaga.nvim",
		event = "BufRead",
		config = function()
			require("lspsaga").setup({
				preview = {
					lines_above = 0,
					lines_below = 10,
				},
				scroll_preview = {
					scroll_down = "<C-f>",
					scroll_up = "<C-b>",
				},
				request_timeout = 2000,
				finder = {
					--percentage
					max_height = 0.5,
					keys = {
						jump_to = "p",
						edit = { "o", "<CR>" },
						vsplit = "s",
						split = "i",
						tabe = "t",
						tabnew = "r",
						quit = { "q", "<ESC>" },
						close_in_preview = "<ESC>",
					},
				},
				definition = {
					edit = "<C-c>o",
					vsplit = "<C-c>v",
					split = "<C-c>i",
					tabe = "<C-c>t",
					quit = "q",
					close = "<Esc>",
				},
				code_action = {
					num_shortcut = true,
					show_server_name = false,
					extend_gitsigns = true,
					keys = {
						-- string | table type
						quit = "<ESC>",
						exec = "<CR>",
					},
				},
				lightbulb = {
					enable = true,
					enable_in_insert = false,
					sign = false,
					sign_priority = 40,
					virtual_text = false,
				},
				diagnostic = {
					show_code_action = true,
					show_source = true,
					jump_num_shortcut = true,
					--1 is max
					max_width = 0.7,
					custom_fix = nil,
					custom_msg = nil,
					text_hl_follow = false,
					border_follow = true,
					keys = {
						exec_action = "o",
						quit = "q",
						go_action = "g",
					},
				},
				rename = {
					quit = "<C-c>",
					exec = "<CR>",
					mark = "x",
					confirm = "<CR>",
					in_select = true,
				},
				outline = {
					win_position = "right",
					win_with = "",
					win_width = 30,
					show_detail = true,
					auto_preview = true,
					auto_refresh = true,
					auto_close = true,
					custom_sort = nil,
					keys = {
						jump = "o",
						expand_collapse = "u",
						quit = "q",
					},
				},
				symbol_in_winbar = {
					enable = true,
					separator = " - ",
					hide_keyword = true,
					show_file = true,
					folder_level = 2,
					respect_root = false,
					color_mode = true,
				},
				ui = {
					kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
				},
			})
		end,
		dependencies = {
			{ "nvim-tree/nvim-web-devicons" },
			--Please make sure you install markdown and markdown_inline parser
			{ "nvim-treesitter/nvim-treesitter" },
		},
	},
	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim", -- show diagnostics using virtual lines
		config = function()
			local lsp_lines = require("lsp_lines")

			lsp_lines.setup()

			vim.keymap.set("n", "g?", function()
				local lines_enabled = not vim.diagnostic.config().virtual_lines
				vim.diagnostic.config({
					virtual_lines = lines_enabled,
					virtual_text = not lines_enabled,
				})
			end, { noremap = true, silent = true })

			vim.diagnostic.config({
				virtual_text = true,
				virtual_lines = false,
			})
		end,
	},
	{

		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		config = function()
			local ufo = require("ufo")

			vim.o.foldcolumn = "0"
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			local handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local suffix = ("  %d "):format(endLnum - lnum)
				local sufWidth = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth = 0
				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)
						table.insert(newVirtText, { chunkText, hlGroup })
						chunkWidth = vim.fn.strdisplaywidth(chunkText)
						if curWidth + chunkWidth < targetWidth then
							suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end
				table.insert(newVirtText, { suffix, "MoreMsg" })
				return newVirtText
			end

			ufo.setup({
				fold_virt_text_handler = handler,
			})
		end,
	},
}
