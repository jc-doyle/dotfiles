# Dotfiles

My configuration - using on arch-linux + dwm. 

Contains multiple submodules relating to per-program configuration,
notably: - `colors/`: System-unified colorscheme. 
- `scripts/`: System-wide scripts. 
- `config/dwm`: Dwm build. 
- `config/nvim`: Neovim configuration.

Uses GNU Stow to symlink and update the all config files in their respective places. 

## Personal Post-Installation Notes

### Early commands

`useradd -m -G wheel -s /bin/zsh [name]`
`passwd [name]`
`EDITOR=nvim visudo`

### Change cursor theme

`edit /usr/share/icons/default/index.theme`

## Pull down dotfiles (stored in `other` folder)

`mkdir other && cd other`
`git clone --recurse-submodules [this repo]`
