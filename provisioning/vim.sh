#!/bin/bash
if [ ! $commands[vim] ];then
    apt-get update
    apt-get install -y vim
fi 
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
cp .vimrc ~/.vimrc
vim +PluginInstall +qall