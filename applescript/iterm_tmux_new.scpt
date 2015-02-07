tell application "iTerm"
    tell the current terminal
        launch session "Default Session"
        tell the last session
            write text "/bin/rm -f ~/.notmux; tmux new"
        end tell
    end tell
end tell
