#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
for lib_file in $DIR/*.sh; do
    if [[ ! $lib_file = *"include.sh"* ]]; then
        source "${lib_file}"
    fi
done