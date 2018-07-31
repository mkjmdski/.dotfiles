#!/bin/bash
set -e
function setup {
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

function link_config {
    currDir=$PWD
    (
        cd ~
        ln -s $currDir/.tmux.conf .tmux.conf
    )
    tmux source ~/.tmux.conf
}

setup
link_config