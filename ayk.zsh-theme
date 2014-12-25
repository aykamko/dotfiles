# Git: gets number of commits ahead/behind remote master
function git_remote_status() {
    local REV_PROMPT
    set -- $(command git rev-list --left-right --count @{u}.. 2> /dev/null)

    # $1 is behind, $2 is forward
    if [[ -n $2 && $2 != 0 ]]; then
        if [[ -n $1 && $1 != 0 ]]; then
            REV_PROMPT="+$2, -$1"
        else
            REV_PROMPT="+$2"
        fi
    elif [[ -n $1 && $1 != 0 ]]; then
        REV_PROMPT="+$1"
    fi
    if [[ ! -z ${REV_PROMPT} ]]; then
        echo -n "$ZSH_THEME_GIT_PROMPT_REMOTE_PREFIX$REV_PROMPT$ZSH_THEME_GIT_PROMPT_REMOTE_SUFFIX"
    fi
}

# Virtualenv: current working virtualenv
# export VIRTUAL_ENV_DISABLE_PROMPT=yes
function virtualenv_prompt_info {
    if [[ -n ${VIRTUAL_ENV} ]]; then
        echo -n "${ZSH_THEME_VENV_PREFIX}${VIRTUAL_ENV:t}$ZSH_THEME_VENV_SUFFIX"
    fi
}

# built prompt extras
function prompt_extra {
    local extra
    extra=""
    extra+="$(virtualenv_prompt_info)"
    extra+="$(git_prompt_info)"
    extra+="$(git_remote_status)"
    if [[ -n ${extra} ]]; then
        echo " ${extra}"
    fi
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[blue]%})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}x%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_REMOTE_PREFIX="%{$fg_bold[blue]%}{%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_REMOTE_SUFFIX="%{$fg[blue]%}}%{$reset_color%}"
ZSH_THEME_VENV_PREFIX="%{$fg_bold[blue]%}[%{$fg[white]%}"
ZSH_THEME_VENV_SUFFIX="%{$fg[blue]%}]%{$reset_color%}"

PROMPT='%{$fg[cyan]%}%3c%{$reset_color%}$(prompt_extra) 🐼  '
