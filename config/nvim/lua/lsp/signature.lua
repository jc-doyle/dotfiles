require 'lsp_signature'.setup({
	doc_lines = 0,
	max_width = 100,
	padding = ' ',
	fix_pose = true,
	hi_parameter = 'LspSignature',
	hint_enable = false,
	handler_opts = {
		border = 'none'
		-- double, single, shadow, none
	},
})
