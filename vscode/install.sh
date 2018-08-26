#!/bin/zsh
set -e
for file in $(git rev-parse --show-toplevel)/lib/*.sh; do
    source "${file}"
done
function vscode_config_path {
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
    link_config --target-directory "$(vscode_config_path)" settings.json snippets
    install_vscode_extensions
}

main