require 'compe'.setup {
	enabled = true;
	autocomplete = true;
	debug = false;
	min_length = 2;
	preselect = 'always';
	throttle_time = 100;
	source_timeout = 200;
	resolve_timeout = 800;
	incomplete_delay = 400;
	max_abbr_width = 20;
	max_kind_width = 15;
	max_menu_width = 100;
	documentation = {
		border = "single",
		winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
		max_width = 60,
		min_width = 20,
		max_height = math.floor(vim.o.lines * 0.2),
		min_height = 1,
	};
	source = {
		path = {kind = "/ Path", menu = "", true};
		buffer = {kind = "﬘ Buffer", menu = "", true};
		calc = {kind = " Calc", menu = "", true};
		nvim_lsp = {menu = "", true};
		vsnip = {priority = 2000, kind = " Snippet", menu = "", true};
		nvim_lua = false;
		luasnip = false;
		treesitter = false;
	};
}

