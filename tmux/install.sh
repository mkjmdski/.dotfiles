#!/bin/bash
set -e
for file in $(git rev-parse --show-toplevel)/lib/*.sh; do
    source "${file}"
done

function main {
    _install_custom_plugin "tmux" "brew install tmux"
    link_config .tmux.conf
}

echo " >> Installing tmux"
main
echo " >> Success"