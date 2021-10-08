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
	Property = "襁Property",
	Unit = " Unit",
	Value = " Value",
	Enum = "練Enum",
	Keyword = " Keyword",
	Snippet = " Snippet",
	Color = " Color",
	File = " File",
	Reference = " Reference",
	Folder = " Folder",
	EnumMember = " EnumMember",
	Constant = " Constant",
	Struct = " Struct",
	Event = " Event",
	Opertaor = " Operator",
	TypeParameter = " TypeParameter",
}

local function format_kind(entry, item)
	local source = entry.source.name
	item.kind = LspItemKind[item.kind]

	if source == 'buffer' then
		item.kind = "﬘ Buffer"
	elseif source == 'spell' then
		item.kind = " Spell"
	elseif source == 'ultisnips' then
		item.abbr = item.abbr .. '~'
	elseif source == 'latex_symbols' then
		local result = {}
		for word in string.gmatch(item.abbr, "[^%s]+") do
			table.insert(result, word)
		end
		item.abbr = result[1]
		if result[2] ~= nil then
			item.kind = result[2] .. " Symbol"
		end
	elseif source == 'pandoc_references' then
    if not string.match(item.abbr, '(%w+):(%g+)') then
		  item.kind = " Citation"
    end
	end

	return item
end

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
	item = truncate(item)
	item = format_kind(entry, item)
	return item
end

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["UltiSnips#Anon"](args.body)
		end,
	},
	documentation = {
		border = {'', '', '', ' ', '', '', '', ' '},
		winhighlight = 'NormalFloat:NormalFloat,FloatBorder:NormalFloat',
		maxwidth = 40,
		maxheight = 15
	},
	sources = {
		{name = "nvim_lsp"},
		{name = "buffer"},
		{name = "path"},
		{name = "ultisnips"},
		{name = "latex_symbols"},
		{name = "pandoc_references"},

		-- {name = "vsnip"},
		-- {name = "spell"},
	},
	formatting = {format = format},
	mapping = mappings,
	autocomplete = false
})
