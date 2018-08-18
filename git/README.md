# Git

## Developing this repository

All files inside `conifg` are during commit merged into `.gitconfig` which is sourced by your global git configuration. While testing edit `.gitconfig` file and when commiting add new file or edit existing ones inside config directory. This way configuration is more readeable.

## Editor

During `git rebase -i` or `git commit --amend` you have to enter the editor. Some of us are picky about this and don't like the default one (for e.g. nano in Ubuntu). You can change that for any of your choice. I chose `vim`. But nothing stands against picking `code` or `atom` or `sublime`. See commented lines in `config/core` to check out this feature!

## Changed behaviours

* `git pull --rebase` is always done instead of `git pull`.
* `git diff` shows renamed/moved files and adds functionality of using `git difftool` which runs [icdiff](https://github.com/jeffkaufman/icdiff) in the background.
* `git log` tries to show shorter commit hashes wherever it's possible
* `git push` pushes with tags
* `git tag` output is sorted by numeric value of the tags
* `git clone` can now use `gh:` for `git@github.com:` and `bb:` for `git@bitbucket.org:`. All https connections are replaced with ssh.
* `git mergetool` runs pycharm as your default conflict tool

## Aliases

Each developer knows that each of the key strokes counts. Remember about this during creating commits! And use some of life-hack aliases:

* `git a` - stages all files
* `git s` - status with branch and stash
* `git m` - commits the stage with message
* `git amend` - overwrite previous commit with the current stage
* `git force` - overwrites remote commits done by you
* `git log-line` - presents all commits in pretty nice line
* `git mark` - adds a simple tag with message equal to version number and overwrites previous tag with that version
* `git tags` - lists all tags with messages
* `git branch-delete` - deletes given branch locally and remotely
* `git tag-delete` - deletes given tag locally and remotely
* `git undo` - unstages last commit
* `git stash-all` - stashes all changes with untracked files
* `git pop` - pops from stash
* `git unstage` - unstages changes from the index
* `git this` = Start a new local repository with all files in it and perform initial commit

## Colours

I learned that you can customize colors of `git branch`, `git diff`, `git status`, `git log --decorate`, `git grep`, and `git {add,clean} --interactive`. The easiest way I could find to view what properties are available to colorize is to search for *slot* on the git-config man page. I included some example in my `config/colors.gitconfig`.

## Gitignore

Everything listed in `global.gitignore` is indeed global gitignore file