export DOTFILES="$HOME/.dotfiles"

source $DOTFILES/zsh/sources/path.zsh
source $DOTFILES/zsh/sources/spaceship.zsh

HIST_STAMPS="yyyy-mm-dd"
compinit
source ~/.zplug/init.zsh
zplug load

source $DOTFILES/zsh/sources/git-extra-completions.zsh
source $DOTFILES/zsh/sources/bash-completions.bash
source $DOTFILES/zsh/sources/commands.zsh

# auto change directory
setopt auto_cd
# use brace
setopt brace_ccl
# compacked complete list display
setopt list_packed
setopt auto_remove_slash        # self explicit
setopt chase_links              # resolve symlinks