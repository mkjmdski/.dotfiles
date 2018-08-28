#### EXPORTS
function _system_exports {
    export EDITOR="$( echo $(which vim) || echo $(which vi) )"
    export GPG_TTY=$(tty) # Use actual tty when prompting for GPG passwords
    export LANG=en_US.UTF-8 # Default language
    export PAGER="most"
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
}

function _load_brew {
    #### LOAD BREW PATH ON LINUX
    if [ "$(uname)" = "Linux" ]; then
        if [ -d "/home/linuxbrew/.linuxbrew" ]; then
            export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
            export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
            export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
        fi
    fi

    #### INSTALL DEPS FROM BREWFILE
    (
        cd $DOTFILES
        local brew_info="$(brew bundle check --verbose 2> /dev/null)"
        if [ "$?" -ne 0 ] ; then
            echo "${brew_info}" | grep "→"
            _log_info "Install missing brew formulas? [y/N]: " # Prompt about installing plugins
            if read -q; then
                echo; brew bundle
            fi
        fi
    )
}

function _load_gems {
    local -a gems=(
        colorls
    )
    local -a uninstalled_gems
    for gem in "${gems[@]}"; do
        if ! gem list -i "${gem}" &> /dev/null; then
            uninstalled_gems+=("${gem}")
        fi
    done
    if [ ${#uninstalled_gems[@]} -ne 0 ]; then
        echo "${uninstalled_gems[@]}"
        _log_info "Install missing gems? [y/N]: "
        if read -q; then
            echo;
            for gem in "${uninstalled_gems[@]}"; do
                gem install --user-install "${gem}"
            done
        fi
    fi
}

function _load_zplug {
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
}

function _load_others {
    #### LOAD AUTOJUMP
    if [[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]]; then source $HOME/.autojump/etc/profile.d/autojump.sh fi
}

function _init_zsh {
    export DOTFILES="$HOME/.dotfiles" # <- dotfiles directory
    source "${DOTFILES}/lib/log.sh"
    _system_exports
    _expand_path
    _load_zplug
    _load_brew
    _load_gems
    _load_others
    source "${DOTFILES}/zsh/functions.zsh"
    source "${DOTFILES}/zsh/aliases.zsh"
    source "${DOTFILES}/zsh/configuration.zsh"
}

_init_zsh