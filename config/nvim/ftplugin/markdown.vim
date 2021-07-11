setlocal conceallevel=2
setlocal textwidth=80
" setlocal foldmethod=expr
" setlocal foldexpr=MarkdownFold()
" Checkbox
imap <buffer><silent> <Cr> <Plug>(mkdx-enter)
map <buffer><silent> o <Plug>(mkdx-o)
nmap <buffer><silent> O <Plug>(mkdx-shift-o)

nmap <buffer><silent> <C-b> <Plug>(mkdx-text-bold-n)
vmap <buffer><silent> <C-b> <Plug>(mkdx-text-bold-v)

nmap <buffer><silent> <C-_> <Plug>(mkdx-text-italic-n)
vmap <buffer><silent> <C-_> <Plug>(mkdx-text-italic-v)


