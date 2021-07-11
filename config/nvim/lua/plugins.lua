local packer = require("packer")
local use = packer.use

return packer.startup(
    function()
        use "wbthomason/packer.nvim"

        use "kyazdani42/nvim-web-devicons"
        use "tjdevries/colorbuddy.nvim"

        use {
          "glepnir/galaxyline.nvim",
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
                require("plugin-settings/bufferline")
            end
        }

        use {
          "voldikss/vim-floaterm",
            config = function()
                require("plugin-settings/floaterm")
          end
        }

        use {
             "folke/which-key.nvim",
             config = function()
                 require("plugin-settings/which-key")
             end
        }

--         -- language related plugins
         use {
             "nvim-treesitter/nvim-treesitter",
             config = function()
                 require("plugin-settings/treesitter")
             end
         }

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
             "glepnir/lspsaga.nvim",
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
                require("nvim-autopairs.completion.compe").setup(
                    {
                        map_cr = true,
                        map_complete = true -- insert () func completion
                    }
                )
            end
        }


--         use {
--             "onsails/lspkind-nvim",
--             event = "BufRead",
--             config = function()
--                 require("lspkind").init()
--             end
--         }

--         -- load compe in insert mode only

        -- file managing , picker etc
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

--         -- git stuff
--         use {
--             "lewis6991/gitsigns.nvim",
--             event = "BufRead",
--             config = function()
--                 require("gitsigns-nvim").config()
--             end
--         }

--         -- misc plugins

--         use {"andymass/vim-matchup", event = "CursorMoved"}

--         use {
--             "terrortylor/nvim-comment",
--             cmd = "CommentToggle",
--             config = function()
--                 require("nvim_comment").setup()
--             end
--         }

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

--         use {"tweekmonster/startuptime.vim", cmd = "StartupTime"}

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

--         -- smooth scroll
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

--         use {
--             "lukas-reineke/indent-blankline.nvim",
--             event = "BufRead",
--             setup = function()
--                 require("misc-utils").blankline()
--             end
--         }
--     end,
--     {
--         display = {
--             border = {"┌", "─", "┐", "│", "┘", "─", "└", "│"}
--         }
--     }
end)
