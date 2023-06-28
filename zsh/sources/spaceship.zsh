SPACESHIP_TIME_SHOW="true"
SPACESHIP_BATTERY_THRESHOLD="80"
SPACESHIP_EXIT_CODE_SHOW="true"
SPACESHIP_EXIT_CODE_SYMBOL="✘ "

SPACESHIP_GIT_LAST_COMMIT_SHOW="${SPACESHIP_GIT_LAST_COMMIT_SHOW=true}"
SPACESHIP_GIT_LAST_COMMIT_SYMBOL="${SPACESHIP_GIT_LAST_COMMIT_SYMBOL=""}"
SPACESHIP_GIT_LAST_COMMIT_PREFIX="${SPACESHIP_GIT_LAST_COMMIT_PREFIX="("}"
SPACESHIP_GIT_LAST_COMMIT_SUFFIX="${SPACESHIP_GIT_LAST_COMMIT_SUFFIX=") "}"
SPACESHIP_GIT_LAST_COMMIT_COLOR="${SPACESHIP_GIT_LAST_COMMIT_COLOR="magenta"}"

# # ------------------------------------------------------------------------------
# # Section
# # ------------------------------------------------------------------------------

# # Show git_last_commit status
# # spaceship_ prefix before section's name is required!
# # Otherwise this section won't be loaded.
spaceship_git_last_commit() {
  # If SPACESHIP_GIT_LAST_COMMIT_SHOW is false, don't show git_last_commit section
  [[ $SPACESHIP_GIT_LAST_COMMIT_SHOW == false ]] && return

  spaceship::is_git || return

  local 'git_last_commit_status'
  # last commit in all repository
  #   git_last_commit_status=$(git log --pretty='format:%s|%cr' "HEAD^..HEAD" 2>/dev/null | head -n 1)
  # last commit in the current direcotry
  git_last_commit_status=$(git show --pretty='format:%s|%cr' $(git rev-list -1 HEAD -- .) 2>/dev/null | head -n 1)

  [[ -z $git_last_commit_status ]] && return

  # Display git_last_commit section
  spaceship::section::v4 \
    --color "$SPACESHIP_GIT_LAST_COMMIT_COLOR" \
    --prefix "$SPACESHIP_GIT_LAST_COMMIT_PREFIX" \
    --symbol "$SPACESHIP_GIT_LAST_COMMIT_SYMBOL" \
    --suffix "$SPACESHIP_GIT_LAST_COMMIT_SUFFIX" \
    "$git_last_commit_status"

}

SPACESHIP_KUBECTL_CONTEXT_PREFIX="at ☸️  "
if [ -f "$HOME/.dotfiles/.is_laptop" ]; then
  SPACESHIP_PROMPT_ORDER=(battery time dir git git_last_commit golang venv kubectl_context exec_time line_sep jobs exit_code char)
else
  SPACESHIP_PROMPT_ORDER=(time dir git git_last_commit golang venv kubectl_context exec_time line_sep jobs exit_code char)
fi