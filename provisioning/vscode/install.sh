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
        for conf_file in settings.json snippets; do
            ln -s "${currDir}/${conf_file}" "${conf_file}"
        done
    )
}

link_config
