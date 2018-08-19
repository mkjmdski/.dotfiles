#!/bin/bash
function actualize_crontabs {
    crontab <<< $(cat $DOTFILES/crontab/crontab.*)
}