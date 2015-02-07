###############################################################################
# Autostart TMUX
###############################################################################
if [[ ! -f "$HOME/.notmux" && -z "$TMUX" ]]; then
    echo "Not in tmux session. Won't load rest of zshrc."
    tmux attach || tmux
    return
fi

###############################################################################
# Prezto
###############################################################################
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

###############################################################################
# Aliases & Functions
###############################################################################
# basics
#------------------------------------------------------------------------------
alias c="clear"

# zsh
#------------------------------------------------------------------------------
alias zshso="source ~/.zshrc"
alias zshrc="vi ~/.zshrc"
alias zprofile="vi ~/.zprofile"
alias zpreztorc="vi ~/.zpreztorc"

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
            else
                # sessions == 1
                realtmux a
            fi
        elif [[ $num_sess -gt 1 ]]; then 
            # already in tmux, sessions > 1
            realtmux choose-session
        else
            # already in tmux, sessions == 1
            echo 'Only running tmux session.\nExit tmux and use tnew to create a new one.'
        fi
    fi
}

# tmux attach
function ta() {
    if [[ -z $TMUX ]]; then
        tmux attach -t $*
    else
        tmux switch -t $*
    fi
}

function exit() {
    if [[ -n $TMUX ]]; then
        tmux detach
    else
        builtin exit
    fi
}

function tkill() {
    [[ -n $TMUX ]] && exit
    tmux ls | awk '{print $1}' | sed 's/:.*$//' | xargs -I{} tmux kill-session -t {}
}

alias tl='tmux ls'
alias detach='tmux detach'
alias tconf="vi ~/.tmux.conf"

# vim
#------------------------------------------------------------------------------
alias vimclean="realrm -f ~/.zcompdump* && exec zsh"
alias vi="vim"
alias vimrc="vi ~/.vimrc"
function swpclean() {
    find . -name "*.sw*" -exec /bin/rm -rf {} \;
}

# ssh aliases
#------------------------------------------------------------------------------
alias ssh164='ssh -X cs164-em@pentagon.cs.berkeley.edu'
alias ssh61b='ssh -X cs61b@cs61b.eecs.berkeley.edu'
alias ssh188='ssh -X cs188-hz@pentagon.cs.berkeley.edu'

# python
#------------------------------------------------------------------------------
eval "$(pyenv init -)"
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
    venvwrapper
    workon ${VIRTUAL_ENV:t}
fi

# ruby
#------------------------------------------------------------------------------
function _loadrvm() {
    echo 'Loading RVM. Run command again to use it.'
    unalias rvm
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
}
alias rvm=_loadrvm

# alias for rm (requires trash script)
#------------------------------------------------------------------------------
alias realrm='/bin/rm'
alias rm='trash'

# builtin overrides and misc
#------------------------------------------------------------------------------
# override cd to do ls and vi when necessary
function _better_cd() {
    if [[ -f $1 ]]; then
        local -a fdir
        fdir="${${1}%/*}"
        if [[ -d $fdir ]]; then
            builtin cd "$fdir" && ls
        fi
        vim "${${1}##*/}" ${*:2}
    else
        builtin cd $* && ls
    fi
}
alias cd=_better_cd

# fall back to use built in cd
function cs() {
    builtin cd $*
}

# go to root of git directory
function groot() {
    cd "$(git rev-parse --show-toplevel)"
}

# go to temp dir
alias temp="cs $HOME/temp"

###############################################################################
# Mac OSX
###############################################################################
if [[ "$OSTYPE" == darwin* && -f "$HOME/.osx_zshrc" ]]; then
    source "$HOME/.osx_zshrc";
fi

###############################################################################
# Temporary
###############################################################################
if [[ -f "$HOME/.tmp_zshrc" ]]; then
    source "$HOME/.tmp_zshrc";
fi
