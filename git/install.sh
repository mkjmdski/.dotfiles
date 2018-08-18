#!/bin/bash
set -e
source "$DOTFILES/.lib/include.sh"

function main {
    git config --global include.path "$PWD/global.gitconfig"
    git config --global core.excludesfile "$PWD/global.gitignore"
    if ! icdiff --version &> /dev/null; then
        sudo pip install git+https://github.com/jeffkaufman/icdiff.git
    fi
    if [ "$(get_os)" = "CentOS" ]; then
         rpm -U http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm
         yum install -y git
    fi
}

main
