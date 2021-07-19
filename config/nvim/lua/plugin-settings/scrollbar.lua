vim.g.scrollbar_shape = {head = ' ', body = ' ', tail = ' '}
vim.g.scrollbar_highlight = {
	head = 'Scrollbar',
	body = 'Scrollbar',
	tail = 'Scrollbar'
}
vim.g.scrollbar_right_offset = 0

vim.cmd([[
  augroup ScrollbarInit
  autocmd!
  autocmd CursorMoved,VimResized,QuitPre * silent! lua require('scrollbar').show()
  autocmd WinEnter,FocusGained           * silent! lua require('scrollbar').show()
  autocmd WinLeave,BufLeave,BufWinLeave,FocusLost            * silent! lua require('scrollbar').clear()
  augroup end
]])
