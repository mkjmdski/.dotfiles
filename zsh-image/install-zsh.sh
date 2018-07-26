#!/bin/bash
set -e
### DEFINE INSTALATION PLATFROM
function get_distro {
    echo "$(cat /etc/*-release | head -n 1 | cut -d= -f 2 | cut -d" " -f 1)" #why the fuck this works even if -d" " stop quoting?
}
function get_platform {
    unameOut="$(uname -s)"
    case "${unameOut}" in
        Linux*)  
            distro="$(get_distro)"
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
### ENDEF 

function install_zsh {
    [ "$(whoami)" = root ] && prefix="" || prefix="sudo"
    case "$1" in
        Ubuntu*) 
            $prefix apt-get update
            $prefix apt-get install -y \
                git \
                zsh
            rm -rf /var/lib/apt/lists/*
        ;;
        CentOS*) 
            $prefix yum install -y \
                git \
                which \
                zsh
            $prefix yum clean all
        ;;
        Darwin*)
            if echo "$(which brew)" | grep --quiet brew; then
                brew install zsh git
            else
                echo "You have to install brew before..." && exit -1
            fi
        ;;
    esac
    chsh -s $(which zsh) #set zsh as current default shell
}

platform="$(get_platform)"
install_zsh ${platform}