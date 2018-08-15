#!/bin/bash
source "../.lib/include.sh"
set -e
function main {
    os="$(get_os)"
    case "${os}" in
        CentOS*)
            install_package_centos task
        ;;
        Ubuntu*)
            install_package_ubuntu taskwarrior
        ;;
        Darwin*)
            install_package_darwin task
        ;;
        *)
            echo "Operating system > ${os} < is not supported" && exit 1
        ;;
    esac
}

main