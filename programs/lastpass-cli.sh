#!/bin/bash
set -e
source "../.lib/include.sh"

function build_from_source { (
    cd /tmp || return
    git clone --depth=1 https://github.com/lastpass/lastpass-cli.git
    cd lastpass-cli
    make
    sudo make install
    mv build/lpass "$HOME/bin"
    cd ..
    rm -rf lastpass-cli
) }

function install_lastpass_centos {
    local os_version
    os_version="$(get_centos_version)"
    is_new="$(version_compare $os_version 7)"
    if [ "${is_new}" -eq "2" ]; then
        install_package_centos openssl libcurl libxml2 pinentry xclip openssl-devel libxml2-devel libcurl-devel gcc gcc-c++ make cmake
        build_from_source
    else
        install_package_centos lastpass-cli
    fi
}

function install_ubuntu_dependencies {
    local os_version
    os_version="$(get_centos_version)"
    is_new="$(version_compare $os_version 18.04)"
    if [ "$is_new" -eq "2" ]; then
        apt-get --no-install-recommends -yqq install \
            bash-completion \
            build-essential \
            cmake \
            libcurl3  \
            libcurl3-openssl-dev  \
            libssl1.0 \
            libssl1.0-dev \
            libxml2 \
            libxml2-dev  \
            pkg-config \
            ca-certificates \
            xclip
    else
        apt-get --no-install-recommends -yqq install \
            bash-completion \
            build-essential \
            cmake \
            libcurl4  \
            libcurl4-openssl-dev  \
            libssl-dev  \
            libxml2 \
            libxml2-dev  \
            libssl1.1 \
            pkg-config \
            ca-certificates \
            xclip
    fi
    build_from_source
}

function main {
    os="$(get_os)"
    case "${os}" in
        CentOS*)
            install_lastpass_centos
        ;;
        Ubuntu*)
            install_ubuntu_dependencies
        ;;
        Darwin*)
            brew install lastpass-cli --with-pinentry
        ;;
        *)
            echo "Operating system > ${os} < is not supported" && exit 1
        ;;
    esac
}

main