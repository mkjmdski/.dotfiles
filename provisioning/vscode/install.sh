#!/bin/bash
set -e
source "../../.lib/include.sh"

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

function install_extensions {
    installed_extensions="$(code --list-extensions)"
    for extension in $(cat installed_vs_extensions); do
        if [[ ! $installed_extensions = *"$extension"* ]]; then
            code --install-extension "${extension}"
        else
            echo "$extension is installed"
        fi
    done
}

function main {
    link_config --target-directory "$(set_config_path)" settings.json snippets
    install_extensions
}

main