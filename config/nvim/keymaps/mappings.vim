" <TAB>: completion.
inoremap <expr><S-TAB> pumvisible() ? "\<C-n>" : "\<S-TAB>"

if exists(":Tabularize")
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  " nmap <Leader>a\ :Tabularize /|<CR>
  " vmap <Leader>a\ :Tabularize /|<CR>
endif

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()



" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> rn <Plug>(coc-rename)


" Spelling Correction
inoremap <C-l> <c-g>u<esc>[s1z=`]a<c-g>u

" scroll through autocomplete in commandline tab-menu
cnoremap <C-j> <C-n>
cnoremap <C-k> <C-p>

"Quickly insert an empty new line without entering insert mode
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>

" Highlighting
nnoremap <Leader>ah :echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')<CR>

"Better nav for omnicomplete
inoremap <expr> <c-j> ("\<C-n>")
inoremap <expr> <c-k> ("\<C-p>")

" Use alt + hjkl to resize windows
nnoremap <M-j>    :resize -2<CR>
nnoremap <M-k>    :resize +2<CR>
nnoremap <M-h>    :vertical resize -2<CR>
nnoremap <M-l>    :vertical resize +2<CR>

" Easy CAPS
inoremap <c-u> <ESC>viwUi
nnoremap <c-u> viwU<Esc>

" TAB in general mode will move to text buffer
nnoremap <silent> <TAB> :BufferNext<CR>
nnoremap <silent> <s-TAB> :BufferPrevious<CR>

nnoremap <silent>    <A-TAB> :BufferPick<CR>

nnoremap <silent>    <A-.> :BufferMoveNext<CR>
nnoremap <silent>    <A-,> :BufferMovePrevious<CR>

nnoremap <silent>    <A-q> :BufferClose<CR>

" Alternate way to save
nnoremap <C-s> :w<CR>
" Alternate way to quit
nnoremap <C-Q> :wq!<CR>

" Better tabbing
vnoremap < <gv
vnoremap > >gv
