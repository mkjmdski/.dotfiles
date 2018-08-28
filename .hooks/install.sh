#!/bin/bash
set -e
for file in $(git rev-parse --show-toplevel)/lib/*.sh; do
    source "${file}"
done
function main {
    link_config --target-directory "$(git rev-parse --show-toplevel)/.git/hooks" post-commit commit-msg post-merge
}
echo " >> Installing git hooks"
main
echo " >> Success"