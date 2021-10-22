fpath=($fpath $DOTFILES/zsh/fpath)
if [ ! "$PATH_LOADED" = "true" ]; then
    if [ -d "$HOME/repos/karhoo/k-tools" ]; then
        export PATH="$HOME/repos/karhoo/k-tools/bin:$PATH"
    fi

    if [ -d "$HOME/repos/agmar/toolkitz/programs" ]; then
        export PATH="$HOME/repos/agmar/toolkitz/programs/bin:$PATH"
    fi

    export PATH="$DOTFILES/bin:$PATH"
    export PATH="$DOTFILES/venv/bin:$PATH"
    eval $(thefuck --alias)

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
    if uname | grep -iq darwin; then
        export PATH="$(brew --prefix openvpn)/sbin:$PATH"
        export PATH="$(brew --prefix gnu-sed)/libexec/gnubin:$PATH"
    fi
    # Add custom bin files
    if [ -d "$HOME/bin" ]; then export PATH="$HOME/bin:$PATH"; fi
    if [ -d "$HOME/.local/bin" ]; then export PATH="$HOME/.local/bin:$PATH"; fi
    export PATH="$HOME/.tfenv/bin:$PATH"

    export HELM_DRIVER=configmap
    export PATH="$HOME/.helmenv/bin:$PATH"
    export TF_PLUGIN_CACHE_DIR="$HOME/.terraform-plugins"
    export ZPLUG_LOADFILE="$DOTFILES/.zplugs.zsh"
    export PATH_LOADED="true"
    export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"


    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


    if [[ $commands[jira] ]]; then
        eval "$(jira --completion-script-zsh)"
    fi

    if [[ -z "${CLOUDSDK_HOME}" ]]; then
        search_locations=(
            "$HOME/google-cloud-sdk"
            "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk"
            "/usr/share/google-cloud-sdk"
            "/snap/google-cloud-sdk/current"
            "/usr/lib64/google-cloud-sdk/"
            "/opt/google-cloud-sdk"
        )

        for gcloud_sdk_location in $search_locations; do
            if [[ -d "${gcloud_sdk_location}" ]]; then
            CLOUDSDK_HOME="${gcloud_sdk_location}"
            break
            fi
        done
        fi

        if (( ${+CLOUDSDK_HOME} )); then
        if (( ! $+commands[gcloud] )); then
            # Only source this if GCloud isn't already on the path
            if [[ -f "${CLOUDSDK_HOME}/path.zsh.inc" ]]; then
            source "${CLOUDSDK_HOME}/path.zsh.inc"
            fi
        fi
        alias gcloud="export SPACESHIP_GCLOUD_SHOW='true'; $(which gcloud)"
        source "${CLOUDSDK_HOME}/completion.zsh.inc"
        export CLOUDSDK_HOME
    fi
fi
