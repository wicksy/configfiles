# Functions
#

function _show_git_status {
  # Get the current git branch and colorize to indicate branch state
  # branch_name+ indicates there are stash(es)
  # branch_name? indicates there are untracked files
  # branch_name! indicates your branches have diverged
  local unknown untracked stash clean ahead behind staged unstaged diverged
  unknown='0;34'      # blue
  untracked='0;32'    # green
  stash='0;32'        # green
  clean='0;32'        # green
  ahead='0;33'        # yellow
  behind='0;33'       # yellow
  staged='0;96'       # cyan
  unstaged='0;31'     # red
  diverged='0;31'     # red

  if [[ $TERM = *256color ]]; then
    unknown='38;5;25'     # dark blue
    untracked='38;5;35'   # greenish
    stash='38;5;72'       # dull green
    clean='38;5;2'        # green
    ahead='38;5;220'      # yellow
    behind='38;5;142'     # darker yellow-orange
    staged='38;5;130'     # orangey
    unstaged='38;5;202'   # orange
    diverged='38;5;124'   # red
  fi

  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    git_status=$(git status 2> /dev/null)
    # If nothing changes the color, we can spot unhandled cases.
    color=$unknown
    if echo $git_status | grep -qe 'Untracked files'; then
      color=$untracked
      branch="${branch}?"
    fi
    if git stash show &>/dev/null; then
      color=$stash
      branch="${branch}+"
    fi
    if echo $git_status | grep -qe 'working directory clean'; then
      color=$clean
    fi
    if echo $git_status | grep -qe 'Your branch is ahead'; then
      color=$ahead
    fi
    if echo $git_status | grep -qe 'Your branch is behind'; then
      color=$behind
    fi
    if echo $git_status | grep -qe 'Changes to be committed'; then
      color=$staged
    fi
    if echo $git_status | grep -qe 'Changed but not updated' \
                               -e 'Changes not staged'; then
      color=$unstaged
    fi
    if echo $git_status | grep -qe 'Your branch.*diverged'; then
      color=$diverged
      branch="${branch}!"
    fi
    echo -n " \[\033[${color}m\](${branch})\[\033[0m\]"
  fi
  return 0
}

function _build_prompt {
  git_status=$(_show_git_status)
  if [[ $(id -u) == 0 ]] ; then
    _prompt="#"
  else
    _prompt="$"
  fi
  PS1="\u@\h${git_status}:\w\${_prompt} "
  return 0
}
PROMPT_COMMAND="_build_prompt; $PROMPT_COMMAND"

# Virtual environments for pips
#
export WORKON_HOME=~/.pyenvironments
mkdir -p ${WORKON_HOME}
source /usr/local/bin/virtualenvwrapper.sh

# Command retrieval
#
set -o vi
