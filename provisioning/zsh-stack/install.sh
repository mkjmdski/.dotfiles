#!/bin/bash
set -e
source "../../.lib/include.sh"

function install_zsh {
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
    chsh -s /bin/zsh $USER #set zsh as current default shell
}

function main {
    install_zsh
    link_config ".zshrc"
}

main
zsh