local M = {}
local api = vim.api

local utils = require 'utils.general'

local terminal = {bufnum = nil, window = nil}

-- Setup AutoCmds
utils.autocmd('BufWinEnter,WinEnter,TermOpen','term://*','startinsert')

local function is_open()
	local wins = api.nvim_list_wins()
	local is_open = false

	for _, win in pairs(wins) do
		local buf = api.nvim_win_get_buf(win)
		if buf == terminal.bufnum then
			is_open = true
			terminal.window = win
		end
	end

	return is_open
end

local function setup_terminal(win_num)
	vim.fn.termopen('/bin/zsh')
	vim.wo[win_num].number = false
	vim.wo[win_num].relativenumber = false
end

local function create_or_show()
	vim.cmd("10split")
	local current_win = api.nvim_get_current_win()
	if (terminal.bufnum == nil) or not api.nvim_buf_is_valid(terminal.bufnum) then
		terminal.bufnum = api.nvim_create_buf(false, false)
		api.nvim_win_set_buf(current_win, terminal.bufnum)
		setup_terminal(current_win)
	else
		api.nvim_win_set_buf(current_win, terminal.bufnum)
	end
end

function M.toggle()
	if is_open() then
		api.nvim_win_close(terminal.window, true)
	else
		create_or_show()
	end
end


return M
