# vim: set ft=zsh:

# basics
alias ':q'=exit
alias c=clear

clr() {
  clear
  [[ -n $TMUX ]] && tmux clear-history
}
stripansi() {
  [[ $UNAME == darwin ]] && \
    sed -E "s/"$'\E'"\[([0-9]{1,2}(;[0-9]{1,2})*)?m//g" ||
    sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})*)?m//g"
}

alias vimrc='vim ~/.vimrc'

# zsh
alias zshso='source ~/.zshrc'
alias zshenv='vim ~/.zshenv'
alias zshrc='vim ~/.zshrc'
alias zprofile='vim ~/.zprofile'
alias zlogin='vim ~/.zlogin'
alias zlocal='vim ~/.zshrc.local'

# git
alias gitconfig='vim ~/.gitconfig'
alias gitignore_global='vim ~/.gitignore_global'
alias gs='git status'
alias g='git'

# tmux
alias t='tmux'
alias tl='tmux ls'
alias detach='tmux detach'
alias tmuxconf="vim ~/.tmux.conf"
alias tconf='tmuxconf'
alias tname='tmux rename-session'
if [[ -z $TMUX ]]; then
  tmux() { [[ -z "$@" ]] && command tmux new -A -s 0 || command tmux "$@" }
fi
alias tkill="killall tmux"

# python
alias ipy3=ipython3
alias ipy=ipython
alias py3=python3
alias py=python

# misc
alias tmp="cd $HOME/tmp"

# Builtin overrides
if (( $+commands[lsd] )); then
  # https://github.com/Peltoche/lsd
  alias ls=lsd
fi

# override cd to do ls and vim when necessary
better_cd() {
  set -- ${1//,/.} # replace commas , with periods . (Golang)
  if [[ -f $1 ]]; then
    local fdir=$(dirname $1)
    [[ -d $fdir ]] && builtin cd $fdir && ls && vim $(basename $1) ${*:2}
  else
    builtin cd "$@" && ls
  fi
}
alias cd=better_cd

# tab completion in dotfiles directory
dotfiles() { cd $DOTFILES/$1; }
compctl -f -W $DOTFILES/ dotfiles

# Vi mode cursor
function zle-keymap-select {
  case $KEYMAP in
    vicmd)      echo -ne '\e[2 q' ;;  # block cursor in normal mode
    viins|main) echo -ne '\e[6 q' ;;  # bar cursor in insert mode
  esac
}
zle -N zle-keymap-select

function zle-line-init {
  echo -ne '\e[6 q'  # bar cursor on each new prompt
}
zle -N zle-line-init

# Color test grid
function lscolors() {
  for i in {0..255}; do
    printf "\e[48;05;%dm%-10d\n" ${i} ${i}
  done | column -c 120 -s ''; echo -e "\e[m"
}

# man with colors via less
unalias man >/dev/null 2>&1
man() {
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;34m") \
    LESS_TERMCAP_md=$(printf "\e[1;34m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;37m") \
      /usr/bin/man "$@"
}

alias clawd="claude --dangerously-skip-permissions"

# eternal terminal via coder connect.
# usage: et-coder <workspace> [user]
# Requires Coder Connect to be running (the userspace VPN daemon makes the
# *.coder hostname directly TCP-reachable and auths SSH via your Coder session).
et-coder() {
  if [[ -z "$1" ]]; then
    echo "usage: et-coder <workspace> [user]" >&2
    return 1
  fi
  local ws="$1" user="${2:-ubuntu}"
  local host="devcontainer.$ws.akamko.coder"
  if ! coder connect exists "$host" 2>/dev/null; then
    echo "et-coder: Coder Connect isn't reachable for $host." >&2
    echo "  Start it via the Coder Desktop app, or 'coder connect run'." >&2
    return 1
  fi
  command et "$user@$host"
}
