###############################################################################
# Trace .zshrc startup
###############################################################################
# set trace prompt to include seconds since start, script name, and line number
zmodload zsh/datetime
setopt promptsubst
SHELL_START_TIME=$EPOCHREALTIME
PS4='+$((EPOCHREALTIME - SHELL_START_TIME)) %N:%i> '
# save file stderr to file descriptor 3 and redirect stderr (including trace 
# output) to a file with the unixtime and the script's PID as an extension
exec 3>&2 2>/tmp/shellstartlog.$(echo $(date +%s) | cut -c6-)-$$
# turn on tracing and expansion of commands contained in the prompt
setopt xtrace prompt_subst


###############################################################################
# Basics
###############################################################################
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="ayk"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment following line if you want to disable autosetting terminal title.
export DISABLE_AUTO_TITLE="true"

# Plugins to load (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(git github python brew)

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

# virtualenvwrapper
export WORKON_HOME=$HOME/.pyvirtualenvs

# Manually set language to UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# Default editor to vim
export EDITOR='vim'

# latex
export TEXMFHOME=texmf

# tab completion in school directory
cds() { cd $HOME/Documents/School/$1; }
compctl -W $HOME/Documents/School/ -/ cds

# cd .. completion
zstyle ':completion:*' special-dirs true

# //FIXME: temporary for cs61b
source $HOME/Documents/School/61B/cs61b-software/adm/login

# pass bad match to command
setopt NO_NOMATCH

###############################################################################
# Aliases
###############################################################################
# vim
#------------------------------------------------------------------------------
alias vimclean="realrm -f ~/.zcompdump* && exec zsh"
alias vi="vim"
alias vimrc="vi ~/.vimrc"
function swpclean() {
    find . -name "*.sw*" -exec /bin/rm -rf {} \;
}

# tmux
#------------------------------------------------------------------------------
alias realtmux="/usr/local/bin/tmux"
function tmux() {
    # if given more than one argument, run tmux program with args normally
    if [[ $# -gt 0 ]]; then
        realtmux ${*:1}
        return
    fi
    local sessions
    sessions=$(realtmux ls 2>/dev/null)
    if [[ -z $sessions ]]; then 
        # if no tmux sessions open, start a new one
        realtmux
    else
        # else, do useful things
        local num_sess
        num_sess=$(echo $sessions | wc -l)
        if [[ -z $TMUX ]]; then 
            # not in tmux already
            if [[ $num_sess -gt 1 ]]; then
                # sessions > 1
                realtmux a \; choose-session
            fi
            # sessions == 1
            realtmux a
        elif [[ $num_sess -gt 1 ]]; then 
            # already in tmux, sessions > 1
            realtmux choose-session
        else
            # already in tmux, sessions == 1
            echo "Only running tmux session.\nExit tmux and use tnew to create a new one."
        fi
    fi
}

# attach to session
function ta() {
    if [[ -z $TMUX ]]; then
        tmux attach -t $*
    else
        tmux switch -t $*
    fi
}

# create new session
function ts() {
    if [[ ! -z $TMUX ]]; then
        local before
        local after
        before=$(tmux ls)
        TMUX= tmux new-session -d
        after=$(tmux ls)
        tmux switch -t $(diff <(echo $before) <(echo $after) | sed -n 2p | sed "s/:.*$//g" | cut -c2-)
    else
        tmux
    fi
}
alias tl='tmux ls'
alias tconf="vi ~/.tmux.conf"
alias c="clear"
alias cls="clear && ls"

# hook into exit for special tmux behavior
function exit() {
    if [[ -n $TMUX ]]; then
        tmux detach
    else
        builtin exit
    fi
}
alias tkill="exit && tmux ls | awk '{print $1}' | sed 's/:.*$//' | xargs -I{} tmux kill-session -t {}"

# Autostart if not already in tmux.
if [[ -z "$TMUX" ]]; then
    tmux
fi

# zsh
#------------------------------------------------------------------------------
alias zshrc="vi ~/.zshrc"
alias zshso="source ~/.zshrc"

# ssh aliases
#------------------------------------------------------------------------------
alias ssh61b='ssh -Y cs61b-tb@pentagon.cs.berkeley.edu'
alias ssh188='ssh -Y cs188-hz@pentagon.cs.berkeley.edu'

# python
#------------------------------------------------------------------------------
alias py="python"
alias py3="python3"
alias venvwrapper="source /usr/local/bin/virtualenvwrapper.sh"
function venv() {
    if [[ -n $VIRTUAL_ENV ]]; then
        workon $*
    else
        venvwrapper
        workon $*
    fi
}
if [[ -n $VIRTUAL_ENV ]]; then
    venv ${VIRTUAL_ENV:t}
fi

# alias for rm (requires trash script)
#------------------------------------------------------------------------------
alias realrm='/bin/rm'
alias rm='trash'

# builtin overrides and misc
#------------------------------------------------------------------------------
# override cd to do ls and vi when necessary
function _better_cd() {
    _cdpath="$1";
    if [[ -f $_cdpath ]]; then
        _fdir=${_cdpath%/*}
        if [[ -d $_fdir ]]; then
            builtin cd "${_fdir}" && ls
        fi
        vim "${_cdpath##*/}" ${*:2}
    else
        cd $* && ls
    fi
}
alias cd=_better_cd

# fall back to use built in cd
function cs() {
    builtin cd $*
}

# go to root of git directory
function gitroot() {
    cd "$(git rev-parse --show-toplevel)"
}

# copy to mac osx clipboard
function copy() {
    cat $1 | pbcopy
}

# core audio restart because apple tv sucks
alias fuckyouappletv='sudo killall coreaudiod'

# clean .DS_Store
function dsclean() {
    find . -name ".DS_Store" -exec /bin/rm -rf {} \;
}

# go to temp dir
alias temp="cs ~/temp"

###############################################################################
# End trace .zshrc startup
###############################################################################
unsetopt xtrace
# restore stderr to the value saved in FD 3
exec 2>&3 3>&-
