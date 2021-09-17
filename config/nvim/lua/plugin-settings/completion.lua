local cmp = require 'cmp'
local mappings = require 'mappings.completion'

local LspItemKind = {
	Text = " Text",
	Method = " Method",
	Function = " Function",
	Constructor = " Constructor",
	Field = "פּ Field",
	Variable = " Variable",
	Class = " Class",
	Interface = " Interface",
	Module = " Module",
	Proeperty = "襁Property",
	Unit = " Unit",
	Value = " Value",
	Enum = "練Enum",
	Keyword = " Keyword",
	Snippet = " Snippet",
	Color = " Color",
	File = " File",
	Reference = " Link",
	Folder = " Folder",
	EnumMember = " EnumMember",
	Constant = " Constant",
	Struct = " Struct",
	Event = " Event",
	Opertaor = " Operator",
	TypeParameter = " TypeParameter",
}

local function truncate(item)
	if string.len(item.abbr) > 24 then
		if string.sub(item.abbr, 23, 23) == "," then
			item.abbr = string.sub(item.abbr, 1, 23) .. "…  "
		else
			item.abbr = string.sub(item.abbr, 1, 22) .. "…  "
		end
	end

	return item
end

local function format(entry, item)
	local source = entry.source.name
	item = truncate(item)

	if source == 'nvim_lsp' or 'path' then
		item.kind = LspItemKind[item.kind]
	elseif source == 'buffer' then
		item.kind = "﬘ Buffer"
	elseif source == 'spell' then
		item.kind = " Spell"
	end

  item.label = ""

	return item
end

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	documentation = false,
	sources = {
		{name = "nvim_lsp"},
		{name = "vsnip"},
		{name = "buffer"},
		{name = "path"},
		-- {name = "spell"},
	},
	formatting = {
		format = format
	},
	mapping = mappings,
	autocomplete = false
})

--[[ source = {
		path = {kind = "/ Path", menu = "", true},
		buffer = {kind = "﬘ Buffer", menu = "", true},
		calc = {kind = " Calc", menu = "", true},
		nvim_lsp = {menu = "", true},
		vsnip = {priority = 2000, kind = " Snippet", menu = "", true},
		omni = {kind = " Omni", menu = "", true},
		nvim_lua = false,
		luasnip = false,
		treesitter = false,
	} ]]

require('nvim-autopairs').setup {}
require("nvim-autopairs.completion.cmp").setup({
	map_cr = false,

	--  map <CR> on insert mode
	map_complete = true,

	-- it will auto insert `(` (map_char) after select function or method item
	auto_select = false,

	-- automatically select the first item
	insert = true,

	-- use insert confirm behavior instead of replace
	map_char = {
		-- modifies the function or method delimiter by filetypes
		all = '(',
		tex = '{'
	}
})
