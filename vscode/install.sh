#!/bin/bash
set -e
source "$DOTFILES/.lib/include.sh"

function set_config_path {
    unameOut="$(uname -s)"
    case "${unameOut}" in
        Linux*)
            echo "$HOME/.config/Code/User"
        ;;
        Darwin*)
            echo "$HOME/Library/Application Support/Code/User"
        ;;
        *) echo "UNKOWN OS: ${unameOut}" && exit -1
    esac
}

function main {
    link_config --target-directory "$(set_config_path)" settings.json snippets
    install_extensions
}

main