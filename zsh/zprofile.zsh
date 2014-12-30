###############################################################################
# Browser
###############################################################################
if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

###############################################################################
# Editors
###############################################################################
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

###############################################################################
# Language
###############################################################################
export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'
export LANGUAGE='en_US.UTF-8'

###############################################################################
# Paths
###############################################################################
# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

path=(
  /usr/local/{bin,sbin}
  /usr/{bin,sbin}
  /bin
  /opt/X11/bin
  /usr/local/heroku/bin
  /usr/local/git/bin
  /usr/texbin
  $HOME/.rvm/bin
  $HOME/.rvm/gems/ruby-2.1.3/bin
  $path
)

###############################################################################
# Less
###############################################################################
# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

###############################################################################
# Misc
###############################################################################
# Virtualenv
export WORKON_HOME=$HOME/.pyvirtualenvs

# Latex
export TEXMFHOME=texmf

# pass bad match to command
setopt NO_NOMATCH
