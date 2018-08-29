#!/bin/bash
set -e
source "$(git rev-parse --show-toplevel)/lib/configurations.sh"

function main {
    _install_custom_plugin "git" "brew install git"
    git config --global include.path "$DOTFILES/git/global.gitconfig"
    git config --global core.excludesfile "$DOTFILES/git/global.gitignore"
}

echo " >> Linking files to global git configuration"
main
echo " >> Success"
