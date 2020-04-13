export DOTFILES="$HOME/.dotfiles"
HIST_STAMPS="yyyy-mm-dd"
fpath=($fpath $DOTFILES/zsh/fpath)

if [ ! "$PATH_LOADED" = "true" ]; then
    # We want to extend path once
    export EDITOR="$(which nvim)"
    # export GPG_TTY=$(tty) # Use actual tty when prompting for GPG passwords
    export LANG=en_US.UTF-8 # Default language
    export LC_ALL=en_US.UTF-8
    export GOENV_ROOT="$HOME/.goenv"
    export PATH="$GOENV_ROOT/bin:$PATH"
    export PATH="$DOTFILES/bin:$PATH"
    eval "$(goenv init -)"

    export PATH="$GOROOT/bin:$PATH"
    export PATH="$PATH:$GOPATH/bin"

    if [[ $commands[javac] ]]; then
        export JAVA_HOME="$(dirname $(dirname $(realpath $(which javac))))"
    fi
    # Add yarn global binaries
    if [[ $commands[yarn] ]]; then export PATH="$(yarn global bin):$PATH"; fi

    # Add ruby gems
    if [[ $commands[ruby] ]]; then export PATH="$(ruby -e 'puts Gem.user_dir')/bin:$PATH"; fi

    # Add custom bin files
    if [ -d "$HOME/bin" ]; then export PATH="$HOME/bin:$PATH"; fi
    if [ -d "$HOME/.local/bin" ]; then export PATH="$HOME/.local/bin:$PATH"; fi
    export PATH="$HOME/.tfenv/bin:$PATH"
    export TF_PLUGIN_CACHE_DIR="$HOME/.terraform-plugins"
    export ZPLUG_LOADFILE="$DOTFILES/.zplugs.zsh"
    export PATH_LOADED="true"
    export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
fi

source $DOTFILES/zsh/sources/spaceship.zsh
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