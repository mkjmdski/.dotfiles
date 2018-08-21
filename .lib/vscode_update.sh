#!/bin/sh

function install_extensions {
    local extensions_file="$DOTFILES/vscode/installed_vs_extensions"
    installed_extensions="$(code --list-extensions)"
    echo "VS Code extensions to be installed:"
    for extension in $(cat $extensions_file); do
        if [[ ! $installed_extensions = *"$extension"* ]]; then
            echo "${extension}"
        fi
    done
    read -p "Install? y/N" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        for extension in $(cat $extensions_file); do
            if [[ ! $installed_extensions = *"$extension"* ]]; then
                code --install-extension "${extension}"
            fi
        done
    fi
}
