#!/bin/zsh
#### HELPERS FOR ZPLUG
function _exa_release {
    if [ "$(uname)" = "Darwin" ]; then
        echo '*macos*'
    else
        echo '*linux*'
    fi
}
function _gopass_release {
    if [ "$(uname)" = "Linux" ]; then
        echo '*linux*amd64*tar.gz'
    else
        echo '*darwin*'
    fi
}
function _ccat_release {
    if [ "$(uname)" = "Darwin" ]; then
        echo '*darwin*tar.gz'
    else
        echo '*linux*amd64*tar.gz'
    fi
}
function _fd_release {
    if [ "$(uname)" = "Linux" ]; then
        echo "fd*x86_64*unkown*gnu*"
    else
        echo "*darwin*"
    fi
}
function _autojump_install {
    ./install.py
}

#### UPDATERS
function update_brew {
    #### INSTALL DEPS FROM BREWFILE
    if ! brew bundle check --verbose --file=${DOTFILES}/Brewfile; then
        _log_info "Install missing brew formulas? [y/N]: " # Prompt about installing plugins
        if read -q; then
            echo; brew bundle install --file=${DOTFILES}/Brewfile
        fi
    fi
}

function update_gems {
    #### DECLARE GEMS TO CHECK
    local -a gems=(
        colorls
    )
    local -a not_installed_gems
    local -a installed_gems
    #### CHECK WHICH GEMS ARE NOT INSTALLED
    for gem in "${gems[@]}"; do
        if ! gem list -i "${gem}" &> /dev/null; then
            not_installed_gems+=("${gem}")
        else
            installed_gems+=("${gem}")
        fi
    done
    #### PROMPT ABOUT INSTALLING ALL GEMS
    if [ ${#not_installed_gems[@]} -ne 0 ]; then
        echo "${not_installed_gems[@]}"
        _log_info "Install missing gems? [y/N]: "
        if read -q; then
            echo
            for gem in "${not_installed_gems[@]}"; do
                gem install --user-install "${gem}"
            done
        fi
    fi
    if [ ${#installed_gems[@]} -ne 0 ]; then
        echo "${installed_gems[@]}"
        _log_info "Update already installed gems? [y/N]: "
        if read -q; then
            echo
            for gem in "${installed_gems[@]}"; do
                gem update "${gem}"
            done
        fi
    fi
}

function update_zplugs {
    ZPLUG_UPDATE=true zsh
}

function update {
    update_brew
    update_gems
    update_zplugs
}