local cmp = require 'cmp'
local apairs = require 'nvim-autopairs'

vim.api.nvim_set_keymap(
	'i',
	'<C-i>',
	'v:lua.MPairs.autopairs_cr()',
	{expr = true, noremap = true}
)
local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(
		vim.api.nvim_replace_termcodes(key, true, true, true),
		mode,
		true
	)
end

local M = {
	["<CR>"] = cmp.mapping(
		function(fallback)
			if vim.fn["vsnip#available"]() == 1 then
				feedkey("<Plug>(vsnip-expand-or-jump)", "")
			else
				fallback()
			end
		end,
		{"i", "s"}
	),

	["<S-CR>"] = cmp.mapping(
		function(fallback)
			if vim.fn["vsnip#jumpable"](-1) == 1 then
				feedkey("<Plug>(vsnip-jump-prev)", "")
			else
				fallback()
			end
		end,
		{"i", "s"}
	),

	["<Tab>"] = function()
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

vim.api.nvim_set_keymap(
	'i',
	'<CR>',
	'v:lua.MPairs.autopairs_cr()',
	{expr = true, noremap = true}
)

return M
