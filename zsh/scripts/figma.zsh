# vim: set ft=zsh:

export RACK_ENV=development
export AWS_CONFIG_FILE="$HOME/figma/figma/config/aws/sso_config"

function tf() {
    # Example usage: tf ml plan
    unset AWS_VAULT

    if [[ $1 = "prod" || $1 = "production" ]]; then
        tf_workspace=production
        aws_vault_profile=prod-admin
    elif [[ $1 = "staging" ]]; then
        tf_workspace=staging
        aws_vault_profile=staging-admin
    elif [[ $1 = "gov" ]]; then
	      tf_workspace=gov
	      aws_vault_profile=gov-admin
    elif [[ $1 = "ml" ]]; then
        tf_workspace=ml
        aws_vault_profile=ml-admin
    elif [[ $1 = "ml_production" ]]; then
        tf_workspace=ml_production
        aws_vault_profile=ml-production-admin
    else
        tf_workspace=$1
        aws_vault_profile=dev-admin
    fi
    shift

    echo "\n"
    echo "AWS_VAULT profile:   $aws_vault_profile"
    echo "Terraform workspace: $tf_workspace"
    echo "Command:             TF_WORKSPACE=$tf_workspace access aws exec $aws_vault_profile -- terraform $@"
    echo "\n"

    TF_WORKSPACE=$tf_workspace access aws exec $aws_vault_profile -- terraform $@
}

if [[ -f "$HOME/figma/figma/bin/coder-helpers/zshrc" ]]; then
  source "$HOME/figma/figma/bin/coder-helpers/zshrc"
fi

# ── Lazy, idempotent figma fetch-refspec pinning ─────────────────────
# Piggybacks on `git fetch`/`git pull`: the first time you fetch in a figma
# repo that still has the clone-written `+refs/heads/*` catch-all, this applies
# `git figma-pin` (pins fetch refspecs + --no-tags) so this fetch and every
# later one stays lean. Once pinned it bails after a single `git config` read,
# so it's effectively free thereafter. Wraps interactive use only; scripts and
# git's own aliases shell out to the real `git` and are unaffected.
_figma_autopin() {
  # Bail unless the catch-all refspec is still present (i.e. not yet pinned).
  command git config --get-all remote.origin.fetch 2>/dev/null \
    | grep -q ':refs/remotes/origin/\*$' || return 0
  case "$(command git config --get remote.origin.url 2>/dev/null)" in
    *figma/*)
      command git figma-pin >/dev/null 2>&1 \
        && print -P "%F{244}[figma] pinned fetch refspecs for faster fetches%f"
      ;;
  esac
}

git() {
  case "$1" in
    fetch|pull|pl) _figma_autopin ;;
  esac
  command git "$@"
}

cssh() {
  local workspace="${1:?usage: cssh <workspace>}"
  local target="devcontainer.${workspace}.akamko"
  while true; do
    coder ssh -A "$target"
    local rc=$?
    if [[ $rc -eq 0 ]]; then
      return 0
    fi
    echo "coder ssh exited with $rc, retrying in 3s..."
    sleep 3
  done
}

alias judgebench='bazel run //ml/py/figma/processing/judge_bench:cli -- '

# Coder workspace prompt
if [[ -n $CODER_WORKSPACE_NAME ]]; then
  _coder_emoji=""
  _coder_color="magenta"
  [[ $CODER_WORKSPACE_NAME == *green* ]]  && _coder_emoji=" 💚" && _coder_color="green"
  [[ $CODER_WORKSPACE_NAME == *blue* ]]   && _coder_emoji=" 💙" && _coder_color="blue"
  [[ $CODER_WORKSPACE_NAME == *purple* ]] && _coder_emoji=" 💜" && _coder_color="135"
  [[ $CODER_WORKSPACE_NAME == *orange* ]] && _coder_emoji=" 🧡" && _coder_color="208"
  [[ $CODER_WORKSPACE_NAME == *cyan* ]]   && _coder_emoji=" 🩵" && _coder_color="cyan"
  export PS1='%F{'"${_coder_color}"'}devcontainer.$CODER_WORKSPACE_NAME'"${_coder_emoji}"'%f%b %F{blue}%~%f $(__dx_git_zsh) %F{green}%#%f '
  unset _coder_emoji _coder_color
  if [[ -f ~/.terminfo/x/xterm-ghostty ]]; then
    export TERM=xterm-ghostty
  fi
fi
