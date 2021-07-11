let g:NERDTreeDirArrowExpandable = ' '
let g:NERDTreeDirArrowCollapsible = ' '
let g:NERDTreeMinimalMenu=0
let g:NERDTreeMinimalUI=1
let g:NERDTreeWinSize=35
let g:NERDTreeWinPos="right"
let g:NERDTreeStatusline = '%#NonText#'
let g:NERDTreeQuitOnOpen =1 

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif
