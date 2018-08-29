#### EXPORTS
function _system_exports {
    export EDITOR="$( echo $(which vim) || echo $(which vi) )"
    export GPG_TTY=$(tty) # Use actual tty when prompting for GPG passwords
    export LANG=en_US.UTF-8 # Default language
    export PAGER="most"
    # export ZSH_UPDATE="true"
    # export ZSH_THEME="eendroroy/alien"
}

function _expand_path {
    # Add go binaries
    if [ -d "$GOPATH" ]; then
        export PATH="$GOPATH/bin:$PATH"
    elif [[ $commands[go] ]]; then
        export PATH="$(go env GOPATH)/bin:$PATH"
    fi

    # Add yarn global binaries
    if [[ $commands[yarn] ]]; then export PATH="$(yarn global bin):$PATH"; fi

    # Add ruby gems
    if [[ $commands[ruby] ]]; then export PATH="$(ruby -e 'puts Gem.user_dir')/bin:$PATH"; fi

    # Add custom bin files
    if [ -d "$HOME/bin" ]; then export PATH="$HOME/bin:$PATH"; fi
    if [ -d "$HOME/.local/bin" ]; then export PATH="$HOME/.local/bin:$PATH"; fi

    #### LOAD BREW PATH ON LINUX
    if [ -d "/home/linuxbrew/.linuxbrew" ]; then
        export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
        export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
        export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
    fi
}

function _load_zplug {
    # Install zplug if not installed
    if [ ! -d ~/.zplug ]; then git clone --depth=1 https://github.com/zplug/zplug ~/.zplug; fi
    ZPLUG_LOADFILE="$DOTFILES/zsh/.zplugs.zsh"
    source ~/.zplug/init.zsh
    if ! zplug check --verbose; then
        _log_info "Install zplugs? [y/N]: "
        if read -q; then
            echo; zplug install
        fi
    fi
    zplug load
    if [ ! -z "$ZPLUG_UPDATE" ]; then zplug update; fi
}

function _init_zsh {
    export DOTFILES="$HOME/.dotfiles" # <- dotfiles directory
    source "${DOTFILES}/zsh/functions.zsh"
    source "${DOTFILES}/zsh/updates.zsh"
    _system_exports
    _expand_path
    _load_zplug
    source "${DOTFILES}/zsh/aliases.zsh"
    source "${DOTFILES}/zsh/configuration.zsh"
}

_init_zsh