local settings = {
	nu = true,
	relativenumber = true,
	tabstop = 2,
	softtabstop = 2,
	shiftwidth = 2,
	expandtab = true,
	smartindent = true,
	wrap = true,
	swapfile = false,
	backup = false,
	undodir = os.getenv("HOME") .. "/.vim/undodir",
	undofile = true,
	hlsearch = false,
	incsearch = true,
	termguicolors = true,
	scrolloff = 8,
	updatetime = 50,
	colorcolumn = "120",
	foldenable = false,
	fillchars = {
		diff = "",
		fold = " ",
		eob = " ",
		horiz = "━",
		horizup = "┻",
		horizdown = "┳",
		vert = "┃",
		vertleft = "┫",
		vertright = "┣",
		verthoriz = "╋",
		foldclose = "",
		foldopen = "",
		foldsep = " ",
	},
	autoread = true,
	cmdheight = 1,
	completeopt = { "menuone", "noselect" },
	conceallevel = 0,
	fileencoding = "utf-8",
	ignorecase = true,
	mouse = "a",
	pumheight = 10,
	showmode = false,
	showtabline = 0,
	smartcase = true,
	splitbelow = true,
	splitright = true,
	timeoutlen = 1000,
	writebackup = false,
	cursorline = true,
	number = true,
	numberwidth = 3,
	sidescrolloff = 8,
	errorbells = false,
	title = true,
}

for k, v in pairs(settings) do
	vim.opt[k] = v
end

if vim.fn.has("nvim-0.9") == 1 and not vim.opt.diff:get() then
	vim.opt.signcolumn = "yes:1"
elseif vim.fn.has("nvim-0.9") == 0 then
	vim.opt.signcolumn = "number"
end

if vim.fn.has("nvim-0.9.0") == 1 then
	vim.opt.splitkeep = "screen"
	vim.opt.shortmess = "filnxtToOFWIcC"
end
