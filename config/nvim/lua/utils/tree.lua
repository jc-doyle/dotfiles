M = {}

local bufferline = require('bufferline.state')
local tree = require('nvim-tree.view')

function M.toggle()
	if tree.win_open() then
		tree.close()
		bufferline.set_offset(0)
	else
		bufferline.set_offset(30)
		require 'nvim-tree'.find_file(true)
	end
end

return M
