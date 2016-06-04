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

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# alias to sudo up to root with correct $HOME
alias sup='sudo -H -u root /bin/bash -o vi'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Virtual environments for pips
#
export WORKON_HOME=~/.pyenvironments
mkdir -p ${WORKON_HOME}
source /usr/local/bin/virtualenvwrapper.sh

# Command retrieval
#
set -o vi
