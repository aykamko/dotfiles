#!/usr/bin/env bash
# Usage: notify.sh "title" "message"
title="${1:-Notification}"
message="${2:-}"

# Log for debugging
echo "$(date): $title - $message" >> /tmp/claude-notify.log

# Find the real TTY — hook stdout may be piped back to Claude Code,
# so we need to write the escape sequence directly to the terminal.
tty_dev=""
# Walk up the process tree to find a parent with a real TTY
pid=$$
while [ "$pid" -gt 1 ]; do
    t=$(ps -o tty= -p "$pid" 2>/dev/null | tr -d ' ')
    if [ -n "$t" ] && [ "$t" != "?" ]; then
        tty_dev="/dev/$t"
        break
    fi
    pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
done

# OSC 9 desktop notification — works locally and over SSH (e.g. Ghostty)
if [ -n "$tty_dev" ] && [ -w "$tty_dev" ]; then
    printf '\e]9;%s: %s\e\\' "$title" "$message" > "$tty_dev"
    echo "$(date): wrote to $tty_dev" >> /tmp/claude-notify.log
else
    # Fallback to stdout (works when TUI is rendering, e.g. permission prompts)
    printf '\e]9;%s: %s\e\\' "$title" "$message"
    echo "$(date): fallback to stdout (no tty found)" >> /tmp/claude-notify.log
fi
