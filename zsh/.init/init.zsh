# We want to extend path once
export EDITOR="$( echo $(which vim) || echo $(which vi) )"
export GPG_TTY=$(tty) # Use actual tty when prompting for GPG passwords
export LANG=en_US.UTF-8 # Default language
export LC_ALL=en_US.UTF-8

if [ ! "$PATH_LOADED" = "true" ]; then

    #### LOAD BREW PATH ON LINUX
    if [ -d "/home/linuxbrew/.linuxbrew" ]; then
        export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
        export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
        export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
    fi

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

    export PATH_LOADED="true"
fi