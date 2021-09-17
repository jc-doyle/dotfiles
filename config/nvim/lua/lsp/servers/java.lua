local util = require "lspconfig/util"

local path = vim.fn.stdpath('data') .. '/lsp/java/'
local cmd = path .. 'jdtls.sh'

local workspace_folder, _ = string.gsub(
	vim.fn.fnamemodify(vim.fn.getcwd(), ":h"),
	"/",
	"-"
)
local workspace_path = path .. 'workspace/' .. workspace_folder

local root_files = {
	-- Single-module projects
	{
		"build.xml",
		"pom.xml",
		"settings.gradle",
		"settings.gradle.kts",
	},
	{"build.gradle", "build.gradle.kts"},
}

local root_dir = function(...)
	for _, patterns in ipairs(root_files) do
		local root = util.root_pattern(unpack(patterns))(...)
		if root then
			return root
		end
	end
	return util.root_pattern(".git")(...)
end

local extendedClientCapabilities = require 'jdtls'.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.workspace.configuration = true
capabilities.textDocument.completion.completionItem.snippetSupport = true

local debug_path = vim.fn.glob(path .. "java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar")

local settings = {
	java = {
		signatureHelp = {enabled = true};
		referenceCodeLens = {enabled = true};
		implementationCodeLens = {enabled = true};
		contentProvider = {preferred = 'fernflower'};
		completion = {
			favoriteStaticMembers = {
				"java",
				"org",
				"javax",
			}
		};
	}
}

local config = {
	cmd = {cmd, workspace_path},
	root_dir = root_dir,
	capabilities = capabilities,
	settings = settings,
	init_options = {
		extendedClientCapabilities = extendedClientCapabilities,
		bundles = {debug_path}
	}

	-- flags = {allow_incremental_sync = true},
}

-- Telescope CodeAction UI
local finders = require 'telescope.finders'
local sorters = require 'telescope.sorters'
local actions = require 'telescope.actions'
local pickers = require 'telescope.pickers'
require('jdtls.ui').pick_one_async = function(items, prompt, label_fn, cb)
	local opts = {results_title = false}
	pickers.new(opts, {
		prompt_title = prompt,
		finder = finders.new_table {
			results = items,
			entry_maker = function(entry)
				return {
					value = entry,
					display = label_fn(entry),
					ordinal = label_fn(entry),
				}
			end,
		},
		sorter = sorters.get_generic_fuzzy_sorter(),
		attach_mappings = function(prompt_bufnr)
			actions.select_default:replace(function()
				local selection = actions.get_selected_entry(prompt_bufnr)
				actions.close(prompt_bufnr)

				cb(selection.value)
			end)

			return true
		end,
	}):find()
end

require 'jdtls'.setup_dap()

return config
