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
            echo " >> unlinking ${target_dir}/${config_file}"
            unlink "${target_dir}/${config_file}"
        fi
        if [ -e "${target_dir}/${config_file}" ]; then
            echo " >> ${target_dir}/${config_file} exists, creating backup at ${target_dir}/${config_file}.bkp"
            mv "${target_dir}/${config_file}" "${target_dir}/${config_file}.bkp"
        fi
        cd "${target_dir}"
        ln -s "${curr_dir}/${config_file}" "${config_file}"
        echo " >> link created succesfully: ${curr_dir}/${config_file}" "${config_file}"
    ) done
}

function _install_custom_plugin {
    program="$1"
    installation_script="$2"
    if ! which $program &> /dev/null; then
        read -p " >> Install $program? [y/N]: " -n 1 -r
        echo    # (optional) move to a new line
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            eval $installation_script
        fi
    fi
}