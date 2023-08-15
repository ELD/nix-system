return {
	"CRAG666/code_runner.nvim",
	config = function()
		local code_runner = require("code_runner")

		code_runner.setup({
			mode = "term",
			startinsert = "true",
			filetype = {
				rust = "cd $dir && rustc $fileName && $dir/$fileNameWithoutExt",
			},
		})
	end,
}
