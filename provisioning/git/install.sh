#!/bin/bash
function main {
    sudo pip install git+https://github.com/jeffkaufman/icdiff.git
    git config --global include.path "$PWD/.gitconfig"
}
main
