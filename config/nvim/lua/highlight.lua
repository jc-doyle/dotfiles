local Color, colors, Group, _, styles = require 'colorbuddy'.setup()
local hl = Group.new

local none = styles.NONE
local bold = styles.bold
local italic = styles.italic
local underline = styles.underline
local strikethrough = styles.strikethrough

local au = require 'utils.general'.autocmd

vim.g.colors_name = 'default'

require 'colors.util'
local template = require 'colors.colors'

-- Assigned Colors
Color.new('base0', template.base0)
Color.new('base1', template.base1)
Color.new('base2', template.base2)
Color.new('base3', template.base3)
Color.new('base4', template.base4)
Color.new('base5', template.base5)
Color.new('base6', template.base6)
Color.new('base7', template.base7)
Color.new('base8', template.base8)
Color.new('base9', template.base9)
Color.new('base10', template.base10)
Color.new('base11', template.base11)
Color.new('base12', template.base12)
Color.new('base13', template.base13)
Color.new('base14', template.base14)
Color.new('base15', template.base15)

-- HIGHLIGHTS
-- Base
hl('Bold', colors.none, colors.none, bold)
hl('Italic', colors.none, colors.none, italic)
hl('Underline', colors.none, colors.none, underline)
hl('Strikethrough', colors.none, colors.none, strikethrough)

-- UI
hl('Normal', colors.base4, colors.base0)
hl('LineNr', colors.base1, colors.none)
hl('Cursor', colors.none, colors.base4)
hl('CursorLine', colors.none, colors.base0:light(0.01))
hl('CursorLineNr', colors.base3, colors.none)
hl('CursorColumn', colors.none, colors.none)
hl('Conceal', colors.base11, colors.none)
hl('Error', colors.base11, colors.none)
hl('iCursor', colors.base0, colors.base5)
hl('Pmenu', colors.base3, colors.base1:dark(0.03))
hl('PmenuSel', colors.base5, colors.base1:light(0.06))
hl('PmenuSbar', colors.none, colors.base1:dark(0.02))
hl('PmenuThumb', colors.none, colors.base1:light(0.05))
hl('NormalFloat', colors.none, colors.base1:dark(0.03))
hl("FloatBorder", colors.base2, colors.base1:dark(0.03))

-- StatusLine
hl('StError', colors.base7, colors.base0)
hl('StWarn', colors.base10, colors.base0)
hl('StHint', colors.base2, colors.base0)
hl('StInfo', colors.base1, colors.base0)

hl('StNormal', colors.base0, colors.base6)
hl('StInsert', colors.base0, colors.base10)
hl('StVisual', colors.base0, colors.base8)
hl('StReplace', colors.base0, colors.base12)
hl('StSelect', colors.base0, colors.base13)
hl('StCommand', colors.base0, colors.base11)

hl('StInactive', colors.base0, colors.base1)
hl('StLine', colors.base1, colors.base0, strikethrough)
hl("StatusLineNC", colors.base0, colors.base0)
hl("StatusLine", colors.none, colors.base0)

hl("MatchParen", colors.base7, colors.none)
hl("NonText", colors.base2, colors.none)
hl("SpecialKey", colors.base2, colors.none)
hl("SpellBad", colors.none, colors.none, underline)
hl("SpellCap", colors.base13, colors.none)
hl("SpellLocal", colors.base4, colors.none)
hl("SpellRare", colors.none, colors.none)
hl("Visual", colors.none, colors.base1)
hl("VisualNOS", colors.base2, colors.none)
hl("healthError", colors.base11, colors.none)
hl("healthSuccess", colors.base14, colors.none)
hl("healthWarning", colors.base13, colors.none)
hl("TermCursorNC", colors.base2, colors.none)
hl("Folded", colors.base2, colors.none)
hl("FoldColumn", colors.base15, colors.none)
hl("SignColumn", colors.base2, colors.none)
hl("Directory", colors.base6, colors.none)
hl("EndOfBuffer", colors.base0, colors.none)
hl("MsgArea", colors.base2, colors.base0)
hl("ErrorMsg", colors.base10, colors.none, italic)
hl("WarningMsg", colors.base13, colors.none)
hl("MoreMsg", colors.base3, colors.none)
hl("Yank", colors.none, colors.base1:light(0.05))

hl("Question", colors.base3, colors.none)
hl("WildMenu", colors.base15, colors.none)
hl("Search", colors.none, colors.base1, bold)
hl("IncSearch", colors.base0, colors.base11)
hl("VertSplit", colors.base1, colors.none)

-- Standard Language Groups
hl("Boolean", colors.base10, colors.none)
hl("Character", colors.base12, colors.none)
hl("Comment", colors.base2, colors.none, italic)
hl("Conditional", colors.base7, colors.none)
hl("Constant", colors.base10, colors.none)
hl("Define", colors.base13, colors.none)
hl("Delimiter", colors.base3, colors.none)
hl("Exception", colors.base7, colors.none)
hl("Float", colors.base10, colors.none)
hl("Function", colors.base11, colors.none)
hl("Identifier", colors.base6, colors.none)
hl("Include", colors.base10, colors.none)
hl("Keyword", colors.base15, colors.none)
hl("Label", colors.base15, colors.none)
hl("Number", colors.base6, colors.none)
hl("Operator", colors.base10, colors.none)
hl("PreProc", colors.base14, colors.none)
hl("Repeat", colors.base7, colors.none)
hl("Special", colors.base15, colors.none)
hl("SpecialChar", colors.base15, colors.none)
hl("Statement", colors.base3, colors.none)
hl("String", colors.base8, colors.none)
hl("Structure", colors.base12, colors.none)
hl("Tag", colors.base10, colors.none)
hl("Title", colors.base6, colors.none, bold)
hl("Todo", colors.base11, colors.none)
hl("Type", colors.base6, colors.none)
hl("Typedef", colors.base13, colors.none)

--Treesitter
hl("TSBoolean", colors.base10, colors.none)
hl("TSCharacter", colors.base12, colors.none)
hl("TSComment", colors.base2, colors.none, italic)
hl("TSConditional", colors.base7, colors.none)
hl("TSConstant", colors.base10, colors.none)
hl("TSConstBuiltin", colors.base13, colors.none)
hl("TSConstructor", colors.base14, colors.none)
hl("TSError", colors.none, colors.none, none)
hl("TSException", colors.base10, colors.none, italic)
hl("TSDefine", colors.base13, colors.none)
hl("TSDelimiter", colors.base3, colors.none)
hl("TSException", colors.base7, colors.none)
hl("TSField", colors.base13, colors.none)
hl("TSFloat", colors.base10, colors.none)
hl("TSFunction", colors.base11, colors.none)
hl("TSFuncBuiltin", colors.base11, colors.none)
hl("TSIdentifier", colors.base6, colors.none)
hl("TSInclude", colors.base10, colors.none)
hl("TSKeyword", colors.base15, colors.none, italic)
hl("TSKeywordFunction", colors.base14, colors.none)
hl("TSKeywordOperator", colors.base14, colors.none)
hl("TSKeywordReturn", colors.base11, colors.none)
hl("TSLabel", colors.base15, colors.none)
hl("TSMethod", colors.base6, colors.none)
hl("TSNamespace", colors.base4, colors.none)
hl("TSNumber", colors.base9, colors.none)
hl("TSOperator", colors.base14, colors.none)
hl("TSParameter", colors.base13, colors.none)
hl("TSProperty", colors.base6, colors.none)
hl("TSPunctDelimiter", colors.base3:light(0.15), colors.none)
hl("TSPunctBracket", colors.base4, colors.none)
hl("TSPunctSpecial", colors.base5, colors.none)
hl("TSRepeat", colors.base7, colors.none)
hl("TSString", colors.base8, colors.none)
hl("TSStringRegex", colors.base11, colors.none)
hl("TSStringEscape", colors.base9, colors.none)
hl("TSStringSpecial", colors.base14, colors.none)
hl("TSSymbol", colors.base12, colors.none)
hl("TSTag", colors.base10, colors.none)
hl("TSTagAttribute", colors.base13, colors.none)
hl("TSTagDelimiter", colors.base3, colors.none)
hl("TSText", colors.base5, colors.none)
hl("TSTextReference", colors.base13, colors.none)
hl("TSTitle", colors.base6, colors.none, bold)
hl("TSType", colors.base11, colors.none)
hl("TSTypeBuiltin", colors.base3, colors.none)
hl("TSVariable", colors.base5, colors.none)
hl("TSVariableBuiltin", colors.base4, colors.none)

hl("TSDefinitionUsage", colors.none, colors.none, underline)
hl("TSDefinition", colors.none, colors.base1:light(0.05), underline)

-- Quickfix
hl("qfFileName", colors.base6, colors.none)
hl("qfSeparator", colors.base0, colors.none)
hl("qfLineNr", colors.base2, colors.none, italic)
hl("QuickFixLine", colors.none, colors.base0:light(0.03))
hl("BqfPreviewBorder", colors.base14, colors.none)
hl("BqfPreviewCursor", colors.none, colors.base2)

-- Plugins
hl('TabLineFill', colors.none, colors.base0)
hl('BufferOffset', colors.none, colors.base0)

hl('BufferCurrent', colors.base0, colors.base6)
hl('BufferCurrentSign', colors.base0, colors.base6)
hl('BufferCurrentIndex', colors.base0, colors.base6)
hl('BufferCurrentMod', colors.base0, colors.base6)

hl('BufferVisible', colors.base3, colors.base1)
hl('BufferVisibleSign', colors.base3, colors.base1)
hl('BufferVisibleIndex', colors.base3, colors.base1)
hl('BufferVisibleMod', colors.base3, colors.base1)

hl('BufferInactive', colors.base2, colors.base0)
hl('BufferInactiveSign', colors.base2, colors.base0)
hl('BufferInactiveIndex', colors.base2, colors.base0)
hl('BufferInactiveMod', colors.base2, colors.base0)

hl('BufferCurrentTarget', colors.base14, colors.base6, bold)
hl('BufferInactiveTarget', colors.base14, colors.base1, bold)
hl('BufferVisibleTarget', colors.base14, colors.base2, bold)

hl("Scrollbar", colors.none, colors.base0:light(0.04))

hl("DapLine", colors.none, colors.base0:light(0.02))
hl("DapBreakpoint", colors.base7, colors.base0:light(0.02))
hl("DapStopped", colors.base6, colors.base0:light(0.02))
hl("DapLogPoint", colors.base14, colors.base0:light(0.02))

hl("NvimDapVirtualText", colors.base2, colors.base0, italic)


hl("NvimTreeNormal", colors.base4, colors.base0)
hl("NvimTreeRootFolder", colors.base7, colors.none, italic)
hl("NvimTreeIndentMarker", colors.base2, colors.none)
hl("NvimTreeFolderIcon", colors.base6, colors.none)
hl("NvimTreeFolderName", colors.base6, colors.none, bold)
hl("NvimTreeOpenedFolderName", colors.base6, colors.none, bold)
hl("NvimTreeOpenedFile", colors.base7, colors.none, italic)
hl("NvimTreeStatuslineNC", colors.none, colors.base1, italic)

hl("FloatermBorder", colors.base6, colors.base0)

hl("IndentBlanklineChar", colors.base0:light(0.02), colors.none)
hl("IndentBlanklineContextChar", colors.base2, colors.none, bold)

hl("GitSignsAdd", colors.base10, colors.none)
hl("GitSignsAddNr", colors.base10, colors.none)
hl("GitSignsAddLn", colors.base5, colors.base10)

hl("GitSignsChange", colors.base11, colors.none)
hl("GitSignsChangeNr", colors.base11, colors.none)
hl("GitSignsChangeLn", colors.base5, colors.base11)

hl("GitSignsDelete", colors.base7, colors.none)
hl("GitSignsDeleteNr", colors.base7, colors.none)
hl("GitSignsDeleteLn", colors.base5, colors.base7)

hl("GitSignsCurrentLineBlame", colors.base3, colors.none, italic)

hl("CompeDocumentation", colors.none, colors.base0)
hl("CompeDocumentationBorder", colors.base6, colors.base0)

hl("LspSignature", colors.base6, colors.none, bold)

-- Lsp
hl("LspDiagnosticsSignError", colors.base10, colors.base0)
hl("LspDiagnosticsSignWarning", colors.base9, colors.base0)
hl("LspDiagnosticsSignInformation", colors.base3, colors.base0)
hl("LspDiagnosticsSignHint", colors.base2, colors.base0)

hl("LspDiagnosticsVirtualTextError", colors.base10, colors.none, italic)
hl("LspDiagnosticsVirtualTextWarning", colors.base9, colors.none, italic)
hl("LspDiagnosticsVirtualTextInformation", colors.base3, colors.none, italic)
hl("LspDiagnosticsVirtualTextHint", colors.base2, colors.none, italic)

hl("LspDiagnosticsUnderlineError", colors.none, colors.none, underline)
hl("LspDiagnosticsUnderlineWarning", colors.none, colors.none, underline)
hl("LspDiagnosticsUnderlineInformation", colors.none, colors.none)
hl("LspDiagnosticsUnderlineHint", colors.none, colors.none)

hl("TroubleFile", colors.base6, colors.none, italic)
hl("TroubleCount", colors.base11, colors.base0:light(0.02))


hl("FocusedSymbol", colors.base6, colors.none, bold)

hl("WhichKey", colors.base11, colors.none, bold)
hl("WhichKeySeperator", colors.base2, colors.none, none)
hl("WhichKeyGroup", colors.base6, colors.none, none)
hl("WhichKeyDesc", colors.base4, colors.none, none)

hl("TelescopeSelection", colors.base6, colors.base0:light(0.02), bold)
hl("TelescopeSelectionCarat", colors.base7, colors.none)
hl("TelescopeMultiSelection", colors.base11, colors.none, bold)
hl("TelescopeNormal", colors.base4, colors.none)

hl("TelescopeBorder", colors.base4, colors.none)
hl("TelescopePromptBorder", colors.base10, colors.none)
hl("TelescopeResultsBorder", colors.base6, colors.none)
hl("TelescopePreviewBorder", colors.base3, colors.none)

hl("TelescopeMatching", colors.base6, colors.none, bold)
hl("TelescopePromptPrefix", colors.base10, colors.none)

hl("StartifyHeader", colors.base6, colors.none)

-- Language Specific
-- Markdown(pandoc)
hl("pandocAtxHeader", colors.base6, colors.none, bold)
hl("pandocAtxStart", colors.base11, colors.none)
hl("pandocListItemBulletID", colors.base14, colors.none)
hl("pandocListItemBullet", colors.base2, colors.none)


-- Yaml
hl("yamlDocumentStart", colors.base2, colors.none)
hl("yamlPlainScalar", colors.base3, colors.none)
hl("yamlBlockMappingKey", colors.base11, colors.none, italic)
hl("yamlKeyValueDelimiter", colors.base2, colors.none, italic)


-- R
hl("routnormal", colors.base4, colors.none)
hl("routerror", colors.base10, colors.none, italic)

-- Java Docs
hl("java1", colors.base11, colors.none, italic)

-- Highlight Yank
au(
	'TextYankPost',
	'* silent!',
	'lua vim.highlight.on_yank{ higroup="Yank", timeout=250 }'
)
