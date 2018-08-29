#!/bin/bash

function install_vscode_extensions {
    local extensions_file="$DOTFILES/vscode/installed_vs_extensions"
    installed_extensions="$(code --list-extensions)"
    echo " >> VS Code extensions to be installed: "
    for extension in $(cat $extensions_file); do
        if ! echo "${installed_extensions}" | grep --quiet "${extension}"; then
            printf "\t\t${extension}\n"
        fi
    done
    read -p " >> Install vscode extensions? [y/N]" -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        for extension in $(cat $extensions_file); do
            if ! echo "${installed_extensions}" | grep --quiet "${extension}"; then
                code --install-extension "${extension}"
            fi
        done
    fi
}
