#!/bin/bash
set -e
source "$DOTFILES/.lib/include.sh"

function _install_powerline_font { (
    cd /tmp || return
    git clone https://github.com/powerline/fonts.git --depth=1
    cd fonts
    ./install.sh
    cd ..
    rm -rf fonts
) }

function install_powerline_fonts {
    case "$(get_os)" in
        Ubuntu*)
            install_package_ubuntu fonts-powerline ttf-ancient-fonts
        ;;
        CentOS*)
            _install_powerline_fonts
        ;;
        Darwin*)
            _install_powerline_fonts
        ;;
    esac
}

function main {
    if ! zsh --version &> /dev/null; then
        install_package_universal zsh
        chsh -s /bin/zsh $USER #set zsh as current default shell
    fi
    link_config ".zshrc"
}

if [ $1 = "--install-powerline-fonts" ]; then
    install_powerline_fonts
else
    main
    zsh
fi