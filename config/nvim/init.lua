vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.vim_in_focus = true
vim.g.vsnip_snippet_dir = vim.fn.stdpath('config')..'/snippets'
vim.g.loaded_netrw = 0

require "plugins"
require "settings"
require "mappings"
require "statusline"

-- colorscheme
vim.cmd('colorscheme default')

