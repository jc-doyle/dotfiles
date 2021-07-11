" let g:pandoc#folding#fold_yaml=1
" let g:vim_markdown_frontmatter = 1

" let g:vim_markdown_folding_level = 6
" let g:vim_markdown_folding_style_pythonic = 1
" let g:vim_markdown_override_foldtext = 0

let g:markdown_enable_conceal = 1
let g:markdown_enable_mappings = 0


let g:mkdx#settings     = { 'highlight': { 'enable': 1 },
    \ 'map': { 'enable' : 0 },
    \ 'links': { 'external': { 'enable': 1, 'relative': 1 }, 'fragment': {'complete': 1, 'jumplist': 1 } },
    \ 'toc': { 'text': 'Table of Contents', 'update_on_write': 1 },
    \ 'fold': { 'enable': 1 },
    \ 'gf_on_steroids': 1,
    \ 'checkbox': { 'toggles': [' ', '-', 'x'] },
    \ }

let g:waikiki_default_maps = 1
let g:waikiki_roots = ['~/cfa/wiki/']

" let g:pandoc#modules#enabled = ["folding"]
" let g:pandoc#folding#fold_yaml = 1

" let g:pandoc#folding#fdc = 0

