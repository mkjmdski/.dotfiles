#!/bin/bash
set -e
source "$(git rev-parse --show-toplevel)/lib/configurations.sh"

function _get_font_dir {
    if [ ! "$(uname)" = "Darwin" ]; then
            mkdir -p ~/.local/share/fonts
            dir="$HOME/.local/share/fonts"
    else
            dir="$HOME/Library/Fonts"
    fi
    echo "${dir}"
}

function _install_powerline_fonts { (
    if [ ! -f "$(_get_font_dir)/Hack-Regular.ttf" ]; then
        echo " >> Installing powerline fonts"
        cd /tmp
        git clone https://github.com/powerline/fonts.git --depth=1
        cd fonts
        ./install.sh
        cd ..
        rm -rf fonts
    fi
) }

function _install_nerd_fonts { (
    font_dir="$(_get_font_dir)"
    if [ ! -f "$font_dir/Droid Sans Mono for Powerline Nerd Font Complete.otf" ]; then
        echo " >> Installing nerd fonts"
        cd $font_dir
        curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
    fi
) }

function _install_brew {
    if ! which brew &> /dev/null; then
        echo " >> Installing brew"
        if [ "$(uname)" = "Linux" ]; then
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)" # Install brew if not installed
        elif [ "$(uname)" = "Darwin" ]; then
            ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        fi
    fi
}

function main {
    _install_brew
    if ! which zsh &> /dev/null; then
        brew install zsh
    fi
    link_config ".zshrc"
    _install_powerline_fonts
    _install_nerd_fonts
    read -p " >> Do you want to set zsh as your default shell? [y/N]" -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        chsh -s /bin/zsh
    fi
}

main
