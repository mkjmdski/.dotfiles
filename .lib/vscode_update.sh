#!/bin/sh

function install_extensions {
    local extensions_file="$DOTFILES/vscode/installed_vs_extensions"
    installed_extensions="$(code --list-extensions)"
    for extension in $(cat $extensions_file); do
        if [[ ! $installed_extensions = *"$extension"* ]]; then
            printf "Install ${extension}? [y/N]: "
            if read -q; then
                echo; code --install-extension "${extension}"
            fi
        else
            echo "$extension is installed"
        fi
    done
}