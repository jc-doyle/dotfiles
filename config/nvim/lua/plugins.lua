local packer = require("packer")
local use = packer.use

return packer.startup(function()
	use "wbthomason/packer.nvim"
	use "kyazdani42/nvim-web-devicons"
	use "tjdevries/colorbuddy.nvim"
	use "tpope/vim-fugitive"
	use "hrsh7th/vim-vsnip"
	use "tpope/vim-surround"
	use "b3nj5m1n/kommentary"
	use "rafamadriz/friendly-snippets"
	use "kabouzeid/nvim-lspinstall"
	use "nvim-lua/plenary.nvim"
	use "nvim-lua/popup.nvim"

	use {
		"lewis6991/gitsigns.nvim",
		config = function()
			require("plugin-settings.gitsigns")
		end
	}

	use {
		"Famiu/feline.nvim",
		config = function()
			require("plugin-settings.statusline")
		end
	}

	use {
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end
	}

	use {
		"akinsho/nvim-toggleterm.lua",
		event = "BufWinEnter",
		config = function()
			require("plugin-settings.terminal")
		end,
	}

	use {
		"romgrk/barbar.nvim",
		config = function()
			require("plugin-settings.bufferline")
		end
	}

	use {
		"voldikss/vim-floaterm",
		config = function()
			require("plugin-settings.floaterm")
		end
	}

	use {
		"folke/which-key.nvim",
		config = function()
			require("plugin-settings.which-key")
		end
	}

	use {
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("plugin-settings.treesitter")
		end
	}
	use "nvim-treesitter/nvim-treesitter-textobjects"
	use "nvim-treesitter/playground"
	use "nvim-treesitter/nvim-treesitter-refactor"

	use {
		"neovim/nvim-lspconfig",
		config = function()
			require("lsp")
		end
	}

	use {
		"kosayoda/nvim-lightbulb",
	}

	use {
		"simrat39/symbols-outline.nvim",
		config = function()
			require("lsp.outline")
		end
	}

	use {
		"hrsh7th/nvim-compe",
		event = "InsertEnter",
		config = function()
			require("lsp.completion")
		end
	}

	use {
		"windwp/nvim-autopairs",
		after = "nvim-compe",
		config = function()
			require("nvim-autopairs").setup()
			require("nvim-autopairs.completion.compe").setup({
				map_cr = true,
				map_complete = true

				-- insert () func completion
			})
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
		"mhartington/formatter.nvim",
		config = function()
			require("plugin-settings.format")
		end,
		event = "BufRead",
	}

	use {
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("plugin-settings.indent")
		end,
		event = "BufRead",
	}

	use {"tweekmonster/startuptime.vim", cmd = "StartupTime"}
end)
