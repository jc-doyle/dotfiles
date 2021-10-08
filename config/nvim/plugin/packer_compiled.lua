-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/jonty/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/jonty/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/jonty/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/jonty/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/jonty/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["Nvim-R"] = {
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/Nvim-R"
  },
  ["barbar.nvim"] = {
    config = { "\27LJ\2\n:\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\31plugin-settings.bufferline\frequire\0" },
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/barbar.nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/cmp-buffer"
  },
  ["cmp-latex-symbols"] = {
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/cmp-latex-symbols"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp"
  },
  ["cmp-nvim-ultisnips"] = {
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/cmp-nvim-ultisnips"
  },
  ["cmp-pandoc-references"] = {
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/cmp-pandoc-references"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/cmp-path"
  },
  ["cmp-spell"] = {
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/cmp-spell"
  },
  ["colorbuddy.nvim"] = {
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/colorbuddy.nvim"
  },
  ["formatter.nvim"] = {
    commands = { "FormatWrite" },
    config = { "\27LJ\2\n6\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\27plugin-settings.format\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/opt/formatter.nvim"
  },
  ["goyo.vim"] = {
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/goyo.vim"
  },
  ["indent-blankline.nvim"] = {
    config = { "\27LJ\2\n6\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\27plugin-settings.indent\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/opt/indent-blankline.nvim"
  },
  ["lsp_signature.nvim"] = {
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/lsp_signature.nvim"
  },
  ["neoscroll.nvim"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14neoscroll\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/opt/neoscroll.nvim"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\2\n9\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\30plugin-settings.autopairs\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/opt/nvim-autopairs"
  },
  ["nvim-bqf"] = {
    config = { "\27LJ\2\n8\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\29plugin-settings.quickfix\frequire\0" },
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/nvim-bqf"
  },
  ["nvim-cmp"] = {
    after = { "nvim-autopairs" },
    loaded = true,
    only_config = true
  },
  ["nvim-colorizer.lua"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14colorizer\frequire\0" },
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua"
  },
  ["nvim-comment"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17nvim_comment\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/opt/nvim-comment"
  },
  ["nvim-dap"] = {
    config = { "\27LJ\2\n5\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\26plugin-settings.debug\frequire\0" },
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/nvim-dap"
  },
  ["nvim-dap-virtual-text"] = {
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/nvim-dap-virtual-text"
  },
  ["nvim-gps"] = {
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/nvim-gps"
  },
  ["nvim-jdtls"] = {
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/nvim-jdtls"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\2\n#\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\blsp\frequire\0" },
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-tree.lua"] = {
    config = { "\27LJ\2\n8\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\29plugin-settings.filetree\frequire\0" },
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\n:\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\31plugin-settings.treesitter\frequire\0" },
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-treesitter-refactor"] = {
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/nvim-treesitter-refactor"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["scrollbar.nvim"] = {
    config = { "\27LJ\2\n9\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\30plugin-settings.scrollbar\frequire\0" },
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/scrollbar.nvim"
  },
  ["startuptime.vim"] = {
    commands = { "StartupTime" },
    loaded = false,
    needs_bufread = false,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/opt/startuptime.vim"
  },
  ["symbols-outline.nvim"] = {
    commands = { "SymbolsOutline" },
    config = { "\27LJ\2\n7\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\28plugin-settings.outline\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/opt/symbols-outline.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n9\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\30plugin-settings.telescope\frequire\0" },
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["trouble.nvim"] = {
    config = { "\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20lsp.diagnostics\frequire\0" },
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/trouble.nvim"
  },
  ultisnips = {
    config = { "\27LJ\2\n8\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\29plugin-settings.snippets\frequire\0" },
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/ultisnips"
  },
  ["vim-floaterm"] = {
    config = { "\27LJ\2\n8\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\29plugin-settings.floaterm\frequire\0" },
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/vim-floaterm"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/vim-fugitive"
  },
  ["vim-pandoc-syntax"] = {
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/vim-pandoc-syntax"
  },
  ["vim-pencil"] = {
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/vim-pencil"
  },
  ["vim-python-pep8-indent"] = {
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/vim-python-pep8-indent"
  },
  ["vim-startify"] = {
    loaded = true,
    needs_bufread = false,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/opt/vim-startify"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/vim-surround"
  },
  vimtex = {
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/vimtex"
  },
  ["virtual-types.nvim"] = {
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/virtual-types.nvim"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\2\n9\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\30plugin-settings.which-key\frequire\0" },
    loaded = true,
    path = "/home/jonty/.local/share/nvim/site/pack/packer/start/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Setup for: vim-startify
time([[Setup for vim-startify]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\30plugin-settings.dashboard\frequire\0", "setup", "vim-startify")
time([[Setup for vim-startify]], false)
time([[packadd for vim-startify]], true)
vim.cmd [[packadd vim-startify]]
time([[packadd for vim-startify]], false)
-- Config for: scrollbar.nvim
time([[Config for scrollbar.nvim]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\30plugin-settings.scrollbar\frequire\0", "config", "scrollbar.nvim")
time([[Config for scrollbar.nvim]], false)
-- Config for: vim-floaterm
time([[Config for vim-floaterm]], true)
try_loadstring("\27LJ\2\n8\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\29plugin-settings.floaterm\frequire\0", "config", "vim-floaterm")
time([[Config for vim-floaterm]], false)
-- Config for: nvim-dap
time([[Config for nvim-dap]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\26plugin-settings.debug\frequire\0", "config", "nvim-dap")
time([[Config for nvim-dap]], false)
-- Config for: ultisnips
time([[Config for ultisnips]], true)
try_loadstring("\27LJ\2\n8\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\29plugin-settings.snippets\frequire\0", "config", "ultisnips")
time([[Config for ultisnips]], false)
-- Config for: which-key.nvim
time([[Config for which-key.nvim]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\30plugin-settings.which-key\frequire\0", "config", "which-key.nvim")
time([[Config for which-key.nvim]], false)
-- Config for: trouble.nvim
time([[Config for trouble.nvim]], true)
try_loadstring("\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20lsp.diagnostics\frequire\0", "config", "trouble.nvim")
time([[Config for trouble.nvim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\30plugin-settings.telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\31plugin-settings.completion\frequire\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)
-- Config for: nvim-bqf
time([[Config for nvim-bqf]], true)
try_loadstring("\27LJ\2\n8\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\29plugin-settings.quickfix\frequire\0", "config", "nvim-bqf")
time([[Config for nvim-bqf]], false)
-- Config for: barbar.nvim
time([[Config for barbar.nvim]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\31plugin-settings.bufferline\frequire\0", "config", "barbar.nvim")
time([[Config for barbar.nvim]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\2\n#\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\blsp\frequire\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\31plugin-settings.treesitter\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: nvim-colorizer.lua
time([[Config for nvim-colorizer.lua]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14colorizer\frequire\0", "config", "nvim-colorizer.lua")
time([[Config for nvim-colorizer.lua]], false)
-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
try_loadstring("\27LJ\2\n8\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\29plugin-settings.filetree\frequire\0", "config", "nvim-tree.lua")
time([[Config for nvim-tree.lua]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd nvim-autopairs ]]

-- Config for: nvim-autopairs
try_loadstring("\27LJ\2\n9\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\30plugin-settings.autopairs\frequire\0", "config", "nvim-autopairs")

time([[Sequenced loading]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file SymbolsOutline lua require("packer.load")({'symbols-outline.nvim'}, { cmd = "SymbolsOutline", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file FormatWrite lua require("packer.load")({'formatter.nvim'}, { cmd = "FormatWrite", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file StartupTime lua require("packer.load")({'startuptime.vim'}, { cmd = "StartupTime", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au WinScrolled * ++once lua require("packer.load")({'neoscroll.nvim'}, { event = "WinScrolled *" }, _G.packer_plugins)]]
vim.cmd [[au BufRead * ++once lua require("packer.load")({'nvim-comment', 'indent-blankline.nvim'}, { event = "BufRead *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
