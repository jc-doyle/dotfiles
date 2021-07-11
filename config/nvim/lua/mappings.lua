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

map("n", "<leader>r", ":FloatermNew lf<CR>")

-- Saving/Quitting
map("n", "<C-s>", ":w<CR>")
