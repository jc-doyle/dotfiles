local packer = require("packer")
local use = packer.use

return packer.startup(function()
	use "wbthomason/packer.nvim"
	use "kyazdani42/nvim-web-devicons"
	use "tjdevries/colorbuddy.nvim"
	use "tpope/vim-fugitive"
	use "hrsh7th/vim-vsnip"
	use "rafamadriz/friendly-snippets"

	use {
		"lewis6991/gitsigns.nvim",
		config = function()
			require("plugin-settings/gitsigns")
		end
	}

	use {
		"Famiu/feline.nvim",
		config = function()
			require("plugin-settings/statusline")
		end
	}

	use {
		"norcalli/nvim-colorizer.lua",
		event = "BufRead",
		config = function()
			require("colorizer").setup()
			vim.cmd("ColorizerReloadAllBuffers")
		end
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
	use "windwp/nvim-ts-autotag"

	use {
		"b3nj5m1n/kommentary",
	}

	use {
		"neovim/nvim-lspconfig",
		config = function()
			require("lsp")
		end
	}

	use {
		"kabouzeid/nvim-lspinstall",
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
			require("plugin-settings/filetree")
		end
	}

	use {
		"nvim-telescope/telescope.nvim",
		requires = {
			{"nvim-lua/popup.nvim"},
			{"nvim-lua/plenary.nvim"},
			{"nvim-telescope/telescope-fzf-native.nvim", run = "make"},
			{"nvim-telescope/telescope-media-files.nvim"}
		},
		cmd = "Telescope",
		config = function()
			require("telescope-nvim").config()
		end
	}

	--         use {
	--             "glepnir/dashboard-nvim",
	--             cmd = {
	--                 "Dashboard",
	--                 "DashboardNewFile",
	--                 "DashboardJumpMarks",
	--                 "SessionLoad",
	--                 "SessionSave"
	--             },
	--             setup = function()
	--                 require("dashboard").config()
	--             end
	--         }

	use {"tweekmonster/startuptime.vim", cmd = "StartupTime"}

	--         -- load autosave only if its globally enabled
	--         use {
	--             "Pocco81/AutoSave.nvim",
	--             config = function()
	--                 require("zenmode").autoSave()
	--             end,
	--             cond = function()
	--                 return vim.g.auto_save == true
	--             end
	--         }

	use {
		"karb94/neoscroll.nvim",
		event = "WinScrolled",
		config = function()
			require("neoscroll").setup()
		end
	}

	--         use {
	--             "Pocco81/TrueZen.nvim",
	--             cmd = {"TZAtaraxis", "TZMinimalist", "TZFocus"},
	--             config = function()
	--                 require("zenmode").config()
	--             end
	--         }

	--         --   use "alvan/vim-closetag" -- for html autoclosing tag

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
end)
