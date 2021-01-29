call plug#begin('~/.config/nvim/plugged')

" Plugins

" Coc
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ryanoasis/vim-devicons'

" Aesthetics
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'

Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'mhinz/vim-startify'

" Functionality
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'ap/vim-css-color'
Plug 'godlygeek/tabular'
Plug 'liuchengxu/vim-which-key'
Plug 'tpope/vim-commentary'
Plug 'sidofc/mkdx'
Plug 'voldikss/vim-floaterm'
Plug 'tpope/vim-fugitive'

Plug 'lervag/vimtex'
Plug 'KeitaNakamura/tex-conceal.vim'

Plug 'weirongxu/plantuml-previewer.vim'
Plug 'aklt/plantuml-syntax'
Plug 'tyru/open-browser.vim'

" Snippets
Plug 'SirVer/ultisnips'

call plug#end()
