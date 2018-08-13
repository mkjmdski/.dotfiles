#!/bin/bash
set -e
source "../../.lib/include.sh"


function install_oh_my_zsh {
    install_package_universal tmux zsh
    case "$(get_os)" in
        Ubuntu*)
            install_package_ubuntu fonts-powerline ttf-ancient-fonts
        ;;
        CentOS*)
            install_powerline_font
        ;;
        Darwin*)
            install_powerline_font
        ;;
    esac
    chsh -s "$(which zsh)" #set zsh as current default shell
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed '/env zsh/ d')"
}

function install_plugins {
    declare -A plugins=(
        [zsh-autosuggestions]=https://github.com/zsh-users/zsh-autosuggestions.git
        [zsh-syntax-highlighting]=https://github.com/zsh-users/zsh-syntax-highlighting.git
    )
    (
        cd "$ZSH/custom/plugins"
        for plugin in "${!plugins[@]}"; do
            if [ ! -d "${plugin}" ]; then
                git clone --depth=1 "${plugins[$plugin]}" "${plugin}"
            fi
        done
    )
    declare -A raw_plugins=(
        [lpass]=https://raw.githubusercontent.com/lastpass/lastpass-cli/master/contrib/lpass_zsh_completion
    )
    for raw_plugin in "${!raw_plugins[@]}"; do
        local plugin_location="$ZSH/custom/plugins/${raw_plugin}"
        mkdir -p "${plugin_location}"
        curl -L "${raw_plugins[$raw_plugin]}" > "${plugin_location}/_${raw_plugin}"
    done
}

function main {
    export ZSH="$HOME/.oh-my-zsh" #default root of ZSH
    install_oh_my_zsh
    link_config ".zshrc"
    link_config --target-directory "$ZSH" "custom"
    install_plugins
}

 main