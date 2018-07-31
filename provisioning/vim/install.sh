#!/bin/bash
set -e
function setup {
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
}

function link_config {
    currDir=$PWD
    (
        cd ~
        ln -s $currDir/.vimrc .vimrc
    )
}

function install_plugins {
    vim +PluginInstall +qall
}

setup
link_config
install_plugins
