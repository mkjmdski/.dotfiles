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

if [[ -f "$HOME/repos/agmar/toolkitz/programs/.rc" ]]; then
    source "$HOME/repos/agmar/toolkitz/programs/.rc"
fi

# auto change directory
setopt auto_cd
# use brace
setopt brace_ccl
# compacked complete list display
setopt list_packed

setopt auto_remove_slash

# resolve symlinks
setopt chase_links

# what to do when change location
function chpwd {
    if [ -d ".git" ] || [ -f ".git" ]; then
        if [ ! -f ".git/index.lock" ]; then
            git pull &
        fi
    fi
    if [ -d "venv" ] && [ -z "$VIRTUAL_ENV" ]; then
        source venv/bin/activate
    fi
    if [ ! -d "venv" ] && [ ! -z "$VIRTUAL_ENV" ]; then
        deactivate
    fi
}

