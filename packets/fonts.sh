#!/bin/bash

function _get_font_dir {
    if [ ! "$(uname)" = "Darwin" ]; then
            mkdir -p ~/.local/share/fonts
            dir="$HOME/.local/share/fonts"
    else
            dir="$HOME/Library/Fonts"
    fi
    echo "${dir}"
}

function install_fonts {
    font_dir="$(_get_font_dir)"
    if [ ! -f "$font_dir/Droid Sans Mono for Powerline Nerd Font Complete.otf" ]; then
        echo " >> Installing nerd fonts"
        cd $font_dir
        curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
    fi
    if [ ! -f "$font_dir/Hack-Regular.ttf" ]; then
        echo " >> Installing powerline fonts"
        cd /tmp
        git clone https://github.com/powerline/fonts.git --depth=1
        cd fonts
        ./install.sh
        cd ..
        rm -rf fonts
    fi
}

install_fonts