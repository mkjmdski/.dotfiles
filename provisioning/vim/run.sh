#!/bin/bash
if [ ! $commands[vim] ];then
    apt-get update
    apt-get install -y vim
fi
if [ ! -d ~/.vim/bundle ]; then 
    mkdir -p ~/.vim/bundle; 
fi
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
currDir=$PWD
(
    cd ~
    ln $currDir/.vimrc .vimrc
)
