vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap.set

-- Debug
keymap({ "n", "t" }, "<A-o>", function()
	require("dap").step_out()
end, { silent = true, desc = "step out" })
keymap({ "n", "t" }, "<A-i>", function()
	require("dap").step_into()
end, { silent = true, desc = "step into" })
keymap({ "n", "t" }, "<A-j>", function()
	require("dap").step_over()
end, { silent = true, desc = "step over" })
keymap({ "n", "t" }, "<A-h>", function()
	require("dap").continue()
end, { silent = true, desc = "step out" })
keymap({ "n", "t" }, "<A-k>", function()
	require("dap.ui.widgets").hover()
end, { silent = true, desc = "calculate expr" })
keymap("n", "<F5>", function()
	require("dap").toggle_breakpoint()
end, { silent = true, desc = "toggle breakpoint" })

-- Redo
keymap("n", "U", "<C-r>", { silent = true, desc = "Redo" })

-- Up or down one visual line
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Next/Previous search result
keymap("n", "n", "nzzzv", { silent = true })
keymap("n", "N", "Nzzzv", { silent = true })

-- Window nav
keymap({ "n", "i" }, "<C-h>", "<C-w>h", { silent = true, desc = "Go to left window" })
keymap({ "n", "i" }, "<C-j>", "<C-w>j", { silent = true, desc = "Go to lower window" })
keymap({ "n", "i" }, "<C-k>", "<C-w>k", { silent = true, desc = "Go to upper window" })
keymap({ "n", "i" }, "<C-l>", "<C-w>l", { silent = true, desc = "Go to right window" })

-- Visbility of nvim-tree
keymap("n", "<C-b>", "<cmd>NvimTreeToggle<CR>", { silent = true, desc = "Toggle NeoVim Tree" })

-- Resize
keymap("n", "<C-Up>", ":resize +2<CR>", { silent = true, desc = "Increase window height" })
keymap("n", "<C-Down>", ":resize -2<CR>", { silent = true, desc = "Decrease window height" })
keymap("n", "<C-Left>", ":vertical :resize -2<CR>", { silent = true, desc = "Decrease window height" })
keymap("n", "<C-Right>", ":vertical :resize +2<CR>", { silent = true, desc = "Increase window height" })

-- Navigate buffers
keymap("n", "<Tab>", ":bn<CR>", { silent = true, desc = "Next Tab" })
keymap("n", "<S-Tab>", ":bp<CR>", { silent = true, desc = "Previous Tab" })

-- Move lines
keymap("n", "<A-Down>", ":m .+1<CR>==", { silent = true, desc = "Move Down" })
keymap("n", "<A-Up>", ":m .-2<CR>==", { silent = true, desc = "Move Up" })

-- Split windows
keymap("n", "vs", ":vs<CR>", { silent = true, desc = "Split Vertically" })
keymap("n", "sp", ":sp<CR>", { silent = true, desc = "Split Horizontally" })

-- Better marks
keymap("n", "'", "`", { silent = true })

-- Repeat and macro
keymap("n", "`", "@a", { silent = true })

-- Find text
keymap(
	"n",
	"<C-s>",
	"<cmd>lua require('telescope.builtin').live_grep(require('telescope.themes').get_dropdown({}))<CR>",
	{ silent = true, desc = "search" }
)

-- Copy and paste
keymap("n", "<C-y>", "<esc>:%y+<CR>", { silent = true })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
keymap("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

keymap("n", "<leader>a", "<cmd>Alpha<CR>", { desc = "Show Alpha" })

-- buffers
keymap("n", "<leader>bb", "<cmd>lua require('telescope.builtin').buffers()<CR>", { desc = "Switch Buffers" })
keymap("n", "<leader>bd", "<cmd>Bdelete!<CR>", { desc = "Delete current buffer" })

-- Debug
keymap(
	"n",
	"<leader>dt",
	"<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
	{ desc = "Toggle Condition Breakpoint" }
)
keymap("n", "<leader>dk", "<cmd>lua require'dap'.up()<CR>", { desc = "Stack up" })
keymap("n", "<leader>dj", "<cmd>lua require'dap'.down()<CR>", { desc = "Stack down" })
keymap("n", "<leader>dn", "<cmd>lua require'dap'.run_to_cursor()<CR>", { desc = "Run To Cursor" })
keymap("n", "<leader>dq", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Terminate" })
--[[ .exit               Closes the REPL ]]
--[[ .c or .continue     Same as |dap.continue| ]]
--[[ .n or .next         Same as |dap.step_over| ]]
--[[ .into               Same as |dap.step_into| ]]
--[[ .into_target        Same as |dap.step_into{askForTargets=true}| ]]
--[[ .out                Same as |dap.step_out| ]]
--[[ .up                 Same as |dap.up| ]]
--[[ .down               Same as |dap.down| ]]
--[[ .goto               Same as |dap.goto_| ]]
--[[ .scopes             Prints the variables in the current scopes ]]
--[[ .threads            Prints all threads ]]
--[[ .frames             Print the stack frames ]]
--[[ .capabilities       Print the capabilities of the debug adapter ]]
--[[ .b or .back         Same as |dap.step_back| ]]
--[[ .rc or .reverse-continue   Same as |dap.reverse_continue| ]]
keymap("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<CR>", { desc = "Toggle Repl" })
keymap("n", "<leader>df", "<cmd>Telescope dap frames<CR>", { desc = "Stack frames" })
keymap("n", "<leader>db", "<cmd>Telescope dap list_breakpoints<CR>", { desc = "All breakpoints" })
keymap(
	"n",
	"<leader>ds",
	"<cmd>lua require'dap.ui.widgets'.centered_float(require'dap.ui.widgets'.scopes)<CR>",
	{ desc = "View current scope" }
)

-- find
keymap("n", "<leader>fc", "<cmd>Telescope colorscheme<CR>", { desc = "Colorscheme" })
keymap("n", "<leader>fC", "<cmd>Telescope commands<CR>", { desc = "Commands" })
keymap("n", "<leader>ff", [[<cmd>lua require('telescope.builtin').find_files()<CR>]], { desc = "Find files" })
keymap(
	"n",
	"<leader>fF",
	"<cmd>lua require('telescope.builtin').find_files({no_ignore=true})<CR>",
	{ desc = "Find files but no ignore" }
)
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help" })
keymap("n", "<leader>fl", "<cmd>Telescope resume<CR>", { desc = "Last Search" })
keymap("n", "<leader>fm", "<cmd>Telescope man_pages<CR>", { desc = "Man Pages" })
keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Recent File" })
keymap("n", "<leader>fR", "<cmd>Telescope registers<CR>", { desc = "Registers" })
keymap("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Keymaps" })
keymap("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Todos" })

-- Git
keymap("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", { desc = "Lazygit" })
keymap("n", "<leader>gf", "<cmd>0Gclog<CR>", { desc = "File history" })
keymap("n", "<leader>gj", "<cmd>lua require 'gitsigns'.next_hunk()<CR>", { desc = "Next Hunk" })
keymap("n", "<leader>gk", "<cmd>lua require 'gitsigns'.prev_hunk()<CR>", { desc = "Prev Hunk" })
keymap("n", "<leader>gL", "<cmd>G blame<CR>", { desc = "Git Blame Information" })
keymap("n", "<leader>gl", "<cmd>Gclog<CR>", { desc = "Git Log Information" })
keymap("n", "<leader>gp", "<cmd>lua require 'gitsigns'.preview_hunk()<CR>", { desc = "Preview Hunk" })
keymap("n", "<leader>gP", "<cmd>G push<CR>", { desc = "Push..." })
keymap("n", "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<CR>", { desc = "Reset Hunk" })
keymap("n", "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<CR>", { desc = "Reset Buffer" })
keymap("n", "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<CR>", { desc = "Stage Hunk" })
keymap("n", "<leader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<CR>", { desc = "Undo Stage Hunk" })
keymap("n", "<leader>go", "<cmd>Telescope git_status<CR>", { desc = "Open changed file" })
keymap("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", { desc = "Checkout branch" })
keymap("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Checkout commit" })
keymap("n", "<leader>gd", "<cmd>lua require('user.utils.diff')()<CR>", { desc = "Diff With" })

-- Hop
keymap("n", "<leader>hw", "<cmd>HopWordCurrentLine<CR>", { desc = "Hop Word In Current Line" })
keymap("n", "<leader>hp", "<cmd>HopPattern<CR>", { desc = "Hop Word With Pattern" })

-- lsp
keymap("n", "<leader>la", "<cmd>Lspsaga code_action<CR>", { desc = "Code Action" })
keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format({async=true})<CR>", { desc = "Format" })
keymap("n", "<leader>li", "<cmd>LspInfo<CR>", { desc = "Info" })
keymap("n", "<leader>lI", "<cmd>LspInstallInfo<CR>", { desc = "Installer Info" })
keymap("n", "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<CR>", { desc = "CodeLens Action" })
keymap("n", "<leader>lr", "<cmd>Lspsaga rename<CR>", { desc = "Rename" })

-- markdown
keymap("n", "<leader>mP", "<Plug>MarkdownPreview", { desc = "Preview Markdown" })
keymap("n", "<leader>ms", "<Plug>MarkdownPreviewStop", { desc = "Stop Preview Markdown" })
keymap("n", "<leader>mt", "<cmd>InsertToc<CR>", { desc = "Insert Tocs" })
keymap("n", "<leader>mp", "<cmd>PasteImg<CR>", { desc = "Paster Images" })

-- code runner
keymap("n", "<leader>rr", "<cmd>RunFile<CR>", { desc = "Run File" })
keymap("n", "<leader>rp", "<cmd>RunProject<CR>", { desc = "Run Project" })
keymap("n", "<leader>rc", "<cmd>RunClose<CR>", { desc = "Close" })

-- terminal
keymap("n", "<leader>tn", "<cmd>lua _NODE_TOGGLE()<CR>", { desc = "Node" })
keymap("n", "<leader>tu", "<cmd>lua _NCDU_TOGGLE()<CR>", { desc = "NCDU" })
keymap("n", "<leader>tt", "<cmd>lua _HTOP_TOGGLE()<CR>", { desc = "Htop" })
keymap("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<CR>", { desc = "Python" })
keymap("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", { desc = "Float" })
keymap("n", "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<CR>", { desc = "Horizontal" })
keymap("n", "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<CR>", { desc = "Vertical" })

keymap("n", "<leader>n", "<cmd>noh<CR>", { desc = "Clear highlight" })

-- Insert Mode --
-- Debug
keymap("i", "<F5>", function()
	require("dap").toggle_breakpoint()
end, { silent = true })

-- Rename
keymap("i", "<F2>", "<cmd>Lspsaga rename<CR>", { silent = true, desc = "rename" })

keymap("i", "<A-Down>", "<Esc>:m .+1<cr>==gi", { desc = "Move down" })
keymap("i", "<A-Up>", "<Esc>:m .-2<cr>==gi", { desc = "Move up" })
------------------------------------ Visual Mode ------------------------
-- Stay in indent mode
keymap("v", "<", "<gv", { silent = true })
keymap("v", ">", ">gv", { silent = true })

-- Repeat and macro
keymap("v", ".", ":normal .<CR>", { silent = true })
keymap("v", "`", ":normal @a<CR>", { silent = true })

keymap("v", "p", '"_dP', { silent = true })

-- Move text up and down
keymap("v", "<A-Down>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
keymap("v", "<A-Up>", ":m '<-2<cr>gv=gv", { desc = "Move up" })
---------------------------------- Visual Block Mode ------------------------
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", { silent = true })
keymap("x", "K", ":move '<-2<CR>gv-gv", { silent = true })
keymap("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

---------------------------------- Terminal Mode ---------------------------
-- <C-\>: toggle terminal window
-- Alt+x: exit terminal mode
keymap("t", "<A-x>", [[<C-\><C-n>]], { silent = true })
