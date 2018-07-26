## Description
This repository is my source control for [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) config which I use on various environements. The setup contains:
## ZSH 
### plugins which are always loaded:
* `copyfile`
* `copydir`
* `history`
* `encode64`
* `extract`
* [`zsh-syntax-highlighting`](https://github.com/zsh-users/zsh-syntax-highlighting)
* [`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions)
### plugins which are loaded if command exists: 
* `docker-compose`
* `docker`
* `yarn`
* `vault`
* `terraform`
* `minikube`
* `helm`
* `kubectl`
### sets up extra $PATH for:
* `yarn global bin` if yarn exists 
* `$HOME/bin` if `bin` dir exists in $HOME
### theme: 
my edited version of `agnoster` which shorts the directory to current CWD and avoids user info, also shows git tag in repositories
## git:
* sets up default editor as `vim`
* adds aliases:
    * `bd` or `branch-delete` - removes branch locally and on remote
    * `td` or `tag-delete` - removes tag locally and on remote
    * `aa` - stands for add --all
    * `ca` - stands for commit --amend --no-edit
    * `pf` - stand for push --force-with-lease
    * `mark` - tags commit with version $1 and message $2 (or $1 if not given)
## vim:
* install vim if doesn't exist ;)
* add Vundle to manage plugins
* install plugins:
    * `VundleVim/Vundle`
    * `bash-support`
    * `ekalinin/Dockerfile`
    * `avakhov/vim-yaml`
    * `neutaaaaan/iosvkem`

## Installation
### Instruction:

To install run:

`sh -c "$(curl -fsSL https://raw.githubusercontent.com/mkjmdski/shell-config/master/install.sh)"`


### Additional info

All files in this repository are not copied but the symlinks in proper places are created so while you edit this repository config on your machines changes