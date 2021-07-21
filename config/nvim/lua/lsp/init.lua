require('lsp.lightbulb')

local on_attach = function(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	-- Mappings.
	local opts = {noremap = true, silent = true}
	buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)

	buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	buf_set_keymap(
		'n',
		'<C-k>',
		'<cmd>lua vim.lsp.buf.signature_help()<CR>',
		opts
	)
	buf_set_keymap('n', 'T', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	buf_set_keymap('n', 'rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap(
		'n',
		'[d',
		'<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',
		opts
	)
	buf_set_keymap(
		'n',
		']d',
		'<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',
		opts
	)

	-- Set some keybinds conditional on server capabilities
	if client.resolved_capabilities.document_formatting then
		buf_set_keymap(
			"n",
			"<space>f",
			"<cmd>lua vim.lsp.buf.formatting()<CR>",
			opts
		)
	elseif client.resolved_capabilities.document_range_formatting then
		buf_set_keymap(
			"n",
			"<space>f",
			"<cmd>lua vim.lsp.buf.range_formatting()<CR>",
			opts
		)
	end

	-- Set autocommands conditional on server_capabilities
	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_exec(
			[[
    augroup lsp_document_highlight
    autocmd! * <buffer>
    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]],
			false
		)
	end
end

-- config that activates keymaps and enables snippet support
local function make_config()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	return {
		-- enable snippet support
		capabilities = capabilities,

		-- map buffer local keybindings when the language server attaches
		on_attach = on_attach,
	}
end

-- Server Config
local function setup_servers()
	require 'lspinstall'.setup()

	-- get all installed servers
	local servers = require 'lspinstall'.installed_servers()

	-- ... and add manually installed servers

	for _, server in pairs(servers) do
		local config = make_config()

		-- language specific config
		if server == "lua" then
			config.settings = require("lsp/servers/lua")
		end
		require 'lspconfig' [server].setup(config)
	end
end

-- Setup Servers
setup_servers()

-- UI Settings
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics,
	{
		underline = true,
		signs = false,
		virtual_text = {prefix = "▩ ", spacing = 2},
		update_in_insert = false
	}
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
	vim.lsp.handlers.signature_help,
	{border = "single"}
)

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
	vim.lsp.handlers.hover,
	{border = "single"}
)

vim.lsp.handlers["textDocument/definition"] = vim.lsp.with(
	vim.lsp.handlers.implementation,
	{border = "single"}
)

vim.lsp.handlers["textDocument/implementation"] = vim.lsp.with(
	vim.lsp.handlers.implementation,
	{border = "single"}
)

vim.lsp.handlers["textDocument/typeDefinition"] = vim.lsp.with(
	vim.lsp.handlers.implementation,
	{border = "single"}
)

vim.lsp.protocol.CompletionItemKind = {
	" Text",
	" Method",
	" Function",
	" Constructor",
	"פּ Field",
	" Variable",
	" Class",
	" Interface",
	" Module",
	"襁Property",
	" Unit",
	" Value",
	"練Enum",
	" Keyword",
	" Snippet",
	" Color",
	" File",
	" Reference",
	" Folder",
	" EnumMember",
	" Constant",
	"ﳤ Struct",
	" Event",
	" Operator",
	" TypeParameter",
}
