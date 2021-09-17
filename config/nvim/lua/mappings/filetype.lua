local utils = require 'utils.general'
local options = {noremap = true, silent = true}

local function bmap(mode, lhs, rhs)
	vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, options)
end

local M = {}

function M.r()
	bmap('n', '<C-Bslash>', '<cmd>call SendLineToR("stay")<cr>')
	bmap('n', '<S-Bslash>', '<cmd>call SendParagraphToR("echo", "stay")<cr>')
	bmap('n', '<leader>o', '<cmd>call RObjBrowser()<cr>')
	bmap('n', '<S-k>', '<cmd>call RObjBrowser()<cr>')
end

function M.java()
	bmap('n', '<leader>lc', '<cmd>lua require("jdtls").code_action()<cr>')
	bmap('n', '<A-CR>', '<cmd>lua require("jdtls").code_action()<cr>')
	bmap('i', '<A-CR>', '<cmd>lua require("jdtls").code_action()<cr>')
end

utils.augroup(
	{
		{'FileType', 'r,rmd', 'lua require"mappings.filetype".r()'},
		{'FileType', 'java', 'lua require"mappings.filetype".java()'},
	},
	"filetype_mappings"
)

return M
