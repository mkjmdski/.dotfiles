#!/bin/bash

function install_vscode_extensions {
    local extensions_file="$DOTFILES/vscode/installed_vs_extensions"
    local installed_extensions="$(code --list-extensions)"
    local -a ext_to_install
    for extension in $(cat $extensions_file); do
        if ! echo "${installed_extensions}" | grep --quiet "${extension}"; then
            ext_to_install+=("${extension}")
        fi
    done
    if [ ${#ext_to_install[@]} -gt 0 ]; then
        echo "${ext_to_install[@]}"
        read -p " >> Install vscode extensions? [y/N]" -n 1 -r
        echo    # (optional) move to a new line
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            for extension in $(cat $extensions_file); do
                if ! echo "${installed_extensions}" | grep --quiet "${extension}"; then
                    code --install-extension "${extension}"
                fi
            done
        fi
    fi
}
