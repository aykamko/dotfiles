# vim: set ft=zsh:

if (( $+commands[rbenv] )); then
  rbenv() { unset -f rbenv && eval "$(rbenv init -)" && rbenv "$@"; }
fi

if (( $+commands[nodenv] )); then
  nodenv() { unset -f nodenv && eval "$(nodenv init -)" && nodenv "$@"; }
fi

if (( $+commands[pyenv] )); then
  pyenv() {
    unset -f pyenv
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    pyenv "$@"
  }
fi

# direnv
if (( $+commands[direnv] )); then
  eval "$(direnv hook zsh)"
fi

# context from root of git directory
gr() {
  local root=$(command git rev-parse --show-toplevel 2> /dev/null)
  [[ $? == 0 ]] && cd $root || cd "$@"
}
alias '$'=gr

if (( $+commands[tag] )); then
  export TAG_SEARCH_PROG=rg
  tag() { command tag "$@" && source ${TAG_ALIAS_FILE:-/tmp/tag_aliases} 2>/dev/null }
  alias ag=tag

  if [[ $TAG_SEARCH_PROG == 'rg' ]]; then
    agg() {
      rg --files -g "*$1*"
    }
  fi
fi

if (( $+commands[mise] && ! $+functions[_mise_hook] )); then
  eval "$(mise activate zsh)"
fi

# Make sure docker doesn't build arm64 images
export DOCKER_DEFAULT_PLATFORM=linux/amd64

# uv (Python)
[[ -f "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"
alias uvr="uv run --no-project"
