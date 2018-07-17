## Description
This repository is my source control for zsh config which I use on various environements. It sets up:
* plugins which are loaded if binary exists: 
    * `docker-compose`
    * `docker`
    * `yarn`
    * `vault`
    * `terraform`
    * `minikube`
* plugins whic are always loaded:
    * `history`
* custom plugins which are always loaded:
    * [https://github.com/zsh-users/zsh-syntax-highlighting](zsh-syntax-highlighting)
    * [https://github.com/zsh-users/zsh-autosuggestions](zsh-autosuggestions)
* sets up bin path for:
    * yarn if exists as `yarn global bin`
    * custom `bin` directory at `$HOME`
* theme: fork of `agnoster` which shorts the directory to current CWD and avoids user info
* git:
    * sets up default editor as `vim`
    * aliases:
        * `bd` or `branch-delete` - removes branch locally and on remote
        * `td` or `tag-delete` - removes tag locally and on remote
        * `aa` - stands for add --all
        * `ca` - stands for commit --amend --no-edit
        * `pf` - stand for push --force-with-lease
        * `mark` - tags commit with version $1 and message $2 (or $1 if not given)

## Installation
For installation run:

`sh -c "$(curl -fsSL https://raw.githubusercontent.com/mkjmdski/shell-config/master/setup-ubuntu.sh)"`

Currently only ubuntu is supported, for other systems you need to edit file `setup-ubuntu.sh` manually and run it on the system if it fails.