#!/bin/bash
set -e
function main {
    local version="$1"
    wget "https://hisham.hm/htop/releases/2.2.0/htop-${version}.tar.gz"
    x htop-*.tar.gz
    (
        cd "htop-${version}"
        ./configure && make
        make install
        mv htop "$HOME/bin/"
    )
    rm -rf htop-*
}

main "2.2.0"