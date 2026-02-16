#!/usr/bin/env bash
# Usage: notify.sh "title" "message"
title="${1:-Notification}"
message="${2:-}"

if [ "$(uname)" = "Darwin" ]; then
    osascript -e "display notification \"$message\" with title \"$title\""
else
    # OSC 9 desktop notification — travels through SSH to local terminal (e.g. Ghostty)
    printf '\e]9;%s: %s\e\\' "$title" "$message"
fi
