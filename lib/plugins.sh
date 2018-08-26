#!/bin/bash

function _install_custom_plugin {
    program="$1"
    installation_script="$2"
    if ! which $program &> /dev/null; then
        _log_info "Install $program? [y/N]: " # Prompt about installing plugins
        if read -q; then
            echo
            eval $installation_script
        fi
    fi
}