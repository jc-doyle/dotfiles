local cmp = require 'cmp'

local feedkey = function(key, mode)
	vim.fn.feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode)
end

vim.api.nvim_set_keymap(
	'i',
	'<CR>',
	'v:lua.MPairs.autopairs_cr()',
	{expr = true, noremap = true}
)


local M = {
	["<CR>"] = cmp.mapping(
		function(fallback)
			if (vim.fn["UltiSnips#CanExpandSnippet"]() == 1 or vim.fn[
				"UltiSnips#CanJumpForwards"
			]() == 1) then
				feedkey("<A-S-N>", "i")
			else
				fallback()
			end
		end,
		{"i", "s"}
	),


	["<S-CR>"] = cmp.mapping(
		function(fallback)
			if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
				feedkey("<A-S-P>", "i")
			else
				fallback()
			end
		end,
		{"i", "s"}
	),

	["<Tab>"] = function()
		if vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
			feedkey("<A-S-N>", "i")
		elseif vim.fn.pumvisible() == 1 then
			feedkey("<C-Space>", "i")
		else
			feedkey("<Tab>", "n")
		end
	end,

	["<S-Tab>"] = function()
		if vim.fn.pumvisible() == 1 then
			feedkey("<C-Space>", "i")
		else
			feedkey("<Tab>", "n")
		end
	end,

	['<C-Space>'] = cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Insert, select = true}),

	["<C-j>"] = cmp.mapping(
		function(fallback)
			if vim.fn.pumvisible() == 1 then
				feedkey("<C-n>", "n")
			else
				fallback()
			end
		end,
		{"i", "s"}
	),

	["<C-k>"] = cmp.mapping(
		function(fallback)
			if vim.fn.pumvisible() == 1 then
				feedkey("<C-p>", "n")
			else
				fallback()
			end
		end,
		{"i", "s"}
	),
}

return M
