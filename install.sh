#!/bin/bash
source $(git rev-parse --show-toplevel)/zsh/install.sh
for file in $(git rev-parse --show-toplevel)/{.hooks,git,tmux,vim,vscode}/install.sh; do
    source "${file}"
done