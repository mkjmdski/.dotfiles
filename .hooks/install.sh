#!/bin/bash
source "../.lib/link_config.sh"
function main {
    link_config --target-directory ../.git/hooks post-commit pre-commit
}
main