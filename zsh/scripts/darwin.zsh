# vim: set ft=zsh:
[[ $UNAME != darwin ]] && return

# alias for rm (requires trash script)
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
    git_display="${light_blue}(${reset}${yellow}${branch}${reset}${light_blue})${reset}"
  fi
  echo "${git_display}"
}

setopt PROMPT_SUBST
export PS1='%F{200}macbook%f%b %F{blue}%~%f $(__git_statusline) %F{green}%#%f '
