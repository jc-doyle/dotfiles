local utils = require 'statusline.utils'

local M = {}

function M.percent()
	local curr_line = vim.fn.line('.')
	local lines = vim.fn.line('$')

	local percent = vim.fn.round(curr_line / lines * 100)

	if percent < 10 then
		return "      "
	elseif curr_line == lines then
		return "      "
	else
		return string.format('  %2d%%%%  ', percent)
	end
end

function M.folder()
	return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
end

function M.readonly(context)
	if context.readonly then
		return ' ⊘ '
	else
		return '  '
	end
end

function M.mode()
	local mode_icons = {
		['n'] = '      ',
		['i'] = '      ',
		['s'] = '      ',
		['v'] = '      ',
		['r'] = '      ',
		['c'] = '      ',
		['t'] = '      ',
	}

	return mode_icons[utils.mode_alias[vim.fn.mode()]]
end

function M.diag_errors()
	if utils.diagnostics_exist('Error') then
		return '  ' .. utils.get_diagnostics_count('Error')
	else
		return ''
	end
end

function M.diag_warnings()
	if utils.diagnostics_exist('Warning') then
		return '  ' .. utils.get_diagnostics_count('Warning')
	else
		return ''
	end
end

function M.diag_hints()
	if utils.diagnostics_exist('Hint') then
		return '  ' .. utils.get_diagnostics_count('Hint')
	else
		return ''
	end
end

function M.diag_info()
	if utils.diagnostics_exist('Information') then
		return '  ' .. utils.get_diagnostics_count('Information')
	else
		return ''
	end
end

function M.git_branch()
	local gsd = vim.b.gitsigns_status_dict

	if gsd and gsd.head and #gsd.head > 0 then
		return gsd.head .. ' '
	else
		return vim.bo.filetype .. ' '
	end
end

function M.lsp_active()
	if utils.lsp_active() then
		return 'ﬕ '
	else
		return ''
	end
end
return M
