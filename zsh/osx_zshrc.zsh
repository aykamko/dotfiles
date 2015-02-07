# applescript for sexy new tmux session
function tnew() {
    if [[ -z $TMUX || ! -f "$HOME/dotfiles/applescript/iterm_tmux_new.scpt" ]]; then
        tmux new
        return 0
    fi
    touch $HOME/.notmux
    osascript $HOME/dotfiles/applescript/iterm_tmux_new.scpt
}

# copy to mac osx clipboard
function copy() {
    cat $1 | pbcopy
}

# core audio restart because apple tv sucks
alias fuckyouappletv='sudo killall coreaudiod'

# clean .DS_Store
function dsclean() {
    find . -name ".DS_Store" -exec /bin/rm -rf {} \;
}

# tab completion in school directory
cds() { cd $HOME/Documents/School/$1; }
compctl -f -W $HOME/Documents/School/ cds
