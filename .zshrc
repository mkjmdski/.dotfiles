export DOTFILES="$HOME/.dotfiles"
sources="$DOTFILES/zsh/sources"

source $sources/path.zsh
source $sources/spaceship.zsh

source ~/.zinit/bin/zinit.zsh
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select

source $sources/zinit.zsh
source $sources/commands.zsh
source $sources/bash-completions.bash

# auto change directory
setopt auto_cd
# use brace
setopt brace_ccl
# compacked complete list display
setopt list_packed

setopt auto_remove_slash

# resolve symlinks
setopt chase_links
