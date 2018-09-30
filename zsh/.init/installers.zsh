#!/bin/zsh
#### INSTALLERS
function zplugs_install {
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