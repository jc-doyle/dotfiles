local options = {noremap = true, silent = true}

local function map(mode, lhs, rhs)
  rhs = '<cmd>'.. rhs .. '<cr>'
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Buffer Related
map('n', '<TAB>', 'BufferNext')
map('n', '<s-TAB>', 'BufferPrevious')
map('n', '<A-TAB>', 'BufferPick')
map('n', '<TAB>', 'BufferNext')
map('n', '<A-,>', 'BufferMoveNext')
map('n', '<A-.>', 'BufferMovePrevious')

map('n', '<C-q>', 'lua require"utils.close".close()')

-- Window Movement
map('n', '<S-A-j>', 'resize +1')
map('n', '<S-A-k>', 'resize -1')
map('n', '<S-A-l>', 'vertical resize +1')
map('n', '<S-A-h>', 'vertical resize -1')

map('n', '<A-j>', 'wincmd j')
map('n', '<A-k>', 'wincmd k')
map('n', '<A-l>', 'wincmd l')
map('n', '<A-h>', 'wincmd h')

map('n', '<C-A-j>', 'resize 28')
map('n', '<C-A-k>', 'resize 8')

map('t', '<A-k>', 'wincmd k')
map('t', '<C-A-k>', 'resize 25')
map('t', '<C-A-j>', 'resize 8')

map('n', '<A-v>', 'vsp')
map('n', '<A-n>', 'sp')

-- Terminal
map('n', '<C-Enter>', 'lua require "utils.terminal".toggle("terminal")')
map('t', '<C-Enter>', 'lua require "utils.terminal".toggle("terminal")')
-- map('t', '<leader>q', 'lua require "utils.terminal".toggle()')

map('n', '<C-Bslash>', 'lua require "utils.terminal".toggle("shell")')
map('t', '<C-Bslash>', 'lua require "utils.terminal".toggle("shell")')

-- map('t', '<leader>D', 'lua require "dap".step_over()')
map('t', '<C-n>', 'stopinsert')

-- Saving/Quitting
map('n', '<C-s>', 'w')

-- Open Link
map('n', 'gx', 'call jobstart(["xdg-open", expand("<cfile>")])')

