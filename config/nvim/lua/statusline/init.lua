local components = require 'statusline.components'
local utils = require 'statusline.utils'
local autogroup = require 'utils.general'.augroup

local M = {}

local none = {buftypes = {'terminal'}, filetypes = {'Outline', 'NvimTree'}, bufnames = {}}


local function component(hlname, source)
	return '%#' .. hlname .. '#' .. source
end

local function generate(context)
  local active = {left = {}, center = {}, right = {}}
  local inactive = {left = {}, center = {}, right = {}}

	table.insert(active.left, component(utils.mode_hl(), components.mode()))
	table.insert(active.left, component('Normal', ''))
	table.insert(active.left, component('StHint', components.readonly(context)))
	table.insert(active.left, component('StHint', components.folder()))

	table.insert(inactive.center, component('StInfo', ''))
	table.insert(active.center, component('StError', components.diagnostic_errors()))
	table.insert(active.center, component('StWarn', components.diagnostic_warnings()))
	table.insert(active.center, component('StHint', components.diagnostic_hints()))
	table.insert(active.center, component('StInfo', components.diagnostic_info()))

	table.insert(active.right, component('StHint', components.git_branch()))
	table.insert(active.right, component('StHint', components.lsp_active()))
	table.insert(active.right, component(utils.mode_hl(), components.percent()))

	table.insert(inactive.left, component('StInactive', components.mode()))
	table.insert(inactive.left, component('StLine', ''))
	table.insert(inactive.center, component('StLine', ''))
	table.insert(inactive.right, component('StInactive', components.percent()))


  local statusline = {}
  if context.inactive then
    statusline = inactive
  else
    statusline = active
  end

  if context.width < 40 then
		return string.format("%s%%=%s%%=%s",
      statusline.left[1] .. statusline.left[2],
      statusline.center[1],
      statusline.right[#statusline.right])
	elseif context.width < 90 and not context.inactive then
		return string.format("%s%%=%s", table.concat(statusline.left), table.concat(statusline.right))
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
		{'WinEnter,BufEnter', '*', 'set statusline<'},
	},
	'statusline'
)

return M
