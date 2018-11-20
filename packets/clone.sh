#!/bin/bash

if [ ! -d "$HOME/.zplug" ]; then
    git clone --depth=1 https://github.com/zplug/zplug ~/.zplug
fi
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
    git clone --depth=1 https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi