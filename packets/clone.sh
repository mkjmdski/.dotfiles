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