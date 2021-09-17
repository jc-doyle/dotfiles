local packer = require("packer")
local use = packer.use

return packer.startup(function()
	use "wbthomason/packer.nvim"

	-- LSP, Snippets & Completion ----------------------------------------
	use {
		"neovim/nvim-lspconfig",
		config = function()
			require("lsp")
		end
	}

	use {
		"folke/trouble.nvim",
		config = function()
			require("lsp.diagnostics")
		end
	}
	use "ray-x/lsp_signature.nvim"
	use "jubnzv/virtual-types.nvim"

	-- Tree Sitter ------------------------------------------------------
	use {
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("plugin-settings.treesitter")
		end
	}
	use "nvim-treesitter/nvim-treesitter-textobjects"
	use "nvim-treesitter/playground"
	use "nvim-treesitter/nvim-treesitter-refactor"

	-- Git --------------------------------------------------------------
	use {
		"lewis6991/gitsigns.nvim",
		config = function()
			require("plugin-settings.gitsigns")
		end
	}
	use "tpope/vim-fugitive"

	-- Completion & Snippets --------------------------------------------
	use {
		"hrsh7th/nvim-cmp",
		requires = {
			use "hrsh7th/vim-vsnip",
			use "hrsh7th/cmp-vsnip",
			use "hrsh7th/cmp-buffer",
			use "hrsh7th/cmp-path",
			use "hrsh7th/cmp-nvim-lsp",
      use "f3fora/cmp-spell"
		},
		config = function()
			require("plugin-settings.completion")
		end
	}

	-- use "abecodes/tabout.nvim"

	-- Editing Functionality --------------------------------------------
	use {
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end
	}

	use {
		"mhartington/formatter.nvim",
		config = function()
			require("plugin-settings.format")
		end,
		event = "BufRead",
	}

	use "windwp/nvim-autopairs"

	use "tpope/vim-surround"
	use "b3nj5m1n/kommentary"
	use "nvim-lua/plenary.nvim"
	use "nvim-lua/popup.nvim"
	use "tjdevries/colorbuddy.nvim"
	use "preservim/vim-pencil"

	-- Debug -----------------------------------------------------------
	use {
		"mfussenegger/nvim-dap",
		config = function()
			require("plugin-settings.debug")
		end
	}

	use "theHamsta/nvim-dap-virtual-text"

	-- Terminal --------------------------------------------------------
	use {
		"voldikss/vim-floaterm",
		config = function()
			require("plugin-settings.floaterm")
		end
	}

	-- UI/Tools --------------------------------------------------------
	use {
		"folke/which-key.nvim",
		config = function()
			require("plugin-settings.which-key")
		end
	}
	use {
		"romgrk/barbar.nvim",
		config = function()
			require("plugin-settings.bufferline")
		end
	}
	use {
		"Xuyuanp/scrollbar.nvim",
		config = function()
			require("plugin-settings.scrollbar")
		end
	}
	use {
		"kyazdani42/nvim-tree.lua",
		config = function()
			require("plugin-settings.filetree")
		end
	}
	use {
		"simrat39/symbols-outline.nvim",
		config = function()
			require("plugin-settings.outline")
		end,
		lock = true
	}
	use {
		"nvim-telescope/telescope.nvim",
		config = function()
			require("plugin-settings.telescope")
		end,
		requires = "sudormrfbin/cheatsheet.nvim"
	}
	use {
		"mhinz/vim-startify",
		setup = function()
			require("plugin-settings.dashboard")
		end
	}
	use {
		"karb94/neoscroll.nvim",
		event = "WinScrolled",
		config = function()
			require("neoscroll").setup()
		end
	}
	use {
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("plugin-settings.indent")
		end,
		event = "BufRead",
	}
	use {
		"kevinhwang91/nvim-bqf",
		config = function()
			require("plugin-settings.qf")
		end
	}
	use "kyazdani42/nvim-web-devicons"
	use "junegunn/goyo.vim"
	use {"tweekmonster/startuptime.vim", cmd = "StartupTime"}

	-- Language Specific -----------------------------------------------
	use "Vimjas/vim-python-pep8-indent"
	use "vim-pandoc/vim-pandoc-syntax"
	use "vim-pandoc/vim-pandoc"
	use "jalvesaq/Nvim-R"
	use "mfussenegger/nvim-jdtls"
end)
