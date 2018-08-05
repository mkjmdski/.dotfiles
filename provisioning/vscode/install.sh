#!/bin/bash
set -e

# rogalmic.bash-debug
# apt package manager {r, engine='bash'} sudo apt-get install bashdb
# sudo gdebi Downloads/bashdb_4.3.0.91+ds-4build1_amd64.deb
# yum package manager {r, engine='bash'} sudo yum install bashdb
# installation from sources (advanced): {r, engine='bash'} tar -xvf bashdb-*.tar.gz cd bashdb-* ./configure make sudo make install
# verification {r, engine='bash'} bashdb --version

# timonwong.shellcheck
# apt-get install shellcheck
# yum -y install epel-release
# yum install ShellCheck
# brew install shellcheck

# ms-python.python
# pip3 install pylint

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

link_config
install_extensions