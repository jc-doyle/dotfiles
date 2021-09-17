local config = {}

local g = vim.g
local utils = require 'utils.general'

g.R_rconsole_width = 0
g.R_rconsole_height = 10
g.R_hl_term = 0
g.R_clear_line = 1
g.R_close_term = 1
g.R_auto_start = 0
g.R_auto_omni = { "r",  "rmd", "rnoweb", "rhelp", "rrst" }

utils.augroup(
	{
		{'FileType', 'rdoc', 'setlocal nonu nornu'},
		{'TermOpen', '*', 'setlocal nonu nornu'}
	},
	'r'
)

return config
