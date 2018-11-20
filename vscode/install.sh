#!/bin/bash
source "$(git rev-parse --show-toplevel)/lib/vscode.sh"
if ! which code > /dev/null; then
    echo "You need to have vscode installed before!"
else
    install_vscode_extensions
fi