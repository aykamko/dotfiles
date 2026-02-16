#!/usr/bin/env bash
# curl -fsSL https://raw.githubusercontent.com/aykamko/dotfiles/refs/heads/master/bootstrap.sh | bash
set -e

DOTFILES_DIR="$HOME/dotfiles"
DOTFILES_REPO="https://github.com/aykamko/dotfiles.git"

if [ -d "$DOTFILES_DIR" ]; then
    echo "Updating dotfiles..."
    if ! git -C "$DOTFILES_DIR" diff --quiet 2>/dev/null; then
        echo "Error: unstaged changes in $DOTFILES_DIR. Commit or stash them first." >&2
        exit 1
    fi
    git -C "$DOTFILES_DIR" pull --rebase
else
    echo "Cloning dotfiles..."
    git clone --recurse-submodules "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

# Use /dev/tty for stdin so interactive prompts work when piped from curl
exec "$DOTFILES_DIR/install.sh" </dev/tty
