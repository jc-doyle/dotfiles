local actions = require('telescope.actions')

-- A no preview theme (Dropdown)
local no_preview = {
	results_title = false,
	layout_strategy = "vertical",
	layout_config = {
		preview_cutoff = 400,
		width = function(_, max_columns, _)
			return math.min(max_columns - 10, 80)
		end,
		height = function(_, _, max_lines)
			return math.min(max_lines - 8, 25)
		end,
	},
}

local preview = {
	results_title = false,
	preview_title = false,
	layout_strategy = "flex",
	layout_config = {
		preview_cutoff = 1,
		width = function(_, max_columns, _)
			return math.min(max_columns - 10, 80)
		end,
		height = function(_, _, max_lines)
			return math.min(max_lines - 6, 30)
		end,
	},
}

require('telescope').setup {
	defaults = {
		vimgrep_arguments = {
			'rg',
			'--color=never',
			'--no-heading',
			'--with-filename',
			'--line-number',
			'--column',
			'--smart-case'
		},
		prompt_prefix = " ⊳ ",
		selection_caret = " ⊳ ",
		entry_prefix = "  ",
		initial_mode = "insert",
		selection_strategy = "reset",
		sorting_strategy = "ascending",
		layout_strategy = "flex",
		layout_config = {
			horizontal = {mirror = true},
			vertical = {mirror = true},
		},
		file_sorter = require 'telescope.sorters'.get_fuzzy_file,
		file_ignore_patterns = {},
		generic_sorter = require 'telescope.sorters'.get_generic_fuzzy_sorter,
		winblend = 2,
		border = {},
		borderchars = {'─', '│', '─', '│', '┌', '┐', '┘', '└'},
		color_devicons = false,
		use_less = true,
		path_display = {},
		set_env = {['COLORTERM'] = 'truecolor'},

		-- default = nil,
		file_previewer = require 'telescope.previewers'.vim_buffer_cat.new,
		grep_previewer = require 'telescope.previewers'.vim_buffer_vimgrep.new,
		qflist_previewer = require 'telescope.previewers'.vim_buffer_qflist.new,

		-- Developer configurations: Not meant for general override
		buffer_previewer_maker = require 'telescope.previewers'.buffer_previewer_maker,
		mappings = {
			i = {
				["<esc>"] = actions.close,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<tab>"] = actions.move_selection_worse,
				["<S-tab>"] = actions.move_selection_better,
				["<C-l>"] = actions.toggle_selection,
			},
		}
	},
	pickers = {
		oldfiles = no_preview,
		command_history = no_preview,
		search_history = no_preview,
		keymaps = no_preview,
		vim_options = no_preview,
		help_tags = no_preview,
		buffers = no_preview,
		registers = no_preview,
		find_files = preview,
	}
}
