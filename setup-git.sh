#!/bin/bash
git config --global core.editor vim
git config --global alias.aa add --all
git config --global alias.ca commit --amend --no-edit
git config --global alias.pf push --force-with-lease
git config --global alias.bd '!sh -c "git branch -D $1 && git push origin :$1" -'
git config --global alias.branch-delete '!sh -c "git branch -D $1 && git push origin :$1" -'
git config --global alias.td '!sh -c "git tag -d $1 && git push origin :refs/tags/$1" -'
git config --global alias.tag-delete '!sh -c "git tag -d $1 && git push origin :refs/tags/$1" -'
git config --global alias.mark '! bash -c "if [[ $# -eq 2 ]]; then git tag -a $1 -m $2 && git push origin --tags; elif [[ $# -eq 1 ]]; then git tag -a $1 -m $1 && git push origin --tags; fi" -'