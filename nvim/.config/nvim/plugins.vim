call plug#begin('~/.config/nvim/plugged')

" Plugins

" Fugitive
Plug 'tpope/fugitive'

" VimWiki
Plug 'vimwiki/vimwiki'

" Nord
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

" Autopairs
Plug 'jiangmiao/auto-pairs'

" Ranger
Plug 'kevinhwang91/rnvimr'

" Prettier
"Plug 'prettier/vim-prettier', {
"  \ 'do': 'yarn install',
"  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }

"Rust
Plug 'rust-lang/rust.vim'

" UltiSnips
Plug 'SirVer/ultisnips'

" VimTex
Plug 'lervag/vimtex'

call plug#end()


