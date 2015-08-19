if [ ! -d $HOME/dotfiles ]; then
    echo "dotfiles directory not found in $HOME" && exit 1
fi
dotfiles="$HOME/dotfiles"

# git
for f in `find $dotfiles/git -not -path '*/\.*' -type f -depth 1`; do
    ln -s "$f" "$HOME/.`basename $f`"
done

# vim
ln -s "$dotfiles/vimrc" "$HOME/.vimrc"
if [ ! -d $HOME/.vim ]; then
    mkdir "$HOME/.vim"
fi
ln -s $dotfiles/vim/* "$HOME/.vim"

# tmux
ln -s "$dotfiles/tmux.conf" "$HOME/.tmux.conf"

# zsh/prezto
if [ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]; then
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    for rcfile in `find "${ZDOTDIR:-$HOME}"/.zprezto/runcoms -not -path '*\.md' -type f`; do
        if [ -f $dotfiles/zsh/`basename $rcfile` ]; then continue; fi
        ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.`basename $rcfile`"
    done
fi
for f in `find $dotfiles/zsh -not -path '*/\.*' -type f -depth 1`; do
    ln -s "$f" "$HOME/.`basename $f`"
done
for f in `find $dotfiles/zsh/zprezto -not -path '*/\.*' -type f`; do
    ln -s "$f" "$HOME/.zprezto/${f##*zprezto/}"
done

# osx
if [ `uname` = 'Darwin' ]; then
    # zsh
    for f in `find $dotfiles/zsh/osx -not -path '*/\.*' -type f -depth 1`; do
        ln -s "$f" "$HOME/.`basename $f`"
    done
fi

if [[ "$SHELL" =~ '.*zsh' ]]; then
    chsh -s /bin/zsh
fi

unset dotfiles
