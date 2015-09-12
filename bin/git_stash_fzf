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
