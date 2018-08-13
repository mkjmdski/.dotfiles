#!/bin/bash
source "../.lib/include.sh"

function main {
    os="$(get_os)"
    case "${os}" in
        CentOS*)
            install_package_centos terminator
        ;;
        Ubuntu*)
            install_package_ubuntu terminator
        ;;
        Darwin*)
            brew cask install iterm2
        ;;
        *)
            echo "Operating system > ${os} < is not supported" && exit 1
        ;;
    esac
}

main