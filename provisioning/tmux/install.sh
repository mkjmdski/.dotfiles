#!/bin/bash
set -e
source "../.lib/link_config.sh"
function main {
    clone_repos_from_file "./tmux_plugins_repositories"
    link_config .tmux.conf
    tmux source ~/.tmux.conf
}
main