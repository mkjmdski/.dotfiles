#!/bin/bash
(
    cd $HOME
    git clone --depth=1 https://github.com/mkjmdski/.dotfiles.git
    cd .dotfiles
    source $(git rev-parse --show-toplevel)/zsh/install.sh
    for file in $(git rev-parse --show-toplevel)/{.hooks,git,tmux,vim,vscode}/install.sh; do
        source "${file}"
    done
)