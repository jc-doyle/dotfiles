let g:mapleader = "\<Space>"
set termguicolors

set guicursor=n-v:block-Cursor
set guicursor+=i-ci-c:ver10-iCursor
set guicursor+=r:hor10-iCursor

colorscheme aeloa

" set leader key
syntax enable             " Enables syntax highlighing
set hidden                " Required to keep multiple buffers open multiple buffers
set nowrap                " Display long lines as just one line
set encoding=utf-8        " The encoding displayed
set pumheight=10          " Makes popup menu smaller
set fileencoding=utf-8    " The encoding written to file
set cmdheight=1           " More space for displaying messages
set iskeyword+=-          " treat dash separated words as a word text object
set mouse=a               " Enable your mouse
set splitbelow            " Horizontal splits will automatically be below
set splitright            " Vertical splits will automatically be to the right
set t_Co=256              " Support 256 colors
set conceallevel=0        " So that I can see `` in markdown files
set tabstop=2             " Insert 2 spaces for a tab
set shiftwidth=2          " Change the number of space characters inserted for indentation
set smarttab              " Makes tabbing smarter will realize you have 2 vs 4
set expandtab             " Converts tabs to spaces
set smartindent           " Makes indenting smart
set autoindent            " Good auto indent
set rnu                   " Relative line numbers
set nu                    " Line numbers
set formatoptions-=cro    " Stop newline continution of comments
set cursorline            " Enable highlighting of the current line
set background=dark       " tell vim what the background color looks like
set showtabline=2         " Always show tabs
set noshowmode            " We don't need to see things like -- INSERT -- anymore
set noshowcmd
set timeoutlen=300        " By default timeoutlen is 1000 ms
set formatoptions-=cro     " Stop newline continution of comments
set clipboard=unnamedplus " Copy paste between vim and everything else
set signcolumn=number     " For COC

set numberwidth=1
set regexpengine=1
set redrawtime=10000
syntax sync minlines=256
set synmaxcol=256
set scl=no
set splitbelow
set splitright
set nofoldenable
" Spell Check
"set spelllang=en
"set spellfile

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup
set scrolloff=5

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
set shortmess+=c
set lazyredraw


let g:python3_host_prog = expand("/usr/bin/python")

" Clear cmd line message
function! s:empty_message(timer)
  if mode() ==# 'n'
    echon ''
  endif
endfunction

augroup cmd_msg_cls
    autocmd!
    autocmd CmdlineLeave :  call timer_start(5000, funcref('s:empty_message'))
augroup END

augroup nerdtreehidecwd
  autocmd!
  autocmd FileType nerdtree setlocal conceallevel=3
          \ | syntax match NERDTreeHideCWD #^[</].*$# conceal
          \ | setlocal concealcursor=n
augroup end

" Autochange cwd
autocmd BufEnter * silent! lcd %:p:h
