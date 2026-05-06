# vim: set ft=zsh:

# Color helpers used by k() below.
_ylw='\x1b[33m'
alias _clr='tput -Txterm sgr0'

# General k8s helpers
k() {
  echo "${_ylw}$(cat ~/.kube/config | grep --color=never '^current-context:.*')$(_clr)"
  kubectl "$@"
}
alias kctx='kubectl config use-context'
alias ktail='k logs --tail=100 -f'
alias ksys="k -n kube-system"
kall() {
  k "$@" --all-namespaces
}
kube-clear-evicted() {
  local namespace="--namespace=${1:-default}"
  kubectl $namespace delete pod $(kubectl $namespace get pods | grep Evicted | awk '{print $1}')
}

# Figma SSO-aware kubectl/k9s wrappers
_k8s() {
    kube_cmd="$1"
    shift

    unset AWS_VAULT
    k8s_env="$1"
    if [[ $1 = "dev" ]]; then
      k8s_env=devenv01
    fi
    shift

    aws_profile="$k8s_env-$1-admin"
    if [[ $1 = "admin" ]]; then
      aws_profile="$k8s_env-admin"
    fi
    shift

    k8s_context="eks-$k8s_env-us-west-2-core-$1"
    shift

    cmd=(access aws exec "$aws_profile" -- "$kube_cmd" --context "$k8s_context" "$@")

    >&2 printf "\n"
    >&2 echo "k8s_context: $k8s_context"
    >&2 echo "aws_profile: $aws_profile"
    >&2 echo "Command: ${cmd[*]}"
    >&2 printf "\n"

    "${cmd[@]}"
}
k8s() {
  _k8s kubectl "$@"
}
k9s() {
  _k8s k9s "$@"
}
alias kdev0="k8s dev admin 0"
alias kdev1="k8s dev admin 1"
alias kdev2="k8s dev admin 2"
