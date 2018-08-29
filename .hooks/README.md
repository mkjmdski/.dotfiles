# Git hooks

## What are hooks

Git hooks are run during specific git actions. Example codes and behaviours are available to check in `.git/hooks`. Unfortunetly those can't be kept in the repository so it's considered a good practice to include them in different directory with instructions how to use and install hooks.

## Installing hooks

Just enter this directory with cd and run `install.sh`

## What do they do

If commit message contains tag `[ext]` your current vscode extensions are taken as update list. This can break your tagging!

After each pull you are asked about installing new set of extensions.

You can also run this command manually form lib/vscode.sh file `source lib/vscode.sh; install_vscode_extensions`