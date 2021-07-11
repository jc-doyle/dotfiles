" Lightline
let g:lightline = {
      \ 'colorscheme': 'base16',
      \ 'active': {
      \   'left': [ [ 'mode' ],
      \             [ 'filename' ] ],
      \   'right': [ 
      \              [ 'percent' ],
      \              [ 'filetype'] ]
      \ }, 
      \ 'inactive': {
      \   'left': [ [ 'mode' ],
      \             [ 'filename' ] ],
      \   'right': [ 
      \              [ 'percent' ],
      \              [ 'filetype'] ]
      \ }, 
      \ 'tabline': {
      \   'left': [ ['buffers'] ],
      \   'right': [ [] ]
      \ },
      \ 'component': {
	    \ 'mode': '  %{lightline#mode()}  ',
      \ 'percent': ' %2p%% '  
      \ }, 
      \ 'component_expand': {
      \   'buffers': 'lightline#bufferline#buffers'
      \ },
      \ 'component_type': {
      \   'buffers': 'tabsel'
      \ },
      \ }

let g:lightline.tabline_subseparator = { 'left': '', 'right': '' }
let g:lightline.component_raw = {'buffers': 1}
let g:lightline#bufferline#clickable = 1
let g:lightline#bufferline#more_buffers = '⋯ '
let g:lightline#bufferline#modified = ' ⋅'
let g:lightline#bufferline#unnamed = ' ▫  '
" let g:lightline#bufferline#unicode_symbols = 1

let g:lightline.mode_map = {
    \ 'n' : 'N',
    \ 'i' : 'I',
    \ 'R' : 'R',
    \ 'v' : 'V',
    \ 'V' : 'V',
    \ "\<C-v>": 'V',
    \ 'c' : 'C',
    \ 's' : 'S',
    \ 'S' : 'S',
    \ "\<C-s>": 'S',
    \ 't': 'T',
    \ }
