#
# A cool theme, yo.
#
# Authors:
#   Aleks Kamko <aykamko@gmail.com>
#
#

_primary_color='cyan'
_secondary_color='blue'

function +vi-git_remote {
    local left_right
    local -a remote_info
    set -- $(command git rev-list --left-right --count @\{u\}.. 2> /dev/null)

    # $1 is behind, $2 is forward
    if [[ -n $2 && $2 != 0 ]]; then
        remote_info+=("+$2")
        left_right=true
    fi
    if [[ -n $1 && $1 != 0 ]]; then
        (( $left_right )) && remote_info+=(", ")
        remote_info+=("-$1")
    fi
    [[ -n $remote_info ]] && hook_com[misc]="%F{$_secondary_color}{%f%F{yellow}$remote_info%f%F{$_secondary_color}}%f"
}

function prompt_ayk_precmd {
    vcs_info
}

function prompt_ayk_setup {
    setopt LOCAL_OPTIONS
    unsetopt XTRACE KSH_ARRAYS
    prompt_opts=(cr percent subst)

    # Load required functions.
    autoload -Uz add-zsh-hook
    autoload -Uz vcs_info

    # Add hook for calling vcs_info before each command.
    add-zsh-hook precmd prompt_ayk_precmd

    echo $hook_com[misc]
    
    # Set vcs_info parameters.
    zstyle ':vcs_info:*' enable git hg svn
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '%F{yellow}●%f'
    zstyle ':vcs_info:*' unstagedstr '%F{green}●%f'
    zstyle ':vcs_info:git*' formats ' %F{$_secondary_color}(%f%F{red}%b%f%c%u%F{$_secondary_color})%f%m'
    zstyle ':vcs_info:git*' actionformats ' %F{$_secondary_color}(%f%F{red}%b%f%c%u|%F{cyan}%a%f%F{$_secondary_color})%f%m'
    zstyle ':vcs_info:*' formats ' %F{$_secondary_color}(%f%F{red}%b%f%c%u%F{$_secondary_color})%f'
    zstyle ':vcs_info:*' actionformats ' %F{$_secondary_color}(%f%F{red}%b%f%c%u|%F{cyan}%a%f%F{$_secondary_color})%f'
    zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b|%F{cyan}%r%f'
    zstyle ':vcs_info:git*+set-message:*' hooks git_remote

    # Define prompts.
    PROMPT='%F{$_primary_color}%3~%f${vcs_info_msg_0_} 🐼  '
    RPROMPT=''
}

prompt_ayk_setup "$@"
