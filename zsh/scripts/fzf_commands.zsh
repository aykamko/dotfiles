# From: https://github.com/junegunn/fzf/wiki/Examples
# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-*} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf-tmux +m) &&
  cd "$dir"
}

# From: https://github.com/junegunn/fzf/wiki/Examples
# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local file k
  out=$(fzf-tmux --query="$1" --select-1 --exit-0 \
    --expect=ctrl-d)
  k=$(head -1 <<< "$out")
  file=$(tail -1 <<< "$out")
  if [ -n "$file" ]; then
    if [ "$k" = 'ctrl-d' ]; then
      cd $(dirname "$file")
    else
      ${EDITOR:-vim} "$file"
    fi
  fi
}

# From: https://github.com/junegunn/fzf/wiki/Examples
# chrome - browse chrome history
chrome() {
  local cols sep
  cols=$(( COLUMNS / 3 ))
  sep='{{::}}'

  # Copy History DB to circumvent the lock
  # - See http://stackoverflow.com/questions/8936878 for the file path
  yes | cp -f ~/Library/Application\ Support/Google/Chrome/Default/History /tmp/h

  sqlite3 -separator $sep /tmp/h \
    "select substr(title, 1, $cols), url
     from urls order by last_visit_time desc" |
  awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\n", $1, $2}' |
  fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs open
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
  local files
  files=$(grep '^>' ~/.viminfo | cut -c3- |
          while read line; do
            [ -f "${line/\~/$HOME}" ] && echo "$line"
          done | fzf-tmux -d -m -q "$*" -1 \
            --expect=ctrl-d)
  if [ -n "$files" ]; then
    if [ "$k" = 'ctrl-d' ]; then
      cd $(dirname "$files")
    else
      vim ${files//\~/$HOME}
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
