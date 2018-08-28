#!/bin/zsh
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

function _log_info {
    echo "$fg[green][INFO]$reset_color $(date '+%H:%M:%S') > $@"
}

function update_brew {
    #### INSTALL DEPS FROM BREWFILE
    local brew_info="$(brew bundle check --verbose --file=${DOTFILES}/Brewfile 2> /dev/null)"
    if [ "$?" -ne 0 ] ; then
        echo "${brew_info}" | grep "→"
        _log_info "Install missing brew formulas? [y/N]: " # Prompt about installing plugins
        if read -q; then
            echo; brew bundle
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

function update_dotfiles {
    update_brew
    update_gems
    zplug update
}