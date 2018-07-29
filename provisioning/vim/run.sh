#!/bin/bash
set -e
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
currDir=$PWD
(
    cd ~
    ln $currDir/.vimrc .vimrc
)
vim +PluginInstall +qall
