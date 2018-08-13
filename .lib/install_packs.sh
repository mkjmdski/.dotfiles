#!/bin/bash

function install_powerline_font { (
    cd /tmp || return
    git clone https://github.com/powerline/fonts.git --depth=1
    cd fonts
    ./install.sh
    cd ..
    rm -rf fonts
) }

function install_package_ubuntu {
    local prefix
    [ "$(whoami)" = root ] && prefix="" || prefix="sudo"
    $prefix apt-get install -y "$@"
}

function install_package_centos {
    local prefix
    [ "$(whoami)" = root ] && prefix="" || prefix="sudo"
    $prefix yum install -y "$@"
}

function install_package_darwin {
    if brew -v > /dev/null; then
        for pack in "$@"; do
            if [ ! $commands[$pack] ]; then
                brew install "${pack}"
            fi
        done
    else
        echo "You have to install brew before..."
        local response
        response=y
        read -p "Install brew y/n? deafult: y `echo $'\n '`" response
        case "$( echo "${response}" | tr '[:upper:]' '[:lower:]')" in
            y|yes)
                /usr/bin/env ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
                install_package_darwin "$@"
                ;;
            *)
                echo "You can't continue on macOSX without brew https://brew.sh/" && exit 1
                ;;
        esac
    fi
}

function install_package_universal {
    os="$(get_os)"
    for pack in "$@"; do
        case "${os}" in
            CentOS*)
                install_package_centos "${pack}"
            ;;
            Ubuntu*)
                install_package_ubuntu "${pack}"
            ;;
            Darwin*)
                install_package_darwin "${pack}"
            ;;
            *)
                echo "Operating system ${os} is not supported" && exit 1
            ;;
        esac
    done
}