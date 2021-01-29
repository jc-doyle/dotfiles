let g:startify_session_dir = '~/.config/nvim/sessions'

autocmd User Startified setlocal cursorline

 let g:startify_custom_header = 'startify#center(startify#fortune#boxed())'

let g:startify_lists = [
          \ { 'type': 'sessions',  'header': ['   Sessions']  },
          \ { 'type': 'bookmarks', 'header': ['   Bookmarks']  },
          \ { 'type': 'files',     'header': ['   Most Recent']  },
          \ ]

let g:startify_session_autoload = 1
let g:startify_session_delete_buffers = 1
let g:startify_change_to_vcs_root = 1
let g:startify_session_persistence = 1
let g:startify_files_number = 8

let g:startify_bookmarks = [
            \ { 'i': '~/.config/nvim/init.vim' },
            \ { 'z': '~/.config/zsh/.zshrc' },
            \ { 'c': '~/.config/lf/lfrc' },
            \ ]

let g:startify_enable_special = 0

highlight StartifyHeader guifg=#b48ead guibg=NONE
highlight StartifyNumber   guifg=#81a1c1 guibg=NONE
highlight StartifyPath   guifg=#e5e9f0 guibg=NONE
highlight StartifyFile   guifg=#b48ead guibg=NONE
highlight StartifySlash   guifg=#d8dee9 guibg=NONE
highlight StartifyBracket   guifg=#434c5e guibg=NONE

let g:startify_fortune_use_unicode = 1
