#!/bin/bash

function link_config {
    local currDir targetDir
    currDir=$PWD
    if [ "$1" = "--target-directory" ]; then
        targetDir="$2"
        shift
        shift
    else
        targetDir="$HOME"
    fi
    for config_file in "$@"; do (
        [[ -h "$targetDir/$config_file" ]] && unlink "$targetDir/$config_file" #is already a symlink
        [[ -e "$targetDir/$config_file" ]] && rm -rf "$targetDir/$config_file" #is file or directory
        cd "$targetDir" || exit 1
        ln -s "$currDir/$config_file" "$config_file"
    ) done
}

function clone_repos_from_file {
    file="$1"
    [ -n "$2" ] && directory="$2" || directory=""
    for repo in $(cat $file); do
        git clone --depth=1 $repo $directory
    done
}