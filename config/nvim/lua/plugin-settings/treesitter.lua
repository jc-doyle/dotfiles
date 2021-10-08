require 'nvim-treesitter.configs'.setup {
	ensure_installed = "maintained",
  autopairs = {enable = true},
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


-- nvim-treesitter/queries/python/injections.scm, with docstring
-- injections removed
local py_injections = [[
((call
  function: (attribute object: (identifier) @_re)
  arguments: (argument_list (string) @regex))
 (#eq? @_re "re")
 (#match? @regex "^r.*"))

(comment) @comment
]]
vim.treesitter.set_query('python', 'injections', py_injections)
