require('formatter').setup({
	logging = false,
	filetype = {
		javascript = {
			-- prettier
			function()
				return {
					exe = "prettier",
					args = {
						"--stdin-filepath",
						vim.api.nvim_buf_get_name(0),
						'--single-quote'
					},
					stdin = true
				}
			end
		},
		rust = {
			-- Rustfmt
			function()
				return {exe = "rustfmt", args = {"--emit=stdout"}, stdin = true}
			end
		},
		lua = {
			-- luafmt
			function()
				return {
					exe = "lua ~/.local/share/nvim/format/luafmt/luafmt.lua",
					args = {vim.api.nvim_buf_get_name(0)},
					stdin = true
				}
			end
		}
	}
})

vim.api.nvim_exec(
	[[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.js,*.rs,*.lua FormatWrite
augroup END
]],
	true
)

require('formatter.util').print = function()
end
