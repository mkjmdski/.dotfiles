#!/bin/bash
set -e
if [[ -z "${DOTFILES}" ]]; then
    export DOTFILES="$(git rev-parse --show-toplevel)"
fi
source "$DOTFILES/.lib/include.sh"

function _install_powerline_font { (
    cd /tmp || return
    git clone https://github.com/powerline/fonts.git --depth=1
    cd fonts
    ./install.sh
    cd ..
    rm -rf fonts
) }

function main {
    if ! zsh --version &> /dev/null; then
        install_package_universal zsh
        chsh -s /bin/zsh $USER #set zsh as current default shell
    fi
    _install_powerline_fonts
    link_config ".zshrc"
}

main
zsh