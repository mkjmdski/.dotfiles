#!/bin/bash
set -e
source "$(git rev-parse --show-toplevel)/lib/configurations.sh"


function main {
    _install_custom_plugin "tmux" "brew install tmux"
    link_config .tmux.conf
}

echo " >> Installing tmux"
main
echo " >> Success"