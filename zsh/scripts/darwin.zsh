# vim: set ft=zsh:
[[ $UNAME != darwin ]] && return

# alias rm to macos-trash (brew; PATH set in zprofile). macOS ships its own
# /usr/bin/trash, so this guard always passes -- PATH order decides which one
# wins, and we want the brew one because Apple's breaks Finder's "Put Back".
if (( $+commands[trash] )); then
    alias rm=trash
fi

# copy to mac osx clipboard
copy() { cat $1 | pbcopy }

# clean .DS_Store
dsclean() { find . -name ".DS_Store" -exec /bin/rm -rf {} \; }

__git_statusline() {
  local reset='%f%b'
  local light_blue='%F{cyan}'
  local yellow='%F{yellow}'
  local git_display=""
  local branch
  branch=$(git --no-optional-locks branch --show-current 2>/dev/null)
  if [[ -n "$branch" ]]; then
    git_display="${light_blue}(${reset}${yellow}${branch}${reset}${light_blue})${reset} "
  fi
  echo "${git_display}"
}

setopt PROMPT_SUBST
export PS1='%F{200}macbook%f%b %F{blue}%~%f $(__git_statusline)%F{green}%#%f '
