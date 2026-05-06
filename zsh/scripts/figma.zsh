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
  export PS1='%F{'"${_coder_color}"'}devcontainer.$CODER_WORKSPACE_NAME'"${_coder_emoji}"'%f%b %F{blue}%~%f $(__dx_git_zsh) %F{green}%#%f '
  unset _coder_emoji _coder_color
  if [[ -f ~/.terminfo/x/xterm-ghostty ]]; then
    export TERM=xterm-ghostty
  fi
fi
