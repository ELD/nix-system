return {
	"mawkler/modicator.nvim",
	dependencies = "catppuccin/nvim", -- Add your colorscheme plugin here
	init = function()
		vim.o.cursorline = true
		vim.o.number = true
		vim.o.termguicolors = true
	end,
	config = function()
		local function has_value(tbl, value)
			for _, v in ipairs(tbl) do
				if v == value or (type(v) == "table" and has_value(v, value)) then
					return true
				end
			end
			return false
		end

		local function find_mode_section(config_sections)
			for k, section in pairs(config_sections) do
				if has_value(section, "mode") then
					return k
				end
			end
		end

		local function set_mode_hl_from_lualine()
			local ok, lualine = pcall(require, "lualine")
			assert(ok, "Failed to load lualine module")

			local mode_section = find_mode_section(lualine.get_config().sections)
			assert(mode_section, "Could not find mode section in lualine config")

			for hl_group, hl_def in pairs(vim.api.nvim_get_hl(0, { link = false })) do
				local mode_key_pattern = string.format("^%s_%%a+$", mode_section)
				-- getmetatable() as I didn't come up with a better solution to filter out vim.empty_dict()
				if string.match(hl_group, mode_key_pattern) and not getmetatable(hl_def) then
					local mode = hl_group:sub(11):gsub("^%l", string.upper) .. "Mode"
					vim.api.nvim_set_hl(0, mode, { fg = hl_def.bg })
				end
			end
		end

		set_mode_hl_from_lualine()

		require("modicator").setup({
			show_warnings = true,
			highlights = {
				defaults = {
					bold = true,
					italic = true,
				},
			},
		})
	end,
}
