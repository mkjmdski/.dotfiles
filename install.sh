#!/bin/bash
git clone https://github.com/mkjmdski/.dotfiles.git --depth 1
(
    cd .dotfiles
    ./install
)

