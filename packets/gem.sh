#!/bin/bash
if ! gem --version; then
    echo "Install ruby and come back!!" && exit 1
fi
sudo gem install colorls
