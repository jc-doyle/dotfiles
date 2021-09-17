-- UI Settings
local lsp = vim.lsp

-- Padding on left/right
local border = {
      {"", "FloatBorder"},
      {"", "FloatBorder"},
      {"", "FloatBorder"},
      {" ", "FloatBorder"},
      {"", "FloatBorder"},
      {"", "FloatBorder"},
      {"", "FloatBorder"},
      {" ", "FloatBorder"},
}

lsp.handlers["textDocument/signatureHelp"] = lsp.with(
	lsp.handlers.signature_help,
	{border = border}
)

lsp.handlers["textDocument/hover"] = lsp.with(
	lsp.handlers.hover,
	{border = border}
)



lsp.protocol.CompletionItemKind = {
	" Text",
	" Method",
	" Function",
	" Constructor",
	"פּ Field",
	" Variable",
	" Class",
	" Interface",
	" Module",
	"襁Property",
	" Unit",
	" Value",
	"練Enum",
	" Keyword",
	" Snippet",
	" Color",
	" File",
	" Reference",
	" Folder",
	" EnumMember",
	" Constant",
	" Struct",
	" Event",
	" Operator",
	" TypeParameter",
}
