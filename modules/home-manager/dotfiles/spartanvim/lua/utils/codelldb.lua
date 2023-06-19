local M = {}

local is_unix = vim.fn.has("unix") == 1
local is_wsl = vim.fn.has("wsl") == 1
local extension_path
local codelldb_path
local liblldb_path

if is_wsl then
	extension_path = vim.env.HOME .. "/.vscode-server/extensions/vadimcn.vscode-lldb-1.8.1/"
	codelldb_path = extension_path .. "adapter/codelldb"
	liblldb_path = extension_path .. "lldb/lib/liblldb.so"
elseif is_unix then
	extension_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb-1.8.1/"
	codelldb_path = extension_path .. "adapter/codelldb"
	liblldb_path = extension_path .. "lldb/lib/liblldb.so"
end

M.codelldb_path = codelldb_path
M.liblldb_path = liblldb_path

return M
