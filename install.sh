#!/bin/bash
git clone https://github.com/mkjmdski/.dotfiles.git --depth 1 --branch master $HOME/.dotfiles
cd .dotfiles
./install
