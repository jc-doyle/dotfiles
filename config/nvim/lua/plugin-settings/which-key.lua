require("which-key").setup {
	plugins = {
		marks = false,
		registers = false,
		spelling = {
			enabled = false,
			suggestions = 20,
		},
		presets = {
			operators = false,
			motions = false,
			text_objects = false,
			windows = false,
			nav = false,
			z = false,
			g = false,
		},
	},

	key_labels = {
		["<leader>"] = "",

		-- ["<cr>"] = "RET",
		-- ["<tab>"] = "TAB",
	},
	icons = {
		breadcrumb = "»",
		separator = "∈",
		group = "+",
	},
	window = {
		border = "none",
		position = "bottom",
		margin = {1, 0, 0, 0},
		padding = {2, 2, 2, 2},
	},
	layout = {
		height = {min = 4, max = 25},
		width = {min = 25, max = 50},
		spacing = 10,
		align = "center",
	},
	ignore_missing = false,
	hidden = {"<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "},
	show_help = false,
	triggers = {"<leader>"},
	triggers_blacklist = {
		-- list of mode / prefixes that should never be hooked by WhichKey
		-- this is mostly relevant for key maps that start with a native binding
		-- most people should not need to change this
		n = {"g"},
		v = {"j", "k"}
	}
}
