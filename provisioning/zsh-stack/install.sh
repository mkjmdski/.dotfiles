#!/bin/bash
set -e
source "../../.lib/include.sh"


function install_zplug {
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
}

function install_oh_my_zsh {
    install_package_universal zsh
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

function main {
    export ZSH="$HOME/.oh-my-zsh" #default root of ZSH
    install_oh_my_zsh
    install_zplug
    link_config ".zshrc"
    (
        cd my-themes
        for theme in ./*.zsh-theme; do
            link_config --target-directory "$ZSH/custom/themes" "${theme}"
        done
    )
}

 main