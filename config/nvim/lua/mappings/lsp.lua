local M = {}

function M.set(client, bufnr)
	local function map(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end

	-- Mappings.
	local opts = {noremap = true, silent = true}
	map('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	map('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)

	map('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
	map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	map('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	map('n', 'T', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	map('n', 'rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	map('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
	map('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

	-- Set some keybinds conditional on server capabilities
	if client.resolved_capabilities.document_formatting then
		map("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
	end
end

return M
