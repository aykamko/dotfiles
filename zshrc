###############################################################################
# Basics
###############################################################################
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="robbyrussell"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Plugins to load (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(git)

source $ZSH/oh-my-zsh.sh

###############################################################################
# Custom Config
###############################################################################
# Path
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Manually set language to UTF-8
export LANG=en_US.UTF-8

# Default editor to vim
export EDITOR='vim'

###########################################
# Aliases
###########################################

alias vimclean="rm -f ~/.zcompdump* && exec zsh"
alias vi="vim"
alias teven="tmux select-layout even-horizontal"
alias zshrc="vi ~/.zshrc"
alias zshso="source ~/.zshrc"
alias vimrc="vi ~/.vimrc"
alias clear="clear && tmux clear-history"

_mac_copy () {
    cat $1 | pbcopy
}
alias copy=_mac_copy
