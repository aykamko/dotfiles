###############################################################################
# Basics
###############################################################################
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="aleks"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Plugins to load (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(git github python)

source $ZSH/oh-my-zsh.sh

###############################################################################
# Custom Config
###############################################################################
# Base Path
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin

# X11
export PATH=/opt/X11/bin:$PATH
# heroku
export PATH=/usr/local/heroku/bin:$PATH
# git
export PATH=/usr/local/git/bin:$PATH
# LaTeX
export PATH=/usr/texbin:$PATH
# rvm
export PATH=$HOME/.rvm/bin:$PATH
export PATH=$HOME/.rvm/gems/ruby-2.1.3/bin:$PATH
# oculus
export PATH=$HOME/Documents/School/Research/osgoculusviewer/bin:$PATH

# Manually set language to UTF-8
export LANG=en_US.UTF-8

# Default editor to vim
export EDITOR='vim'

# tab completion in school directory
cds() { cd $HOME/Documents/School/$1; }
compctl -W $HOME/Documents/School/ -/ cds

# cd .. completion
zstyle ':completion:*' special-dirs true

# TEMP: for cs61b
source $HOME/Documents/School/61B/cs61b-software/adm/login

###########################################
# Aliases
###########################################
# vim
alias vimclean="realrm -f ~/.zcompdump* && exec zsh"
alias swpclean="/bin/rm -f .*.swp"
alias vi="vim"
alias vimrc="vi ~/.vimrc"

# tmux
alias tmux="tmux -2" # force 256 color support
alias teven="tmux select-layout even-horizontal"
alias tvert="tmux select-layout even-vertical"
alias tmuxconf="vi ~/.tmux.conf"
_clear() {
  clear
  if [[ -n $TMUX ]] ; then
    tmux clear-history
  fi
}
alias clear=_clear

# zsh
alias zshrc="vi ~/.zshrc"
alias zshso="source ~/.zshrc"

# alias for rm (requires trash script)
alias realrm='/bin/rm'
alias rm='trash'

# core audio restart because apple tv sucks
alias fuckyouappletv='sudo killall coreaudiod'

# ssh aliases
alias ssh61b='ssh -Y cs61b-tb@pentagon.cs.berkeley.edu'
alias ssh188='ssh -Y cs188-hz@pentagon.cs.berkeley.edu'

# copy/paste to mac clipboard
_mac_copy () {
    cat $1 | pbcopy
}
alias copy=_mac_copy

#latex
export TEXMFHOME=texmf
