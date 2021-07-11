" Map leader to which_key
nnoremap <silent> <leader> :silent WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual '<Space>'<CR>

" Create map to add keys to
let g:which_key_map =  {}
" Define a separator
let g:which_key_sep = '∈'

let g:which_key_hspace = 7


" Not a fan of floating windows for this
let g:which_key_use_floating_win = 0

" Hide status line
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler


" Single mappings
let g:which_key_map[','] = [ 'Startify'              , 'start' ]
let g:which_key_map['q'] = [ ':bd!'                  , 'quit']
let g:which_key_map['e'] = [ ':NERDTreeToggle'  , 'explorer' ]
let g:which_key_map['f'] = [ ':BLines'               , 'find' ]
let g:which_key_map['F'] = [ ':Files ~'              , 'files ~' ]
let g:which_key_map['t'] = [ ':FloatermToggle'              , 'terminal' ]
let g:which_key_map['R'] = [ ':source $MYVIMRC'      , 'format' ]
let g:which_key_map['S'] = [ ':source $MYVIMRC'      , 'source' ]
let g:which_key_map['r'] = [ ':FloatermNew --height=0.9 --width=0.9 lf', 'lf' ]
let g:which_key_map['l'] = [ ':VimtexErrors'         , 'log' ]
let g:which_key_map['o'] = 'which_key_ignore'
let g:which_key_map['O'] = 'which_key_ignore'
let g:which_key_map['c'] = [':let @/ = ""'               , 'clear seach']
let g:which_key_map['p'] = [ ':Files'              , 'Files' ]
" let g:which_key_map['c'] = [ 'VimtexCountWords'      , 'count' ]
" let g:which_key_map['u'] = [ 'UndotreeToggle'        , 'undo' ]
" let g:which_key_map[';'] = [ ':Commands'             , 'commands' ]
" let g:which_key_map['d'] = [ ':bd'                   , 'delete buffer']
" let g:which_key_map['c'] = [ ':VimtexCountWords'     , 'count' ]

" let g:which_key_map['='] = [ '<C-W>='                     , 'balance windows' ]
" let g:which_key_map['n'] = [ ':tabnew'                    , 'new buffer' ]
" let g:which_key_map['y'] = [ '<Plug>Ysurround'            , 'surround' ]
" let g:which_key_map['n'] = [ ':NERDTreeToggle'            , 'nerdtree' ]
" let g:which_key_map['p'] = [ ':Files'                     , 'search files' ]
" let g:which_key_map.f = 'float explorer'
" let g:which_key_map['h'] = [ '<C-W>s'                     , 'split below']
" let g:which_key_map.l = 'look up'
" let g:which_key_map['v'] = [ '<C-W>v'                     , 'split right']


" Group mappings

" Notes Movement
let g:which_key_map.w = {
      \ 'name' : '+go' ,
      \ 'w' : ['<Plug>(waikikiFollowLink)'           , 'forward'],
      \ 'u' : ['<Plug>(waikikiGoUp)'           , 'index'],
      \ 'h' : [':Pandoc html'           , 'to html from open'],
      \ 'l' : [':Pandoc latex'          , 'to latex from open'],
      \ 'p' : [':Pandoc pdf'            , 'to pdf from open'],
      \ }

      " \ 'L' : [':terminal pandoc -s expand('%:t') -o expand('%:t').tex'       , 'to latex from file'],
      " \ 'm' : [':SDelete!'              , 'to markdown from file'],

" Templates
" let g:which_key_map.t = {
"       \ 'name' : '+templates' ,
"       \ 'p' : [':read ~/.config/nvim/templates/PhilPaper.tex'           , 'PhilPaper.tex'],
"       \ 'l' : [':read ~/.config/nvim/templates/Letter.tex'           , 'Letter.tex'],
"       \ 'g' : [':read ~/.config/nvim/templates/Glossary.tex'           , 'Glossary.tex'],
"       \ 'h' : [':read ~/.config/nvim/templates/HandOut.tex'           , 'HandOut.tex'],
"       \ 'b' : [':read ~/.config/nvim/templates/PhilBeamer.tex'           , 'PhilBeamer.tex'],
"       \ 's' : [':read ~/.config/nvim/templates/SubFile.tex'           , 'SubFile.tex'],
"       \ 'r' : [':read ~/.config/nvim/templates/Root.tex'           , 'Root.tex'],
"       \ 'm' : [':read ~/.config/nvim/templates/MultipleAnswer.tex'           , 'MultipleAnswer.tex'],
"       \ }

" Markdown
let g:which_key_map.m = {
      \ 'name' : '+markdown' ,
      \ 'F'    : ['zA'                                  , 'fold all'],
      \ 'f'    : ['za'                                  , 'fold current'],
      \ 'k'    : ['<Plug>MarkdownPreviewStop'           , 'kill'],
      \ 'x'    : ['<Plug>(mkdx-checkbox-next-n)'  , 'checkbox next'],
      \ 'c'    : ['<Plug>(mkdx-toggle-checkbox-n)'  , 'checkbox toggle'],
      \ 'l'    : ['<Plug>(mkdx-toggle-list-v)'  , 'list toggle'],
      \ 'T'    : ['<Plug>(mkdx-gen-or-upd-toc)'  , 'toc'],
      \ }
      " \ 'm'  : ['<Plug>MarkdownPreviewToggle'     , 'toggle'],

let g:which_key_map.s = {
      \ 'name' : '+settings' ,
      \ 'n' : [':set nu! rnu!'         , 'line toggle'],
      \ 's' : [':setlocal spell!'         , 'spell'],
      \ 'h' : [':set conceallevel=2'         , 'conceal'],
      \ 'c' : [':set conceallevel=0'         , 'show-all'],
      \ 'z' : [':Goyo|Limelight 0.6'         , 'zen + dim'],
      \ 'q' : [':Goyo|Limelight!'         , 'zen'],
      \ 'p' : [':SoftPencil'         , 'soft-pencil'],
      \ }

let g:which_key_map.z = {
      \ 'name' : '+files' ,
      \ 'i' : [':e ~/other/dotfiles/config/nvim/init.vim'         , 'vimrc'],
      \ 'w' : [':e ~/other/dotfiles/config/nvim/keymaps/which-key.vim'   , 'which-key'],
      \ 'C' : [':e ~/other/dotfiles/config/nvim/colors/aeloa.vim'         , 'colors'],
      \ 'l' : [':e ~/other/dotfiles/config/lf/lfrc'         , 'lfrc'],
      \ 'b' : [':e ~/other/dotfiles/config/bspwm/bspwmrc'         , 'bspwmrc'],
      \ 'z' : [':e ~/other/dotfiles/config/zsh/.zshrc'         , 'zshrc'],
      \ 'p' : [':e ~/other/dotfiles/config/polybar/config'         , 'polybar'],
      \ ',' : [':e ~/other/dotfiles/config/picom/picom.conf'         , 'picom'],
      \ 'c' : [':e ~/other/dotfiles/config/nvim/coc-settings.json'         , 'coc'],
      \ }

" a is for actions
let g:which_key_map.a = {
      \ 'name' : '+actions' ,
      \ 's' : [':SSave'                , 'save session'],
      \ 'd' : [':SDelete!'              , 'delete session'],
      \ 'y' : [':CocList -A --normal yank'  , 'yank display'],
      \ 'k' : [':VimtexClean'               , 'kill aux files'],
      \ 'b' : [':terminal bibexport -o %:r.bib %:r.aux'  , 'bib export'],
      \ ';' : [ ':Commands'             , 'commands' ],
      \ 'i' : [ ':PlugInstall'             , 'install' ],
      \ 'u' : [ ':PlugUpdate'             , 'update' ],
      \ 'c' : [ ':PlugClean'             , 'clean' ],
      \ 'h' :  'highlight group',
      \ }

      " \ 't' : [':FloatermToggle'         , 'terminal'],
      " \ 'c' : [':ColorizerToggle'        , 'colorizer'],


" " b is for buffer
" let g:which_key_map.b = {
"       \ 'name' : '+buffer' ,
"       \ '1' : ['b1'        , 'buffer 1']        ,
"       \ '2' : ['b2'        , 'buffer 2']        ,
"       \ 'd' : ['bd'        , 'delete-buffer']   ,
"       \ 'f' : ['bfirst'    , 'first-buffer']    ,
"       \ 'h' : ['Startify'  , 'home-buffer']     ,
"       \ 'l' : ['blast'     , 'last-buffer']     ,
"       \ 'n' : ['bnext'     , 'next-buffer']     ,
"       \ 'p' : ['bprevious' , 'previous-buffer'] ,
"       \ '?' : ['Buffers'   , 'fzf-buffer']      ,
"       \ }

" " s is for search
" let g:which_key_map.? = {
"       \ 'name' : '+search' ,
"       \ '/' : [':History/'     , 'history'],
"       \ ';' : [':Commands'     , 'commands'],
"       \ 'a' : [':Ag'           , 'text Ag'],
"       \ 'b' : [':BLines'       , 'current buffer'],
"       \ 'B' : [':Buffers'      , 'open buffers'],
"       \ 'c' : [':Commits'      , 'commits'],
"       \ 'C' : [':BCommits'     , 'buffer commits'],
"       \ 'f' : [':Files'        , 'files'],
"       \ 'g' : [':GFiles'       , 'git files'],
"       \ 'G' : [':GFiles?'      , 'modified git files'],
"       \ 'h' : [':History'      , 'file history'],
"       \ 'H' : [':History:'     , 'command history'],
"       \ 'l' : [':Lines'        , 'lines'] ,
"       \ 'm' : [':Marks'        , 'marks'] ,
"       \ 'M' : [':Maps'         , 'normal maps'] ,
"       \ 'p' : [':Helptags'     , 'help tags'] ,
"       \ 'P' : [':Tags'         , 'project tags'],
"       \ 's' : [':Snippets'     , 'snippets'],
"       \ 's' : [':Snippets'     , 'snippets'],
"       \ 'S' : [':Colors'       , 'color schemes'],
"       \ 't' : [':Rg'           , 'text Rg'],
"       \ 'T' : [':BTags'        , 'buffer tags'],
"       \ 'w' : [':Windows'      , 'search windows'],
"       \ 'y' : [':Filetypes'    , 'file types'],
"       \ 'z' : [':FZF'          , 'FZF'],
"       \ }

" g is for git
let g:which_key_map.G = {
      \ 'name' : '+git' ,
      \ 'a' : [':Git add .'                        , 'add all'],
      \ 'A' : [':Git add %'                        , 'add current'],
      \ 'b' : [':Git blame'                        , 'blame'],
      \ 'c' : [':Git commit'                       , 'commit'],
      \ 'l' : [':Git log'                          , 'log'],
      \ 'P' : [':Git push'                         , 'push'],
      \ 'p' : [':Git pull'                         , 'pull'],
      \ 'g' : [':FloatermNew lazygit'                           , 'git'],
      \ }

  " nmap ghp <Plug>(GitGutterPreviewHunk)
  " nmap ghs <Plug>(GitGutterStageHunk)
  " nmap ghu <Plug>(GitGutterUndoHunk)


" \ 'H' : ['<Plug>(GitGutterPreviewHunk)'      , 'preview hunk'],
" \ 'j' : ['<Plug>(GitGutterNextHunk)'         , 'next hunk'],
" \ 'k' : ['<Plug>(GitGutterPrevHunk)'         , 'prev hunk'],
" \ 's' : ['<Plug>(GitGutterStageHunk)'        , 'stage hunk'],
" \ 'u' : ['<Plug>(GitGutterUndoHunk)'         , 'undo hunk'],

" " t is for terminal
" let g:which_key_map.t = {
"       \ 'name' : '+terminal' ,
"       \ ';' : [':FloatermNew --wintype=popup --height=6'        , 'terminal'],
"       \ 'f' : [':FloatermNew fzf'                               , 'fzf'],
"       \ 'g' : [':FloatermNew lazygit'                           , 'git'],
"       \ 'd' : [':FloatermNew lazydocker'                        , 'docker'],
"       \ 'n' : [':FloatermNew node'                              , 'node'],
"       \ 'N' : [':FloatermNew nnn'                               , 'nnn'],
"       \ 'p' : [':FloatermNew python'                            , 'python'],
"       \ 'r' : [':FloatermNew ranger'                            , 'ranger'],
"       \ 't' : [':FloatermToggle'                                , 'toggle'],
"       \ 'y' : [':FloatermNew ytop'                              , 'ytop'],
"       \ 's' : [':FloatermNew ncdu'                              , 'ncdu'],
"       \ }


" Register which key map
call which_key#register('<Space>', "g:which_key_map")
