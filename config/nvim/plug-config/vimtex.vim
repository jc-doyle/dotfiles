" VimTex

let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:latex_view_general_viewer = 'zathura'
let g:vimtex_mappings_enabled=0
let g:vimtex_quickfix_mode=0

let g:vimtex_log_ignore = [
        \ 'Underfull',
        \ 'Overfull',
        \ 'specifier changed to',
        \ 'Token not allowed in a PDF string',
      \ ]

function! s:hi(group, guifg, guibg, attr)
  let l:cmd = 'highlight ' . a:group
  if a:guifg != ''
    let l:cmd .= ' guifg=' . a:guifg
  endif
  if a:guibg != ''
    let l:cmd .= ' guibg=' . a:guibg
  endif
  if a:attr != ''
    let l:cmd .= ' gui='   . a:attr
  endif
  execute l:cmd
endfunction

let s:polar1  = '#161821'
let s:polar2  = '#2E3440'
let s:polar3  = '#3B4252'
let s:polar4  = '#6B7089'
let s:snow1   = '#C6C8D1'
let s:snow2   = '#D8DEE9'
let s:snow3   = '#E5E9F0'
let s:frost1  = '#8FBCBB'
let s:frost2  = '#88C0D0'
let s:frost3  = '#81A1C1'
let s:frost4  = '#5E81AC'
let s:aurora1 = '#E27878'
let s:aurora2 = '#E2A478'
let s:aurora3 = '#EBCB8B'
let s:aurora4 = '#A3BE8C'
let s:aurora5 = '#A093C7'

" " basic groups
" call s:hi('texCmd', s:aurora5,  '', '')
" call s:hi('texArg', s:aurora3, '', '')
" call s:hi('texOpt', s:frost2,  '', '')

" " sectioning etc.
" call s:hi('texCmdPart',      s:aurora2, '', '')
" call s:hi('texPartArgTitle', s:aurora3, '', '')
" call s:hi('texCmdTitle',     s:aurora2, '', '')
" call s:hi('texCmdAuthor',    s:aurora2, '', '')
" call s:hi('texTitleArg',     s:aurora3, '', 'bold')
" call s:hi('texAuthorArg',    s:aurora3, '', 'italic')
" call s:hi('texFootnoteArg',  s:snow1,   '', 'italic')

" " environments
" call s:hi('texCmdEnv',     s:frost3,  '', '')
" call s:hi('texEnvArgName', s:aurora2, '', '')
" call s:hi('texEnvOpt',     s:aurora3, '', '')

" " math
" call s:hi('texMathZone',        s:frost1, '', '')
" call s:hi('texMathCmd',         s:frost2, '', '')
" call s:hi('texMathDelim',       s:frost2, '', '')
" call s:hi('texMathDelimZone',   s:frost3, '', '')
" call s:hi('texMathCmdEnv',      s:frost3, '', '')
" call s:hi('texMathEnvArgName',  s:frost3, '', '')
" hi! link texCmdMathText texCmdMathEnv
" hi! link texCmdMathEnv  texMathCmdEnv

" " references
" call s:hi('texCmdRef', s:frost3,  '', '')
" call s:hi('texRefArg', s:aurora4, '', '')
" call s:hi('texRefOpt', s:aurora5, '', '')
" call s:hi('texUrlArg', s:frost4,  '', 'underline')
" hi! link texCmdCRef     texCmdRef
" hi! link texHrefArgLink texUrlArg
" hi! link texHrefArgText texOpt

" " symbols
" call s:hi('texSymbol',      s:aurora5, '', '')
" call s:hi('texSpecialChar', s:frost3,  '', '')
" hi! link texDelim       texSymbol
" hi! link texTabularChar texSymbol

" " files
" call s:hi('texFileArg', s:aurora5, '', '')
" call s:hi('texFileOpt', s:frost2,  '', '')

" " bib
" call s:hi('bibType',     s:aurora2, '', '')
" call s:hi('bibKey',      s:aurora4, '', '')
" call s:hi('bibEntryKw',  s:frost1,  '', '')
" call s:hi('bibVariable', s:aurora3, '', '')
