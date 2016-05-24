fd() {
  local root fzfcmd filter out dir
  root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ $? -eq 0 ]]; then
    filter="--delimiter='$root/' --with-nth=2 --header='Searching from: $root/'"
  else
    root=$PWD
  fi
  fzfcmd="fzf-tmux $filter --query='$1' --select-1 --exit-0"
  out=$(find -L $root -type d -not -path '*\.*' | eval $fzfcmd)
  key=$(head -1 <<< "$out")
  dir=$(tail -1 <<< "$out")
  [[ -n $dir ]] && cd $dir
}

fe() {
  local root fzfcmd filter out file key
  root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ $? -eq 0 ]]; then
    filter="--delimiter='$root/' --with-nth=2 --header='Searching from: $root/'"
  else
    root=$PWD
  fi
  fzfcmd="fzf-tmux $filter --query='$1' --select-1 --exit-0 --expect=ctrl-d,f1"
  out=$(ag --nocolor --hidden --ignore-dir=.git -g '' $root | eval $fzfcmd)
  key=$(head -1 <<< "$out")
  file=$(tail -1 <<< "$out")
  if [[ -n "$file" ]]; then
    if [[ "$key" = 'ctrl-d' || "$key" = 'f1' ]]; then
      cd $(dirname "$file")
    else
      ${EDITOR:-vim} "$file"
    fi
  fi
}

# From: https://github.com/junegunn/fzf/wiki/Examples
# fstash - easier way to deal with stashes
# type fstash to get a list of your stashes
# enter shows you the contents of the stash
# ctrl-d shows a diff of the stash against your current HEAD
# ctrl-b checks the stash out as a branch, for easier merging
# ctrl-y applies the stash
fstash() {
  local out q k sha
    while out=$(
      git stash list --pretty="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs" |
      fzf-tmux --ansi --no-sort --query="$q" --print-query \
          --expect=ctrl-d,ctrl-b,ctrl-y);
    do
      q=$(head -1 <<< "$out")
      k=$(head -2 <<< "$out" | tail -1)
      sha=$(tail -1 <<< "$out" | cut -d' ' -f1)
      [ -z "$sha" ] && continue
      if [ "$k" = 'ctrl-d' ]; then
        git diff $sha
      elif [ "$k" = 'ctrl-b' ]; then
        git stash branch "stash-$sha" $sha
        break;
      elif [ "$k" = 'ctrl-y' ]; then
        git stash apply $sha
        break;
      else
        git stash show -p $sha
      fi
    done
}

# swiftly deal with lsof
# ctrl-d show the ps output
# ctrl-k runs `kill -9`
fport() {
  local out k pid cmd
  out=$(
    lsof -i :$1 | tail -n +2 |
    fzf-tmux --no-sort --exit-0 --expect=ctrl-d,ctrl-z
  )
  key=$(head -1 <<< "$out")
  pid=$(tail -1 <<< "$out" | awk '{print $2}')
  if [ -n "$pid" ]; then
    if [ "$key" = 'ctrl-d' ]; then
      cmd="ps -v $pid"
    elif [ "$key" = 'ctrl-z' ]; then
      cmd="kill -9 $pid"
    else
      cmd="kill $pid"
    fi
    echo "> $cmd"
    eval $cmd
  else
    echo "No PID for :$1 found."
  fi
}

# From: https://github.com/junegunn/fzf/wiki/Examples
# v - open files in ~/.viminfo
v() {
  local infiles out key files
  if hash nvim 2>/dev/null; then
    if [ ! -f ~/.nvim.shada ]; then echo "No shada found at ~/.nvim.shada" && return 1; fi
    command nvim --cmd 'rsh ~/.nvim.shada | for f in v:oldfiles | echo f | endfor | quit' \
      2>!~/.nvim.history
    infiles=$(cat ~/.nvim.history | grep '^/' | tr -cd '[:print:]\n')
  else
    infiles=$(grep '^>' ~/.viminfo | cut -c3- |
          while read line; do
            [ -f "${line/\~/$HOME}" ] && echo "$line"
          done)
  fi
  out=$(echo $infiles | fzf-tmux -d -q "$*" -1 --expect=ctrl-d,f1)
  key=$(head -1 <<< "$out")
  file=$(tail -1 <<< "$out")
  if [[ -n "$file" ]]; then
    if [[ "$key" == 'ctrl-d' || "$key" == 'f1' ]]; then
      cd $(dirname "$file")
    else
      ${EDITOR:-vim} "$file"
    fi
  fi
}

# From: https://github.com/junegunn/fzf/wiki/Examples
unalias z
z() {
  if [[ -z "$*" ]]; then
    cd "$(_z -l 2>&1 | fzf +s --tac | sed 's/^[0-9,.]* *//')"
  else
    _last_z_args="$@"
    _z "$@"
  fi
}

zz() {
  cd "$(_z -l 2>&1 | sed 's/^[0-9,.]* *//' | fzf -q $_last_z_args)"
}
