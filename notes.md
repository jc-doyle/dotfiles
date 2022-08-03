## Create user and add to sudoers
``useradd -m -G wheel -s /bin/zsh [name]``

``passwd [name]``

Add user to sudoers
``EDITOR=nvim visudo``

## Pull down dotfiles (must be stored in other folder)
``mkdir other && cd other``
