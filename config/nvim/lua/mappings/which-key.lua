local wk = require 'which-key'

local mappings = {
	r = {'<cmd>FloatermNew --height=0.9 --width=0.9 lf<cr>', 'lf'},
	e = {'<cmd>lua require"utils.tree".toggle()<cr>', 'tree'},
	q = {'<cmd>lua require"utils.close".close()<cr>', 'close buffer'},
	c = {[[<cmd>let @/ = ''<cr>]], 'clear search'},
	o = {'<cmd>SymbolsOutline<cr>', 'outline'},
	h = {'<cmd>Telescope help_tags<cr>', 'help'},
	F = {'<cmd>Telescope find_files<cr>', 'find files'},
	C = {'<cmd>ColorizerToggle<cr>', 'colorizer'},
	S = {'<cmd>UltiSnipsEdit<cr>', 'snippet'},
	f = {'<cmd>FormatWrite<cr>', 'format'},
	a = {
		name = '+actions',
		s = {'<cmd>so<cr>', 'source'},
		h = {'<cmd>TSHighlightCapturesUnderCursor<cr>', 'highlight'},
	},
	s = {
		name = '+settings',
		s = {'<cmd>setlocal spell!<cr>', 'spell'},
		h = {'<cmd>set conceallevel=2<cr>', 'conceal'},
		c = {'<cmd>set conceallevel=0<cr>', 'no-conceal'},
		w = {'<cmd>set wrap!<cr>', 'wrap'},
	},
	l = {
		name = '+lsp',
		c = {'<cmd>lua vim.lsp.buf.code_action()<cr>', 'code action'},
		t = {'<cmd>Trouble lsp_document_diagnostics<cr>', 'file diag.'},
		T = {'<cmd>Trouble lsp_workspace_diagnostics<cr>', 'global diag.'},
	},
	T = {
		name = '+treesitter',
		o = {'<cmd>TSPlaygroundToggle<cr>', 'playground'},
	},
	D = {'<cmd>lua require"dap".step_over()<cr>', 'debug next'},
	d = {
		name = '+debug',
		d = {'<cmd>lua require"dap".continue()<cr>', 'start'},
		b = {'<cmd>lua require"dap".toggle_breakpoint()<cr>', 'breakpoint'},
		r = {'<cmd>lua require"dap".repl.toggle()<cr>', 'repl'},
		n = {'<cmd>lua require"dap".step_over()<cr>', 'step'},
		j = {
			'<cmd>lua require "jdtls.dap".setup_dap_main_class_configs()<cr>',
			'java setup'
		},
	},
	t = {
		name = '+telescope',
		c = {'<cmd>Telescope command_history<cr>', 'command history'},
		s = {'<cmd>Telescope search_history<cr>', 'searches'},
		o = {'<cmd>Telescope oldfiles<cr>', 'old files'},
		r = {'<cmd>Telescope registers<cr>', 'registers'},
		O = {'<cmd>Telescope vim_options<cr>', 'vim options'},
		y = {'<cmd>Telescope neoclip<cr>', 'neoclip'},
	},
	P = {
		name = '+packer',
		c = {'<cmd>PackerCompile<cr>', 'compile'},
		i = {'<cmd>so | PackerInstall<cr>', 'install'},
		C = {'<cmd>PackerClean<cr>', 'clean'},
		u = {'<cmd>PackerUpdate<cr>', 'update'},
		s = {'<cmd>PackerStatus<cr>', 'status'},
	},
	g = {
		name = '+git',
		s = {'<cmd>Gitsigns toggle_signs<cr>', 'signs'},
		C = {'<cmd>Git commit<cr>', 'commit'},
		a = {'<cmd>Git add %<cr>', 'add current'},
		A = {'<cmd>Git add .<cr>', 'add all'},
		S = {'<cmd>Git status<cr>', 'status'},
		P = {'<cmd>Git push<cr>', 'push'},
		b = {'<cmd>Gitsigns blame_line<cr>', 'line blame'},
		B = {'<cmd>Gitsigns toggle_current_line_blame<cr>', 'toggle blame'},
		l = {'<cmd>Telescope git_bcommits<cr>', 'list bcommits'},
		L = {'<cmd>Telescope git_commits<cr>', 'list commits'},
	},
	z = {
		name = '+files',
		i = {'<cmd>e ~/other/dotfiles/config/nvim/init.lua<cr>', 'vimrc'},
		t = {'<cmd>e ~/university/TODO.md<cr>', 'TODO'},
		h = {
			'<cmd>e ~/other/dotfiles/config/nvim/lua/highlight.lua<cr>',
			'highlight'
		},
		p = {
			'<cmd>e ~/other/dotfiles/config/nvim/lua/plugins.lua<cr>',
			'plugins'
		},
		m = {
			'<cmd>e ~/other/dotfiles/config/nvim/lua/mappings/general.lua<cr>',
			'mappings'
		},
		w = {
			'<cmd>e ~/other/dotfiles/config/nvim/lua/mappings/which-key.lua<cr>',
			'mappings'
		},
		l = {'<cmd>e ~/other/dotfiles/config/lf/lfrc<cr>', 'lfrc'},
		b = {'<cmd>e ~/other/dotfiles/config/bspwm/bspwmrc<cr>', 'bspwmrc'},
		z = {'<cmd>e ~/other/dotfiles/config/zsh/.zshrc<cr>', 'zshrc'},
		s = {'<cmd>e ~/other/dotfiles/config/sxhkd/sxhkdrc<cr>', 'sxhkd'},
		['='] = {'<cmd>e ~/other/dotfiles/config/picom/picom.conf<cr>', 'picom'},
	},
	p = {
		name = '+pandoc',
		p = {
			'<cmd>e ~/.local/share/pandoc/templates/paper.latex<cr>',
			'paper template'
		},
		d = {
			'<cmd>e ~/.local/share/pandoc/templates/default.latex<cr>',
			'default template'
		},
		D = {
			'<cmd>e ~/.local/share/pandoc/defaults.yaml<cr>',
			'default metadata'
		},
		m = {'<cmd>silent exec "!make"<cr>', 'make'},
		v = {'<cmd>silent exec "!make view"<cr>', 'view'},
	},
}

wk.register(mappings, {prefix = '<leader>'})
