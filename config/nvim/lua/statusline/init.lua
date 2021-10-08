-- A groovy status line

-- Sources
local s = require 'statusline.components'

local utils = require 'statusline.utils'
local autogroup = require 'utils.general'.augroup

local M = {}

local none = {
	buftypes = {'terminal', 'quickfix'},
	filetypes = {'Outline', 'NvimTree', 'Trouble'},
	bufnames = {"Object_Browser"}
}

local function component(hlname, source)
	if source then
		return '%#' .. hlname .. '#' .. source
	end
	return '%#' .. hlname .. '#'
end

local function generate(context)
	local active = {left = {}, center = {}, right = {}}
	local inactive = {left = {}, center = {}, right = {}}

	active.left = {
		component(utils.mode_hl(), s.mode()),
		component('Normal'),
		component('StHint', s.folder())
	}

	active.center = {
		component('StError', s.diag_errors()),
		component('StWarn', s.diag_warnings()),
		component('StHint', s.diag_hints()),
		component('StInfo', s.diag_info())
	}

	active.right = {
		component('StHint', s.git_branch()),
		component('StHint', s.lsp_active()),
		component(utils.mode_hl(), s.percent())
	}

	inactive.left = {component('StInactive', s.mode()), component('StLine')}
	inactive.center = {component('StLine')}
	inactive.right = {component('StLine'), component('StInactive', s.percent())}

	local statusline = {}

	if context.inactive or not vim.g.vim_in_focus then
		statusline = inactive
	else
		statusline = active
	end

	if context.width < 40 then
		return string.format(
			"%s%%=%s",
			statusline.left[1] .. statusline.left[2],
			statusline.right[2]
		)
	elseif context.width < 80 and not context.inactive then
		return string.format(
			"%s%%=%s",
			table.concat(statusline.left),
			table.concat(statusline.right)
		)
	else
		return string.format(
			"%s%%=%s%%=%s",
			table.concat(statusline.left),
			table.concat(statusline.center),
			table.concat(statusline.right)
		)
	end
end

local function is_forced_none(context)
	local forced_none = none

	local buftype = context.buftype
	local filetype = context.filetype
	local bufname = context.bufname

	return vim.tbl_contains(forced_none.buftypes, buftype) or vim.tbl_contains(
		forced_none.filetypes,
		filetype
	) or vim.tbl_contains(forced_none.bufnames, bufname)
end

function M.print()
	local curwin = vim.g.statusline_winid or 0
	local curbuf = vim.api.nvim_win_get_buf(curwin)

	local context = {
		bufnum = curbuf,
		winid = curwin,
		bufname = vim.fn.bufname(curbuf),
		readonly = vim.bo[curbuf].readonly,
		filetype = vim.bo[curbuf].ft,
		buftype = vim.bo[curbuf].bt,
		fileformat = vim.bo[curbuf].fileformat,
		shiftwidth = vim.bo[curbuf].shiftwidth,
		width = vim.api.nvim_win_get_width(curwin),
		inactive = vim.api.nvim_get_current_win() ~= curwin
	}

	if is_forced_none(context) then
		return '%#StatusLineNC#'
	else
		return generate(context)
	end
end

vim.o.statusline = '%!v:lua.require\'statusline\'.print()'

autogroup(
	{
		{
			'TermEnter,WinEnter,BufEnter,WinLeave,BufLeave',
			'*',
			'lua vim.wo.statusline=require"statusline".print()'
		},
		{
			'BufWinEnter',
			'quickfix',
			'lua vim.wo.statusline=require"statusline".print()'
		},
		{'WinEnter,BufEnter', '*', 'set statusline<'},
		{'FocusGained', '*', 'let g:vim_in_focus = v:true'},
		{'FocusLost', '*', 'let g:vim_in_focus = v:false'},
	},
	'statusline'
)

return M
