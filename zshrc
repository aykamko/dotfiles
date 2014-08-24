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
plugins=(git github python)

source $ZSH/oh-my-zsh.sh

###############################################################################
# Custom Config
###############################################################################
# Path
export PATH=/usr/texbin:/Users/Aleks/.rvm/gems/ruby-1.9.3-p327@rails3tutorial2ndEd/bin:/Users/Aleks/.rvm/gems/ruby-1.9.3-p327@global/bin:/Users/Aleks/.rvm/rubies/ruby-1.9.3-p327/bin:/Users/Aleks/.rvm/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/git/bin:/usr/local/share/python:/usr/local/share/npm/bin:/usr/local/sbin:/usr/local/heroku/bin

# Manually set language to UTF-8
export LANG=en_US.UTF-8

# Default editor to vim
export EDITOR='vim'

###########################################
# Aliases
###########################################
# vim
alias vimclean="rm -f ~/.zcompdump* && exec zsh"
alias vi="vim"
alias vimrc="vi ~/.vimrc"

# tmux
alias tmux="tmux -2" # force 256 color support
alias teven="tmux select-layout even-horizontal"
alias clear="clear && tmux clear-history"

# zsh
alias zshrc="vi ~/.zshrc"
alias zshso="source ~/.zshrc"

# alias for rm (requires trash script)
alias realrm='/bin/rm'
alias rm='trash'

# core audio restart because apple tv sucks
alias fuckyouappletv='sudo killall coreaudiod'

# copy/paste to mac clipboard
_mac_copy () {
    cat $1 | pbcopy
}
alias copy=_mac_copy
