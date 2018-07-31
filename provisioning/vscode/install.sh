#!/bin/bash
set -e
function set_config_path {
    unameOut="$(uname -s)"
    case "${unameOut}" in
        Linux*)
            echo "$HOME/.config/Code/User/"
        ;;
        Darwin*)
            echo "$HOME/Library/Application Support/Code/User/"
        ;;
        *) echo "UNKOWN OS: ${unameOut}" && exit -1
    esac
}

function link_config {
    config_path="$(set_config_path)"
    rm "${config_path}/settings.json"
    currDir=$PWD
    (
        cd "${config_path}"
        ln -s "${currDir}/settings.json" settings.json
    )
}

link_config
