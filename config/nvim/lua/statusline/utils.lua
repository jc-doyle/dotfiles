local M = {}

M.mode_alias = {
	n = 'n',
	no = 'n',
	nov = 'n',
	noV = 'n',
	['no'] = 'n',
	niI = 'n',
	niR = 'n',
	niV = 'n',
	v = 'v',
	V = 'v',
	[''] = 'v',
	s = 's',
	S = 's',
	[''] = 's',
	['!'] = 's',
	i = 'i',
	ic = 'i',
	ix = 'i',
	R = 'r',
	Rc = 'r',
	Rv = 'r',
	Rx = 'r',
	r = 'r',
	rm = 'r',
	['r?'] = 'r',
	c = 'c',
	cv = 'c',
	ce = 'c',
	t = 't',
	['null'] = 'n',
}

function M.mode_hl()
	local mode = M.mode_alias[vim.fn.mode()]
  if mode == 'v' then
    return 'StVisual'
  elseif mode == 's' then
    return 'StSelect'
  elseif mode == 'i' then
    return 'StInsert'
  elseif mode == 'r' then
    return 'StReplace'
  elseif mode == 'c' then
    return 'StCommand'
  else
    return 'StNormal'
  end
end

function M.lsp_active()
	if next(vim.lsp.buf_get_clients()) ~= nil then
		return true
	else
		return false
	end
end

function M.icon()
	return "  "
end

function M.get_diagnostics_count(severity)
	if not M.lsp_active() then
		return nil
	end

	local bufnr = vim.api.nvim_get_current_buf()
	local active_clients = vim.lsp.buf_get_clients(bufnr)
	local count = 0

	for _, client in pairs(active_clients) do
		count = count + vim.lsp.diagnostic.get_count(bufnr, severity, client.id)
	end

	return count
end

function M.diagnostics_exist(severity)
	local diagnostics_count = M.get_diagnostics_count(severity)
	return diagnostics_count and diagnostics_count > 0
end

return M
