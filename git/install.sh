#!/bin/zsh
set -e
for file in $(git rev-parse --show-toplevel)/lib/*.sh; do
    source "${file}"
done

function main {
    git config --global include.path "$DOTFILES/git/global.gitconfig"
    git config --global core.excludesfile "$DOTFILES/git/global.gitignore"
}

_log_info "Linking files to global git configuration"
main
_log_info "Success"
