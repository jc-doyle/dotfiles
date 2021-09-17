local M = {}
local api = vim.api

local utils = require 'utils.general'
local os_shell = '/bin/zsh'

local terminals = {
	terminal = {bufnum = nil, window = nil},
	shell = {bufnum = nil, window = nil},
	debug = {bufnum = nil, window = nil},
}

function M.is_open(type)
	local wins = api.nvim_list_wins()
	for _, win in pairs(wins) do
		local buf = api.nvim_win_get_buf(win)
		if buf == terminals[type].bufnum then
			terminals[type].window = win
			return true
		end
	end
	return false
end

local function is_any_open()
	local wins = api.nvim_list_wins()
	for _, win in pairs(wins) do
		local buf = api.nvim_win_get_buf(win)
		if buf == terminals[type].bufnum then
			terminals[type].window = win
			return true
		end
	end
	return false
end


local function create(type)
	if type == 'terminal' then
		vim.fn.termopen(os_shell)
	elseif type == 'shell' then
		vim.fn.termopen('/usr/bin/python')
	end
end

local function create_or_show(type)
	vim.cmd("botright 10split")
	local current_win = api.nvim_get_current_win()
	if (terminals[type].bufnum == nil) or not api.nvim_buf_is_valid(terminals[type].bufnum) then
		terminals[type].bufnum = api.nvim_create_buf(false, false)
		api.nvim_win_set_buf(current_win, terminals[type].bufnum)
		create(type)
	else
		api.nvim_win_set_buf(current_win, terminals[type].bufnum)
	end
end

local function find_buf_by_name(name)
	local bufs = api.nvim_list_bufs()

	for _, buf in pairs(bufs) do
		if name == api.nvim_buf_get_name(buf) then
			return buf
		end
	end
end

local function start_r()
	if not vim.g.rplugin.R_bufname then
		vim.cmd('call StartR("R")')
		terminal["terminal"].bufnum = find_buf_by_name(vim.g.rplugin.R_bufname)
	else
		create_or_show()
	end
end

function M.toggle(type)
	if M.is_open(type) then
		api.nvim_win_close(terminals[type].window, true)
	elseif vim.g.rplugin then
		start_r()
	else
		create_or_show(type)
	end
end

--[[ function M.resize()
  if is_open() then
    vim.bo[terminal.bufnum]
  end ]]

utils.augroup(
	{
		{'BufWinEnter,WinEnter,TermOpen', 'term://*', 'startinsert'},

		--[[ {'WinEnter', 'term://*', 'resize 10'},
    {'WinLeave', 'term://*', 'resize 5'}, ]]
	},
	'terminal'
)

return M
