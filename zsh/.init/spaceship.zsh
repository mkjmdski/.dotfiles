SPACESHIP_TIME_SHOW="true"
SPACESHIP_BATTERY_THRESHOLD="80"
SPACESHIP_EXIT_CODE_SHOW="true"
SPACESHIP_EXIT_CODE_SYMBOL="✘ "

SPACESHIP_GIT_LAST_COMMIT_SHOW="${SPACESHIP_GIT_LAST_COMMIT_SHOW=true}"
SPACESHIP_GIT_LAST_COMMIT_SYMBOL="${SPACESHIP_GIT_LAST_COMMIT_SYMBOL=""}"
SPACESHIP_GIT_LAST_COMMIT_PREFIX="${SPACESHIP_GIT_LAST_COMMIT_PREFIX="("}"
SPACESHIP_GIT_LAST_COMMIT_SUFFIX="${SPACESHIP_GIT_LAST_COMMIT_SUFFIX=") "}"
SPACESHIP_GIT_LAST_COMMIT_COLOR="${SPACESHIP_GIT_LAST_COMMIT_COLOR="magenta"}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

# Show git_last_commit status
# spaceship_ prefix before section's name is required!
# Otherwise this section won't be loaded.
spaceship_git_last_commit() {
  # If SPACESHIP_GIT_LAST_COMMIT_SHOW is false, don't show git_last_commit section
  [[ $SPACESHIP_GIT_LAST_COMMIT_SHOW == false ]] && return

  spaceship::is_git || return

  local 'git_last_commit_status'
  git_last_commit_status=$(git log --pretty='format:%s|%cr' "HEAD^..HEAD" 2>/dev/null | head -n 1)

  # Exit section if variable is empty
  [[ -z $git_last_commit_status ]] && return

  # Display git_last_commit section
  spaceship::section \
    "$SPACESHIP_GIT_LAST_COMMIT_COLOR" \
    "$SPACESHIP_GIT_LAST_COMMIT_PREFIX" \
    "$SPACESHIP_GIT_LAST_COMMIT_SYMBOL$git_last_commit_status" \
    "$SPACESHIP_GIT_LAST_COMMIT_SUFFIX"

}


SPACESHIP_WATSON_SHOW="${SPACESHIP_WATSON_SHOW=true}"
SPACESHIP_WATSON_SYMBOL="${SPACESHIP_WATSON_SYMBOL="🔨 "}"
SPACESHIP_WATSON_PREFIX="${SPACESHIP_WATSON_PREFIX="$SPACESHIP_PROMPT_DEFAULT_PREFIX"}"
SPACESHIP_WATSON_SUFFIX="${SPACESHIP_WATSON_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_WATSON_COLOR="${SPACESHIP_WATSON_COLOR="green"}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

# Show watson status
# spaceship_ prefix before section's name is required!
# Otherwise this section won't be loaded.
spaceship_watson() {
  # If SPACESHIP_WATSON_SHOW is false, don't show watson section
  [[ $SPACESHIP_WATSON_SHOW == false ]] && return

  # Check if watson command is available for execution
  spaceship::exists watson || return

  # Use quotes around unassigned local variables to prevent
  # getting replaced by global aliases
  # http://zsh.sourceforge.net/Doc/Release/Shell-Grammar.html#Aliasing
  local 'watson_status'
  watson_status="$(watson status | perl -pe 's/(Project | started.*\(.*\))//g') "

  # Exit section if variable is empty
  [[ -z $watson_status ]] && return
  [[ $watson_status =~ 'No project started' ]] && return

  # Display watson section
  spaceship::section \
    "$SPACESHIP_WATSON_COLOR" \
    "$SPACESHIP_WATSON_PREFIX" \
    "$SPACESHIP_WATSON_SYMBOL$watson_status" \
    "$SPACESHIP_WATSON_SUFFIX"

}
SPACESHIP_PROMPT_ORDER=(time watson user dir host git git_last_commit package node ruby golang rust docker aws venv conda pyenv kubectl terraform exec_time line_sep battery vi_mode jobs exit_code char)