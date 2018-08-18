#!/bin/bash
source "$DOTFILES/.lib/include.sh"

function main {
    link_config --target-directory ../.git/hooks post-commit pre-commit post-merge
}

main