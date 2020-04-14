export DOTFILES="$HOME/.dotfiles"
sources="$DOTFILES/zsh/sources"

source $sources/path.zsh
source $sources/spaceship.zsh

HIST_STAMPS="yyyy-mm-dd"
compinit
source ~/.zplug/init.zsh
zplug load

source $sources/git-extra-completions.zsh
source $sources/bash-completions.bash
source $sources/commands.zsh

# auto change directory
setopt auto_cd
# use brace
setopt brace_ccl
# compacked complete list display
setopt list_packed
setopt auto_remove_slash        # self explicit
setopt chase_links              # resolve symlinks