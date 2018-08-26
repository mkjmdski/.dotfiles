#!/bin/zsh

function _log_warning {
    echo "$fg[yellow][WARNING]$reset_color $(date '+%H:%M:%S') > $@"
}

function _log_error {
    echo "$fg[red][ERROR]$reset_color $(date '+%H:%M:%S') > $@"
}

function _log_info {
    echo "$fg[green][INFO]$reset_color $(date '+%H:%M:%S') > $@"
}
