return {
	"goolord/alpha-nvim",
	config = function()
		local alpha = require("alpha")

		local is_unix = vim.fn.has("unix") == 1
		local is_win32 = vim.fn.has("win32") == 1
		local configure_path
		if is_unix then
			local nvim_app = os.getenv("NVIM_APPNAME")
			local xdg_config_home = os.getenv("XDG_CONFIG_HOME")
			if nvim_app == nil then
				nvim_app = "nvim"
			end
			if xdg_config_home == nil then
				xdg_config_home = "/Users/" .. os.getenv("USER") .. "/.config"
			end

			configure_path = xdg_config_home .. "/" .. nvim_app .. "/init.lua"
		elseif is_win32 then
			configure_path = "~/AppData/Local/nvim/init.lua"
		end

		local dashboard = require("alpha.themes.dashboard")

		dashboard.section.header.val = {
			[[   _____                  _          __      ___           ]],
			[[  / ____|                | |         \ \    / (_)          ]],
			[[ | (___  _ __   __ _ _ __| |_ __ _ _ _\ \  / / _ _ __ ___  ]],
			[[  \___ \| '_ \ / _` | '__| __/ _` | '_ \ \/ / | | '_ ` _ \ ]],
			[[  ____) | |_) | (_| | |  | || (_| | | | \  /  | | | | | | |]],
			[[ |_____/| .__/ \__,_|_|   \__\__,_|_| |_|\/   |_|_| |_| |_|]],
			[[        | |                                                ]],
			[[        |_|                                                ]],
		}

		dashboard.section.buttons.val = {
			dashboard.button("f", "   Find file", ":Telescope find_files<CR>"),
			dashboard.button("e", "   New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("r", "   Recently used file", ":Telescope oldfiles <CR>"),
			dashboard.button("t", "   Find text", ":Telescope live_grep <CR>"),
			dashboard.button("c", "   Configuration", ":e" .. configure_path .. "<CR>"),
			dashboard.button("q", "   Quit SpartanVim", ":qa<CR>"),
		}

		dashboard.section.footer.opts.hl = "Type"
		dashboard.section.header.opts.hl = "Include"
		dashboard.section.buttons.opts.hl = "Keyword"
		dashboard.opts.opts.noautocmd = true

		alpha.setup(dashboard.opts)
	end,
}
