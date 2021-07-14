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

map("n", "gc", "<cmd>CommentToggle<CR>")

-- Saving/Quitting
map("n", "<C-s>", ":w<CR>")

local wk = require("which-key")

-- As an example, we will the create following mappings:
--  * <leader>ff find files
--  * <leader>fr show recent files
--  * <leader>fb Foobar
-- we'll document:
--  * <leader>fn new file
--  * <leader>fe edit file
-- and hide <leader>1

wk.register(
	{
		r = {"<cmd>FloatermNew --height=0.9 --width=0.9 lf<cr>", "lf"},
		e = {"<cmd>NvimTreeToggle<cr>", "tree"},
		q = {"<cmd>bdelete<cr>", "close buffer"},
		c = {"", "clear search"},
	},
	{prefix = "<leader>"}
)
