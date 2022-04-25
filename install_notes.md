## Create user and add to sudoers
useradd -m -G wheel -s /path/to/shell [name]
passwd [name]
EDITOR=nvim visudo

## Pull down dotfiles (stored in other folder)

mkdir other && cd other
git clone
