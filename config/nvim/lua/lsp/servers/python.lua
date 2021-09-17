local cmd = vim.fn.stdpath('data')..'/lsp/python/node_modules/.bin/pyright-langserver'

local config = {
  cmd = {cmd, '--stdio'},
}

return config
