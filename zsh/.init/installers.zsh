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

function brews_install {
    #### INSTALL DEPS FROM BREWFILE
    _log_info "Checking Brewfile dependencies..."
    if ! brew bundle check --verbose --file=${DOTFILES}/Brewfile; then
        _log_info "Install missing brew formulas? [y/N]: " # Prompt about installing plugins
        if read -q; then
            echo; brew bundle install --file=${DOTFILES}/Brewfile
        fi
    fi
}

function gems_install {
    _log_info "Checking installed gems..."
    #### DECLARE GEMS TO CHECK
    local -a gems=(
        colorls
    )
    local -a not_installed_gems
    #### CHECK WHICH GEMS ARE NOT INSTALLED
    for gem in "${gems[@]}"; do
        if ! gem list -i "${gem}" &> /dev/null; then
            not_installed_gems+=("${gem}")
        fi
    done
    #### PROMPT ABOUT INSTALLING ALL GEMS
    if [ ${#not_installed_gems[@]} -gt 0 ]; then
        echo "${not_installed_gems[@]}"
        _log_info "Install missing gems? [y/N]: "
        if read -q; then
            echo
            for gem in "${not_installed_gems[@]}"; do
                gem install --user-install "${gem}"
            done
        fi
    else
        _log_info "Gems dependencies satisfied."
    fi
}
