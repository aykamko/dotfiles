# vim: set ft=zsh:

if (( $+commands[nvim] )); then
  alias vim=nvim
  alias vi=nvim
else
  alias vi=vim
fi

# only defined in neovim libvterm
if [[ -n $NVIM_LISTEN_ADDRESS ]]; then

  _nvr_up()    { nvr -c 'TmuxNavigateUp' }
  _nvr_right() { nvr -c 'TmuxNavigateRight' }
  _nvr_down()  { nvr -c 'TmuxNavigateDown' }
  _nvr_left()  { nvr -c 'TmuxNavigateLeft' }
  zle -N nvr_up _nvr_up
  zle -N nvr_right _nvr_right
  zle -N nvr_down _nvr_down
  zle -N nvr_left _nvr_left
  bindkey '^K' nvr_up
  bindkey '^L' nvr_right
  bindkey '^J' nvr_down
  bindkey '^H' nvr_left

  sp () { nvr -o $@ }
  vsp () { nvr -O $@ }
  ds() { nvr -c "DirectionalSplit $@" }

  alias nvim=nvr
  alias vim=nvr
  alias vi=nvr
  export EDITOR=nvr

  command_not_found_handler() {
    if [[ "$@" =~ ^: ]]; then
      nvr --remote-send "<C-\\><C-n>${@}<CR>"
    else
      return 127
    fi
  }
fi
