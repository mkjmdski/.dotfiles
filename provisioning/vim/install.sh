#!/bin/bash
set -e
source "../../.lib/link_config.sh"
function main {
    git clone --depth=1 https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    link_config .vimrc
    vim +PluginInstall +qall
}

main