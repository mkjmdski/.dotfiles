#!/bin/bash
set -e
source "../../.lib/get_os.sh"
source "../../.lib/install_packs.sh"
source "../../.lib/link_config.sh"

function install_oh_my_zsh {
    case "$(get_os)" in
        Ubuntu*)
            install_ubuntu git fonts-powerline ttf-ancient-fonts tmux vim zsh
        ;;
        CentOS*)
            install_centos git tmux vim zsh
            install_powerline_font
        ;;
        Darwin*)
            install_darwin git tmux zsh
            brew cask install iterm2
            install_powerline_font
        ;;
    esac
    chsh -s "$(which zsh)" #set zsh as current default shell
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed '/env zsh/ d')"
}

function install_plugins {
    declare -a plugins=(
        https://github.com/zsh-users/zsh-autosuggestions.git
        https://github.com/zsh-users/zsh-syntax-highlighting.git
        https://github.com/leonhartX/docker-machine-zsh-completion.git
    )
    (
        cd "$ZSH/custom/plugins"
        for custom_plugin in "${plugins[@]}"; do
            git clone --depth=1 $custom_plugin
        done
    )
    declare -A raw_plugins=(
        [lpass]=https://raw.githubusercontent.com/lastpass/lastpass-cli/master/contrib/lpass_zsh_completion
    )
    for raw_plugin in "${!raw_plugins[@]}"; do
        local plugin_location="$ZSH/custom/plugins/${raw_plugin}"
        mkdir -p $plugin_location
        curl -L ${raw_plugins[$raw_plugin]} > "${plugin_location}/_${raw_plugin}"
    done
}

function main {
    export ZSH="$HOME/.oh-my-zsh" #default root of ZSH
    install_oh_my_zsh
    link_config ".zshrc" ".zshenv"
    link_config --target-directory "$ZSH" "custom"
    install_plugins
}

 main