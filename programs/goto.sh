#!/bin/bash
set -e
function main { (
    cd /tmp || return
    git clone --depth=1 https://github.com/iridakos/goto.git
    cd goto
    sudo ./install
    cd ..
    rm -rf goto
) }
main