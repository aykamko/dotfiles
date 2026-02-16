#!/bin/bash

# Read JSON input
input=$(cat)

# Extract values
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
session_name=$(echo "$input" | jq -r '.session_name // empty')
output_style=$(echo "$input" | jq -r '.output_style.name // empty')
vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

# Colors (using ANSI codes)
c1='36'  # cyan
c2='34'  # blue
c3='35'  # magenta
c4='31'  # red
c5='33'  # yellow
c6='32'  # green

# Get shortened path (last 3 components, replace home with ~)
short_path="${cwd/#$HOME/~}"
IFS='/' read -ra path_parts <<< "$short_path"
if [[ ${#path_parts[@]} -gt 3 ]]; then
    short_path=".../${path_parts[-3]}/${path_parts[-2]}/${path_parts[-1]}"
fi

# Build prompt components
prompt_parts=""

# Current directory in cyan
prompt_parts="$(printf "\033[${c1}m%s\033[0m" "$short_path")"

# Git info (if in git repo)
if git --no-optional-locks rev-parse --git-dir > /dev/null 2>&1; then
    git_branch=$(git --no-optional-locks symbolic-ref --short HEAD 2>/dev/null || git --no-optional-locks rev-parse --short HEAD 2>/dev/null)

    # Check for changes
    git_status=""
    if ! git --no-optional-locks diff --quiet 2>/dev/null; then
        git_status="$(printf "\033[${c5}m●\033[0m")"  # yellow dot for unstaged
    fi
    if ! git --no-optional-locks diff --cached --quiet 2>/dev/null; then
        git_status="$(printf "\033[${c6}m●\033[0m")"  # green dot for staged
    fi

    # Check ahead/behind
    ahead_behind=""
    upstream=$(git --no-optional-locks rev-parse --abbrev-ref @{upstream} 2>/dev/null)
    if [[ -n "$upstream" ]]; then
        ahead=$(git --no-optional-locks rev-list --count HEAD..@{upstream} 2>/dev/null || echo "0")
        behind=$(git --no-optional-locks rev-list --count @{upstream}..HEAD 2>/dev/null || echo "0")
        if [[ "$behind" != "0" || "$ahead" != "0" ]]; then
            ahead_behind="$(printf "\033[${c2}m{\033[0m")"
            [[ "$behind" != "0" ]] && ahead_behind+="$(printf "\033[${c5}m+%s\033[0m" "$behind")"
            [[ "$behind" != "0" && "$ahead" != "0" ]] && ahead_behind+="$(printf "\033[${c2}m,\033[0m")"
            [[ "$ahead" != "0" ]] && ahead_behind+="$(printf "\033[${c5}m-%s\033[0m" "$ahead")"
            ahead_behind+="$(printf "\033[${c2}m}\033[0m")"
        fi
    fi

    prompt_parts+=" $(printf "\033[${c2}m(\033[${c4}m%s\033[0m%s%s\033[${c2}m)\033[0m" "$git_branch" "$git_status" "$ahead_behind")"
fi

# Vim mode indicator
if [[ -n "$vim_mode" ]]; then
    if [[ "$vim_mode" == "NORMAL" ]]; then
        prompt_parts+=" $(printf "\033[${c3}m✱\033[0m")"
    else
        prompt_parts+=" ❯"
    fi
else
    prompt_parts+=" ❯"
fi

# Add session name if present
if [[ -n "$session_name" ]]; then
    prompt_parts+=" $(printf "\033[${c2}m[\033[0m%s\033[${c2}m]\033[0m" "$session_name")"
fi

# Add output style if not default
if [[ -n "$output_style" && "$output_style" != "default" ]]; then
    prompt_parts+=" $(printf "\033[${c6}m%s\033[0m" "$output_style")"
fi

# Add context remaining percentage if available
if [[ -n "$remaining" ]]; then
    remaining_int=$(printf "%.0f" "$remaining")
    prompt_parts+=" $(printf "\033[${c5}m%s%%\033[0m" "$remaining_int")"
fi

echo -e "$prompt_parts"
