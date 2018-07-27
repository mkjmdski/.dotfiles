#!/bin/bash
set -e
if [ ! -d ~/.vim/bundle ]; then 
    mkdir -p ~/.vim/bundle; 
fi
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
currDir=$PWD
(
    cd ~
    ln $currDir/.vimrc .vimrc
)
vim +PluginInstall +qall
