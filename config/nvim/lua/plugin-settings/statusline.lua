local colors = require('../colors/colors')
local mode = require('../utils/statusline/mode')
local lsp = require('../utils/statusline/lsp')

local components = {
	left = {active = {}, inactive = {}},
	mid = {active = {}, inactive = {}},
	right = {active = {}, inactive = {}}
}

-- Vi Mode
table.insert(components.left.active, {
	provider = function()
		return mode.print_mode()
	end,

	hl = function()
		local val = {}
		val.name = mode.get_mode_highlight_name()
		val.fg = 'base0'
		val.bg = mode.get_mode_color()
		return val
	end,
})

-- LSP Indicator
table.insert(components.left.active, {
	provider = function()
		return lsp.icon()
	end,

	hl = function()
		local val = {}
		val.bg = 'base0'
		val.fg = 'base5'
		return val
	end,

	right_sep = {
		str = "|",
		hl = {fg = 'base2'},
	},

	enabled = function()
		return lsp.is_active()
	end
})

-- Folder Name
table.insert(components.left.active, {
	provider = function()
		return '  ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
	end,
	hl = function()
		local val = {}
		val.fg = 'base4'
		return val
	end,
})

table.insert(components.mid.active, {
	provider = lsp.diagnostic_info,
	hl = function()
		local val = {}
		val.fg = 'base5'
		return val
	end,
	enabled = function()
		return lsp.is_active() and lsp.diagnostics_exist("Information")
	end
})

table.insert(components.mid.active, {
	provider = lsp.diagnostic_hints,
	hl = function()
		local val = {}
		val.fg = 'base3'
		return val
	end,
	enabled = function()
		return lsp.is_active() and lsp.diagnostics_exist("Hint")
	end
})

table.insert(components.mid.active, {
	provider = lsp.diagnostic_warnings,
	hl = function()
		local val = {}
		val.fg = 'base01'
		return val
	end,
	enabled = function()
		return lsp.is_active() and lsp.diagnostics_exist("Warning")
	end
})

table.insert(components.mid.active, {
	provider = lsp.diagnostic_errors,
	hl = function()
		local val = {}
		val.fg = 'base9'
		return val
	end,
	enabled = function()
		return lsp.is_active() and lsp.diagnostics_exist("Error")
	end
})

-- Git Info
table.insert(components.right.active, {
	provider = function()
		local gsd = vim.b.gitsigns_status_dict

		if gsd and gsd.head and #gsd.head > 0 then
			return gsd.head .. '  '
		else
			return ''
		end
	end,
	hl = function()
		local val = {}
		val.fg = 'base4'
		return val
	end,
})

-- Line %
table.insert(components.right.active, {
	provider = function()
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
	end,
	hl = function()
		local val = {}
		val.name = mode.get_mode_highlight_name()
		val.fg = 'base0'
		val.bg = mode.get_mode_color()
		return val
	end,
})

table.insert(components.left.inactive, {
	provider = function()
		return "      "
	end,

	hl = function()
		local val = {}
		val.fg = 'base0'
		val.bg = 'base1'
		return val
	end,
})

table.insert(components.left.inactive, {
	provider = function()
		return ""
	end,

	hl = function()
		local val = {}
		val.fg = 'base1'
		val.bg = 'base0'
		val.style = 'strikethrough'
		return val
	end,
})

table.insert(components.mid.inactive, {
	provider = function()
		return ""
	end,
	hl = function()
		local val = {}
		val.fg = 'base1'
		val.bg = 'base0'
		val.style = 'strikethrough'
		return val
	end,
})

table.insert(components.right.inactive, {
	provider = function()
		local curr_line = vim.fn.line('.')
		local lines = vim.fn.line('$')

		local percent = vim.fn.round(curr_line / lines * 100)

		if percent < 10 then
			return "      "
		elseif percent > 95 then
			return "      "
		else
			return string.format('  %2d%%%%  ', percent)
		end
	end,
	hl = function()
		local val = {}
		val.fg = 'base0'
		val.bg = 'base1'
		return val
	end,
})

local properties = {
	force_inactive = {
		filetypes = {'packer', 'NvimTree'},
		buftypes = {'terminal'},
		bufnames = {}
	}
}

require('feline').setup({
	default_bg = colors.base0,
	default_fg = colors.base4,
	colors = colors,
	components = components,
	properties = properties,
})

vim.cmd([[
  autocmd BufEnter,FileType NvimTree,Outline setlocal statusline=%#Normal#
]])
