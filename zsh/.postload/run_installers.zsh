#!/bin/zsh
#### INSTALLERS
function _gopass_release {
    if [ "$(uname)" = "Linux" ]; then
        echo '*linux*amd64*tar.gz'
    else
        echo '*darwin*'
    fi
}
function _fd_release {
    if [ "$(uname)" = "Linux" ]; then
        echo "fd*x86_64*unkown*gnu*"
    else
        echo "*darwin*"
    fi
}
function _noti_release {
    if [ "$(uname)" = "Linux" ]; then
        echo "noti*linux*"
    else
        echo "*noti*darwin*"
    fi
}
function _gopass_completion {
    gopass completion zsh > "${DOTFILES}/zsh/fpath/_gopass"
}
function _googler_completion {
    ln -s 
}
function _autojump_install {
    ./install.py
}


function _zplugs_binaries_install {
    #### PARSING OUTPUTS
    zplug "stedolan/jq", from:gh-r, as:command
    zplug "peco/peco", from:gh-r, as:command

    #### INTELIGENT PATH CHANGING
    zplug "wting/autojump", as:command, hook-build:"_autojump_install 2> /dev/tty"

    #### PASSWORD MANAGING IN GOPASS
    zplug "gopasspw/gopass", from:gh-r, use:"$(_gopass_release)", as:command, hook-build:"_gopass_completion"

    #### DIFF TOOL FOR GIT
    zplug "jeffkaufman/icdiff", use:icdiff.py, rename-to:icdiff, as:command

    #### CHEAT SHEAT
    zplug "chubin/cheat.sh", use:"share/cht.sh.txt", as:command, rename-to:cht.sh

    #### FIND TOOLS
    zplug "sharkdp/fd", from:gh-r, as:command

    #### NOTIFY AFTER EVENT IS DONE
    zplug "variadico/noti", from:gh-r, as:command, use:"$(_noti_release)"

    #### RUN GOOGLE SEARCH FROM CLI
    zplug "jarun/googler", use:"googler", as:command, hook-build:"_googler_completion"
}


function zplugs_install {
    _zplugs_binaries_install
    _log_info "Checking zplugs..."
    if ! zplug check --verbose; then
        _log_info "Install zplugs? [y/N]: "
        if read -q; then
            echo; zplug install
        fi
    fi
}

function brew_install {
    #### INSTALL DEPS FROM BREWFILE
    _log_info "Checking Brewfile dependencies..."
    if ! brew bundle check --verbose --file=${DOTFILES}/Brewfile; then
        _log_info "Install missing brew formulas? [y/N]: " # Prompt about installing plugins
        if read -q; then
            echo; brew bundle install --file=${DOTFILES}/Brewfile
        fi
    fi
}

function pip_install {
    _log_info "Installing python dependencies..."
    /usr/bin/env pip3 install -r $DOTFILES/requirements.txt
}

function gems_install {
    if ! command bundle; then
        gem install --user bundle
    fi
    _log_info "Installing ruby dependencies..."
    bundle install --system --gemfile $DOTFILES/Gemfile
}

function yarn_install {
    yarn global add @aweary/alder to-double-quotes-cli to-single-quotes-cli yaml-cli rename-cli
}


if [ "$ZPLUG_INSTALL" = true ] || [ "$INSTALL" = true ]; then
    zplugs_install
fi

## LOAD BREW
if [ "$BREW_INSTALL" = true ] || [ "$INSTALL" = true ]; then
    brew_install
fi

## LOAD GEMS
if [ "$GEMS_INSTALL" = true ] || [ "$INSTALL" = true ]; then
    gems_install
fi

if [ "$PYTHON_INSTALL" = true ] || [ "$INSTALL" = true ]; then
    pip_install
fi

if [ "$YARN_INSTALL" = true ] || [ "$INSTALL" = true ]; then
    yarn_install
fi