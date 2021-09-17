local actions = require('telescope.actions')

-- A preview theme
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
    -- no preview
    results_title = false,
    layout_strategy = "vertical",
    layout_config = {
			horizontal = {mirror = true},
			vertical = {mirror = true},
      preview_cutoff = 400,
      width = function(_, max_columns, _)
        return math.min(max_columns - 10, 80)
      end,
      height = function(_, _, max_lines)
        return math.max(max_lines - 20, 12)
      end,
    },

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
		file_sorter = require 'telescope.sorters'.get_fuzzy_file,
		file_ignore_patterns = {},
		generic_sorter = require 'telescope.sorters'.get_generic_fuzzy_sorter,
		winblend = 0,
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
				-- ["<esc>"] = actions.close,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<tab>"] = actions.move_selection_worse,
				["<S-tab>"] = actions.move_selection_better,
				["<C-l>"] = actions.toggle_selection,
			},
      n = {
				["<esc>"] = actions.close,
				["<tab>"] = actions.move_selection_worse,
				["<S-tab>"] = actions.move_selection_better,
				["<C-l>"] = actions.toggle_selection,
      }
		}
	},
	pickers = {
		find_files = preview,
	}
}
