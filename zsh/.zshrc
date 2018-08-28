#### EXPORTS
export DOTFILES="$HOME/.dotfiles" # <- dotfiles directory

function _get_editor { echo $(which vim) || echo $(which vi) }
export EDITOR="$(_get_editor)"

export GPG_TTY=$(tty) # Use actual tty when prompting for GPG passwords
export LANG=en_US.UTF-8 # Default language

#### LIBRARY
source "${DOTFILES}/lib/log.sh"
source "${DOTFILES}/lib/plugins.sh"

#### LINUXBREW LOAD
if [ "$(uname)" = "Linux" ]; then
    if [ -d "/home/linuxbrew/.linuxbrew" ]; then
        export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
        export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
        export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
    fi
fi

#### ZPLUG
# Install zplug if not installed
if [ ! -d ~/.zplug ]; then git clone --depth=1 https://github.com/zplug/zplug ~/.zplug; fi

# Variables for .zplugs.zsh file
# export ZSH_THEME="eendroroy/alien"
ZPLUG_LOADFILE="$DOTFILES/zsh/.zplugs.zsh"
source ~/.zplug/init.zsh
if ! zplug check --verbose; then
    _log_info "Install zplugs? [y/N]: " # Prompt about installing plugins
    if read -q; then
        echo; zplug install
    fi
fi
zplug load

#### OTHER PLUGS LOAD
if [[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]]; then
    source $HOME/.autojump/etc/profile.d/autojump.sh
fi

#### $PATH
# Add go binaries
if [ -d "$GOPATH" ]; then
    export PATH="$GOPATH/bin:$PATH"
elif [[ $commands[go] ]]; then
    export PATH="$(go env GOPATH)/bin:$PATH"
fi

# Add yarn global binaries
if [[ $commands[yarn] ]]; then export PATH="$(yarn global bin):$PATH"; fi

# Add custom bin files
if [ -d "$HOME/bin" ]; then export PATH="$HOME/bin:$PATH"; fi
if [ -d "$HOME/.local/bin" ]; then export PATH="$HOME/.local/bin:$PATH"; fi

#### FUNCTIONS
function load_nvm {
    export NVM_DIR="$HOME/.nvm"
    if [ -d "$NVM_DIR" ]; then
    \. "$NVM_DIR/nvm.sh"  # This loads nvm
    \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    fi
}

function cd-gitroot {
    local root
    root=$(git rev-parse --show-toplevel)
    eval $root
}

function gopass-clipboard {
    local secret
    secret=$(gopass show $1 | head -n 1)
    clipcopy <<< $secret
}

function take {
  mkdir -p $@ && cd ${@:$#}
}

function zsh_stats {
  fc -l 1 | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n20
}

#### ALIASES
## GIT
alias s="git s"
alias cdg="cd-gitroot"
## Color ls
alias ls="colorls"
alias t="ls -A --tree"
alias l="ls -lA"
unalias la ll lsa
## rm
alias rmf="rm -rf"

#### CUSTOM ZSH CONFIGURATIONS
setopt auto_cd

#### SET COLORS FOR MAN PAGES
export PAGER="most"

#### COMPLETION COLORS
# ls with color
eval $(gdircolors $DOTFILES/.dir_colors)
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"