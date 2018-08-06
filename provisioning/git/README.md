# Git

## Editor

During `git rebase -i` or `git commit --amend` you have to enter the editor. Some of us are picky about this and don't like the default one (for e.g. nano in Ubuntu). You can change that for any of your choice. I chose vim. But nothing stands against picking `code` or `atom` or `sublime`. See commented lines to check out this feature!

## Default behaviours

* `git pull --rebase` is always done instead of `git pull`.
* `git diff` shows renamed/moved files and adds functionality of using `git difftool` which runs [icdiff](https://github.com/jeffkaufman/icdiff) in the background.
* `git log` tries to show shorter commit hashes wherever it's possible
* `git push` pushes with tags
* `git tag` output is sorted by numeric value of the tags
* `git clone` can now use `gh:` for `git@github.com:` and `gh://` for `https://github.com/`. Same for `bb` which stands for bitbucket


## Aliases

Each developer knows that all of the key stroke count. Remember about this during creating commits! And use some of life-hack aliases:

* `git a` - stages all files
* `git m` - commits the stage with message
* `git am` - commits all files with the message
* `git amend` - overwrite previous commit with the current stage
* `git force` - overwrites remote commits done by you
* `git log-line` - presents all commits in pretty nice line
* `git mark` - adds a simple tag with message equal to version number and overwrites previous tag with that version
* `git tags` - lists all tags with messages
* `git branch-delete` - deletes given branch locally and remotely
* `git tag-delete` - deletes given tag locally and remotely

## Colours

I learned that you can customize the colors of `git branch`, `git diff`, `git status`, `git log --decorate`, `git grep`, and `git {add,clean} --interactive`. The easiest way I could find to view what properties are available to colorize is to search for <slot> on the git-config man page. I included some example in my config

## Configuration

This configuration is added as include key in `.gitconfig` toml. It means there is no symbolink link between your file and repository configuration. It is just loaded from the location. Warning! `icdiff` requires python2 to run correctly.