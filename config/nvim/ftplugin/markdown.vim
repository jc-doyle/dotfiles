setlocal conceallevel=2
setlocal textwidth=80
nmap <buffer><silent> <leader>i <Plug>(mkdx-text-italic-n)
vmap <buffer><silent> <leaver>i <Plug>(mkdx-text-italic-v)

nmap <buffer><silent> <C-b> <Plug>(mkdx-text-bold-n)
vmap <buffer><silent> <C-b> <Plug>(mkdx-text-bold-v)

nmap <buffer><silent> <C-l> <Plug>(mkdx-indent)
vmap <buffer><silent> <C-l> <Plug>(mkdx-indent)
nmap <buffer><silent> <C-h> <Plug>(mkdx-unindent)

nmap <buffer><silent> <C-c> <Plug>(mkdx-toggle-checklist-n)
vmap <buffer><silent> <C-c> <Plug>(mkdx-toggle-checklist-v)

nmap <buffer><silent> <C-x> <Plug>(mkdx-checkbox-next-n)
vmap <buffer><silent> <C-x> <Plug>(mkdx-checkbox-next-v)

vmap <buffer><silent> <C-x> <Plug>(mkdx-checkbox-next-v)
let g:which_key_map.b = 'bold'
