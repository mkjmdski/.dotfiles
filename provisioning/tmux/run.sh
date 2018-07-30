#!/bin/bash
set -e
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
currDir=$PWD
(
    cd ~
    ln -s $currDir/.tmux.conf .tmux.conf
)
tmux source ~/.tmux.conf
