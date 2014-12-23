PROMPT='%{$fg_bold[green]%}%p%{$fg[cyan]%}%3c$(git_prompt_info)$(git_remote_status) 🐼  %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[blue]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[blue]%})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}x%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_REMOTE_PREFIX="%{$fg_bold[blue]%}{%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_REMOTE_SUFFIX="%{$fg[blue]%}}%{$reset_color%}"

# gets number of commits ahead/behind remote master
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
    if [[ ! -z "$REV_PROMPT" ]]; then
        echo "$ZSH_THEME_GIT_PROMPT_REMOTE_PREFIX$REV_PROMPT$ZSH_THEME_GIT_PROMPT_REMOTE_SUFFIX"
    fi
}

