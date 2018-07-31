#!/bin/bash
set -e
conf="git config --global"
$conf core.editor vim
$conf alias.a "add --all"
$conf alias.s "status --branch --show-stash"
$conf alias.com "commit --all --message"
$conf alias.amend "commit --amend --no-edit"
$conf alias.force "push --force-with-lease"
$conf alias.branch-delete '!sh -c "git branch -D $1 && git push origin :$1" -'
$conf alias.tag-delete '!sh -c "git tag -d $1 && git push origin :refs/tags/$1" -'
$conf alias.mark '! bash -c "if [[ $# -eq 2 ]]; then git tag -a $1 -m $2; elif [[ $# -eq 1 ]]; then git tag -a $1 -m $1; fi" -'