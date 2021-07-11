let g:colors_name = "aeloa"
set background=dark

" %%base16_template: vim##default %%
let s:base0_gui = "#F8F6F4"
let s:base1_gui = "#F4F2EF"
let s:base2_gui = "#E8E6E4"
let s:base3_gui = "#CCCAC9"
let s:base4_gui = "#908D8D"
let s:base5_gui = "#5B5B5B"
let s:base6_gui = "#3B3B3B"
let s:base7_gui = "#1F1F1F"
let s:base8_gui = "#4E81A6"
let s:base9_gui = "#DD6783"
let s:base10_gui = "#5EAE9B"
let s:base11_gui = "#A367B3"
let s:base12_gui = "#34806E"
let s:base13_gui = "#CE365B"
let s:base14_gui = "#384C7F"
let s:base15_gui = "#912C93"

" %%base16_template_end%%

let s:base1_term = "0"
let s:base3_term = "8"
let s:base5_term = "7"
let s:base6_term = "15"
let s:base7_term = "14"
let s:base8_term = "6"
let s:base9_term = "4"
let s:base10_term = "12"
let s:base11_term = "1"
let s:base12_term = "11"
let s:base13_term = "3"
let s:base14_term = "2"
let s:base15_term = "5"

let s:bold = "bold,"

let s:italic = "italic,"

let s:underline = "underline,"

function! s:hi(group, guifg, guibg, ctermfg, ctermbg, attr, guisp)
  if a:guifg != ""
    exec "hi " . a:group . " guifg=" . a:guifg
  endif
  if a:guibg != ""
    exec "hi " . a:group . " guibg=" . a:guibg
  endif
  if a:ctermfg != ""
    exec "hi " . a:group . " ctermfg=" . a:ctermfg
  endif
  if a:ctermbg != ""
    exec "hi " . a:group . " ctermbg=" . a:ctermbg
  endif
  if a:attr != ""
    exec "hi " . a:group . " gui=" . a:attr . " cterm=" . substitute(a:attr, "undercurl", s:underline, "")
  endif
  if a:guisp != ""
    exec "hi " . a:group . " guisp=" . a:guisp
  endif
endfunction

"+---------------+
"+ UI Components +
"+---------------+
"+--- Attributes ---+
call s:hi("Bold", "", "", "", "", s:bold, "")
call s:hi("Italic", "", "", "", "", s:italic, "")
call s:hi("Underline", "", "", "", "", s:underline, "")

"+--- Editor ---+
call s:hi("ColorColumn", "", s:base1_gui, "NONE", s:base1_term, "", "")
call s:hi("Cursor", s:base0_gui, s:base8_gui, "", "NONE", "", "")
call s:hi("CursorLine", "", s:base1_gui, "NONE", s:base1_term, "NONE", "")
call s:hi("Conceal", s:base15_gui, "NONE", "NONE", "NONE", "NONE", "")
call s:hi("Error", s:base11_gui, "NONE", "", s:base11_term, "", "")
call s:hi("iCursor", s:base0_gui, s:base9_gui, "", "NONE", "", "")
call s:hi("LineNr", s:base0_gui, "NONE", s:base3_term, "NONE", "", "")
call s:hi("MatchParen", s:base9_gui, "NONE", s:base8_term, "NONE", s:bold, "")
call s:hi("NonText", s:base2_gui, "", s:base3_term, "", "", "")
call s:hi("Normal", s:base5_gui, s:base0_gui, "NONE", "NONE", "", "")
call s:hi("PMenu", s:base5_gui, s:base2_gui, "NONE", s:base1_term, "NONE", "")
call s:hi("PmenuSbar", s:base8_gui, s:base2_gui, "NONE", s:base1_term, "", "")
call s:hi("PmenuThumb", s:base8_gui, s:base8_gui, "NONE", s:base3_term, "", "")
call s:hi("PMenuSel", s:base0_gui, s:base8_gui, s:base8_term, s:base3_term, "", "")
call s:hi("SpecialKey", s:base3_gui, "", s:base3_term, "", "", "")
call s:hi("SpellBad", s:base13_gui, "NONE", s:base11_term, "NONE", "undercurl", s:base11_gui)
call s:hi("SpellCap", s:base13_gui, "NONE", s:base13_term, "NONE", "undercurl", s:base13_gui)
call s:hi("SpellLocal", s:base5_gui, "NONE", s:base5_term, "NONE", "undercurl", s:base5_gui)
call s:hi("SpellRare", s:base6_gui, "NONE", s:base6_term, "NONE", "undercurl", s:base6_gui)
call s:hi("Visual", "", s:base2_gui, "", s:base1_term, "", "")
call s:hi("VisualNOS", "", s:base2_gui, "", s:base1_term, "", "")
"+- Neovim Support -+
call s:hi("healthError", s:base11_gui, s:base1_gui, s:base11_term, s:base1_term, "", "")
call s:hi("healthSuccess", s:base14_gui, s:base1_gui, s:base14_term, s:base1_term, "", "")
call s:hi("healthWarning", s:base13_gui, s:base1_gui, s:base13_term, s:base1_term, "", "")
call s:hi("TermCursorNC", "", s:base1_gui, "", s:base1_term, "", "")

"+--- Gutter ---+
call s:hi("CursorColumn", "", s:base1_gui, "NONE", s:base1_term, "", "")
call s:hi("CursorLineNr", s:base3_gui, "", "NONE", "", "NONE", "")
call s:hi("Folded", s:base3_gui, "NONE", s:base3_term, s:base1_term, s:italic, "")
call s:hi("FoldColumn", s:base15_gui, s:base0_gui, s:base3_term, "NONE", "", "")
call s:hi("SignColumn", s:base1_gui, s:base0_gui, s:base1_term, "NONE", "", "")

"+--- Navigation ---+
call s:hi("Directory", s:base8_gui, "", s:base8_term, "NONE", "", "")

"+--- Prompt/Status ---+
call s:hi("EndOfBuffer", s:base0_gui, "", s:base1_term, "NONE", "", "")
call s:hi("ErrorMsg", s:base11_gui, "NONE", "NONE", s:base11_term, "", "")
call s:hi("MoreMsg", s:base9_gui, "", s:base8_term, "", "", "")
call s:hi("Question", s:base4_gui, "", "NONE", "", "", "")

call s:hi("StatusLine", s:base8_gui, s:base0_gui, s:base8_term, s:base3_term, "NONE", "")
call s:hi("StatusLineNC", s:base4_gui, s:base0_gui, "NONE", s:base1_term, "NONE", "")
call s:hi("StatusLineTerm", s:base8_gui, s:base3_gui, s:base8_term, s:base3_term, "NONE", "")
call s:hi("StatusLineTermNC", s:base4_gui, s:base1_gui, "NONE", s:base1_term, "NONE", "")
call s:hi("WarningMsg", s:base13_gui, "NONE", s:base1_term, s:base13_term, "", "")
call s:hi("WildMenu", s:base15_gui, s:base1_gui, s:base8_term, s:base1_term, "", "")

"+--- Search ---+
call s:hi("IncSearch", s:base6_gui, s:base10_gui, s:base6_term, s:base10_term, s:underline, "")
call s:hi("Search", s:base1_gui, s:base8_gui, s:base1_term, s:base8_term, "NONE", "")

"+--- Window ---+
call s:hi("VertSplit", s:base2_gui, s:base0_gui, s:base3_term, "NONE", "NONE", "")

"+----------------------+
"+ Language Base Groups +
"+----------------------+
call s:hi("Boolean", s:base11_gui, "", s:base9_term, "", "", "")
call s:hi("Character", s:base12_gui, "", s:base14_term, "", "", "")
call s:hi("Comment", s:base4_gui, "", s:base3_term, "", s:italic, "")
call s:hi("Conditional", s:base13_gui, "", s:base9_term, "", "", "")
call s:hi("Constant", s:base11_gui, "", "NONE", "", "", "")
call s:hi("Define", s:base13_gui, "", s:base9_term, "", "", "")
call s:hi("Delimiter", s:base7_gui, "", s:base6_term, "", "", "")
call s:hi("Exception", s:base9_gui, "", s:base9_term, "", "", "")
call s:hi("Float", s:base15_gui, "", s:base15_term, "", "", "")
call s:hi("Function", s:base8_gui, "", s:base8_term, "", "", "")
call s:hi("Identifier", s:base6_gui, "", "NONE", "", "NONE", "")
call s:hi("Include", s:base8_gui, "", s:base9_term, "", "", "")
call s:hi("Keyword", s:base14_gui, "", s:base9_term, "", "", "")
call s:hi("Label", s:base9_gui, "", s:base9_term, "", "", "")
call s:hi("Number", s:base15_gui, "", s:base15_term, "", "", "")
call s:hi("Operator", s:base8_gui, "", s:base9_term, "", "NONE", "")
call s:hi("PreProc", s:base9_gui, "", s:base9_term, "", "NONE", "")
call s:hi("Repeat", s:base15_gui, "", s:base9_term, "", "", "")
call s:hi("Special", s:base11_gui, "", "NONE", "", "", "")
call s:hi("SpecialChar", s:base11_gui, "", s:base13_term, "", "", "")
call s:hi("SpecialComment", s:base8_gui, "", s:base8_term, "", s:italic, "")
call s:hi("Statement", s:base9_gui, "", s:base9_term, "", "", "")
call s:hi("StorageClass", s:base9_gui, "", s:base9_term, "", "", "")
call s:hi("String", s:base10_gui, "", s:base14_term, "", "", "")
call s:hi("Structure", s:base9_gui, "", s:base9_term, "", "", "")
call s:hi("Tag", s:base8_gui, "", "", "", "", "")
call s:hi("Todo", s:base13_gui, "NONE", s:base13_term, "NONE", "", "")
call s:hi("Type", s:base9_gui, "", s:base9_term, "", "NONE", "")
call s:hi("Typedef", s:base10_gui, "", s:base9_term, "", "", "")
hi! link Macro Define
hi! link PreCondit PreProc

call s:hi("DiffAdd", s:base14_gui, s:base0_gui, s:base14_term, "NONE", "inverse", "")
call s:hi("DiffChange", s:base13_gui, s:base0_gui, s:base13_term, "NONE", "inverse", "")
call s:hi("DiffDelete", s:base11_gui, s:base0_gui, s:base11_term, "NONE", "inverse", "")
call s:hi("DiffText", s:base9_gui, s:base0_gui, s:base9_term, "NONE", "inverse", "")


"+-----------+
"+ Languages +
"+-----------+
call s:hi("asciidocAttributeEntry", s:base10_gui, "", s:base10_term, "", "", "")
call s:hi("asciidocAttributeList", s:base10_gui, "", s:base10_term, "", "", "")
call s:hi("asciidocAttributeRef", s:base10_gui, "", s:base10_term, "", "", "")
call s:hi("asciidocHLabel", s:base9_gui, "", s:base9_term, "", "", "")
call s:hi("asciidocListingBlock", s:base7_gui, "", s:base7_term, "", "", "")
call s:hi("asciidocMacroAttributes", s:base8_gui, "", s:base8_term, "", "", "")
call s:hi("asciidocOneLineTitle", s:base8_gui, "", s:base8_term, "", "", "")
call s:hi("asciidocPassthroughBlock", s:base9_gui, "", s:base9_term, "", "", "")
call s:hi("asciidocQuotedMonospaced", s:base7_gui, "", s:base7_term, "", "", "")
call s:hi("asciidocTriplePlusPassthrough", s:base7_gui, "", s:base7_term, "", "", "")
hi! link asciidocAdmonition Keyword
hi! link asciidocAttributeRef markdownH1
hi! link asciidocBackslash Keyword
hi! link asciidocMacro Keyword
hi! link asciidocQuotedBold Bold
hi! link asciidocQuotedEmphasized Italic
hi! link asciidocQuotedMonospaced2 asciidocQuotedMonospaced
hi! link asciidocQuotedUnconstrainedBold asciidocQuotedBold
hi! link asciidocQuotedUnconstrainedEmphasized asciidocQuotedEmphasized
hi! link asciidocURL markdownLinkText

call s:hi("markdownBlockquote", s:base13_gui, "", s:base7_term, "", "", "")
call s:hi("markdownBold", s:base5_gui, "", s:base7_term, "", s:bold, "")
call s:hi("markdownBoldDelimiter", s:base9_gui, "", s:base7_term, "", s:bold, "")
call s:hi("markdownCode", s:base6_gui, "", s:base7_term, "", "", "")
call s:hi("markdownCodeDelimiter", s:base4_gui, "", s:base7_term, "", "", "")
call s:hi("markdownFootnote", s:base7_gui, "", s:base7_term, "", "", "")
call s:hi("markdownId", s:base7_gui, "", s:base7_term, "", "", "")
call s:hi("markdownIdDeclaration", s:base7_gui, "", s:base7_term, "", "", "")
call s:hi("markdownH1", s:base7_gui, "", s:base9_term, "", s:bold, "")
call s:hi("markdownH2", s:base8_gui, "", s:base9_term, "", s:bold, "")
call s:hi("markdownH3", s:base6_gui, "", s:base9_term, "", s:italic, "")
call s:hi("markdownLinkText", s:base9_gui, "", s:base8_term, "", "", "")
call s:hi("markdownUrl", s:base4_gui, "", "NONE", "", "NONE", "")
call s:hi("markdownHeadingDelimiter", s:base2_gui, "", s:base7_term, "", "", "")

call s:hi("mkdxTableDelimiter", s:base3_gui, "", s:base7_term, "", "", "")
call s:hi("mkdxTableHeadDelimiter", s:base3_gui, "", s:base7_term, "", "", "")
call s:hi("mkdxTableHeader", s:base7_gui, "", s:base7_term, "", "", "")
call s:hi("mkdxListItem", s:base11_gui, "", s:base7_term, "", "", "")

hi! link markdownFootnoteDefinition markdownFootnote
hi! link markdownH4 markdownH3
hi! link markdownH5 markdownH3
hi! link markdownH6 markdownH3
hi! link markdownIdDelimiter Keyword
hi! link markdownItalic Italic
hi! link markdownItalicDelimiter Keyword
hi! link markdownLinkDelimiter Keyword
hi! link markdownLinkTextDelimiter Keyword
hi! link markdownListMarker Keyword
hi! link markdownRule Keyword

call s:hi("texMathSymbol", s:base15_gui, "", s:base7_term, "", "", "")
call s:hi("texStatement", s:base9_gui, "", s:base7_term, "", "", "")


"+----------------+
"+ Plugin Support +
"+----------------+
"+--- UI ---+

" Coc
" > neoclide/coc
call s:hi("CocWarningSign", s:base11_gui, "", s:base13_term, "", "", "")
call s:hi("CocErrorSign" , s:base9_gui, "", s:base11_term, "", s:italic, "")
call s:hi("CocInfoSign" , s:base15_gui, "", s:base8_term, "", "", "")
call s:hi("CocHintSign" , s:base10_gui, "", s:base10_term, "", "", "")
call s:hi("CocHintFloat" , s:base3_gui, "", s:base8_term, "", "", "")
call s:hi("CocHintFloat" , s:base3_gui, "", s:base8_term, "", "", "")

" Nvim LSP
" > neovim/nvim-lsp
call s:hi("LSPDiagnosticsWarning", s:base13_gui, "", s:base13_term, "", "", "")
call s:hi("LSPDiagnosticsError" , s:base11_gui, "", s:base11_term, "", "", "")
call s:hi("LSPDiagnosticsInformation" , s:base8_gui, "", s:base8_term, "", "", "")
call s:hi("LSPDiagnosticsHint" , s:base10_gui, "", s:base10_term, "", "", "")

" vim-plug
" > junegunn/vim-plug
call s:hi("plugDeleted", s:base11_gui, "", "", s:base11_term, "", "")

" NerdTree
call s:hi("NERDTreeFlags", s:base3_gui, "", "", s:base11_term, "", "")
call s:hi("NERDTreeDir", s:base9_gui, "", "", s:base11_term, s:bold, "")

" FloatTerm
call s:hi("FloatermBorder", s:base3_gui, "NONE", "", "", s:bold, "")

" Startify
call s:hi("StartifyHeader", s:base14_gui, "", "", "", "", "")
call s:hi("StartifyNumber", s:base9_gui, "", "", "", "", "")
call s:hi("StartifyPath", s:base4_gui, "", "", "", "", "")
call s:hi("StartifyFile", s:base14_gui, "", "", "", "", "")
call s:hi("StartifyBracket", s:base3_gui, "", "", "", "", "")
call s:hi("StartifySlash", s:base3_gui, "", "", "", "", "")
call s:hi("StartifySection", s:base8_gui, "", "", "", s:italic, "")

" WhichKey 
call s:hi("WhichKey", s:base13_gui, "", "", "", s:bold, "")
call s:hi("WhichKeySeperator", s:base3_gui, "", "", "", "", "")
call s:hi("WhichKeyGroup", s:base14_gui, "", "", "", s:bold, "")
call s:hi("WhichKeyDesc", s:base14_gui, "", "", "", "", "")

" BarBar
call s:hi("BufferCurrent", s:base0_gui, s:base8_gui, "", "", "", "")
hi! link BufferCurrentSign BufferCurrent
hi! link BufferCurrentIndex BufferCurrent
hi! link BufferCurrentMod BufferCurrent

call s:hi("BufferVisible", s:base0_gui, s:base10_gui, "", "", "", "")
hi! link BufferVisibleSign BufferVisible
hi! link BufferVisibleIndex BufferVisible
hi! link BufferVisibleMod BufferVisible

call s:hi("BufferInactive", s:base4_gui, s:base0_gui, "", "", "", "")
hi! link BufferInactiveSign BufferInactive
hi! link BufferInactiveIndex BufferInactive
hi! link BufferInactiveMod BufferInactive

call s:hi("BufferCurrentTarget", s:base0_gui, s:base8_gui, "", "", s:bold, "")
call s:hi("BufferInactiveTarget", s:base14_gui, s:base0_gui, "", "", s:bold, "")
hi! link BufferVisibleTarget BufferInactiveTarget
