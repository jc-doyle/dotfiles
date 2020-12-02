call plug#begin('~/.config/nvim/plugged')

" Plugins

" Aesthetics
Plug 'arcticicestudio/nord-vim'
Plug 'dylanaraps/wal.vim'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'mhinz/vim-startify'
Plug 'ap/vim-css-color'

" Functionality
Plug 'tpope/vim-surround'
Plug 'https://github.com/jiangmiao/auto-pairs'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }
Plug 'voldikss/vim-floaterm'

" Language Support
Plug 'tpope/fugitive'
Plug 'fatih/vim-go'

Plug 'lervag/vimtex'
Plug 'KeitaNakamura/tex-conceal.vim'

Plug 'weirongxu/plantuml-previewer.vim'
Plug 'aklt/plantuml-syntax'
Plug 'tyru/open-browser.vim'

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

call plug#end()


