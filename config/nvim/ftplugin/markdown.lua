vim.wo.foldcolumn = "0"
vim.o.foldtext = "v:lua.require\'utils.fold\'.text()"
vim.bo.synmaxcol = 1000

vim.cmd([[
  augroup pandoc_syntax
    au! BufNewFile,BufFilePre,BufRead,BufWinEnter *.md set syntax=markdown.pandoc
  augroup END
]])

vim.cmd("let g:pandoc#syntax#conceal#urls=1")
vim.cmd('SoftPencil')
