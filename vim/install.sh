#!/bin/bash
set -e
if [[ -z "${DOTFILES}" ]]; then
    export DOTFILES="$(git rev-parse --show-toplevel)"
fi
source "$DOTFILES/.lib/include.sh"

function main {
    vundle_dir="$HOME/.vim/bundle/Vundle.vim"
    [[ ! -d "$vundle_dir" ]] && git clone --depth=1 https://github.com/VundleVim/Vundle.vim.git $vundle_dir
    link_config .vimrc
    vim +PluginInstall +qall
}

main