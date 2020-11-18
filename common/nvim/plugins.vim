call plug#begin('~/.config/nvim/plugged')

" Plugins
" Themes
Plug 'arcticicestudio/nord-vim'
Plug 'dylanaraps/wal.vim'

" Surrounds
Plug 'tpope/vim-surround'
Plug 'https://github.com/jiangmiao/auto-pairs'

" Go
Plug 'fatih/vim-go'

" Fugitive
"Plug 'tpope/fugitive'

" VimWiki
Plug 'vimwiki/vimwiki'

" Themes
Plug 'arcticicestudio/nord-vim'

" Lightline
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'

" GoYo
Plug 'junegunn/goyo.vim'

" Startify
Plug 'mhinz/vim-startify'

" Floatterm
Plug 'voldikss/vim-floaterm'

" CoC
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Colors
Plug 'ap/vim-css-color'

" Prettier
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }

"Rust
"Plug 'rust-lang/rust.vim'

" UltiSnips
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" VimTex
Plug 'lervag/vimtex'
Plug 'KeitaNakamura/tex-conceal.vim'

" PlantUML
Plug 'weirongxu/plantuml-previewer.vim'
Plug 'aklt/plantuml-syntax'
Plug 'tyru/open-browser.vim'

call plug#end()


