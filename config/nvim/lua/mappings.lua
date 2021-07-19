local function map(mode, lhs, rhs)
	local options = {noremap = true, silent = true}
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Buffer Related
map("n", "<TAB>", ":BufferNext<CR>")

map("n", "<s-TAB>", ":BufferPrevious<CR>")
map("n", "<A-TAB>", ":BufferPick<CR>")
map("n", "<TAB>", ":BufferNext<CR>")
map("n", "<A-,>", ":BufferMoveNext<CR>")
map("n", "<A-.>", "BufferMovePrevious<CR>")
map("n", "<C-q>", ":BufferClose<CR>")

map("n", "<S-A-j>", "<cmd>resize +1<CR>")
map("n", "<S-A-k>", "<cmd>resize -1<CR>")
map("n", "<S-A-l>", "<cmd>vertical resize +1<CR>")
map("n", "<S-A-h>", "<cmd>vertical resize -1<CR>")

map("n", "<A-j>", "<cmd>wincmd j<CR>")
map("n", "<A-k>", "<cmd>wincmd k<CR>")
map("n", "<A-l>", "<cmd>wincmd l<CR>")
map("n", "<A-h>", "<cmd>wincmd h<CR>")
map("n", "<A-n>", ":vsp<CR>")

-- Saving/Quitting
map("n", "<C-s>", ":w<CR>")

-- Completion
vim.cmd 'inoremap <expr> <c-j> ("\\<C-n>")'
vim.cmd 'inoremap <expr> <c-k> ("\\<C-p>")'
vim.cmd 'cnoremap <expr> <c-j> ("\\<C-n>")'
vim.cmd 'cnoremap <expr> <c-k> ("\\<C-p>")'

vim.cmd 'inoremap <silent><expr> <Tab> compe#confirm("<Tab>")'

vim.cmd 'inoremap <silent><expr> <C-f> compe#scroll({ "delta": +4 })'
vim.cmd 'inoremap <silent><expr> <C-d> compe#scroll({ "delta": -4 })'

vim.cmd([[imap <expr> <Tab> pumvisible() ? compe#confirm('<Tab>') : vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<Tab>"]])

vim.cmd 'smap <expr> <Tab>   vsnip#jumpable(1)  ? "<Plug>(vsnip-jump-next)" : "<Tab>"'
vim.cmd 'smap <expr> <S-Tab> vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<S-Tab>"'
vim.cmd 'imap <expr> <S-Tab> vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<S-Tab>"'

local wk = require("which-key")
vim.cmd([[nnoremap <Leader>ah :echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')<CR>]])

-- Which Key
wk.register(
	{
		r = {"<cmd>FloatermNew --height=0.9 --width=0.9 lf<cr>", "lf"},
		e = {"<cmd>lua require('utils.tree').toggle()<cr>", "tree"},
		q = {"<cmd>:bd!<cr>", "close buffer"},
		c = {"", "clear search"},
		o = {"<cmd>SymbolsOutline<cr>", "outline"},
		a = {
			name = "+actions",
			h = {"syntax highlight"},
			s = {"<cmd>so<cr>", "source"},
		},
		t = {
			name = "+treesitter",
			o = {"<cmd>TSPlaygroundToggle<cr>", "playground"},
			h = {"<cmd>TSHighlightCapturesUnderCursor<cr>", "highlight"},
		},
		p = {
			name = "+packer",
			c = {"<cmd>so | PackerCompile<cr>", "compile"},
			i = {"<cmd>so | PackerInstall<cr>", "install"},
			C = {"<cmd>so | PackerClean<cr>", "clean"},
			s = {"<cmd>PackerStatus<cr>", "status"},
		},
		g = {
			name = "+git",
			s = {"<cmd>Gitsigns toggle_signs<cr>", "signs"},
			C = {"<cmd>Git commit<cr>", "commit"},
			a = {"<cmd>Git add .<cr>", "add"},
			b = {"<cmd>Gitsigns blame_line<cr>", "line blame"},
		},
	},
	{prefix = "<leader>"}
)
