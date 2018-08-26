# Bash Library

## About

It's not easy to create library for shell because each operation basically works on simple stdin/stdout operation. To include this library you have to source `include.sh` as an absolute path (relative paths can fail if you run script from different location)

## Library Structure

Even if each file is separated, access to them is shared. It means once you source library you can't limit it's scope. Each `.sh` file in library is loaded.

## Available functions

`get_os` returns `Darwin` (osx) or name of Linux distribution

`clone_repos_from_file` clones repositories included in text file (each one new line) to `$PWD` or directory passed as a second argument

`link_config` if you pass --target-directory as a first argument it will link configuration files to this directory. Otherwise all other arguments are linked with same name in `$HOME`