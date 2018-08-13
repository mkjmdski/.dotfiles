#!/bin/bash
set -e
source "../../.lib/include.sh"

function tmux {
    os="$(get_os)"
    case "${os}" in
        CentOS*)
            install_package_centos epel-release tmux
        ;;
        Ubuntu*)
            install_package_ubuntu git automake build-essential pkg-config libevent-dev libncurses5-dev
            git clone --depth=1git clone https://github.com/tmux/tmux.git /tmp/tmux
            (
                cd /tmp/tmux
                sh autogen.sh
                ./configure && make
                sudo make install
            )
            rm -fr /tmp/tmux
        ;;
        Darwin*)
            install_package_darwin tmux
        ;;
        *)
            echo "Operating system > ${os} < is not supported" && exit 1
        ;;
    esac
}

function main {
    install_tmux
    clone_repos_from_file "./tmux_plugins_repositories"
    link_config .tmux.conf
    tmux source ~/.tmux.conf
}
main