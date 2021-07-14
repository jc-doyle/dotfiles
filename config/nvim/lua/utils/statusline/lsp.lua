local M = {}

function M.is_active()
	if next(vim.lsp.buf_get_clients()) ~= nil then
		return true
	else
		return false
	end
end

function M.icon()
	-- return " 歷 "
	return "  "
end

return M
