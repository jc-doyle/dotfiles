call plug#begin('~/.config/nvim/plugged')

" Plugins

" Language Specifc
Plug 'leafoftree/vim-vue-plugin'
Plug 'lervag/vimtex'
Plug 'KeitaNakamura/tex-conceal.vim'
Plug 'weirongxu/plantuml-previewer.vim'
Plug 'aklt/plantuml-syntax'
Plug 'tyru/open-browser.vim'
Plug 'SidOfc/mkdx'
" Plug 'gabrielelana/vim-markdown'
" Plug 'Scuilion/markdown-drawer'
" Plug 'plasticboy/vim-markdown'
Plug 'leafOfTree/vim-svelte-plugin'


" LSP/Frameworks
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neovim/nvim-lspconfig'

" Aesthetics
Plug 'itchyny/lightline.vim'
"Plug 'mengelbrecht/lightline-bufferline'
Plug 'romgrk/barbar.nvim'
Plug 'scr1pt0r/crease.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'mhinz/vim-startify'

" Functionality
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-commentary'
Plug 'ap/vim-css-color'
Plug 'godlygeek/tabular'
Plug 'liuchengxu/vim-which-key'
Plug 'voldikss/vim-floaterm'
Plug 'tpope/vim-fugitive'
Plug 'fcpg/vim-waikiki'
" Plug 'vim-pandoc/vim-pandoc'
" Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'honza/vim-snippets'
Plug 'reedes/vim-pencil'

" Serach & File Management
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf.vim'

" Snippets
Plug 'SirVer/ultisnips'

call plug#end()
