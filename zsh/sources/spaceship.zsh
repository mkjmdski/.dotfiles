
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
  # last commit in all repository
#   git_last_commit_status=$(git log --pretty='format:%s|%cr' "HEAD^..HEAD" 2>/dev/null | head -n 1)
  # last commit in the current direcotry
  git_last_commit_status=$(git show --pretty='format:%s|%cr' $(git rev-list -1 HEAD -- .) 2>/dev/null | head -n 1)

  # Exit section if variable is empty
  [[ -z $git_last_commit_status ]] && return

  # Display git_last_commit section
  spaceship::section \
    "$SPACESHIP_GIT_LAST_COMMIT_COLOR" \
    "$SPACESHIP_GIT_LAST_COMMIT_PREFIX" \
    "$SPACESHIP_GIT_LAST_COMMIT_SYMBOL$git_last_commit_status" \
    "$SPACESHIP_GIT_LAST_COMMIT_SUFFIX"

}

#
# Google Cloud Platform (gcloud)
#
# gcloud is a tool that provides the primary command-line interface to Google Cloud Platform.
# Link: https://cloud.google.com/sdk/gcloud/

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_GCLOUD_SHOW="${SPACESHIP_GCLOUD_SHOW=false}"
SPACESHIP_GCLOUD_PREFIX="${SPACESHIP_GCLOUD_PREFIX="using "}"
SPACESHIP_GCLOUD_SUFFIX="${SPACESHIP_GCLOUD_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_GCLOUD_SYMBOL="${SPACESHIP_GCLOUD_SYMBOL="☁️"}"
SPACESHIP_GCLOUD_COLOR="${SPACESHIP_GCLOUD_COLOR="26"}"


# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

# Shows active gcloud configuration.
spaceship_gcloud() {
  [[ $SPACESHIP_GCLOUD_SHOW == false ]] && return

  # Check if the glcoud-cli is installed
  spaceship::exists gcloud || return

  # Check if there is an active config
  [[ -d ~/.config/gcloud ]] || return
  [[ -f ~/.config/gcloud/active_config ]] || return

  # Reads the current config from the file
  local GCLOUD_CONFIG=${$(head -n1 ~/.config/gcloud/active_config)}
  # Get active project
  local GCLOUD_ACTIVE_PROJECT=$(cat ~/.config/gcloud/configurations/config_$GCLOUD_CONFIG | grep project | cut -d '=' -f 2)
  [[ -z $GCLOUD_ACTIVE_PROJECT ]] && return
  spaceship::section \
    "$SPACESHIP_GCLOUD_COLOR" \
    "$SPACESHIP_GCLOUD_PREFIX" \
    "${SPACESHIP_GCLOUD_SYMBOL}$GCLOUD_ACTIVE_PROJECT " \
    "$SPACESHIP_GCLOUD_SUFFIX"
}

SPACESHIP_PROMPT_ORDER=(time user dir host git git_last_commit golang docker venv gcloud kubectl exec_time line_sep battery vi_mode jobs exit_code char)