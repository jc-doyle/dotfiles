vim.cmd [[ autocmd CursorHold,CursorHoldI * lua Lightbulb() ]]

Lightbulb = function()
	require 'nvim-lightbulb'.update_lightbulb {
		sign = {
			enabled = false,
			text = " ",
		},
		float = {
			enabled = false,
			text = " ",
		},
		virtual_text = {
			enabled = true,
			text = " ",
		},
		status_text = {enabled = false, text = " ", text_unavailable = "x"}
	}
end
