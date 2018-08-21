#!/bin/bash
set -e
if [[ -z "${DOTFILES}" ]]; then
    export DOTFILES="$(git rev-parse --show-toplevel)"
fi
source "$DOTFILES/.lib/include.sh"

function install_tmux {
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

function source_tmux_config {
    tmux new-session -d -s installation-session
    tmux source ~/.tmux.conf
    tmux kill-session -t installation-session
}

function main {
    if ! tmux -V &> /dev/null; then
        install_tmux
    fi
    link_config .tmux.conf
    source_tmux_config
}

main