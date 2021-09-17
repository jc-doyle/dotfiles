local dap = require('dap')

--[[ dap.defaults.fallback.external_terminal = {
	command = '/usr/bin/alacritty';
	args = {'-e'};
}
dap.defaults.fallback.force_external_terminal = true ]]
dap.defaults.fallback.terminal_win_cmd = '10split new'

vim.fn.sign_define('DapBreakpoint', {text='▪ ', texthl='DapBreakpoint', linehl='DapLine', numhl='DapLine'})
vim.fn.sign_define('DapBreakpointRejected', {text='▫ ', texthl='DapBreakpoint', linehl='DapLine', numhl='DapLine'})
vim.fn.sign_define('DapStopped', {text='⏵ ', texthl='DapStopped', linehl='DapLine', numhl='DapLine'})
vim.fn.sign_define('DapLogPoint', {text='▪ ', texthl='DapLogPoint', linehl='DapLine', numhl='DapLine'})

vim.g.dap_virtual_text = true
