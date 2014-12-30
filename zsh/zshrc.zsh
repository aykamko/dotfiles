###############################################################################
# Prezto
###############################################################################
# Source Prezto
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

###############################################################################
# Aliases & Functions
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
            echo 'Only running tmux session.\nExit tmux and use tnew to create a new one.'
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
    if [[ -f $1 ]]; then
        local fdir
        fdir="${$1%/*}"
        if [[ -d $fdir ]]; then
            builtin cd "$fdir" && ls
        fi
        vim "${$1##*/}" ${*:2}
    else
        builtin cd $* && ls
    fi
}
alias cd=_better_cd

# fall back to use built in cd
function cs() {
    builtin cd $*
}

# tab completion in school directory
cds() { cd $HOME/Documents/School/$1; }
compctl -/ -W $HOME/Documents/School/ cds

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
