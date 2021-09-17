local autogroup = require 'utils.general'.augroup
require 'bqf'.setup({
	auto_resize_height = false,
	func_map = {preview = 'l'},
	preview = {
		auto_preview = false,
		border_chars = {
			'│',
			'│',
			'─',
			'─',
			'┌',
			'┐',
			'└',
			'┘',
			'┃'
		},
		delay_syntax = 50,
		win_height = 15,
		win_vheight = 15,
		wrap = false,
		should_preview_cb = nil
	},
})

vim.cmd([[
  fu Vqftf(info) abort
    if a:info.quickfix
        let items = getqflist({'id': a:info.id, 'items': 0}).items
    else
        let items = getloclist(a:info.winid, {'id': a:info.id, 'items': 0}).items
    endif
    let l = []
    for e in items
        let fname = printf('%-30s', fnamemodify(bufname(e.bufnr),':~:.'))
        let width = winwidth(0) - 20
        let fname = printf('    %-*s', width, fname)
        let lnum = printf('|line %-6d', e.lnum)
        call add(l, fname . ' ' . lnum )
    endfor
    return l
  endfu

 set qftf=Vqftf 
]])

autogroup(
	{
		{'BufWinEnter', 'quickfix', 'setlocal nonu nornu'},
		--[[ {'BufWinEnter', 'quickfix', 'hi Cursor blend=100'},
		{'BufWinLeave', 'quickfix', 'hi Cursor blend=0'}, ]]
	},
	'quickfix'
)

--[[ local function qftf(info)
    local items
    local ret = {}
    if info.quickfix == 1 then
        items = vim.fn.getqflist({id = info.id, items = 0}).items
    else
        items = vim.fn.getloclist(info.winid, {id = info.id, items = 0}).items
    end
    for _, e in ipairs(items) do
        table.insert(ret, e.bufnr .. ' | ' .. e.text)
    end
    return ret
end

return qftf ]]
