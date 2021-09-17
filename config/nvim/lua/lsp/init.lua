local lsp = require 'lspconfig'

local servers = {
	lua = 'sumneko_lua',
	go = 'gopls',
	java = 'jdtls',
	python = 'pyright',
	r = 'r_language_server',
	json = 'jsonls',
	sh = 'bashls',
	zsh = 'bashls',
	latex = 'texlab'
}

local on_attach = function(client, bufnr)
	require 'mappings.lsp'.set(client, bufnr)
end

for language, name in pairs(servers) do
	local setup_path = 'lsp.servers.' .. language
	local config = require(setup_path)

  if config.capabilities then
    config.capabilities =  require('cmp_nvim_lsp').update_capabilities(config.capabilities)
  else
    config.capabilities =  require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
 end

	config.on_attach = on_attach

	lsp[name].setup(config)
end

require 'lsp.signature'
require 'lsp.ui'
