#!/bin/bash
set -e
source "../../.lib/link_config.sh"
source "../../.lib/install_packs.sh"

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
    extensions=(
        marcostazi.VS-code-vagrantfile
        PeterJausovec.vscode-docker
        ipedrazas.kubernetes-snippets

        ms-python.python
        timonwong.shellcheck
        formulahendry.code-runner
        secanis.jenkinsfile-support
        atishay-jain.all-autocomplete
        ionutvmi.path-autocomplete
        ryu1kn.partial-diff

        shanoor.vscode-nginx
        mrmlnc.vscode-apache

        davidanson.vscode-markdownlint
        alanwalk.markdown-toc
        wholroyd.jinja

        bungcip.better-toml
        redhat.vscode-yaml
        dunstontc.viml
        sidneys1.gitconfig
        mohsen1.prettify-json

        loganarnett.tf-snippets
        erd0s.terraform-autocomplete
        mauve.terraform
        mindginative.terraform-snippets

        vangware.dark-plus-material
        file-icons.file-icons

        donjayamanne.githistory
        waderyan.gitblame
        eamodio.gitlens
    )
    installed_extensions="$(code --list-extensions)"
    for extension in "${extensions[@]}"; do
        if [[ ! $installed_extensions = *"$extension"* ]]; then
            code --install-extension $extension
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