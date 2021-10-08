vim.g.UltiSnipsSnippetDirectories = {"snippet"}
vim.g.UltiSnipsRemoveSelectModeMappings = 0
vim.g.UltiSnipsExpandTrigger = "<A-S-N>"
vim.g.UltiSnipsJumpForwardTrigger = "<A-S-N>"
vim.g.UltiSnipsJumpBackwardTrigger = "<A-S-P>"

-- Mappings for $VISUAL placeholder
vim.cmd([[exec "xnoremap <silent> <CR> :call UltiSnips#SaveLastVisualSelection()<cr>gvs"]])
vim.cmd([[exec "xnoremap <silent> <Tab> :call UltiSnips#SaveLastVisualSelection()<cr>gvs"]])

