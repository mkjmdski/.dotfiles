#!/bin/bash
set -e
git config --global core.editor vim
git config --global alias.a "add --all"
git config --global alias.s "status --branch --show-stash"
git config --global alias.com "commit --all --message"
git config --global alias.amend "commit --amend --no-edit"
git config --global alias.force "push --force-with-lease"
git config --global alias.branch-delete '!sh -c "git branch -D $1 && git push origin :$1" -'
git config --global alias.tag-delete '!sh -c "git tag -d $1 && git push origin :refs/tags/$1" -'
git config --global alias.mark '! bash -c "if [[ $# -eq 2 ]]; then git tag -a $1 -m $2; elif [[ $# -eq 1 ]]; then git tag -a $1 -m $1; fi" -'