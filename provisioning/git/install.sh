#!/bin/bash
function link_config {
    git config --global include.path $PWD/.gitconfig
}

link_config