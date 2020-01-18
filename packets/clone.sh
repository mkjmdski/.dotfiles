#!/bin/bash

if [ ! -d "$HOME/bin" ]; then
    mkdir ~/bin
fi
if [ ! -d "$HOME/.zplug" ]; then
    git clone --depth=1 https://github.com/zplug/zplug ~/.zplug
fi
if [ ! -f "$HOME/.local/share/nvim/site/autoload/plug.vim" ]; then
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
if [ ! -f "$HOME/bin/cht.sh" ]; then
    curl https://cht.sh/:cht.sh > ~/bin/cht.sh
fi

function _get_font_dir {
    if [ ! "$(uname)" = "Darwin" ]; then
            mkdir -p ~/.local/share/fonts
            dir="$HOME/.local/share/fonts"
    else
            dir="$HOME/Library/Fonts"
    fi
    echo "${dir}"
}

font_dir="$(_get_font_dir)"
cd $font_dir
if [ ! -f "Droid Sans Mono for Powerline Nerd Font Complete.otf" ]; then
    curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf"
    curl -fLo "Ubuntu Mono Nerd Font Complete Mono.ttf" "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/UbuntuMono/Regular/complete/Ubuntu%20Mono%20Nerd%20Font%20Complete%20Mono.ttf"
    curl -fLo "Hack Regular Nerd Font Complete Mono.ttf" "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete%20Mono.ttf"
    fc-cache -vf
    mkfontscale
    mkfontdir
fi

if ! git standup; then
    curl -L https://raw.githubusercontent.com/kamranahmedse/git-standup/master/installer.sh | sudo sh
fi

if ! tfschema; then
    (
        cd /tmp
        wget https://github.com/minamijoyo/tfschema/releases/download/v0.3.0/tfschema_0.3.0_linux_amd64.tar.gz
        tar -xzf tfschema_0.3.0_linux_amd64.tar.gz
        mv tfschema ~/bin
    )
fi