#!/bin/bash
set -e
source "../../.lib/include.sh"

function main {
    sudo pip install git+https://github.com/jeffkaufman/icdiff.git
    git config --global include.path "$PWD/.gitconfig"
    git config --global --file .gitconfig
    if [ "$(get_os)" = "CentOS" ]; then
         rpm -U http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm
         yum install -y git
    fi
}

main
