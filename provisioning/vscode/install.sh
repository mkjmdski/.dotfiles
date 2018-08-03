#!/bin/bash
set -e
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

function link_config {
    config_path="$(set_config_path)"
    currDir=$PWD
    (
        cd "${config_path}"
        for conf_file in settings.json snippets; do
            rm -rf "${config_path}/${conf_file}"
            ln -s "${currDir}/${conf_file}" "${conf_file}"
        done
    )
}

function install_extensions {
    extensions=(
        bungcip.better-toml
        marcostazi.VS-code-vagrantfile
        PeterJausovec.vscode-docker
        redhat.vscode-yaml
        robertohuertasm.vscode-icons
        rogalmic.bash-debug
        secanis.jenkinsfile-support
        shanoor.vscode-nginx
        shd101wyy.markdown-preview-enhanced
        tinkertrain.theme-panda
        wholroyd.jinja
        dunstontc.viml
        loganarnett.tf-snippets
        erd0s.terraform-autocomplete
        mauve.terraform
        mindginative.terraform-snippets
        mrmlnc.vscode-apache
        vangware.dark-plus-material
        file-icons.file-icons
    )
    installed_extensions="$(code --list-extensions)"
    for extension in $extensions; do
        if [[ ! $installed_extensions = *"$extension"* ]]; then
            code --install-extension $extension
        fi
    done
}

link_config
install_extensions