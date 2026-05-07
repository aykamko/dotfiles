#!/usr/bin/env bash
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Helpers ──────────────────────────────────────────────────────────

clean_dead_symlinks() {
    for dir in "$@"; do
        dir="${dir/#\~/$HOME}"
        [ -d "$dir" ] || continue
        find "$dir" -maxdepth 1 -type l ! -exec test -e {} \; -print -delete 2>/dev/null || true
    done
}

mklink() {
    local target="$1" link="${2/#\~/$HOME}"
    mkdir -p "$(dirname "$link")"
    ln -sfn "$target" "$link"
}

is_darwin() { [ "$(uname)" = "Darwin" ]; }
is_linux()  { [ "$(uname)" = "Linux" ]; }

confirm() {
    if [ "${YES:-}" = 1 ]; then return 0; fi
    local prompt="$1" default="${2:-true}"
    if [ "$default" = true ]; then
        read -rp "$prompt [Y/n] " reply
        [[ -z "$reply" || "$reply" =~ ^[Yy] ]]
    else
        read -rp "$prompt [y/N] " reply
        [[ "$reply" =~ ^[Yy] ]]
    fi
}

# ── Clean dead symlinks in ~ ────────────────────────────────────────

echo "Cleaning dead symlinks..."
clean_dead_symlinks ~ ~/.*

# ── Update git submodules ───────────────────────────────────────────

echo "Updating git submodules..."
cd "$DOTFILES"
git submodule update --init --recursive

# ── zsh ─────────────────────────────────────────────────────────────

echo "Setting up zsh..."

mklink "$DOTFILES/zsh/zshenv"    ~/.zshenv
mklink "$DOTFILES/zsh/zshrc"     ~/.zshrc
mklink "$DOTFILES/zsh/zprofile"  ~/.zprofile
mklink "$DOTFILES/zsh/zlogin"    ~/.zlogin

# ── neovim ────────────────────────────────────────────────────

echo "Setting up neovim..."

if ! hash nvim 2>/dev/null; then
    if is_darwin; then
        brew install neovim
    elif is_linux && hash apt-get 2>/dev/null; then
        sudo apt-get install -y neovim
    else
        echo "Skipping Neovim install: no supported package manager found."
    fi
fi

NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:=$HOME/.config}/nvim"
if [[ -L "$NVIM_CONFIG_DIR" ]]; then
    # remove old ~/.vim symlink
    rm "$NVIM_CONFIG_DIR"
fi

mkdir -p "${XDG_CONFIG_HOME:=$HOME/.config}/nvim"
mklink "$DOTFILES/nvim/init.lua" "$XDG_CONFIG_HOME/nvim/init.lua"

# ── git ─────────────────────────────────────────────────────────────

echo "Setting up git..."

mklink "$DOTFILES/git/gitconfig"        ~/.gitconfig
mklink "$DOTFILES/git/gitconfig.user"   ~/.gitconfig.user
mklink "$DOTFILES/git/gitignore_global" ~/.gitignore_global
mklink "$DOTFILES/git/git_template"     ~/.git_template

if is_darwin; then
    mklink "$DOTFILES/git/gitconfig.os.darwin" ~/.gitconfig.os
elif is_linux; then
    mklink "$DOTFILES/git/gitconfig.os.linux" ~/.gitconfig.os
fi

# ── fzf ─────────────────────────────────────────────────────────────

if [ ! -d "$HOME/.fzf" ]; then
    echo "Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --all --no-update-rc
fi

# ── eternal terminal ────────────────────────────────────────────────

if is_linux && hash apt-get 2>/dev/null && ! hash etserver 2>/dev/null; then
    if confirm "Install Eternal Terminal (et)?"; then
        sudo apt-get install -y software-properties-common
        sudo add-apt-repository -y ppa:jgmath2000/et
        sudo apt-get update
        sudo apt-get install -y et
    fi
fi

# ── tmux ────────────────────────────────────────────────────────────

echo "Setting up tmux..."
mklink "$DOTFILES/tmux/tmux.conf" ~/.tmux.conf

# ── direnv ──────────────────────────────────────────────────────────

echo "Setting up direnv..."
mklink "$DOTFILES/direnv/direnvrc" ~/.config/direnv/direnvrc

# ── ghostty ─────────────────────────────────────────────────────────

echo "Setting up ghostty..."
mklink "$DOTFILES/ghostty/config" ~/.config/ghostty/config

if ! infocmp xterm-ghostty &>/dev/null; then
    echo "Installing ghostty terminfo..."
    tic -x "$DOTFILES/ghostty/xterm-ghostty.terminfo"
fi

# ── claude code ─────────────────────────────────────────────────────

echo "Setting up claude code..."
mklink "$DOTFILES/claude/settings.json"        ~/.claude/settings.json
mklink "$DOTFILES/claude/statusline-command.sh" ~/.claude/statusline-command.sh
mkdir -p ~/.claude/hooks
mklink "$DOTFILES/claude/notify.sh"            ~/.claude/hooks/notify.sh

# ── macOS ───────────────────────────────────────────────────────────

if is_darwin; then
    echo "Applying macOS settings..."
    defaults write com.apple.dock no-bouncing -bool True
    killall Dock
fi

echo "Done!"
