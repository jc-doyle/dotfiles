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

-- Git Info
table.insert(components.right.active, {
	provider = 'git_branch',
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

local properties = {
	force_inactive = {
		filetypes = {
			'NvimTree',
			'packer',
		},
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
