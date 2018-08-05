#!/bin/bash
set -e

function _get_distro { (
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        echo "${NAME}"
    elif [ -x "$( lsb_release --id )" ]; then
        lsb_release --id | cut -d":" -f 2 | tr -d '[:space:]'
    else
        echo "Can't define the way to find linux distribution" && exit -1
    fi
) }

function get_os {
    local unameOut distro
    unameOut="$(uname -s)"
    case "${unameOut}" in
        Linux*)
            distro="$(_get_distro)"
            case "${distro}" in
                Ubuntu|CentOS) echo "${distro}"
                ;;
                *) echo "UNKOWN LNIUX DISTRIBUTION ${distro}" && exit -1
            esac
        ;;
        Darwin*) echo Darwin
        ;;
        CYGWIN*) echo "Cygwin is not supported, try to analyze sourcode to install dependencies" && exit -1
        ;;
        MINGW*) echo "Mingw is not supported, try to analyze sourcode to install dependencies" && exit -1
        ;;
        *) echo "UNKOWN OS: ${unameOut}" && exit -1
    esac
}