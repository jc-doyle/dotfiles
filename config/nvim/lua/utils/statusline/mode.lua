local M = {}

M.colors = {
	n = 'base8',
	i = 'base9',
	v = 'base10',
	r = 'base11',
	c = 'base11',
	t = 'base10',
	s = 'base8',
}

local mode_icons = {
	['n'] = '   ',
	['i'] = '   ',
	['s'] = '   ',
	['v'] = '   ',
	['r'] = '   ',
	['c'] = '   ',
	['t'] = '   ',
}

local alias = {
	n = 'n',
	no = 'n',
	nov = 'n',
	noV = 'n',
	['no'] = 'n',
	niI = 'n',
	niR = 'n',
	niV = 'n',
	v = 'v',
	V = 'v',
	[''] = 'v',
	s = 's',
	S = 's',
	[''] = 's',
	['!'] = 's',
	i = 'i',
	ic = 'i',
	ix = 'i',
	R = 'r',
	Rc = 'r',
	Rv = 'r',
	Rx = 'r',
	r = 'r',
	rm = 'r',
	['r?'] = 'r',
	c = 'c',
	cv = 'c',
	ce = 'c',
	t = 't',
	['null'] = 't',
}

function M.get_mode()
	return alias[vim.fn.mode()]
end

function M.get_mode_color()
	return M.colors[M.get_mode()]
end

-- String to title case
local function title_case(str)
	return string.gsub(string.lower(str), '%a', string.upper, 1)
end

function M.get_mode_highlight_name()
	return 'Status' .. title_case(M.get_mode())
end

function M.print_mode()
	return "  " .. mode_icons[M.get_mode()] .. " "
end

return M
