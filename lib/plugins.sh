#!/bin/bash

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