#!/bin/bash
set -e
source "$(git rev-parse --show-toplevel)/lib/configurations.sh"

function main {
    _install_custom_plugin "vim" "brew install vim"
    vundle_dir="$HOME/.vim/bundle/Vundle.vim"
    if [ ! -d "${vundle_dir}" ]; then
        echo " >> Cloning vundle"
        git clone --depth=1 https://github.com/VundleVim/Vundle.vim.git "${vundle_dir}"
    fi
    link_config .vimrc
    read -p " >> Do you want to install vim plugins now? [y/N]" -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        vim +PluginInstall +qall
    else
        echo "You can do it later by running: vim +PluginInstall +qall"
    fi
}

echo " >> Configuring vim"
main
echo " >> Success"