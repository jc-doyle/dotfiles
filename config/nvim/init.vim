if exists('g:vscode')
  source ~/.config/nvim/bindings.vim
else
  source ~/.config/nvim/plugins.vim
  source ~/.config/nvim/plugconfig.vim
  source ~/.config/nvim/bindings.vim
  source ~/.config/nvim/settings.vim
endif
