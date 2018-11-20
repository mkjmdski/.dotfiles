#!/bin/bash

if apt --version; then
    sudo apt install -y \
        mc \
        silversearcher-ag \
        most
fi