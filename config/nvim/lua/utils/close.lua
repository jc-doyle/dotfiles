local api = vim.api
local utils = require 'utils.general'

local special_buffers = {"bin/java", "[dap-repl]"}

local M = {}

local function is_special(bufname)
	for _, buffer in ipairs(special_buffers) do
		if bufname:find(buffer) then
			return true
		end
	end
	return false
end

function M.remove_wins(wins)
	local i = 1
	while i <= #wins do
		local buf_num = api.nvim_win_get_buf(wins[i])
		local buf_name = vim.fn.bufname(buf_num)
		if buf_name:find("scrollbar_") or buf_name:find('term://') then
			table.remove(wins, i)
		else
			i = i + 1
		end
	end

	return wins
end

function M.close_nvim()
	local wins = M.remove_wins(api.nvim_list_wins())

	if #wins == 0 then
		vim.cmd('q!')
	elseif (#wins == 1 and vim.fn.bufname() == "") then
		vim.cmd('q')
	end
end

function M.close()
	local wins = M.remove_wins(api.nvim_list_wins())

	if #wins == 0 then
		vim.cmd("q")
	elseif #wins == 1 then
		vim.cmd("BufferDelete")
	elseif is_special(vim.fn.bufname()) then
	  vim.cmd("bdelete!")
  else
	  vim.cmd("wincmd c")
end
end
utils.augroup(
	{
		{"WinEnter", "*", "lua require 'utils.close'.close_nvim()"},
		{"BufWinEnter", "*", "lua require 'utils.close'.close_nvim()"},
	},
	'close'
)

return M
