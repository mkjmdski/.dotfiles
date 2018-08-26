#!/bin/bash

function link_config {
    local curr_dir target_dir
    curr_dir=$PWD
    if [ "$1" = "--target-directory" ]; then
        target_dir="$2"
        shift
        shift
    else
        target_dir="$HOME"
    fi
    for config_file in "$@"; do (
        if [ -h "${target_dir}/${config_file}" ]; then
            _log_info "unlinking ${target_dir}/${config_file}"
            unlink "${target_dir}/${config_file}"
        fi
        if [ -e "${target_dir}/${config_file}" ]; then
            _log_info "${target_dir}/${config_file} exists, creating backup at ${target_dir}/${config_file}.bkp"
            mv "${target_dir}/${config_file}" "${target_dir}/${config_file}.bkp"
        fi
        cd "${target_dir}"
        ln -s "${curr_dir}/${config_file}" "${config_file}"
        _log_info "link created succesfully: ${curr_dir}/${config_file}" "${config_file}"
    ) done
}

function clone_repos_from_file {
    file="$1"
    [ -n "$2" ] && directory="$2" || directory=""
    for repo in $(cat $file); do
        git clone --depth=1 $repo $directory
    done
}