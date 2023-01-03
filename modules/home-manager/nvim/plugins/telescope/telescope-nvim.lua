local telescope = require("telescope")
telescope.setup()

vim.api.nvim_set_keymap("n", "<Leader>ff", ":Telescope find_files<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>fg", ":Telescope live_grep<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>fb", ":Telescope buffers<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>fh", ":Telescope help_tags<cr>", { noremap = true })
