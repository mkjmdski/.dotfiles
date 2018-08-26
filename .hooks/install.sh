#!/bin/zsh
set -e
for file in $(git rev-parse --show-toplevel)/lib/*.sh; do
    source "${file}"
done
function main {
    link_config --target-directory "$(git rev-parse --show-toplevel)/.git/hooks" post-commit commit-msg post-merge
}
_log_info "Installing git hooks"
main
_log_info "Success"