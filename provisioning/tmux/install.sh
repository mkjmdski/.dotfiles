#!/bin/bash
set -e
source "../.lib/link_config.sh"
function main {
    git clone --depth=1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    link_config .tmux.conf
    tmux source ~/.tmux.conf
}
main