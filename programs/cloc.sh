#!/bin/bash
set -e
source "../.lib/include.sh"

function main {
    echo install
    install_package_universal cloc
}
main