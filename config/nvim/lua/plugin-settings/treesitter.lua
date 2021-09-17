require 'nvim-treesitter.configs'.setup {
	ensure_installed = "maintained",
	highlight = {enable = true, disable = {"r"}},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = ".",
			node_incremental = ".",
			scope_incremental = "grc",
			node_decremental = ",",
		},
	},
	indent = {enable = true, disable = {"python"}},
	refactor = {highlight_definitions = {enable = true}},
	textobjects = {
		select = {
			enable = true,

			-- Automatically jump forward to textobj, similar to targets.vim 
			lookahead = true,

			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
	}
}
