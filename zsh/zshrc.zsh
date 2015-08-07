# vim
#------------------------------------------------------------------------------
alias vimclean="realrm -f ~/.zcompdump* && exec zsh"
alias vi="vim"
alias vimrc="vi ~/.vimrc"
function swpclean() {
    find . -name "*.sw*" -exec /bin/rm -rf {} \;
}
function vreplace() {
  if [[ $# < 2 ]]; then
    echo 'Not enough arguments!'
    return 1
  fi

  local files
  if [[ $# == 2 ]]; then
    files=`find .`
  else
    files=${*:3}
  fi
  vim -c "bufdo \%s/$1/$2/gec | update" -c "q" $files
}

###############################################################################
# Aliases & Functions
###############################################################################
# basics
#------------------------------------------------------------------------------
alias c="clear"

# Facebook Path Picker
#------------------------------------------------------------------------------
alias pp="fpp"

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
    sessions=`realtmux ls 2>/dev/null`
    if [[ -z $sessions ]]; then 
        # if no tmux sessions open, start a new one
        realtmux
    else
        # else, do useful things
        local num_sess
        num_sess=`echo $sessions | wc -l`
        if [[ -z $TMUX ]]; then # not in tmux already
            if [[ $num_sess -gt 1 ]]; then
                realtmux a \; choose-session
            else
                # sessions == 1
                realtmux a
            fi
        elif [[ $num_sess -gt 1 ]]; then # already in tmux, sessions > 1
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

function tkill() {
    [[ -n $TMUX ]] && exit
    tmux ls | awk '{print $1}' | sed 's/:.*$//' | xargs -I{} tmux kill-session -t {}
}

alias tl='tmux ls'
alias detach='tmux detach'
alias tconf="vi ~/.tmux.conf"

function tpp() {
  [[ -z $TMUX ]] && echo 'Not in tmux!' && return
  realtmux capture-pane -pe | fpp
}

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
    venvwrapper
    workon ${VIRTUAL_ENV:t}
fi

# modified from http://unix.stackexchange.com/questions/13464
function _upsearch() {
    local curdir
    curdir="$PWD"
    while : ; do
        test -e "$curdir/$1" && echo "$curdir/$1" && return
        [[ "$curdir" == "/" ]] && return
        curdir=`dirname "$curdir"`
    done
}
alias upsearch=_upsearch

function _dmake() { # django
    local django
    django=`upsearch manage.py`
    if [[ -z "$django" ]]; then
        echo "Couldn't find manage.py" && return
    else
        python -W ignore "$django" $*
    fi
}
alias dmake=_dmake # django

# ruby
#------------------------------------------------------------------------------
function _loadrvm() {
    echo 'Loading RVM. Run command again to use it.'
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
}
alias rvm=_loadrvm

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# node
#------------------------------------------------------------------------------
if which nvm > /dev/null; then
  export NVM_DIR=~/.nvm
  source $(brew --prefix nvm)/nvm.sh
fi

# alias for rm (requires trash script)
#------------------------------------------------------------------------------
alias realrm='/bin/rm'
alias rm='trash'

# git
#------------------------------------------------------------------------------
alias g='git'
alias rgit='/usr/local/bin/git'

# # capture output of last git command from Facebook Path Picker
# export git_capture=''
# function capturegit() {
#     rgit $* | read -d EOF git_capture
#     echo $git_capture
# }
# alias git=capturegit
# alias gpp='echo $git_capture | fpp'

# go to root of git directory
function groot() {
cd "$(rgit rev-parse --show-toplevel)"
}
alias gr=groot

# other
#------------------------------------------------------------------------------
# fall back to use built in cd
function cs() {
builtin cd $*
}

# go to temp dir
alias temp="cs $HOME/temp"

###############################################################################
# Special Settings
###############################################################################
# Mac OSX
if [[ "$OSTYPE" == darwin* && -f "$HOME/.osx_zshrc" ]]; then
  source "$HOME/.osx_zshrc";
fi

# Temporary
if [[ -f "$HOME/.tmp_zshrc" ]]; then
  source "$HOME/.tmp_zshrc";
fi

# Secret!
if [[ -f "$HOME/.secret_zshrc" ]]; then
  source "$HOME/.secret_zshrc";
fi

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
# Better CD
###############################################################################
# override cd to do ls and vi when necessary
function _better_cd() {
set -- ${1//,/.} # replace commas (,) with periods (.)
if [[ -f $1 ]]; then
  local fdir
  fdir=`dirname $1`
  if [[ -d $fdir ]]; then
    builtin cd "$fdir" && ls
  fi
  vim `basename $1` ${*:2}
else
  builtin cd $* && ls
fi
}
alias cd=_better_cd

# disable autocorrect suggestions for commands
unsetopt CORRECT

# pass bad match to command
setopt NO_NOMATCH

###############################################################################
# sport
###############################################################################
function sport() {
lsof -i :$1
}

###############################################################################
# vim fzf
###############################################################################
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_COMPLETION_TRIGGER='jk'
