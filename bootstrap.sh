#!/bin/bash

set -e  # Exit immediately if any command fails

echo "🔧 Starting environment bootstrap..."

# Update and install essential packages
sudo apt update && sudo apt install -y git stow curl build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget llvm libncursesw5-dev xz-utils tk-dev \
libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

echo "✅ System packages installed"

# Clone dotfiles repo if not already there
DOTFILES_DIR=~/Repositories/Dot-Files
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "📦 Cloning dotfiles repo..."
    git clone git@github.com:Drew5040/Dot-Files.git "$DOTFILES_DIR"
fi

# Symlink dotfiles using stow
cd "$DOTFILES_DIR"
for dir in bash git wsl editor .git-templates; do
    echo "🔗 Stowing $dir"
    stow -v -t ~ "$dir"
done

echo "✅ Dotfiles symlinked"

# Set up Git global configs (safe to reapply)
git config --global init.templateDir ~/.git-templates
git config --global core.excludesfile ~/.gitignore_global
git config --global core.editor nano
git config --global push.default simple
git config --global merge.conflictstyle diff3
git config --global credential.helper cache
git config --global core.pager "less -FRX"
git config --global color.ui auto

echo "✅ Git configuration updated"

# Install pyenv and pyenv-virtualenv if not already installed
if [ ! -d "$HOME/.pyenv" ]; then
    echo "📦 Installing pyenv..."
    curl https://pyenv.run | bash
fi

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

# Install Python version & create virtualenv
PYTHON_VERSION=3.10.13
pyenv install -s "$PYTHON_VERSION"
pyenv virtualenv "$PYTHON_VERSION" venv_wsl
pyenv activate venv_wsl

echo "🐍 Python $PYTHON_VERSION and venv_wsl activated"

# Install Python tools inside venv
pip install --upgrade pip
pip install pre-commit black nbqa flake8 nbstripout

echo "✅ Python tools installed"

# Register nbstripout globally via Git
nbstripout --install --global
echo "✅ nbstripout registered globally"

# If pre-commit config exists, set up hooks
if [ -f .pre-commit-config.yaml ]; then
    pre-commit install
    pre-commit install --hook-type pre-push
    pre-commit run --all-files
    echo "✅ pre-commit hooks installed and validated"
fi

echo "🎉 Bootstrap complete. You're ready to go!"
