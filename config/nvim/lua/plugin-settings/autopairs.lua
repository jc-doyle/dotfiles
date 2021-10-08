local npairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')

require('nvim-autopairs').setup({
	-- will ignore alphanumeric and `.` symbol
	ignored_next_char = "[%w%.]",

	check_ts = true,
	ts_config = {
		-- it will not add a pair on that treesitter node
		lua = {'string'},
		javascript = {'template_string'},
		java = false,
	}
})

require('nvim-autopairs.completion.cmp').setup({
	map_cr = false,

	--  map <CR> on insert mode
	map_complete = true,

	-- it will auto insert `(` (map_char) after select function or method item
	auto_select = false,

	-- automatically select the first item
	insert = true,

	-- use insert confirm behavior instead of replace
	map_char = {
		-- modifies the function or method delimiter by filetypes
		all = '(',
		tex = '{'
	}
})


npairs.add_rule(Rule("*","*","markdown"))
