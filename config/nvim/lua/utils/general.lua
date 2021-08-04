local M = {}

-- Create augroup
function M.augroup(autocmds, name)
	vim.cmd('augroup ' .. name)
	vim.cmd('autocmd!')

	for _, autocmd in ipairs(autocmds) do
		vim.cmd('autocmd ' .. table.concat(autocmd, ' '))
	end

	vim.cmd('augroup END')
end

function M.autocmd(event, pattern, cmd)
	vim.cmd('autocmd ' .. event .. ' ' .. pattern .. ' ' .. cmd)
end

return M
