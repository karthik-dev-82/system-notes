#!/usr/bin/env bash
# Bootstraps Vundle (the vim plugin manager this .vimrc depends on).
# Safe to re-run -- skips the clone if Vundle is already installed.
set -euo pipefail

VUNDLE_DIR="$HOME/.vim/bundle/Vundle.vim"

if [ -d "$VUNDLE_DIR" ]; then
  echo "Vundle already installed at $VUNDLE_DIR"
else
  git clone https://github.com/VundleVim/Vundle.vim.git "$VUNDLE_DIR"
fi

echo "Now symlink or copy .vimrc to ~/.vimrc, then run vim +PluginInstall +qall"
