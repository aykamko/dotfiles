#!/usr/bin/env bash
# Usage: notify.sh "title" "message"
title="${1:-Notification}"
message="${2:-}"

# OSC 9 desktop notification — works locally and over SSH (e.g. Ghostty)
printf '\e]9;%s: %s\e\\' "$title" "$message" > /dev/tty
